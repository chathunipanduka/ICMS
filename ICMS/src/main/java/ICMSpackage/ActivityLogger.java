package ICMSpackage;

import java.sql.*;

public class ActivityLogger {

    public static void log(int userId, String role, String actionType, String actionDesc, String ip, String userAgent) {
        String sql = "INSERT INTO activity_log_tb (user_id, role, action_type, action_desc, ip_address, user_agent) " +
                     "VALUES (?,?, ?, ?, ?, ?)";
        try (Connection conn = IcmsConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, role);
            ps.setString(3, actionType);
            ps.setString(4, actionDesc);
            ps.setString(5, ip);
            ps.setString(6, userAgent);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace(); // You can log this somewhere else too
        }
    }
}
