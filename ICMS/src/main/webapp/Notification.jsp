<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ page import="ICMSpackage.IcmsConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Notifications</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%
String username = (String) session.getAttribute("username");
if (username == null) {
    response.sendRedirect(request.getContextPath() + "/Login.jsp");
    return;
}
%>

<div class="container mt-4">
    <h2 class="text-center mb-5 fw-bold" style="color: #00274d;">Notification</h2>

    <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle text-center">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Message</th>
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

    // Select notifications for the logged-in user, newest first
    String sql = "SELECT id_notification_tb, complaint_id, message, is_read, create_at "
               + "FROM notification_tb "
               + "WHERE user_id = (SELECT id_login_tb FROM user_tb WHERE uName = ?) and type='status_update' "
               + "ORDER BY create_at DESC";

    ps = conn.prepareStatement(sql);
    ps.setString(1, username);
    rs = ps.executeQuery();

    boolean hasData = false;
    int rowNumber = 1;
    
    while (rs.next()) {
        hasData = true;
        int id = rs.getInt("id_notification_tb");
        String message = rs.getString("message");
        Timestamp dateTime = rs.getTimestamp("create_at");
        boolean isRead = rs.getBoolean("is_read");

        // Bold for unread notifications
        String rowClass = isRead ? "" : "fw-bold";
%>
<tr class="<%=rowClass%>">
    <td><%=rowNumber++%></td>
    <td><%=message%></td>
    <td><%=dateTime%></td>
    <td>
        <form action="ViewNotificationServlet" method="post" style="margin:0;">
            <input type="hidden" name="notificationId" value="<%=id%>"/>
            <button type="submit" class="btn btn-primary btn-sm">
                View
            </button>
        </form>
    </td>
</tr>
<%
    }

    if (!hasData) {
        out.println("<tr><td colspan='4' class='text-muted'>No notifications available.</td></tr>");
    }

} catch (Exception e) {
    out.println("<tr><td colspan='4' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
} finally {
    try { if (rs != null) rs.close(); } catch (Exception ignored) {}
    try { if (ps != null) ps.close(); } catch (Exception ignored) {}
    try { if (conn != null) conn.close(); } catch (Exception ignored) {}
}
%>
            </tbody>
        </table>
    </div>
</div>

<!-- Footer (unchanged) -->
<footer class="text-light pt-4" style="background-color: #00274d; width: 99.5%; padding:15px;">
  <div class="container1">
    <div class="row text-center text-md-start">
      <div class="col-md-4 mb-3">
        <h5>Biyagama Pradeshiya Sabha</h5>
        <p>Providing efficient infrastructure complaint management and citizen services for a better community.</p>
      </div>
      <div class="col-md-4 mb-3">
        <h5>Quick Links</h5>
        <ul class="list-unstyled">
          <li><a href="Home.jsp" class="text-light text-decoration-none">Home</a></li>
          <li><a href="Login.jsp" class="text-light text-decoration-none">Submit Complaint</a></li>
          <li><a href="about.jsp" class="text-light text-decoration-none">About Us</a></li>
        </ul>
      </div>
      <div class="col-md-4 mb-3">
        <h5>Contact Us</h5>
        <p>Email: info@biyagama.ps.lk</p>
        <p>Phone: +94 11 234 5678</p>
        <p>Address: Biyagama Pradeshiya Sabha, <br>Biyagama, Sri Lanka</p>
      </div>
    </div>
    <hr class="bg-light">
    <div class="text-center pb-3">
      &copy; 2025 Biyagama Pradeshiya Sabha. All rights reserved.
    </div>
  </div>
</footer>

</body>
</html>
