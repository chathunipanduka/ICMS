package ICMSpackage;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.Random;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String email = request.getParameter("email");

        try (Connection conn = IcmsConnection.getConnection()) {
            String sql = "SELECT uName FROM user_tb WHERE email=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                //String username = rs.getString("uName");
                int otp = 100000 + new Random().nextInt(900000);
                LocalDateTime expiry = LocalDateTime.now().plusMinutes(5);

                // Store OTP in DB
                String updateOtp = "UPDATE user_tb SET otp_code=?, otp_expiry=? WHERE email=?";
                PreparedStatement ps2 = conn.prepareStatement(updateOtp);
                ps2.setInt(1, otp);
                ps2.setTimestamp(2, Timestamp.valueOf(expiry));
                ps2.setString(3, email);
                ps2.executeUpdate();

                // ✅ Send OTP email
                EmailHelper.sendEmail(email, "Password Reset OTP", 
                    "Your OTP for password reset is: " + otp + 
                    "\n\nValid for 5 minutes only.");

                request.getSession().setAttribute("resetEmail", email);
                response.sendRedirect("VerifyResetOTP.jsp");
                
                
                
            } else {
                request.setAttribute("error", "No account found for this email.");
                request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
