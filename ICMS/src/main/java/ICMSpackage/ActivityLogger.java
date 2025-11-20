package ICMSpackage;

import java.sql.*;

public class ActivityLogger {

    public static void log(int userId, String role, String actionType, String actionDesc, String ip, String userAgent) {
        String sql = "INSERT INTO activity_log_tb (role, action_type, action_desc, ip_address, user_agent, " +
                     "user_id, admin_id, supadmin_id, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        
        try (Connection conn = IcmsConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set common parameters
            ps.setString(1, role);
            ps.setString(2, actionType);
            ps.setString(3, actionDesc);
            ps.setString(4, ip);
            ps.setString(5, userAgent);
            
            // Set appropriate ID based on role, others as NULL
            switch (role) {
                case "User":
                    ps.setInt(6, userId);    // regular_user_id
                    ps.setNull(7, Types.INTEGER);  // admin_id
                    ps.setNull(8, Types.INTEGER);  // supadmin_id
                    break;
                case "Admin":
                    ps.setNull(6, Types.INTEGER);  // regular_user_id
                    ps.setInt(7, userId);    // admin_id
                    ps.setNull(8, Types.INTEGER);  // supadmin_id
                    break;
                case "SupAdmin":
                    ps.setNull(6, Types.INTEGER);  // regular_user_id
                    ps.setNull(7, Types.INTEGER);  // admin_id
                    ps.setInt(8, userId);    // supadmin_id
                    break;
                default:
                    // All NULL if role doesn't match
                    ps.setNull(6, Types.INTEGER);
                    ps.setNull(7, Types.INTEGER);
                    ps.setNull(8, Types.INTEGER);
            }

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}