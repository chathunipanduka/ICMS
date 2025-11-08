package ICMSpackage;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String newPwd = request.getParameter("newPwd");
        String confirmPwd = request.getParameter("confirmPwd");
        String email = (String) request.getSession().getAttribute("resetEmail");
        Boolean otpVerified = (Boolean) request.getSession().getAttribute("otpVerified");

        if (otpVerified == null || !otpVerified) {
            response.sendRedirect("ForgotPassword.jsp");
            return;
        }

        if (!newPwd.equals(confirmPwd)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("ResetPassword.jsp").forward(request, response);
            return;
        }

        try (Connection conn = IcmsConnection.getConnection()) {

            // 1️⃣ Update the password
            String sql = "UPDATE login_tb SET pwd=?, otp_code=NULL, otp_expiry=NULL WHERE email=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newPwd); // ⚠️ Hash this in production
            ps.setString(2, email);
            int updatedRows = ps.executeUpdate();

            if (updatedRows > 0) {
                // 2️⃣ Get user ID and username for logging
                String sql2 = "SELECT id_login_tb, uName FROM login_tb WHERE email=?";
                PreparedStatement ps2 = conn.prepareStatement(sql2);
                ps2.setString(1, email);
                ResultSet rs2 = ps2.executeQuery();

                if (rs2.next()) {
                    int userId = rs2.getInt("id_login_tb");
                    String username = rs2.getString("uName");
                    String ip = request.getRemoteAddr();
                    String userAgent = request.getHeader("User-Agent");

                    // 3️⃣ Log the password reset
                    ActivityLogger.log(userId, "User", "Password Reset", "User: " + username + " reset password", ip, userAgent);
                }
                rs2.close();
                ps2.close();
            }

            // 4️⃣ Clear session attributes
            HttpSession session = request.getSession();
            session.removeAttribute("otpVerified");
            session.removeAttribute("resetEmail");

            // 5️⃣ Redirect to login
            response.sendRedirect("Login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
