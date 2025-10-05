<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard - ICMS</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
  body { font-family: 'Segoe UI', sans-serif; background-color: #f8f9fa; }
  .sidebar { height: 100vh; background-color: #003366; color: white; padding-top: 20px; }
  .sidebar a { display: block; color: white; padding: 15px; text-decoration: none; }
  .sidebar a:hover { background-color: #002244; }
  .main-content { padding: 20px; }
  .navbar {background-color: #003366; color: white;}
  footer {
    background-color: #002b5c;
    color: #ffffff;
    text-align: center;
    padding: 20px 10px;
    position: relative;
    bottom: 0;
    width: 100%;
    border-radius: 15px 15px 0 0;
    margin-top: 40px;
  }
</style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="#">
      <img src="media/logo.png" alt="Logo" width="40" class="me-2">
      <span id="dashboard-title" style="color:white;">Infrastructure Complaint Management System</span>
    </a>
    <div class="ms-auto d-flex align-items-center">
      <div class="dropdown me-3">
        <a href="Home.jsp">
          <button class="btn btn-outline-light btn-sm me-3" id="loginBtn">Home</button>
        </a>
        <button class="btn btn-outline-light btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown">
          <span id="language-label">Language</span>
        </button>
        <ul class="dropdown-menu">
          <li><a class="dropdown-item" href="#" onclick="setLanguage('en')">English</a></li>
          <li><a class="dropdown-item" href="#" onclick="setLanguage('si')">සිංහල</a></li>
          <li><a class="dropdown-item" href="#" onclick="setLanguage('ta')">தமிழ்</a></li>
        </ul>
      </div>
      <form action="LogoutServlet" method="post" style="display:inline;">
        <button class="btn btn-outline-light btn-sm" type="submit" id="logout-text">Logout</button>
      </form>
    </div>
  </div>
</nav>

<div class="container-fluid">
  <div class="row">
    <!-- Sidebar -->
    <div class="col-md-2 sidebar">
      <a href="#" onclick="loadSection('Profile.jsp')">Profile</a>
      <a href="#" onclick="loadSection('SendComplaint.jsp')">Send Complaint</a>
      <a href="#" onclick="loadSection('History.jsp')">History</a>
      <a href="#" onclick="loadSection('Notification.jsp')">Notification</a>
    </div>
    
    <%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp"); // prevent direct access
        return;
    }
%>
    
    <!-- Main content -->
    <div class="col-md-10 main-content" id="main-content">
      <h3>Welcome <%= username %></h3>
      <p>Select a section from the sidebar to load its content.</p>
    </div>
  </div>
</div>

<footer>
  <p>© 2025 Biyagama Pradeshiya Sabha | Infrastructure Complaint Management System</p>
  <p>Designed and Developed for Public Service</p>
</footer>

<script>
function loadSection(file) {
  fetch(file)
    .then(response => {
      if (!response.ok) throw new Error("Failed to load section");
      return response.text();
    })
    .then(html => {
      document.getElementById('main-content').innerHTML = html;
    })
    .catch(err => {
      document.getElementById('main-content').innerHTML = `<p class="text-danger">${err.message}</p>`;
    });
}

// Example: Multi-language support
let currentLanguage = 'en'; // Global selected language

function setLanguage(lang) {
  currentLanguage = lang;

  const translations = {
    en: { "dashboard-title": "Infrastructure Complaint Management System", "logout-text": "Logout", "language-label": "Language" },
    si: { "dashboard-title": "පහසුකම් ගැටළු කළමනාකරණ පද්ධතිය", "logout-text": "පිටවීම", "language-label": "භාෂාව" },
    ta: { "dashboard-title": "அடித்தள புகார் மேலாண்மை அமைப்பு", "logout-text": "வெளியேறு", "language-label": "மொழி" }
  };

  for (const key in translations[lang]) {
    const el = document.getElementById(key);
    if (el) el.innerText = translations[lang][key];
  }
}

setLanguage(currentLanguage);
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
