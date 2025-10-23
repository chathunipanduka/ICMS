package ICMSpackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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
        int userid ;
        int deptid ;

        try (Connection conn = IcmsConnection.getConnection()) {

            // 1️⃣ Fetch user's email and complaint details
            String userSql = """
                SELECT l.email, l.id_login_tb, c.description
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
                        userid = rs.getInt("id_login_tb");
                    } else {
                        response.getWriter().println("❌ User not found for complaint ID: " + id);
                        return;
                    }
                }
            }
            
            HttpSession session = request.getSession(false);
            String username = (session != null) ? (String) session.getAttribute("username") : null;

            if (username == null) {
                response.getWriter().println("User not logged in.");
                return;
            }
            
            
            
            //Dept Id Get
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
        	String subject = "Complaint Staus Changed";
        	String body = "Dear user,<br>Your complaint about <b>" + description + "</b> Status has been changed to <b>"+status+".</b> <hr>\r\n"
        			+ "                    <footer style=\"font-size: 12px; color: #777;\">\r\n"
        			+ "                        This is an automated message from ICMS.<br>\r\n"
        			+ "                        Please do not reply to this email.<br>\r\n"
        			+ "                        © %d ICMS Team\r\n"
        			+ "                    </footer>";
        	EmailHelper.sendEmail(userEmail, subject, body);
        	
        	
        	String title = "Complaint Status Updated";
        	String message = "The status of your complaint #" + id + " has been changed to " + status + ".";
        	String type = "status_update";
        	
        	createNotification(conn, id, deptid, userid, title, message, type);



            // 4️⃣ Redirect back
            response.sendRedirect(request.getContextPath() + "/DeptAdmin/AdmComplaints.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Error: " + e.getMessage());
        }
    }
    
    
    private void createNotification(Connection conn, String id, int deptID, int userID, String title, String message, String type) throws SQLException {
String sql = "INSERT INTO notification_tb (complaint_id, dept_id, user_id, message, type) VALUES (?,?,?,?,?)";
try (PreparedStatement ps = conn.prepareStatement(sql)) {
ps.setInt(1, Integer.parseInt(id));
ps.setInt(2, deptID);
ps.setInt(3, userID);
ps.setString(4, message);
ps.setString(5, type);
ps.executeUpdate();

System.out.println("SQL: " + sql.toString());
}
}

}
