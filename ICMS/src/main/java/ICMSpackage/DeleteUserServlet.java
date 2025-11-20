package ICMSpackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String adminUsername = (String) session.getAttribute("username");
        
        // Check if admin is logged in
        if (adminUsername == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            String id = request.getParameter("id");
            
            if (id == null || id.trim().isEmpty()) {
                request.setAttribute("errorMessage", "User ID is required!");
                request.getRequestDispatcher("AllUsers.jsp").forward(request, response);
                return;
            }
            
            conn = IcmsConnection.getConnection();
            String sql = "DELETE FROM user_tb WHERE id_login_tb = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(id));
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                request.setAttribute("successMessage", "User deleted successfully!");
            } else {
                request.setAttribute("errorMessage", "User not found or already deleted!");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid user ID format!");
            e.printStackTrace();
        } catch (SQLException e) {
            // Check if it's a foreign key constraint violation
            if (e.getMessage().contains("foreign key constraint")) {
                request.setAttribute("errorMessage", "Cannot delete user. This user has related records in the system.");
            } else {
                request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            }
            e.printStackTrace();
        } catch (Exception e) {
            request.setAttribute("errorMessage", "System error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
        
        // Redirect back to users list
        response.sendRedirect(request.getContextPath() + "/SupAdmin/UserManage.jsp");
    }
}