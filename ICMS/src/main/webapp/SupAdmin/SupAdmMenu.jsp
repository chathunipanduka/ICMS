<%@ page import="java.sql.*, ICMSpackage.IcmsConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Panel</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #00274d;
}

.sidebar {
    height: calc(100vh - 60px);
    background: #00274d; /* Dark blue Sidebar */
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

.btn {
    color: #fff;
    text-decoration: none;
    display: block;
    padding: 12px 20px;
    border-radius: 8px;
    margin: 6px;
    transition: background 0.3s;
    cursor: pointer;
}

.dropdown-menu {
    background-color: #003366;
}

.dropdown-menu .dropdown-item:hover {
    background-color: #004080;
}
.sidebar a.active {
    background-color: #0d6efd; /* Bright blue active color */
    font-weight: 600;
    transform: scale(1.03);
  }

</style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="sidebar col-md-3 col-lg-2 d-md-block">
            <a class="active" href="SupAdmHome.jsp" target="rightFrame"><i class="fa fa-home"></i>&nbsp;&nbsp;Home</a>
            <a href="DepartmentManage.jsp" target="rightFrame"><i class="fa fa-building"></i>&nbsp;&nbsp;Department</a>
            <a href="SupAdmReports.jsp" target="rightFrame"><i class="fa fa-chart-bar"></i>&nbsp;&nbsp;Reports</a>
            <a href="UserManage.jsp" target="rightFrame"><i class="fa fa-user"></i>&nbsp;&nbsp;User</a>
            <a href="DeptComplaints.jsp" target="rightFrame"><i class="fa fa-exclamation-circle"></i>&nbsp;&nbsp;Complaints</a>

           <!-- Dropdown for Complaints -->
<div class="dropdown">
    <button class="btn dropdown-toggle btn-sm text-white w-75" 
            type="button" data-bs-toggle="dropdown" 
            style="background-color: transparent; border: none;">
        Complaints
    </button>
    <ul class="dropdown-menu bg-dark">
        <%
            try (Connection con = IcmsConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("SELECT id_dept_tb, deptName FROM dept_tb");
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
        %>
                    <li>
                        <a class="dropdown-item text-white"
                           href="DeptComplaints.jsp?deptId=<%=rs.getInt("id_dept_tb")%>"
                           target="rightFrame">
                           <%=rs.getString("deptName")%>
                        </a>
                    </li>
        <%
                }
            } catch (Exception e) {
                out.println("<li><a class='dropdown-item text-danger'>Error loading departments</a></li>");
            }
        %>
    </ul>
</div>
            <a href="../Notification.jsp" target="rightFrame"><i class="fa fa-file-alt"></i>&nbsp&nbspNotification</a>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
