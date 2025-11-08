package ICMSpackage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Dashboard")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("txtName");
        String password = request.getParameter("txtPwd");

        try (Connection conn = IcmsConnection.getConnection()) {

            // --- Check normal user ---
            String sql = "SELECT id_login_tb, uName, pwd, isBlocked FROM login_tb WHERE (uName=? OR email=?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, username);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int isBlocked = rs.getInt("isBlocked");
                        if (isBlocked == 1) {
                            request.setAttribute("error", "Your account has been blocked. Contact admin.");
                            request.getRequestDispatcher("Login.jsp").forward(request, response);
                            return;
                        }

                        String hashedPassword = rs.getString("pwd");
                        if (BCrypt.checkpw(password, hashedPassword)) {
                            HttpSession session = request.getSession();
                            session.setAttribute("username", rs.getString("uName"));
                            session.setAttribute("userId", rs.getInt("id_login_tb"));
                            response.sendRedirect("User/UserDashboard.jsp");
                          //Add Activity Logger--------------------------------------------------------------
                            int userId = rs.getInt("id_login_tb");
                            String ip = request.getRemoteAddr();
                            String userAgent = request.getHeader("User-Agent");

                            ActivityLogger.log(userId,"User", "User Loging", "User: " + username + " Logged in", ip, userAgent);
                            //-----------------------------------------------------------------------------------------

                            return;
                        }
                    }
                }
            }

            // --- Check department admin ---
            String sql2 = "SELECT iddept_admin_tb, deptAdmUname, deptAdmPwd, isBlocked, role FROM dept_admin_tb WHERE (deptAdmUname=? OR deptAdmEmail=?) AND role='deptAdmin'";
            try (PreparedStatement ps2 = conn.prepareStatement(sql2)) {
                ps2.setString(1, username);
                ps2.setString(2, username);

                try (ResultSet rs2 = ps2.executeQuery()) {
                    if (rs2.next()) {
                        int isBlocked = rs2.getInt("isBlocked");
                        if (isBlocked == 1) {
                            request.setAttribute("error", "Your account has been blocked. Contact admin.");
                            request.getRequestDispatcher("Login.jsp").forward(request, response);
                            return;
                        }

                        String hashedPassword = rs2.getString("deptAdmPwd");
                        if (BCrypt.checkpw(password, hashedPassword)) {
                            HttpSession session2 = request.getSession();
                            session2.setAttribute("username", rs2.getString("deptAdmUname"));
                            session2.setAttribute("userId", rs2.getInt("iddept_admin_tb"));
                            response.sendRedirect("DeptAdmin/DeptAdmDashboard.jsp");
                          //Add Activity Logger--------------------------------------------------------------
                            int userId = rs2.getInt("iddept_admin_tb");
                            String ip = request.getRemoteAddr();
                            String userAgent = request.getHeader("User-Agent");

                            ActivityLogger.log(userId,"Admin", "Admin Loging", "Admin: " + username + " Logged in", ip, userAgent);
                            //-----------------------------------------------------------------------------------------

                            return;
                        }
                    }
                }
            }

            // --- Invalid login ---
            request.setAttribute("error", "Username or Password Incorrect. Try Again.");
            request.getRequestDispatcher("/Login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Login failed due to system error", e);
        }
    }
}
