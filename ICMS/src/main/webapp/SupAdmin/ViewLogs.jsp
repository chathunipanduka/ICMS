<%@ page import="java.sql.*, java.util.*, java.io.*" %>
<%@ page import="ICMSpackage.IcmsConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
String username = (String) session.getAttribute("username");
if (username == null) {
    response.sendRedirect(request.getContextPath() + "/SupAdmin/SupAdmLogin.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Activity Logs - Super Admin</title>

<!-- ✅ Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body {
    background-color: #f8f9fa;
}
.container {
    margin-top: 40px;
}
.table-container {
    max-height: 600px;
    overflow-y: auto;
    background: white;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}
th {
    background-color: #343a40;
    color: white;
    position: sticky;
    top: 0;
    z-index: 1;
}
</style>
</head>

<body>
<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary">Activity Logs</h2>
        
    </div>

    <div class="table-container">
    <table class="table table-bordered table-hover align-middle">
        <thead>
            <tr>
                <th>ID</th>
                <th>User</th>
                <th>Role</th>
                <th>Action</th>
                <th>Description</th>
                <th>IP Address</th>
                <th>User Agent</th>
                <th>Time</th>
            </tr>
        </thead>
        <tbody>
        <%
        try (Connection conn = IcmsConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT l.id_log, " +
                 "COALESCE(u.uName, d.deptAdmUname, s.SupAdmUname) AS username, " +
                 "l.role, l.action_type, l.action_desc, l.ip_address, l.user_agent, l.created_at " +
                 "FROM activity_log_tb l " +
                 "LEFT JOIN login_tb u ON l.user_id = u.id_login_tb AND l.role = 'User' " +
                 "LEFT JOIN dept_admin_tb d ON l.user_id = d.iddept_admin_tb AND l.role = 'Admin' " +
                 "LEFT JOIN supadm_tb s ON l.user_id = s.idSupAdm_tb AND l.role = 'SupAdmin' " +
                 "ORDER BY l.created_at DESC"
             );
             ResultSet rs = ps.executeQuery()) {

             boolean hasData = false;
             while (rs.next()) {
                 hasData = true;
                 Timestamp ts = rs.getTimestamp("created_at");
                 String formattedTime = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(ts);
        %>
            <tr>
                <td><%= rs.getInt("id_log") %></td>
                <td><%= rs.getString("role") %></td>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("action_type") %></td>
                <td><%= rs.getString("action_desc") %></td>
                <td><%= rs.getString("ip_address") %></td>
                <td><%= rs.getString("user_agent") %></td>
                <td><%= formattedTime %></td>
            </tr>
        <%
             }
             if (!hasData) {
                 out.println("<tr><td colspan='8' class='text-center text-muted'>No activity logs found.</td></tr>");
             }
        } catch (Exception e) {
            out.println("<tr><td colspan='8' class='text-danger text-center'>Error loading logs: " + e.getMessage() + "</td></tr>");
        }
        %>
        </tbody>
    </table>
</div>


<!-- ✅ Bootstrap Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
