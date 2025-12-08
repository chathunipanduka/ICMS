<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login - Infrastructure Complaint Management System</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="icon" type="image/x-icon" href="media/BPS_LOGO.png">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
body {
    background-image: url('media/bpms_bg.jpg');
    background-repeat: no-repeat;
    background-attachment: fixed;
    background-size: cover;
    
    /* Optional: Add these for better appearance */
    margin: 0;
    min-height: 100vh;
}

/* Add a semi-transparent overlay for better readability */
body::before {
    content: '';
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(255, 255, 255, 0.6); /* Black overlay with 40% opacity */
    z-index: -1; /* Place behind content */
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

/* Login Box */
.login-box {
  max-width: 400px;
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

/* Password Field with Eye Icon */
.password-container {
  position: relative;
}

.password-container input {
  width: 100%;
  padding-right: 40px;
}

.password-container i {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  cursor: pointer;
  color: #888;
}

.password-container i:hover {
  color: #333;
}

/* Responsive Adjustments */
@media (max-width: 768px) {
  .login-box {
    margin: 40px 15px;
    padding: 30px 20px;
  }
}

@media (max-width: 576px) {
  .login-box { margin-top: 30px; padding: 25px 15px; }
}

#google_translate_element {
    display: inline-block;
    margin: 10px;
  }

  .goog-te-gadget-simple {
    background-color: #f8f9fa !important;
    border: 1px solid #ccc !important;
    border-radius: 6px;
    padding: 5px 10px;
    font-family: 'Segoe UI', sans-serif !important;
    color: #333 !important;
    display: inline-flex;
    align-items: center;
  }

  .goog-te-gadget-simple img {
    display: none; /* Hide Google icon if you want */
  }

  .goog-te-gadget-simple span {
    color: #333 !important;
    font-size: 14px !important;
  }


</style>
</head>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<body>



<script type="text/javascript">
  function googleTranslateElementInit() {
    new google.translate.TranslateElement(
      {
        pageLanguage: 'en',          // Your site’s original language
        includedLanguages: 'en,si,ta', // Optional: restrict languages (English, Sinhala, Tamil)
        layout: google.translate.TranslateElement.InlineLayout.SIMPLE
      },
      'google_translate_element'
    );
  }
</script>

<!-- Google Translate Script -->
<script type="text/javascript" 
  src="https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit">
</script>


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
      	<li><!-- Google Translate Element -->
<div id="google_translate_element"></div></li>
        <li class="nav-item"><a class="nav-link" href="Home.jsp">Home</a></li>
        <li class="nav-item"><a class="nav-link" href="About.jsp">About Us</a></li>
        <li class="nav-item"><a class="nav-link active" href="Login.jsp">Login</a></li>
        <li class="nav-item"><a class="nav-link" href="Register.jsp">Register</a></li>
        <li class="nav-item"><a class="nav-link" href="FAQ.jsp">FAQ</a></li>
      </ul>
    </div>
  </div>
</nav>

<!-- Login Box -->
<div class="login-box">
  <h3 class="text-center mb-4">Login</h3>
  <form action="${pageContext.request.contextPath}/Dashboard" method="post">
    <div class="mb-3">
      <label class="form-label">Email</label>
      <input type="text" name="txtName" class="form-control" placeholder="Enter Username/Email" required>
    </div>

    <div class="mb-3 password-container">
      <label class="form-label">Password</label>
      <input type="password" id="password" name="txtPwd" class="form-control" placeholder="Enter password" required>
      <i class="fa fa-eye" id="togglePassword"></i>
      <a href="ForgotPassword.jsp" class="d-block mt-2">Forgot Password?</a>
    </div>

    <button type="submit" class="btn btn-primary w-100 mb-3">Login</button>
    <div class="text-center">
      <small>New User? <a href="Register.jsp" class="fw-bold">Register here</a></small>
    </div>
  </form>
</div>

<%
String error = (String) request.getAttribute("error");
if (error != null) {
%>
<script>
  Swal.fire({
    icon: 'error',
    title: 'Login Failed',
    text: '<%= error %>',
    confirmButtonColor: '#d33',
    confirmButtonText: 'OK'
  });
</script>
<%
}
%>

<script>
  const togglePassword = document.querySelector('#togglePassword');
  const password = document.querySelector('#password');

  togglePassword.addEventListener('click', function () {
    const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
    password.setAttribute('type', type);

    // Toggle the icon (eye / eye-slash)
    this.classList.toggle('fa-eye');
    this.classList.toggle('fa-eye-slash');
  });
</script>

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
