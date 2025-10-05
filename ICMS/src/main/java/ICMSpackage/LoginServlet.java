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
import java.sql.ResultSet;

@WebServlet("/Dashboard")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("txtName");
        String password = request.getParameter("txtPwd");
        String role = request.getParameter("lbl-role");

        try (Connection conn = IcmsConnection.getConnection()) {
            if (conn == null) {
                throw new ServletException("Database connection failed!");
            }

            String sql = "SELECT uName, role FROM login_tb WHERE (uName=? OR email=?) AND pwd=?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, username);
                ps.setString(3, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        HttpSession session = request.getSession();
                        session.setAttribute("username", rs.getString("uName"));

                        if ("User".equals(role)) {
                            response.sendRedirect("Dashboard.jsp");
                        } else {
                            response.sendRedirect("AdminDashboard.jsp");
                        }
                    } else {
                        response.sendRedirect("login.jsp?error=1");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Login failed due to system error", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
