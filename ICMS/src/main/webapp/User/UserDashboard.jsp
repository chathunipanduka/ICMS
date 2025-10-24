<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*, java.io.*" %>
<%@ page import="ICMSpackage.IcmsConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>User Dashboard</title>

<!-- Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="icon" type="image/x-icon" href="../media/BPS_LOGO.png">

<style>
/* Header */
header {
  background-color: #00274d;
  color: white;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 15px;
  flex-wrap: wrap;
}

.img-container {
  display: flex;
  align-items: center;
  gap: 8px;
}

.userimg {
  width: 45px;
  height: 45px;
  border-radius: 50%;
  object-fit: cover;
}

/* Header title */
.headertitle {
  flex: 1;
  text-align: center;
  font-size: 20px;
  font-weight: 600;
  line-height: 1.2;
}

/* Logout button */
.logout {
  background-color: red;
  color: white;
  border: none;
  border-radius: 6px;
  padding: 8px 15px;
  cursor: pointer;
  font-size: 15px;
  text-decoration: none;
  display: inline-block;
  transition: background 0.3s;
}

.logout:hover {
  background-color: darkred;
}

/* Hamburger button */
.menu-btn {
  background: none;
  border: none;
  color: white;
  font-size: 26px;
  cursor: pointer;
  display: none;
}

/* Iframes */
.iframe-container {
  display: flex;
  height: calc(100vh - 70px);
  overflow: hidden;
}

iframe {
  border: none;
  height: 100%;
}

.left-frame {
  width: 18%;
  min-width: 180px;
  transition: transform 0.3s ease;
}

.right-frame {
  width: 82%;
  background-color: #f8f9fa;
}

/* Mobile view */
@media (max-width: 992px) {
  .menu-btn {
    display: block;
  }
  .headertitle {
    font-size: 18px;
  }
}

@media (max-width: 768px) {
  header {
    flex-direction: row;
  }

  .iframe-container {
    position: relative;
  }

  .left-frame {
    position: absolute;
    top: 0;
    left: 0;
    width: 250px;
    height: calc(100vh - 70px);
    background: #fff;
    z-index: 1000;
    transform: translateX(-100%);
    box-shadow: 2px 0 8px rgba(0, 0, 0, 0.2);
  }

  .left-frame.active {
    transform: translateX(0);
  }

  .right-frame {
    width: 100%;
  }

  .logout {
    padding: 6px 12px;
    font-size: 14px;
  }
}

body {
  font-family: 'Poppins', sans-serif;
  background-color: #f5f7fa;
}

/* Floating Modal Background */
.modal {
  display: none;
  position: fixed;
  z-index: 999;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  backdrop-filter: blur(4px);
  background-color: rgba(0, 0, 0, 0.3);
}

/* Modal Content Box */
.modal-content {
  background: white;
  border-radius: 20px;
  max-width: 400px;
  margin: 5% auto;
  padding: 15px 20px;
  box-shadow: 0 10px 25px rgba(0,0,0,0.2);
  position: relative;
  text-align: center;
}

/* Close Button */
.close-btn {
  position: absolute;
  top: 20px;
  right: 25px;
  font-size: 24px;
  cursor: pointer;
  color: #555;
}

/* Profile Picture */
.profile-pic {
  position: relative;
  display: inline-block;
}
.profile-pic img {
  width: 80px;
  height: 80px;
  padding: 10px;
  border-radius: 50%;
}
.camera-icon {
  position: absolute;
  bottom: 0;
  right: 0;
  background: #f0f0f0;
  padding: 5px;
  border-radius: 50%;
}



/* Buttons */
.save-btn {
  background-color: #1e3a8a;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 8px;
  cursor: pointer;
}


.open-btn{
background-color: #1e3a8a;
  color: white;
  border: none;
  padding: 4px 4px;
  border-radius: 60px;
  cursor: pointer;
}

.open-btn:hover {
  background-color: #517891;
}


.save-btn:hover{
  background-color: #172c69;
}

.profile-form {
  width: 100%;
  max-width: 450px;
  margin: 0 auto;
  font-family: 'Poppins', sans-serif;
}

.form-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12px;
}

.form-row label {
  flex: 0 0 120px; /* fixed width for labels */
  font-weight: 500;
  color: #333;
}

.form-row input {
  flex: 1;
  padding: 5px 10px;
  border: 1px solid #ccc;
  border-radius: 6px;
  background-color: #f3f6fb;
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

<%
    // Variables to hold DB data
    String firstName = "";
    String lastName = "";
    String email = "";
    String uName = "";
    String contactNo = "";
    String department = "Road and Pot Hole"; // static for now or you can fetch from another table

    try {
        Connection conn = IcmsConnection.getConnection();
        String sql = "SELECT firstName, lastName, email, contactNo, uName FROM login_tb WHERE uName = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            firstName = rs.getString("firstName");
            lastName = rs.getString("lastName");
            email = rs.getString("email");
            uName = rs.getString("uName");
            contactNo = rs.getString("contactNo");
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<header>
  <div class="img-container">
    <button class="menu-btn" id="menuToggle">&#9776;</button>
    <button id="openProfileBtn" class="open-btn"><img class="userimg" src="../media/profile.png" alt="User"></button>
    <p class="m-0" style="font-size:16px;"><%= username %></p>
  </div>

  <div class="headertitle text-center">
    Infrastructure Complaint Management System
  </div>

  <a href="<%= request.getContextPath() %>/LogoutServlet" class="logout" target="_top">Logout</a>
</header>

<!-- Floating Profile Modal -->
<div id="profileModal" class="modal">
  <div class="modal-content">
    <span class="close-btn" id="closeProfileBtn">&times;</span>
    <h3 class="title">Profile</h3>

    <div class="profile-pic">
      <img src="../media/profile.png" alt="Profile Picture">
      <div class="camera-icon">
        <i class="fa fa-camera"></i>
      </div>
    </div>

    <div class="info">
    <form class="profile-form" action="${pageContext.request.contextPath}/UpdateProfileServlet" method="post">
  <div class="form-row">
    <label>Username:</label>
    <input type="text" name="uname" value="<%= uName %>" readonly>
  </div>

  

  <div class="form-row">
    <label>Contact No:</label>
    <input type="text" name="contact" value="<%= contactNo %>">
  </div>

  <div class="form-row">
    <label>Email:</label>
    <input type="email" name="email" value="<%= email %>">
  </div>

  <button type="submit" class="save-btn">Save Updates</button>
</form>

    </div>
  </div>
</div>


<div class="iframe-container">
  <iframe src="UserMenu.jsp" name="leftFrame" id="leftFrame" class="left-frame"></iframe>
  <iframe src="UserHome.jsp" name="rightFrame" class="right-frame"></iframe>
</div>

<script>
  // Toggle left sidebar on mobile
  const menuToggle = document.getElementById('menuToggle');
  const leftFrame = document.getElementById('leftFrame');

  menuToggle.addEventListener('click', () => {
    leftFrame.classList.toggle('active');
  });
  
  document.getElementById("openProfileBtn").onclick = function() {
	  document.getElementById("profileModal").style.display = "block";
	};

	document.getElementById("closeProfileBtn").onclick = function() {
	  document.getElementById("profileModal").style.display = "none";
	};

	window.onclick = function(event) {
	  const modal = document.getElementById("profileModal");
	  if (event.target === modal) {
	    modal.style.display = "none";
	  }
	};
</script>

</body>
</html>
