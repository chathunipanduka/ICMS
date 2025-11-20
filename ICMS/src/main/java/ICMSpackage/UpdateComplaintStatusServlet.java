package ICMSpackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
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
        int userid = 0;
        int deptid = 0;

        HttpSession session = request.getSession(false);
        String username = (session != null) ? (String) session.getAttribute("username") : null;
        Integer adminId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        if (username == null || adminId == null) {
            response.getWriter().println("❌ User not logged in.");
            return;
        }

        try (Connection conn = IcmsConnection.getConnection()) {

            // 1️⃣ Fetch user's email and complaint details
            String userSql = """
                SELECT l.email, l.id_login_tb, c.description
                FROM complaint_tb c
                JOIN user_tb l ON c.user_id = l.id_login_tb
                WHERE c.id_complaint_tb = ?
            """;

            try (PreparedStatement psUser = conn.prepareStatement(userSql)) {
                psUser.setInt(1, Integer.parseInt(id));
                try (ResultSet rs = psUser.executeQuery()) {
                    if (rs.next()) {
                        userEmail = rs.getString("email");
                        description = rs.getString("description");
                        userid = rs.getInt("id_login_tb");
                    } else {
                        response.getWriter().println("❌ User not found for complaint ID: " + id);
                        return;
                    }
                }
            }

            // 2️⃣ Get department ID for the admin
            String deptSql = """
                SELECT d.id_dept_tb 
                FROM dept_tb d
                JOIN dept_admin_tb da ON d.deptName = da.dept_name
                WHERE da.deptAdmUname = ?
            """;

            try (PreparedStatement psDept = conn.prepareStatement(deptSql)) {
                psDept.setString(1, username);
                try (ResultSet rs = psDept.executeQuery()) {
                    if (rs.next()) {
                        deptid = rs.getInt("id_dept_tb");
                    } else {
                        response.getWriter().println("❌ Department not found for admin username: " + username);
                        return;
                    }
                }
            }

            // 3️⃣ Update complaint status
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

            // 4️⃣ Send email to user
            String subject = "Complaint Status Changed";
            String body = "Dear user,<br>Your complaint about <b>" + description +
                    "</b> status has been changed to <b>" + status + ".</b><hr>" +
                    "<footer style='font-size:12px;color:#777;'>This is an automated message from ICMS.<br>" +
                    "Please do not reply to this email.<br>&copy; ICMS Team</footer>";
            EmailHelper.sendEmail(userEmail, subject, body);

            // 5️⃣ Create notification
            String title = "Complaint Status Updated";
            String message = "The status of your complaint #" + id + " has been changed to " + status + ".";
            String type = "status_update";
            createNotification(conn, id, deptid, userid, title, message, type);

            // 6️⃣ Add Activity Logger
            String ip = request.getRemoteAddr();
            String userAgent = request.getHeader("User-Agent");
            String actionDesc = String.format(
                    "Admin: %s (DeptID: %d) updated complaint ID %s (UserID: %d) status to %s",
                    username, deptid, id, userid, status
            );

            ActivityLogger.log(adminId, "Admin", "Update Complaint Status", actionDesc, ip, userAgent);

            // 7️⃣ Redirect back
            response.sendRedirect(request.getContextPath() + "/DeptAdmin/AdmComplaints.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Error: " + e.getMessage());
        }
    }

    // Notification helper
    private void createNotification(Connection conn, String id, int deptID, int userID, String title,
                                    String message, String type) throws SQLException {
        String sql = "INSERT INTO notification_tb (complaint_id, dept_id, user_id, message, type) VALUES (?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(id));
            ps.setInt(2, deptID);
            ps.setInt(3, userID);
            ps.setString(4, message);
            ps.setString(5, type);
            ps.executeUpdate();
        }
    }
}
