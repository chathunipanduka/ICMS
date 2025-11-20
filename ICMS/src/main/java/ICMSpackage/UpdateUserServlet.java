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

@WebServlet("/UpdateUserServlet")
public class UpdateUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
            // Get parameters from the form
            String id = request.getParameter("id");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String contactNo = request.getParameter("contactNo");
            String userName = request.getParameter("userName");
            String password = request.getParameter("password");
            
            // Validate required fields
            if (id == null || id.trim().isEmpty() || 
                firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {
                
                request.setAttribute("errorMessage", "Required fields are missing!");
                request.getRequestDispatcher("EditUser.jsp?id=" + id).forward(request, response);
                return;
            }
            
            conn = IcmsConnection.getConnection();
            String sql;
            
            // Check if password is being updated
            if (password != null && !password.trim().isEmpty()) {
                // Update with password
                sql = "UPDATE user_tb SET firstName=?, lastName=?, email=?, contactNo=?, uName=?, pwd=? WHERE id_login_tb=?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, firstName.trim());
                ps.setString(2, lastName.trim());
                ps.setString(3, email.trim());
                ps.setString(4, contactNo != null ? contactNo.trim() : null);
                ps.setString(5, userName != null ? userName.trim() : null);
                ps.setString(6, password.trim()); // In production, hash this password
                ps.setInt(7, Integer.parseInt(id));
            } else {
                // Update without password
                sql = "UPDATE user_tb SET firstName=?, lastName=?, email=?, contactNo=?, uName=? WHERE id_login_tb=?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, firstName.trim());
                ps.setString(2, lastName.trim());
                ps.setString(3, email.trim());
                ps.setString(4, contactNo != null ? contactNo.trim() : null);
                ps.setString(5, userName != null ? userName.trim() : null);
                ps.setInt(6, Integer.parseInt(id));
            }
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                request.setAttribute("successMessage", "User updated successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to update user. User not found.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid user ID format!");
            e.printStackTrace();
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            request.setAttribute("errorMessage", "System error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close resources
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
        
        // Redirect back to users list
        response.sendRedirect(request.getContextPath() + "/SupAdmin/UserManage.jsp");
    }
}