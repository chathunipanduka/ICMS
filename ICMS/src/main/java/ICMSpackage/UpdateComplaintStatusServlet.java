package ICMSpackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/UpdateComplaintStatusServlet")
public class UpdateComplaintStatusServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        String status = request.getParameter("status");
        String userEmail = null;
        String description = null;

        try (Connection conn = IcmsConnection.getConnection()) {

            // 1️⃣ Fetch user's email and complaint details
            String userSql = """
                SELECT l.email, c.description
                FROM complaint_tb c
                JOIN login_tb l ON c.user_id = l.id_login_tb
                WHERE c.id_complaint_tb = ?
            """;

            try (PreparedStatement psUser = conn.prepareStatement(userSql)) {
                psUser.setInt(1, Integer.parseInt(id));
                try (ResultSet rs = psUser.executeQuery()) {
                    if (rs.next()) {
                        userEmail = rs.getString("email");
                        description = rs.getString("description");
                    } else {
                        response.getWriter().println("❌ User not found for complaint ID: " + id);
                        return;
                    }
                }
            }

            // 2️⃣ Update complaint status
            String updateSql = """
                UPDATE complaint_tb 
                SET status = ?, updated = CURRENT_TIMESTAMP 
                WHERE id_complaint_tb = ?
            """;
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setString(1, status);
                ps.setInt(2, Integer.parseInt(id));
                ps.executeUpdate();
            }

         // ✅ Send email to user from DB
        	String subject = "Complaint Submitted Successfully";
        	String body = "Dear user,<br>Your complaint about <b>" + description + "</b> Status has been changed to <b>"+status+".</b> <hr>\r\n"
        			+ "                    <footer style=\"font-size: 12px; color: #777;\">\r\n"
        			+ "                        This is an automated message from ICMS.<br>\r\n"
        			+ "                        Please do not reply to this email.<br>\r\n"
        			+ "                        © %d ICMS Team\r\n"
        			+ "                    </footer>";
        	EmailHelper.sendEmail(userEmail, subject, body);


            // 4️⃣ Redirect back
            response.sendRedirect(request.getContextPath() + "/DeptAdmin/AdmComplaints.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Error: " + e.getMessage());
        }
    }
}
