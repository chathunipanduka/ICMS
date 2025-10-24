package ICMSpackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.Random;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String fName = request.getParameter("fName");
        String lName = request.getParameter("lName");
        String uName = request.getParameter("uName");
        String email = request.getParameter("email");
        String contact = request.getParameter("contact");
        String pwd = request.getParameter("Pwd");
        String cPwd = request.getParameter("cPwd");

        // ✅ Password confirmation check
        if (!pwd.equals(cPwd)) {
            out.println("<script>alert('Passwords do not match!'); window.location='Register.jsp';</script>");
            return;
        }

        try (Connection conn = IcmsConnection.getConnection()) {
            if (conn == null) {
                throw new ServletException("Database connection failed!");
            }

            // ✅ Check if username already exists
            String checkSql = "SELECT uName FROM login_tb WHERE uName=?";
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setString(1, uName);
                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        out.println("<script>alert('Username already exists!'); window.location='Register.jsp';</script>");
                        return;
                    }
                }
            }

            // ✅ Insert new user
            String sql = "INSERT INTO login_tb (firstname, lastname, uname, email, contactNo, pwd) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, fName);
                ps.setString(2, lName);
                ps.setString(3, uName);
                ps.setString(4, email);
                ps.setString(5, contact);
                ps.setString(6, pwd); // ⚠️ Use hashed password in production

                int rows = ps.executeUpdate();
                if (rows > 0) {

                    // ✅ Generate OTP and expiry
                    int otp = 100000 + new Random().nextInt(900000);
                    LocalDateTime expiry = LocalDateTime.now().plusMinutes(5);

                    String updateOtp = "UPDATE login_tb SET otp_code=?, otp_expiry=? WHERE uName=?";
                    try (PreparedStatement ps1 = conn.prepareStatement(updateOtp)) {
                        ps1.setString(1, String.valueOf(otp));
                        ps1.setString(2, expiry.toString());
                        ps1.setString(3, uName);
                        ps1.executeUpdate();
                    }

                    // ✅ Send OTP via Email
                    try {
                        EmailHelper.sendEmail(email, 
                            "OTP Verification - ICMS",
                            "Hello " + fName + ",\n\nYour OTP is: " + otp + 
                            "\nIt will expire in 5 minutes.\n\nThank you!");
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<script>alert('Error sending OTP: " + e.getMessage() + "');</script>");
                    }

                    // ✅ Store username in session for OTP verification
                    HttpSession session = request.getSession();
                    session.setAttribute("username", uName);

                    // ✅ Redirect to OTP page
                    response.sendRedirect("VerifyOTP.jsp");
                    return;
                } else {
                    out.println("<script>alert('Registration Failed!'); window.location='Register.jsp';</script>");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<font color=red>Error: " + e.getMessage() + "</font>");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
