<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, ICMSpackage.IcmsConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
body {
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	background-color: #f8f9fa;
}

.sidebar {
	height: calc(100vh - 0px);
	background: #00274d; /* Darkblue Sidebar */
	padding-top: 20px;
}

.sidebar a {
	color: #fff;
	text-decoration: none;
	display: block;
	padding: 12px 20px;
	border-radius: 8px;
	margin: 6px;
	transition: background 0.3s;
	cursor: pointer;
}

.sidebar a:hover, .sidebar a.active {
	background-color: #495057;
}

.content {
	padding: 20px;
}

.card {
	border-radius: 12px;
	box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
}

.section {
	display: none;
}

.section.active {
	display: block;
}

body {
	background-color: #00274d; /* your dark blue */
}

.sidebar a.active {
	background-color: #0d6efd; /* Bright blue active color */
	font-weight: 600;
	transform: scale(1.03);
}

.goog-te-banner-frame.skiptranslate {
	display: none !important;
}

body {
	top: 0px !important;
}

/* Notification badge styles */
.notification-badge {
    position: relative;
}

.badge {
    position: absolute;
    top: 20px;
    right: 20px;
    transform: translate(25%, -25%);
}
</style>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
	crossorigin="anonymous">
</head>
<body>
	<%
	String currentPage = request.getRequestURI();
	
	// Get the count of unread notifications
	int unreadCount = 0;
	String username = (String) session.getAttribute("username");
	
	if (username != null) {
	    Connection conn = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    
	    try {
	        conn = IcmsConnection.getConnection();
	        String sql = "SELECT COUNT(*) as count FROM notification_tb " +
	                    "WHERE user_id = (SELECT id_login_tb FROM user_tb WHERE uName = ?) " +
	                    "AND is_read = 0 AND type='status_update'";
	        ps = conn.prepareStatement(sql);
	        ps.setString(1, username);
	        rs = ps.executeQuery();
	        
	        if (rs.next()) {
	            unreadCount = rs.getInt("count");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
	        try { if (ps != null) ps.close(); } catch (Exception ignored) {}
	        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
	    }
	}
	%>

	<div class="container-fluid">
		<div class="row">

			<!-- Sidebar -->
			<nav class="sidebar col-md-3 col-lg-2  d-md-block">

				<a class="active" href="UserHome.jsp" target="rightFrame"><i
					class="fa fa-home"></i>&nbsp;&nbsp;Home</a> <a href="SendComplaint.jsp"
					target="rightFrame"><i class="fa fa-exclamation-circle"></i>&nbsp;&nbsp;Add
					Complaint</a> <a href="../Complaints.jsp" target="rightFrame"><i
					class="fa fa-info-circle"></i>&nbsp;&nbsp;View Status</a> <a
					href="../Notification.jsp" target="rightFrame" class="notification-badge"><i
					class="fa fa-bell"></i>&nbsp;&nbsp;Notification 
					<% if (unreadCount > 0) { %>
					<span
					class="badge rounded-pill bg-danger">
						<%= unreadCount > 99 ? "99+" : unreadCount %>
						<span class="visually-hidden">unread notifications</span>
					</span>
					<% } %>
					</a><br> <br> <br> <br> <br>
			</nav>
		</div>
	</div>
	<script>
  // Select all sidebar links
  const sidebarLinks = document.querySelectorAll('.sidebar a');

  sidebarLinks.forEach(link => {
    link.addEventListener('click', () => {
      // Remove 'active' class from all links
      sidebarLinks.forEach(l => l.classList.remove('active'));
      // Add 'active' class to the clicked one
      link.classList.add('active');
    });
  });
</script>

</body>
</html>