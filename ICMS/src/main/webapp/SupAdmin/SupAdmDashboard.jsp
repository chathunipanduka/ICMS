<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Super Admin Dashboard</title>

<!-- Bootstrap 5 CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
	<link rel="icon" type="image/x-icon" href="../media/ICMS.png">

<style>
.headertitle {
  flex: 1;                   /* allows title to take middle space */
  text-align: center;        /* center text */
}
header {
  background-color: #00274d;
  color: white;
  display: flex;
  align-items: center;       /* vertically center all items */
  justify-content: space-between; /* image left, title middle, button right */
  padding: 5px 5px;
  font-size: 22px;
  font-weight: bold;
}

/* Hamburger button styling */
.menu-btn {
	background: none;
	border: none;
	color: white;
	font-size: 24px;
	cursor: pointer;
	display: none; /* hidden on desktop */
}

.iframe-container {
	display: flex;
	height: calc(100vh - 60px);
	overflow: hidden;
}

iframe {
	border: none;
	height: 100%;
}

.left-frame {
	width: 15%;
	transition: transform 0.3s ease;
}

.right-frame {
	width: 85%;
	background-color: #f8f9fa;
}

/* On small screens, hide the left frame by default */
@media ( max-width : 768px) {
	.menu-btn {
		display: block;
	}
	.left-frame {
		position: absolute;
		top: 0px;
		left: 0;
		width: 250px;
		height: calc(100vh - 10px);
		background: white;
		z-index: 1000;
		transform: translateX(-100%);
		box-shadow: 2px 0 5px rgba(0, 0, 0, 0.2);
	}
	.left-frame.active {
		transform: translateX(0);
	}
	.right-frame {
		width: 100%;
	}
}

.userimg {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  object-fit: cover;
  margin-right: 10px;
}


.img-container {
  display: flex;
  align-items: center;
}

.logout {
  background-color: red;      
  color: white;               
  border: none;               
  border-radius: 8px;         
  padding: 10px 20px;         
  cursor: pointer;            
  font-size: 16px;            
  text-decoration: none;       /* Important for links */
  display: inline-block;       /* Make the link behave like a button */
  transition: background 0.3s;
}

.logout:hover {
  background-color: darkred;
}
</style>
</head>
<body>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        // not logged in — redirect to login page
        response.sendRedirect(request.getContextPath() + "/SupAdmin/SupAdmLogin.jsp");
        return;
    }
%>

	<header>
		<div class="img-container">
			<img class="userimg" src="../media/profile.png">
			<p style="font-weight:normal; font-size:18px; "><%= username %></p>
		</div>
		<div class="headertitle">
			Infrastructure Complaint Management System
			<button class="menu-btn" id="menuToggle">â°</button>
		</div>
		
        <a href="<%= request.getContextPath() %>/LogoutServlet" class="logout" target="_top">Logout</a>
		
	</header>

	<div class="iframe-container">
		<iframe src="SupAdmMenu.jsp" name="leftFrame" id="leftFrame"
			class="left-frame"></iframe>
		<iframe src="SupAdmHome.jsp" name="rightFrame" class="right-frame"></iframe>
	</div>

	<!-- Bootstrap + JS -->
	<script>
  // Toggle left menu on mobile
  const menuToggle = document.getElementById('menuToggle');
  const leftFrame = document.getElementById('leftFrame');

  menuToggle.addEventListener('click', () => {
    leftFrame.classList.toggle('active');
  });
</script>


</body>
</html>
