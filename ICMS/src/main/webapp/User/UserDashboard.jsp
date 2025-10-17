<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>User Dashboard</title>

<!-- Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="icon" type="image/x-icon" href="../media/ICMS.png">

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

<header>
  <div class="img-container">
    <button class="menu-btn" id="menuToggle">&#9776;</button>
    <img class="userimg" src="../media/profile.png" alt="User">
    <p class="m-0" style="font-size:16px;"><%= username %></p>
  </div>

  <div class="headertitle text-center">
    Infrastructure Complaint Management System
  </div>

  <a href="<%= request.getContextPath() %>/LogoutServlet" class="logout" target="_top">Logout</a>
</header>

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
</script>

</body>
</html>
