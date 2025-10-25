package ICMSpackage;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.*;

@WebServlet("/VerifyOTPServlet")
public class VerifyOTPServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String enteredOtp = request.getParameter("otp");
        String username = (String) request.getSession().getAttribute("username");

        try (Connection conn = IcmsConnection.getConnection()) {
            String sql = "SELECT otp_code, otp_expiry FROM login_tb WHERE uName=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String dbOtp = rs.getString("otp_code");
                Timestamp expiryTimestamp = rs.getTimestamp("otp_expiry");
                LocalDateTime expiry = expiryTimestamp != null ? expiryTimestamp.toLocalDateTime() : null;

                if (dbOtp != null && expiry != null &&
                    dbOtp.equals(enteredOtp) && LocalDateTime.now().isBefore(expiry)) {

                    // OTP valid — clear OTP fields
                    String clearOtp = "UPDATE login_tb SET otp_code=NULL, otp_expiry=NULL WHERE uName=?";
                    PreparedStatement ps2 = conn.prepareStatement(clearOtp);
                    ps2.setString(1, username);
                    ps2.executeUpdate();

                    response.sendRedirect("Login.jsp");
                } else {
                    request.setAttribute("error", "Invalid or expired OTP.");
                    request.getRequestDispatcher("VerifyOTP.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "User not found.");
                request.getRequestDispatcher("VerifyOTP.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
