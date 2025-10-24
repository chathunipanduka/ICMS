package ICMSpackage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ViewAdmNotificationServlet")
public class ViewAdmNotificationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
	
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int notificationId = Integer.parseInt(request.getParameter("notificationId"));

        try (Connection conn = IcmsConnection.getConnection()) {
            String sql = "UPDATE notification_tb SET is_read = 1, read_at = NOW() WHERE id_notification_tb = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, notificationId);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect back to notifications page
        response.sendRedirect(request.getContextPath() +"/DeptAdmin/AdmComplaints.jsp");
    }
}
