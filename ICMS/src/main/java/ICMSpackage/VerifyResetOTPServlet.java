package ICMSpackage;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.*;

@WebServlet("/VerifyResetOTPServlet")
public class VerifyResetOTPServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String enteredOtp = request.getParameter("otp");
        String email = (String) request.getSession().getAttribute("resetEmail");

        try (Connection conn = IcmsConnection.getConnection()) {
            String sql = "SELECT otp_code, otp_expiry FROM login_tb WHERE email=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String dbOtp = rs.getString("otp_code");
                Timestamp expiryTimestamp = rs.getTimestamp("otp_expiry");
                LocalDateTime expiry = expiryTimestamp.toLocalDateTime();

                if (dbOtp.equals(enteredOtp) && LocalDateTime.now().isBefore(expiry)) {
                    // OTP verified — redirect to reset password page
                    request.getSession().setAttribute("otpVerified", true);
                    response.sendRedirect(request.getContextPath()+"/ResetPassword.jsp");
                } else {
                    request.setAttribute("error", "Invalid or expired OTP.");
                    request.getRequestDispatcher("VerifyResetOTP.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
