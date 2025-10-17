<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Super Admin Dashboard</title>

<!-- Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="icon" type="image/x-icon" href="../media/ICMS.png">

<style>
/* ===== Header ===== */
header {
  background-color: #00274d;
  color: white;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 5px 10px;
  font-size: 22px;
  font-weight: bold;
  flex-wrap: wrap;
}

.headertitle {
  flex: 1;
  text-align: center;
  word-wrap: break-word;
  font-size: 20px;
}

/* ===== Hamburger Button ===== */
.menu-btn {
  background: none;
  border: none;
  color: white;
  font-size: 28px;
  cursor: pointer;
  display: none; /* hidden on desktop */
}

/* ===== Frames ===== */
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
  transition: transform 0.3s ease;
}

.right-frame {
  width: 82%;
  background-color: #f8f9fa;
}

/* ===== User Image and Logout ===== */
.userimg {
  width: 45px;
  height: 45px;
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
  padding: 8px 16px;
  cursor: pointer;
  font-size: 15px;
  text-decoration: none;
  display: inline-block;
  transition: background 0.3s;
}

.logout:hover {
  background-color: darkred;
}

/* ===== Mobile Responsiveness ===== */
@media (max-width: 992px) {
  .headertitle {
    font-size: 18px;
  }
  .logout {
    padding: 6px 14px;
    font-size: 14px;
  }
}

@media (max-width: 768px) {
  header {
    flex-wrap: nowrap;
    justify-content: space-between;
    padding: 8px;
  }

  .menu-btn {
    display: block;
    margin-left: 10px;
  }

  .headertitle {
    order: 2;
    flex: 1;
    text-align: center;
    font-size: 16px;
  }

  .img-container {
    order: 1;
  }

  .logout {
    order: 3;
    font-size: 13px;
    padding: 6px 12px;
  }

  /* Sidebar animation */
  .iframe-container {
    position: relative;
    flex-direction: column;
    height: calc(100vh - 60px);
  }

  .left-frame {
    position: absolute;
    top: 0;
    left: 0;
    width: 250px;
    height: calc(100vh - 10px);
    background: #fff;
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

@media (max-width: 480px) {
  .userimg {
    width: 35px;
    height: 35px;
  }
  .headertitle {
    font-size: 14px;
  }
  .logout {
    padding: 5px 10px;
    font-size: 12px;
  }
}
</style>
</head>
<body>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect(request.getContextPath() + "/SupAdmin/SupAdmLogin.jsp");
        return;
    }
%>

<header>
  <div class="img-container">
    <img class="userimg" src="../media/profile.png">
    <p style="font-weight:normal; font-size:16px; margin-bottom:0;"><%= username %></p>
  </div>

  <div class="headertitle">
    Infrastructure Complaint Management System
    <button class="menu-btn" id="menuToggle">☰</button>
  </div>

  <a href="<%= request.getContextPath() %>/LogoutServlet" class="logout" target="_top">Logout</a>
</header>

<div class="iframe-container">
  <iframe src="SupAdmMenu.jsp" name="leftFrame" id="leftFrame" class="left-frame"></iframe>
  <iframe src="SupAdmHome.jsp" name="rightFrame" class="right-frame"></iframe>
</div>

<!-- ===== JS: Toggle Sidebar ===== -->
<script>
  const menuToggle = document.getElementById('menuToggle');
  const leftFrame = document.getElementById('leftFrame');

  menuToggle.addEventListener('click', () => {
    leftFrame.classList.toggle('active');
  });
</script>

</body>
</html>
