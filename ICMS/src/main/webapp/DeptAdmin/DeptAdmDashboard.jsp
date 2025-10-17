<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Department Dashboard</title>

<!-- Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="icon" type="image/x-icon" href="../media/ICMS.png">

<style>
/* Header styling */
header {
  background-color: #00274d;
  color: white;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 12px;
  flex-wrap: wrap;
}
.headertitle {
  flex: 1;
  text-align: center;
  font-size: 20px;
  font-weight: bold;
}

/* Hamburger button styling */
.menu-btn {
  background: none;
  border: none;
  color: white;
  font-size: 24px;
  cursor: pointer;
  display: none;
}

/* User image */
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
  padding: 8px 18px;
  cursor: pointer;
  font-size: 16px;
  text-decoration: none;
  display: inline-block;
  transition: background 0.3s;
}

.logout:hover {
  background-color: darkred;
}

/* Iframes container */
.iframe-container {
  display: flex;
  height: calc(100vh - 70px);
  overflow: hidden;
}

iframe {
  border: none;
  height: 100%;
}

/* Desktop view */
.left-frame {
  width: 15%;
  transition: transform 0.3s ease;
}

.right-frame {
  width: 85%;
  background-color: #f8f9fa;
}

/* Responsive styles for tablets and mobile */
@media (max-width: 992px) {
  .headertitle {
    font-size: 18px;
  }
  .userimg {
    width: 45px;
    height: 45px;
  }
  .logout {
    font-size: 14px;
    padding: 6px 12px;
  }
}

@media (max-width: 768px) {
  .menu-btn {
    display: block;
  }

  header {
    flex-direction: row;
    align-items: center;
  }

  .img-container p {
    font-size: 14px;
    margin-bottom: 0;
  }

  .headertitle {
    text-align: center;
    font-size: 16px;
  }

  .iframe-container {
    flex-direction: column;
  }

  .left-frame {
    position: absolute;
    top: 60px;
    left: 0;
    width: 220px;
    height: calc(100vh - 60px);
    background: white;
    z-index: 1000;
    transform: translateX(-100%);
    box-shadow: 2px 0 5px rgba(0,0,0,0.2);
  }

  .left-frame.active {
    transform: translateX(0);
  }

  .right-frame {
    width: 100%;
  }

  /* Prevent iframe overflow */
  iframe {
    width: 100%;
  }
}
</style>
</head>
<body>

<%@ page import="java.sql.*, ICMSpackage.IcmsConnection" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }

    String deptName = "";
    try (Connection con = IcmsConnection.getConnection()) {
        String sql = "SELECT dept_name FROM dept_admin_tb WHERE deptAdmUname = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            deptName = rs.getString("dept_name");
        }
        rs.close();
        ps.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<header>
  <div class="img-container">
    <img class="userimg" src="../media/profile.png" alt="Profile"><br>
    <p style="font-weight:normal; font-size:16px; margin-bottom:0;"><%= username %></p>
  </div>

  <div class="headertitle">
    <%= deptName %>
  </div>

  <button class="menu-btn" id="menuToggle">☰</button>

  <a href="<%= request.getContextPath() %>/LogoutServlet" class="logout" target="_top">Logout</a>
</header>

<div class="iframe-container">
  <iframe src="AdminMenu.jsp" name="leftFrame" id="leftFrame" class="left-frame"></iframe>
  <iframe src="AdmHome.jsp" name="rightFrame" class="right-frame"></iframe>
</div>

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
