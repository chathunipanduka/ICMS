<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>About Us - Biyagama Pradeshiya Sabha</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="icon" type="image/x-icon" href="media/ICMS.png">
<style>
  body {
    font-family: 'Segoe UI', sans-serif;
    position: relative;
    min-height: 100vh;
    margin: 0;
    background-color: #E6F0FA;
  }

  /* Navbar */
  .navbar { background-color: #002b5c; }
  .navbar-brand, .nav-link, .dropdown-toggle { color: #ffffff !important; }

  /* Content Section */
  .content-section {
    background-color: rgba(255,255,255,0.95);
    padding: 40px;
    border-radius: 15px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    margin: 40px auto;
    max-width: 900px;
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

  /* Buttons */
  .btn-primary { background-color: #002b5c; border: none; }
  .btn-primary:hover { background-color: #001a38; }

  /* Responsive Adjustments */
  @media (max-width: 768px) {
    .content-section { padding: 25px; margin: 20px; }
    h2 { font-size: 18px; }
    p { font-size: 14px; }
  }
</style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="Home.jsp">
      <img src="media/ICMS.png" alt="Sri Lanka Logo" width="45" class="me-2">
      Infrastructure Complaint Management System
    </a>
    <button class="navbar-toggler text-white" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarContent">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link" href="Home.jsp">Home</a></li>
        <li class="nav-item"><a class="nav-link active" href="about.jsp">About Us</a></li>
        <li class="nav-item"><a class="nav-link" href="Login.jsp">Login</a></li>
        <li class="nav-item"><a class="nav-link" href="Register.jsp">SignUp</a></li>
      </ul>
    </div>
  </div>
</nav>

<!-- Hero Section -->
<div class="content-section text-center">
  <h2>About Biyagama Pradeshiya Sabha</h2>
  <p>Committed to providing efficient infrastructure complaint management and citizen services for a better community.</p>
</div>

<!-- Mission Section -->
<div class="content-section text-center">
  <h2>Our Mission</h2>
  <p>"To provide a transparent, efficient, and citizen-focused platform for reporting and resolving infrastructure issues, ensuring timely maintenance, improved public services, and sustainable community development."</p>
</div>

<!-- Vision Section -->
<div class="content-section text-center">
  <h2>Our Vision</h2>
  <p>"To establish a transparent, efficient, and citizen-centric infrastructure management system, ensuring timely resolution of complaints and sustainable development in Biyagama Pradeshiya Sabha."</p>
</div>

<!-- Footer -->
<footer class="text-light">
  <div class="container">
    <div class="row text-center text-md-start">
      <div class="col-md-4 mb-3">
        <h5>Biyagama Pradeshiya Sabha</h5>
        <p>Providing efficient infrastructure complaint management and citizen services for a better community.</p>
      </div>

      <div class="col-md-4 mb-3">
        <h5>Quick Links</h5>
        <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="Home.jsp">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="About.jsp">About Us</a></li>
                    <li class="nav-item"><a class="nav-link" href="Login.jsp">Login</a></li>
                    <li class="nav-item"><a class="nav-link" href="Register.jsp">SignUp</a></li>
                </ul>
      </div>

      <div class="col-md-4 mb-3">
        <h5>Contact Us</h5>
        <p>Email: info@biyagama.ps.lk</p>
        <p>Phone: +94 11 234 5678</p>
        <p>Address: Biyagama Pradeshiya Sabha, <br>Biyagama, Sri Lanka</p>
      </div>
    </div>

    <hr class="bg-light">

    <div class="text-center pb-3">
      &copy; 2025 Biyagama Pradeshiya Sabha. All rights reserved.
    </div>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
