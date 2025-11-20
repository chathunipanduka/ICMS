package ICMSpackage;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/GetComplaintReportServlet")
public class GetComplaintReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        PreparedStatement psMedia = null;
        ResultSet rsMedia = null;
        
        try {
            int complaintId = Integer.parseInt(request.getParameter("complaintId"));
            String contextPath = request.getContextPath();
            
            conn = IcmsConnection.getConnection();
            
            // Get complaint details
            String sql = "SELECT c.*, d.deptName, u.uName AS username, " +
                        "u.email, u.contactNo " +
                        "FROM complaint_tb c " +
                        "LEFT JOIN dept_tb d ON c.dept_id = d.id_dept_tb " +
                        "LEFT JOIN user_tb u ON c.user_id = u.id_login_tb " +
                        "WHERE c.id_complaint_tb = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, complaintId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                String description = rs.getString("description");
                String status = rs.getString("status");
                String location = rs.getString("location");
                String deptName = rs.getString("deptName");
                String username = rs.getString("username");
                String email = rs.getString("email");
                String phone = rs.getString("contactNo");
                Timestamp dateTime = rs.getTimestamp("date_time");
                Timestamp updatedTime = rs.getTimestamp("updated");
                int rating = rs.getInt("rating");
                
                // Get all media files for this complaint
                String mediaSql = "SELECT id_media, file_name FROM complaint_media_tb WHERE complaint_id = ?";
                psMedia = conn.prepareStatement(mediaSql);
                psMedia.setInt(1, complaintId);
                rsMedia = psMedia.executeQuery();
                
                java.util.List<String> mediaList = new java.util.ArrayList<>();
                while (rsMedia.next()) {
                    mediaList.add(rsMedia.getInt("id_media") + "|" + rsMedia.getString("file_name"));
                }
                
                // Generate HTML report with images
                out.println(generateReportHTML(complaintId, description, status, location, 
                                             deptName, username, email, phone, dateTime, 
                                             updatedTime, rating, mediaList, contextPath));
            } else {
                out.println("<div class='alert alert-warning'>Complaint not found.</div>");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<div class='alert alert-danger'>Error generating report: " + e.getMessage() + "</div>");
        } finally {
            try { if (rsMedia != null) rsMedia.close(); } catch (Exception e) {}
            try { if (psMedia != null) psMedia.close(); } catch (Exception e) {}
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
    
    private String generateReportHTML(int id, String description, String status, String location,
                                    String deptName, String username, String email, String phone,
                                    Timestamp dateTime, Timestamp updatedTime, int rating, 
                                    java.util.List<String> mediaList, String contextPath) {
        
        String statusColor = "warning";
        if ("Solved".equalsIgnoreCase(status)) statusColor = "success";
        else if ("InProgress".equalsIgnoreCase(status)) statusColor = "primary";
        
        // Generate media section HTML
        String mediaSection = generateMediaSection(mediaList, contextPath);
        
        return "<div class='complaint-report'>" +
               "<div class='row'>" +
               "<div class='col-md-6'>" +
               "<div class='card mb-3'>" +
               "<div class='card-header bg-light'><strong>Complaint Details</strong></div>" +
               "<div class='card-body'>" +
               "<p><strong>ID:</strong> #" + id + "</p>" +
               "<p><strong>Status:</strong> <span class='badge bg-" + statusColor + "'>" + status + "</span></p>" +
               "<p><strong>Department:</strong> " + (deptName != null ? deptName : "N/A") + "</p>" +
               "<p><strong>Submitted:</strong> " + dateTime + "</p>" +
               "<p><strong>Last Updated:</strong> " + (updatedTime != null ? updatedTime : "Never") + "</p>" +
               "<p><strong>Location:</strong> " + (location != null ? location : "N/A") + "</p>" +
               "<p><strong>Media Files:</strong> " + mediaList.size() + "</p>" +
               "<p><strong>User Rating:</strong> " + generateRatingStars(rating) + "</p>" +
               "</div></div></div>" +
               
               "<div class='col-md-6'>" +
               "<div class='card mb-3'>" +
               "<div class='card-header bg-light'><strong>User Information</strong></div>" +
               "<div class='card-body'>" +
               "<p><strong>Username:</strong> " + (username != null ? username : "N/A") + "</p>" +
               "<p><strong>Email:</strong> " + (email != null ? email : "N/A") + "</p>" +
               "<p><strong>Phone:</strong> " + (phone != null ? phone : "N/A") + "</p>" +
               "</div></div></div></div>" +
               
               "<div class='card mb-3'>" +
               "<div class='card-header bg-light'><strong>Complaint Description</strong></div>" +
               "<div class='card-body'>" +
               "<p class='card-text'>" + (description != null ? description : "No description provided") + "</p>" +
               "</div></div>" +
               
               mediaSection +
               
               "<div class='mt-3 text-muted small'>" +
               "Report generated on " + new java.util.Date() +
               "</div></div>";
    }
    
    private String generateMediaSection(java.util.List<String> mediaList, String contextPath) {
        if (mediaList.isEmpty()) {
            return "<div class='card'>" +
                   "<div class='card-header bg-light'><strong>Complaint Images</strong></div>" +
                   "<div class='card-body text-center'>" +
                   "<p class='text-muted'><i>No images available for this complaint</i></p>" +
                   "</div></div>";
        }
        
        StringBuilder mediaHtml = new StringBuilder();
        mediaHtml.append("<div class='card'>")
                 .append("<div class='card-header bg-light'><strong>Complaint Images (").append(mediaList.size()).append(")</strong></div>")
                 .append("<div class='card-body'>")
                 .append("<div class='row'>");
        
        for (String mediaInfo : mediaList) {
            String[] parts = mediaInfo.split("\\|");
            int mediaId = Integer.parseInt(parts[0]);
            String fileName = parts.length > 1 ? parts[1] : "Image";
            
            mediaHtml.append("<div class='col-md-4 col-sm-6 mb-3'>")
                     .append("<div class='text-center'>")
                     .append("<img src='").append(contextPath).append("/ViewMediaServlet?mediaId=").append(mediaId)
                     .append("' class='img-thumbnail report-image' style='max-width: 100%; height: 150px; object-fit: cover;'")
                     .append(" alt='").append(fileName).append("'>")
                     .append("<br><small class='text-muted'>").append(fileName).append("</small>")
                     .append("</div></div>");
        }
        
        mediaHtml.append("</div></div></div>");
        return mediaHtml.toString();
    }
    
    private String generateRatingStars(int rating) {
        if (rating == 0) return "Not rated";
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars.append("★");
            } else {
                stars.append("☆");
            }
        }
        return stars.toString() + " (" + rating + "/5)";
    }
}