<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f8f9fa;
    }
   
    
    .sidebar {
      height: calc(100vh - 70px);
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
      <nav class="sidebar col-md-3 col-lg-2  d-md-block">
      
        <a class="active" href="AdmHome.jsp" target="rightFrame"><i class="fa fa-home"></i>&nbsp;&nbsp;Home</a>
        <a href="AdmComplaints.jsp" target="rightFrame"><i class="fa fa-exclamation-circle"></i>&nbsp;&nbsp;Complaints</a>
        <a href="AdmNotification.jsp" target="rightFrame"><i class="fa fa-bell"></i>&nbsp;&nbsp;Notification</a>
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