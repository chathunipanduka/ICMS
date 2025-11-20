package ICMSpackage;


import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/DeleteComplaintServlet")
public class DeleteComplaintServlet extends HttpServlet {
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
            
            conn = IcmsConnection.getConnection();
            
            // First, verify that the complaint belongs to the current user and is within 7 days
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
                    session.setAttribute("errorMessage", "Cannot delete solved complaints.");
                } else if ((currentTime - complaintTime) > sevenDaysInMillis) {
                    session.setAttribute("errorMessage", "Can only delete complaints within 7 days of submission.");
                } else {
                    // Delete related media records first
                    String deleteMediaSql = "DELETE FROM complaint_media_tb WHERE complaint_id = ?";
                    psMedia = conn.prepareStatement(deleteMediaSql);
                    psMedia.setInt(1, complaintId);
                    psMedia.executeUpdate();
                    
                    // Delete the complaint
                    String deleteSql = "DELETE FROM complaint_tb WHERE id_complaint_tb = ?";
                    ps = conn.prepareStatement(deleteSql);
                    ps.setInt(1, complaintId);
                    
                    int rowsAffected = ps.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        session.setAttribute("successMessage", "Complaint deleted successfully!");
                    } else {
                        session.setAttribute("errorMessage", "Failed to delete complaint.");
                    }
                }
            } else {
                session.setAttribute("errorMessage", "Complaint not found or you don't have permission to delete it.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error deleting complaint: " + e.getMessage());
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