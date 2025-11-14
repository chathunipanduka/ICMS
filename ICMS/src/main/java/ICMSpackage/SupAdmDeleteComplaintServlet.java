package ICMSpackage;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/SupAdmDeleteComplaintServlet")
public class SupAdmDeleteComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = (String) request.getSession().getAttribute("username");
        if (username == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        
        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            response.sendRedirect("AllComplaints.jsp?error=Invalid complaint ID");
            return;
        }
        
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = IcmsConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Delete from complaint_media_tb first
            String deleteMediaSql = "DELETE FROM complaint_media_tb WHERE complaint_id = ?";
            ps = conn.prepareStatement(deleteMediaSql);
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();
            ps.close();
            
            // Delete from complaint_tb
            String deleteComplaintSql = "DELETE FROM complaint_tb WHERE id_complaint_tb = ?";
            ps = conn.prepareStatement(deleteComplaintSql);
            ps.setInt(1, Integer.parseInt(id));
            
            int rowsDeleted = ps.executeUpdate();
            
            if (rowsDeleted > 0) {
                conn.commit();
                response.sendRedirect("SupAdmin/DeptComplaints.jsp?success=Complaint deleted successfully");
            } else {
                conn.rollback();
                response.sendRedirect("SupAdmin/DeptComplaints.jsp?error=Complaint not found");
            }
            
        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("SupAdmin/DeptComplaints.jsp?error=Database error: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}