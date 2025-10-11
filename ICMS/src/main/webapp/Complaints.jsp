<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ page import="ICMSpackage.IcmsConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
// ✅ Check if user is logged in
String username = (String) session.getAttribute("username");
if (username == null) {
	response.sendRedirect(request.getContextPath() + "/Login.jsp");
	return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>My Complaints</title>

<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
body {
	background-color: #f7f9fb;
	font-family: "Segoe UI", sans-serif;
}

.container {
	margin-top: 50px;
	background: #fff;
	padding: 25px;
	border-radius: 10px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

h2 {
	color: #003366;
	margin-bottom: 25px;
	text-align: center;
}

table {
	font-size: 15px;
}

th {
	background-color: #003366;
	color: white;
}

.media-preview {
    width: 80px;
    height: 80px;
    border-radius: 8px;
    object-fit: cover;
    transition: transform 0.2s, box-shadow 0.2s;
    cursor: pointer;
}

.media-preview:hover {
    transform: scale(1.05);
    box-shadow: 0 0 6px rgba(0, 0, 0, 0.3);
}

.no-media {
	color: #999;
	font-size: 13px;
}

.status {
	font-weight: bold;
}

.status.pending {
	color: #e69500;
}

.status.resolved {
	color: #28a745;
}

.status.rejected {
	color: #dc3545;
}

footer {
	bottom: 0;
	left: 0;
	width: 100%;
	background-color: #00274d;
	text-align: center;
	padding: 15px;
	font-size: 14px;
	color: #ffffff;
	box-shadow: 0 -2px 5px rgba(0, 0, 0, 0.1);
}
</style>
</head>
<body>

	<div class="container">
		<h2>📋 My Submitted Complaints</h2>

		<table
			class="table table-bordered table-hover align-middle text-center">
			<thead>
				<tr>
					<th>ID</th>
					<th>Department</th>
					<th>Description</th>
					<th>Status</th>
					<th>Media</th>
					<th>Date/Time</th>
				</tr>
			</thead>
			<tbody>
				<%
				Connection conn = null;
				PreparedStatement ps = null;
				ResultSet rs = null;
				try {
					conn = IcmsConnection.getConnection();

					// ✅ Only show complaints of the logged-in user
					String sql = "SELECT c.id_complaint_tb, c.description, c.status, c.media, c.date_time, d.deptName "
					+ "FROM complaint_tb c " + "LEFT JOIN dept_tb d ON c.dept_id = d.id_dept_tb "
					+ "WHERE c.user_id = (SELECT id_login_tb FROM login_tb WHERE uName = ?) " + "ORDER BY c.date_time DESC";

					ps = conn.prepareStatement(sql);
					ps.setString(1, username);
					rs = ps.executeQuery();

					boolean hasData = false;
					while (rs.next()) {
						hasData = true;
						int id = rs.getInt("id_complaint_tb");
						String deptName = rs.getString("deptName");
						String desc = rs.getString("description");
						String status = rs.getString("status");
						Timestamp dateTime = rs.getTimestamp("date_time");
						Blob media = rs.getBlob("media");
				%>
				<tr>
					<td><%=id%></td>
					<td><%=(deptName != null ? deptName : "N/A")%></td>
					<td><%=desc%></td>
					<td class="status <%=status.toLowerCase()%>"><%=status%></td>
					<td>
						<% if (media != null && media.length() > 0) { %>
    <a href="ViewMediaServlet?id=<%= id %>" target="_blank">
        <img src="ViewMediaServlet?id=<%= id %>" class="media-preview" alt="Complaint Image">
    </a>
<% } else { %>
    <span class="no-media">No Media</span>
<% } %>
					</td>
					<td><%=dateTime%></td>
				</tr>
				<%
				}

				if (!hasData) {
				out.println("<tr><td colspan='6' class='text-muted'>No complaints submitted yet.</td></tr>");
				}

				} catch (Exception e) {
				out.println("<tr><td colspan='6' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
				} finally {
				try {
				if (rs != null)
					rs.close();
				} catch (Exception ignored) {
				}
				try {
				if (ps != null)
					ps.close();
				} catch (Exception ignored) {
				}
				try {
				if (conn != null)
					conn.close();
				} catch (Exception ignored) {
				}
				}
				%>
			</tbody>
		</table>

		
	</div>

	<footer>
		Biyagama Pradeshiya Sabha<br> Contact: +94 123456789<br>
		Email: biyagamapradehsiyasabha@gmail.com
	</footer>

</body>
</html>
