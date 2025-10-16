<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ page import="ICMSpackage.IcmsConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>All Complaints - Super Admin</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { background-color: #f7f9fb; font-family: "Segoe UI", sans-serif; }
.container { margin-top: 50px; background: #fff; padding: 25px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1);}
h2 { color: #003366; margin-bottom: 25px; text-align: center;}
th { background-color: #003366; color: white;}
.media-preview { width: 80px; height: 80px; border-radius: 8px; object-fit: cover; transition: transform 0.2s, box-shadow 0.2s; cursor: pointer;}
.media-preview:hover { transform: scale(1.05); box-shadow: 0 0 6px rgba(0,0,0,0.3);}
.no-media { color: #999; font-size: 13px;}
footer { bottom: 0; left: 0; width: 100%; background-color: #00274d; text-align: center; padding: 15px; font-size: 14px; color: #ffffff; }
</style>
</head>
<body>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
%>

<div class="container">
    <h2>📋 All Submitted Complaints</h2>

    <table class="table table-bordered table-hover align-middle text-center">
        <thead>
            <tr>
                <th>ID</th>
                <th>Department</th>
                <th>Description</th>
                <th>Status</th>
                <th>Media</th>
                <th>User</th>
                <th>Location</th>
                <th>Date/Time</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
<%
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
try {
    conn = IcmsConnection.getConnection();
    String sql = "SELECT c.id_complaint_tb, c.description, c.status, c.media, c.location, c.date_time, " +
                 "d.deptName, l.uName AS username " +
                 "FROM complaint_tb c " +
                 "LEFT JOIN dept_tb d ON c.dept_id = d.id_dept_tb " +
                 "LEFT JOIN login_tb l ON c.user_id = l.id_login_tb " +
                 "ORDER BY c.date_time DESC";
    ps = conn.prepareStatement(sql);
    rs = ps.executeQuery();

    boolean hasData = false;
    while (rs.next()) {
        hasData = true;
        int id = rs.getInt("id_complaint_tb");
        String dept_Name = rs.getString("deptName");
        String desc = rs.getString("description");
        String status = rs.getString("status");
        String location = rs.getString("location");
        String user_name = rs.getString("username");
        Timestamp dateTime = rs.getTimestamp("date_time");
        Blob media = rs.getBlob("media");
%>
<tr>
    <td><%= id %></td>
    <td><%= dept_Name != null ? dept_Name : "N/A" %></td>
    <td><%= desc %></td>
    <td>
        <% if ("Pending".equalsIgnoreCase(status)) { %>
            <span class="badge bg-warning text-dark">Pending</span>
        <% } else if ("InProgress".equalsIgnoreCase(status)) { %>
            <span class="badge bg-info text-dark">In Progress</span>
        <% } else if ("Solved".equalsIgnoreCase(status)) { %>
            <span class="badge bg-success">Solved</span>
        <% } else { %>
            <span class="badge bg-secondary">Unknown</span>
        <% } %>
    </td>
    <td>
        <% if (media != null && media.length() > 0) { %>
            <a href="../ViewMediaServlet?id=<%= id %>" target="_blank">
                <img src="../ViewMediaServlet?id=<%= id %>" class="media-preview" alt="Complaint Image">
            </a>
        <% } else { %>
            <span class="no-media">No Media</span>
        <% } %>
    </td>
    <td><%= user_name != null ? user_name : "N/A" %></td>
    <td><%= location != null ? location : "N/A" %></td>
    <td><%= dateTime %></td>
    <td>
        <a href="EditComplaint.jsp?id=<%= id %>" class="btn btn-sm btn-warning">Edit</a>
        <a href="${pageContext.request.contextPath}/DeleteComplaintServlet?id=<%= id %>" 
           class="btn btn-sm btn-danger"
           onclick="return confirm('Are you sure you want to delete this complaint?');">
           Delete
        </a>
    </td>
</tr>
<%
    }
    if (!hasData) {
        out.println("<tr><td colspan='9' class='text-muted'>No complaints submitted yet.</td></tr>");
    }
} catch (Exception e) {
    out.println("<tr><td colspan='9' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
    e.printStackTrace();
} finally {
    try { if (rs != null) rs.close(); } catch (Exception ignored) {}
    try { if (ps != null) ps.close(); } catch (Exception ignored) {}
    try { if (conn != null) conn.close(); } catch (Exception ignored) {}
}
%>
        </tbody>
    </table>
</div>

<footer>
    Biyagama Pradeshiya Sabha<br>Contact: +94 123456789<br>
    Email: biyagamapradehsiyasabha@gmail.com
</footer>
</body>
</html>
