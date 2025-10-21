<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register - Infrastructure Complaint Management System</title>
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

/* Register Box */
.register-box {
  max-width: 500px;
  margin: 80px auto;
  background: rgba(255,255,255,0.95);
  padding: 40px;
  border-radius: 15px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

/* Buttons */
.btn-primary {
  background-color: #002b5c;
  border: none;
}
.btn-primary:hover {
  background-color: #001a38;
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

/* Responsive Adjustments */
@media (max-width: 768px) {
  .register-box {
    margin: 40px 15px;
    padding: 30px 20px;
  }
}
@media (max-width: 576px) {
  .register-box { margin-top: 30px; padding: 25px 15px; }
}

/* Responsive Adjustments */
@media (max-width: 992px) {
  .navbar .d-flex {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }
}

@media (max-width: 768px) {
  .complaint-section {
    padding: 25px;
    margin-top: 0;
  }
  #hero-title, #hero-sub {
    font-size: 16px;
    text-align: center;
  }
  .navbar-brand img {
    width: 35px;
  }
  .navbar-brand span {
    font-size: 14px;
  }
  .carousel-caption {
    padding: 10px;
  }
}

@media (max-width: 576px) {
  #hero-title {
    font-size: 15px;
    padding: 6px 12px;
  }
  #hero-sub {
    font-size: 13px;
    padding: 5px 10px;
  }
  .btn {
    font-size: 13px;
    padding: 6px 10px;
  }
  footer p {
    font-size: 12px;
  }
  .card p {
    font-size: 14px;
  }
  .card {
    padding: 15px !important;
  }
}

@media (max-width: 400px) {
  .navbar-brand span {
    display: block;
    font-size: 12px;
    line-height: 1.2;
  }
  #lbt-view {
    font-size: 12px;
  }
  .complaint-section h3 {
    font-size: 16px;
  }
}
</style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="Home.jsp">
      <img src="media/BPS_LOGO.png" alt="Logo" width="45" class="me-2">
      <span id="title">Infrastructure Complaint Management System</span>
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarContent">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link" href="Home.jsp">Home</a></li>
        <li class="nav-item"><a class="nav-link" href="About.jsp">About Us</a></li>
        <li class="nav-item"><a class="nav-link" href="Login.jsp">Login</a></li>
        <li class="nav-item"><a class="nav-link active" href="Register.jsp">SignUp</a></li>
      </ul>
    </div>
  </div>
</nav>

<!-- Register Box -->
<div class="register-box">
  <h3 class="text-center mb-4">Register</h3>
  <form action="RegisterServlet" method="post">
    <div class="mb-3">
      <label class="form-label">First Name</label>
      <input type="text" class="form-control" name="fName" placeholder="Enter first name" required>
    </div>
    <div class="mb-3">
      <label class="form-label">Last Name</label>
      <input type="text" class="form-control" name="lName" placeholder="Enter last name" required>
    </div>
    <div class="mb-3">
      <label class="form-label">Username</label>
      <input type="text" class="form-control" name="uName" placeholder="Enter username" required>
    </div>
    <div class="mb-3">
      <label class="form-label">Email</label>
      <input type="email" class="form-control" name="email" placeholder="Enter email" required>
    </div>
    <div class="mb-3">
      <label class="form-label">Password</label>
      <input type="password" class="form-control" name="Pwd" placeholder="Enter password" required>
    </div>
    <div class="mb-3">
      <label class="form-label">Confirm Password</label>
      <input type="password" class="form-control" name="cPwd" placeholder="Confirm password" required>
    </div>
    <button type="submit" class="btn btn-primary w-100 mb-3">Register</button>
    <div class="text-center">
      <small>Already have an account? <a href="Login.jsp" class="fw-bold">Login here</a></small>
    </div>
  </form>
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
          <li><a href="Login.jsp" class="text-light text-decoration-none">Submit Complaint</a></li>
          <li><a href="About.jsp" class="text-light text-decoration-none">About Us</a></li>
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
