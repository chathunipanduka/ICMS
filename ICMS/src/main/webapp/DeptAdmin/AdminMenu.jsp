<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f8f9fa;
    }
   
    
    .sidebar {
      height: calc(100vh - 60px);
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
    .content { padding: 20px; }
    .card {
      border-radius: 12px;
      box-shadow: 0 3px 10px rgba(0,0,0,0.1);
    }
    .section { display: none; }
    .section.active { display: block; }
    
body {
  background-color: #00274d; /* your dark blue */
}




  
  </style>
</head>
<body>

  <div class="container-fluid">
    <div class="row">
      
      <!-- Sidebar -->
      <nav class="sidebar col-md-3 col-lg-2  d-md-block">
      
        <a class="active" href="AdmHome.jsp" target="rightFrame">Home</a>
        <a href="../Complaints.jsp" target="rightFrame">Complaints</a>
        <a href="AdmReports.jsp" target="rightFrame">Generate Reports</a>
        <a href="../Notification.jsp" target="rightFrame">Notification</a><br><br><br><br><br><br><br><br>
      </nav>
      </div>
      </div>
      

</body>
</html>