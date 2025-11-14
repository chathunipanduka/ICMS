package ICMSpackage;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/SupAdmInlineEditComplaintServlet")
public class SupAdmInlineEditComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = (String) request.getSession().getAttribute("username");
        if (username == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        
        // Get parameters
        String id = request.getParameter("id");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String location = request.getParameter("location");
        
        System.out.println("=== FORM SUBMISSION RECEIVED ===");
        System.out.println("ID: " + id);
        System.out.println("Description: " + description);
        System.out.println("Status: " + status);
        System.out.println("Location: " + location);
        
        if (id == null || id.trim().isEmpty()) {
            response.sendRedirect("AllComplaints.jsp?error=Invalid complaint ID");
            return;
        }
        
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = IcmsConnection.getConnection();
            String sql = "UPDATE complaint_tb SET description = ?, status = ?, location = ?, updated = CURRENT_TIMESTAMP WHERE id_complaint_tb = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, description);
            ps.setString(2, status);
            ps.setString(3, location);
            ps.setInt(4, Integer.parseInt(id));
            
            int rowsUpdated = ps.executeUpdate();
            
            if (rowsUpdated > 0) {
                System.out.println("SUCCESS: Complaint " + id + " updated successfully");
                response.sendRedirect("SupAdmin/DeptComplaints.jsp?success=Complaint updated successfully");
            } else {
                System.out.println("WARNING: No rows updated for complaint " + id);
                response.sendRedirect("SupAdmin/DeptComplaints.jsp?error=Failed to update complaint");
            }
            
        } catch (SQLException e) {
            System.err.println("SQL ERROR: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("SupAdmin/DeptComplaints.jsp?error=Database error: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("ERROR: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("SupAdmin/DeptComplaints.jsp?error=Server error: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}