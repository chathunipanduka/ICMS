<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>About Us - Infrastructure Complaint Management System</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="icon" type="image/x-icon" href="media/BPS_LOGO.png">
<style>
body {
  font-family: 'Segoe UI', sans-serif;
  position: relative;
  min-height: 100vh;
  margin: 0;
}
body::before {
  content: "";
  background-color: #E6F0FA;
  position: absolute;
  top: 0; left: 0;
  width: 100%; height: 100%;
  z-index: -1;
}

/* Navbar */
.navbar {
  background-color: #002b5c;
}
.navbar-brand, .nav-link, .dropdown-toggle {
  color: #ffffff !important;
}
.navbar-toggler {
  border: none;
}
.navbar-toggler-icon {
  background-image: url("data:image/svg+xml;charset=utf8,%3Csvg viewBox='0 0 30 30' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath stroke='white' stroke-width='2' stroke-linecap='round' stroke-miterlimit='10' d='M4 7h22M4 15h22M4 23h22'/%3E%3C/svg%3E");
}
.navbar .nav-link.active {
  position: relative;
  color: #ffffff !important;
}
.navbar .nav-link.active::after {
  content: "";
  display: block;
  width: 100%;
  height: 2px;
  background-color: #ffffff;
  position: absolute;
  bottom: 0;
  left: 0;
}

/* Content Section */
.content-section {
  background-color: rgba(255,255,255,0.95);
  padding: 40px;
  border-radius: 15px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  margin: 40px auto;
  max-width: 900px;
  text-align: center;
}
.map-section {
  background-color: rgba(255,255,255,0.95);
  padding: 40px;
  border-radius: 15px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  margin: 40px auto;
  max-width: 1100px;
}

/* Footer */
footer {
  background-color: #002b5c;
  color: #ffffff;
  text-align: center;
  padding: 20px 10px;
  border-radius: 15px 15px 0 0;
  margin-top: 40px;
}

/* Responsive */
@media (max-width: 768px) {
  .content-section, .map-section { padding: 25px; margin: 20px; }
  h2, h3 { font-size: 18px; }
  p { font-size: 14px; }
  .navbar-brand span { display: block; font-size: 13px; text-align: center; }
  
  .navbar-brand img {
    width: 35px;
  }
}



</style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold d-flex align-items-center" href="Home.jsp">
      <img src="media/BPS_LOGO.png" alt="Logo" width="45" class="me-2">
      <span id="title">Infrastructure Complaint Management System</span>
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarContent">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link" href="Home.jsp">Home</a></li>
        <li class="nav-item"><a class="nav-link active" href="About.jsp">About Us</a></li>
        <li class="nav-item"><a class="nav-link" href="Login.jsp">Login</a></li>
        <li class="nav-item"><a class="nav-link" href="Register.jsp">SignUp</a></li>
      </ul>
    </div>
  </div>
</nav>

<!-- Hero / Content -->
<div class="content-section">
  <h2>About Biyagama Pradeshiya Sabha</h2>
  <p>Providing efficient infrastructure complaint management and citizen services for a better community.</p>
</div>

<div class="map-section">
  <img src="media/map.jpg" alt="Map" class="img-fluid">
</div>

<div class="content-section">
  <h3>Mission</h3>
  <p>To provide a transparent, efficient, and citizen-focused platform for reporting and resolving infrastructure issues, ensuring timely maintenance, improved public services, and sustainable community development.</p>
</div>

<div class="content-section">
  <h3>Vision</h3>
  <p>To establish a transparent, efficient, and citizen-centric infrastructure management system, ensuring timely resolution of complaints and sustainable development in Biyagama Pradeshiya Sabha.</p>
</div>

<!-- Footer -->
<footer>
  <div class="container">
    <div class="row text-center text-md-start">
      <div class="col-md-4 mb-3">
        <h5>Biyagama Pradeshiya Sabha</h5>
        <p>Providing efficient infrastructure complaint management and citizen services for a better community.</p>
      </div>
      <div class="col-md-4 mb-3">
        <h5>Quick Links</h5>
        <ul class="list-unstyled">
          <li><a href="Home.jsp" class="text-light text-decoration-none">Home</a></li>
          <li><a href="Login.jsp" class="text-light text-decoration-none">Login</a></li>
          <li><a href="Register.jsp" class="text-light text-decoration-none">SignUp</a></li>
        </ul>
      </div>
      <div class="col-md-4 mb-3">
        <h5>Contact Us</h5>
        <p>Email: info@biyagama.ps.lk</p>
        <p>Phone: +94 11 234 5678</p>
        <p>Address: Biyagama Pradeshiya Sabha, Biyagama, Sri Lanka</p>
      </div>
    </div>
    <hr class="bg-light">
    <div class="text-center pb-3">&copy; 2025 Biyagama Pradeshiya Sabha. All rights reserved.</div>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
