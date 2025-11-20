package ICMSpackage;


import java.io.*;
import java.sql.*;
import java.util.Collection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/UpdateComplaintServlet")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 10, // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class UpdateComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        
        if (username == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        PreparedStatement psMedia = null;
        PreparedStatement verifyStmt = null;
        ResultSet rs = null;
        
        try {
            int complaintId = Integer.parseInt(request.getParameter("complaint_id"));
            String description = request.getParameter("description");
            String location = request.getParameter("location");
            
            conn = IcmsConnection.getConnection();
            
            // Verify that the complaint belongs to the current user
            String verifySql = "SELECT c.id_complaint_tb, c.date_time, c.status " +
                             "FROM complaint_tb c " +
                             "INNER JOIN user_tb u ON c.user_id = u.id_login_tb " +
                             "WHERE c.id_complaint_tb = ? AND u.uName = ?";
            
            verifyStmt = conn.prepareStatement(verifySql);
            verifyStmt.setInt(1, complaintId);
            verifyStmt.setString(2, username);
            rs = verifyStmt.executeQuery();
            
            if (rs.next()) {
                Timestamp complaintDate = rs.getTimestamp("date_time");
                String status = rs.getString("status");
                
                // Check if complaint is within 7 days and not solved
                long complaintTime = complaintDate.getTime();
                long currentTime = System.currentTimeMillis();
                long sevenDaysInMillis = 7 * 24 * 60 * 60 * 1000;
                
                if (status.equalsIgnoreCase("Solved")) {
                    session.setAttribute("errorMessage", "Cannot edit solved complaints.");
                } else if ((currentTime - complaintTime) > sevenDaysInMillis) {
                    session.setAttribute("errorMessage", "Can only edit complaints within 7 days of submission.");
                } else {
                    // Update the complaint
                    String updateSql = "UPDATE complaint_tb SET description = ?, location = ?, updated = ? WHERE id_complaint_tb = ?";
                    ps = conn.prepareStatement(updateSql);
                    ps.setString(1, description);
                    ps.setString(2, location);
                    ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                    ps.setInt(4, complaintId);
                    
                    int rowsAffected = ps.executeUpdate();
                    
                    // Handle media upload if files are provided
                    Collection<Part> parts = request.getParts();
                    boolean hasMedia = false;
                    
                    for (Part part : parts) {
                        if (part.getName().equals("media") && part.getSize() > 0) {
                            hasMedia = true;
                            break;
                        }
                    }
                    
                    if (hasMedia) {
                        // Delete existing media first
                        String deleteMediaSql = "DELETE FROM complaint_media_tb WHERE complaint_id = ?";
                        psMedia = conn.prepareStatement(deleteMediaSql);
                        psMedia.setInt(1, complaintId);
                        psMedia.executeUpdate();
                        psMedia.close();
                        
                        // Insert new media files
                        for (Part part : parts) {
                            if (part.getName().equals("media") && part.getSize() > 0) {
                                InputStream fileContent = part.getInputStream();
                                String insertMediaSql = "INSERT INTO complaint_media_tb (complaint_id, media, file_name) VALUES (?, ?, ?)";
                                psMedia = conn.prepareStatement(insertMediaSql);
                                psMedia.setInt(1, complaintId);
                                psMedia.setBlob(2, fileContent);
                                psMedia.setString(3, part.getSubmittedFileName());
                                psMedia.executeUpdate();
                                psMedia.close();
                            }
                        }
                    }
                    
                    if (rowsAffected > 0) {
                        session.setAttribute("successMessage", "Complaint updated successfully!");
                    } else {
                        session.setAttribute("errorMessage", "Failed to update complaint.");
                    }
                }
            } else {
                session.setAttribute("errorMessage", "Complaint not found or you don't have permission to edit it.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error updating complaint: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (verifyStmt != null) verifyStmt.close(); } catch (Exception e) {}
            try { if (psMedia != null) psMedia.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        
        response.sendRedirect(request.getContextPath() + "/Complaints.jsp");
    }
}