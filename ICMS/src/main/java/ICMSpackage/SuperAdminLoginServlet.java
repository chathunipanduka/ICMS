package ICMSpackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/SuperAdminLogin")
public class SuperAdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("superAdminName");
        String password = request.getParameter("superAdminPwd");

        try (Connection conn = IcmsConnection.getConnection()) {
            if (conn == null) {
                throw new ServletException("Database connection failed!");
            }

            String sql = "SELECT SupAdmUname FROM supadm_tb WHERE SupAdmUname=? AND SupAdmPwd=?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        // ✅ Create session for Super Admin
                        HttpSession session = request.getSession();
                        session.setAttribute("superAdmin", username);

                        // Redirect to Dashboard
                        response.sendRedirect("SupAdmDashboard.jsp");
                    } else {
                        // ❌ Wrong credentials → back to login
                        request.setAttribute("error", "Invalid Username or Password!");
                        request.getRequestDispatcher("SupAdmLogin.jsp").forward(request, response);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("SupAdmLogin.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
