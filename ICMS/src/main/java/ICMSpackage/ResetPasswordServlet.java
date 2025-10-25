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
            String sql = "UPDATE login_tb SET pwd=?, otp_code=NULL, otp_expiry=NULL WHERE email=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newPwd); // ⚠️ hash in production
            ps.setString(2, email);
            ps.executeUpdate();

            // clear session
            request.getSession().removeAttribute("otpVerified");
            request.getSession().removeAttribute("resetEmail");

            response.sendRedirect("Login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
