<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ page import="ICMSpackage.IcmsConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Notifications</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
/* =====================
   BASE UI
   ===================== */
body {
	background: linear-gradient(135deg, #f4f7fb, #eef2f7);
	font-family: "Segoe UI", sans-serif;
	margin-top: 20px;
}

/* Page Card */
.page-card {
	background: #ffffff;
	border-radius: 16px;
	padding: 25px;
	box-shadow: 0 15px 40px rgba(0,0,0,0.08);
}

/* Title */
h2 {
	color: #00274d;
	font-weight: 700;
	letter-spacing: 0.4px;
}

/* =====================
   TABLE → NOTIFICATION UX
   ===================== */
.table {
	border-collapse: separate;
	border-spacing: 0 10px;
	font-size: 15px;
}

thead th {
	background: #00274d;
	color: #fff;
	border: none;
	padding: 14px;
}

tbody tr {
	background: #ffffff;
	border-radius: 14px;
	box-shadow: 0 6px 14px rgba(0,0,0,0.06);
	transition: transform 0.15s ease, box-shadow 0.15s ease;
}

tbody tr:hover {
	transform: translateY(-3px);
	box-shadow: 0 10px 22px rgba(0,0,0,0.1);
}

td {
	border: none;
	padding: 14px;
	vertical-align: middle;
}

/* Unread notification highlight */
tbody tr.fw-bold {
	border-left: 6px solid #0d6efd;
	background: #f8fbff;
}

/* Message column */
.notification-message {
	text-align: left;
}

/* Date */
.notification-date {
	font-size: 13px;
	color: #6c757d;
}

/* Button */
.btn-view {
	border-radius: 20px;
	font-size: 13px;
	padding: 6px 16px;
}

/* =====================
   MOBILE UX
   ===================== */
@media (max-width: 768px) {

	h2 {
		font-size: 1.4rem;
	}

	.table {
		font-size: 13px;
	}

	td, th {
		padding: 10px;
	}

	.notification-message {
		font-size: 13px;
	}

	.btn-view {
		width: 100%;
	}
}

@media (max-width: 576px) {

	h2 {
		font-size: 1.25rem;
	}

	.notification-date {
		font-size: 12px;
	}
}
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

<div class="container mt-4">
	<div class="page-card">

		<h2 class="text-center mb-4">Notifications</h2>

		<div class="table-responsive">
			<table class="table align-middle text-center">
				<thead>
					<tr>
						<th>#</th>
						<th>Message</th>
						<th>Date / Time</th>
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

        String rowClass = isRead ? "" : "fw-bold";
%>
<tr class="<%=rowClass%>">
	<td><%=rowNumber++%></td>
	<td class="notification-message"><%=message%></td>
	<td class="notification-date"><%=dateTime%></td>
	<td>
		<form action="ViewNotificationServlet" method="post" style="margin:0;">
			<input type="hidden" name="notificationId" value="<%=id%>"/>
			<button type="submit" class="btn btn-primary btn-sm btn-view">
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
</div>

<!-- Footer (UNCHANGED) -->
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
