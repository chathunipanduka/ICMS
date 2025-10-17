<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ page import="ICMSpackage.IcmsConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
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
<meta name="viewport" content="width=device-width, initial-scale=1"> <!-- ✅ Important for mobile -->
<title>My Complaints</title>

<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
body {
	background-color: #f7f9fb;
	font-family: "Segoe UI", sans-serif;
	margin: 0;
	padding: 0;
}

/* Container Styling */
.container {
	margin-top: 40px;
	background: #fff;
	padding: 25px;
	border-radius: 12px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

/* Header */
h2 {
	color: #003366;
	margin-bottom: 25px;
	text-align: center;
	font-size: 1.8rem;
}

/* Table Styling */
.table {
	font-size: 15px;
	word-break: break-word;
}

th {
	background-color: #003366;
	color: white;
	font-weight: 600;
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

.status.solved {
	color: #28a745;
}

.status.inprogress {
	color: #dc3545;
}

/* Responsive Table Wrapper */
.table-responsive {
	border-radius: 10px;
	overflow-x: auto;
}

/* Footer 
footer {
	width: 100%;
	background-color: #00274d;
	text-align: center;
	padding: 15px;
	font-size: 14px;
	color: #ffffff;
	box-shadow: 0 -2px 5px rgba(0, 0, 0, 0.1);
	margin-top: 30px;
}*/

/* ===== Responsive Breakpoints ===== */

/* Tablets */
@media (max-width: 992px) {
	h2 {
		font-size: 1.6rem;
	}
	.media-preview {
		width: 65px;
		height: 65px;
	}
	.table {
		font-size: 14px;
	}
}

/* Mobile */
@media (max-width: 768px) {
	.container {
		padding: 15px;
		margin-top: 25px;
	}
	h2 {
		font-size: 1.4rem;
	}
	th, td {
		font-size: 13px;
		padding: 8px;
	}
	.media-preview {
		width: 60px;
		height: 60px;
	}
	footer {
		font-size: 12px;
		padding: 10px;
		line-height: 1.4;
	}
}
</style>
</head>
<body>

	<div class="container">
		<h2>📋 My Submitted Complaints</h2>

		<!-- ✅ Makes table horizontally scrollable on small screens -->
		<div class="table-responsive">
			<table class="table table-bordered table-hover align-middle text-center">
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

						String sql = "SELECT c.id_complaint_tb, c.description, c.status, c.media, c.date_time, d.deptName "
								+ "FROM complaint_tb c "
								+ "LEFT JOIN dept_tb d ON c.dept_id = d.id_dept_tb "
								+ "WHERE c.user_id = (SELECT id_login_tb FROM login_tb WHERE uName = ?) "
								+ "ORDER BY c.date_time DESC";

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
						try { if (rs != null) rs.close(); } catch (Exception ignored) {}
						try { if (ps != null) ps.close(); } catch (Exception ignored) {}
						try { if (conn != null) conn.close(); } catch (Exception ignored) {}
					}
					%>
				</tbody>
			</table>
		</div>
	</div>

	<!-- Footer -->
<footer class="text-light pt-4" style="background-color: #00274d; width: 99.5%; padding:15px;">
  <div class="container1">
    <div class="row text-center text-md-start">
      <!-- About Section -->
      <div class="col-md-4 mb-3">
        <h5>Biyagama Pradeshiya Sabha</h5>
        <p>Providing efficient infrastructure complaint management and citizen services for a better community.</p>
      </div>

      <!-- Quick Links -->
      <div class="col-md-4 mb-3">
        <h5>Quick Links</h5>
        <ul class="list-unstyled">
          <li><a href="Home.jsp" class="text-light text-decoration-none">Home</a></li>
          <li><a href="Login.jsp" class="text-light text-decoration-none">Submit Complaint</a></li>
          <li><a href="about.jsp" class="text-light text-decoration-none">About Us</a></li>
        </ul>
      </div>

      <!-- Contact Info -->
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
