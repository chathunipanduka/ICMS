<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register - Infrastructure Complaint Management System</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8f9fa;
      font-family: 'Segoe UI', sans-serif;
    }
    .navbar {
      background-color: #003366;
    }
    .navbar-brand, .nav-link, .dropdown-toggle {
      color: white !important;
    }
    .register-box {
      max-width: 500px;
      margin: 80px auto;
      background: #fff;
      padding: 40px;
      border-radius: 15px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.2);
    }
    .btn-primary {
      background-color: #003366;
      border: none;
    }
    .btn-primary:hover {
      background-color: #002244;
    }
  </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="Home.jsp">
      <img src="media/logo.png" alt="Logo" width="40" class="me-2">
      <span id="title">Infrastructure Complaint Management System</span>
    </a>
    <div class="ms-auto">
      <div class="dropdown">
        <button class="btn btn-outline-light dropdown-toggle btn-sm" type="button" data-bs-toggle="dropdown">
          <span id="language-label">Language</span>
        </button>
        <ul class="dropdown-menu">
          <li><a class="dropdown-item" href="#" onclick="setLanguage('en')">English</a></li>
          <li><a class="dropdown-item" href="#" onclick="setLanguage('si')">සිංහල</a></li>
          <li><a class="dropdown-item" href="#" onclick="setLanguage('ta')">தமிழ்</a></li>
        </ul>
      </div>
    </div>
  </div>
</nav>

<!-- Register Form -->
<div class="register-box">
  <h3 class="text-center mb-4" id="register-title">Register</h3>
  <form action="RegisterServlet" method="post">

    <!-- First Name -->
    <div class="mb-3">
      <label class="form-label" id="lbl-fname">First Name</label>
      <input type="text" class="form-control" name="fName" placeholder="Enter first name" required>
    </div>
	
    <!-- Last Name -->
    <div class="mb-3">
      <label class="form-label" id="lbl-lname">Last Name</label>
      <input type="text" class="form-control" name="lName" placeholder="Enter last name" required>
    </div>

    <!-- Username -->
    <div class="mb-3">
      <label class="form-label" id="lbl-username">Username</label>
      <input type="text" class="form-control" name="uName" placeholder="Enter username" required>
    </div>
	
    <!-- Email -->
    <div class="mb-3">
      <label class="form-label" id="lbl-email">Email</label>
      <input type="email" class="form-control" name="email" placeholder="Enter email" required>
    </div>

    <!-- Password -->
    <div class="mb-3">
      <label class="form-label" id="lbl-password">Password</label>
      <input type="password" class="form-control" name="Pwd" placeholder="Enter password" required>
    </div>

    <!-- Confirm Password -->
    <div class="mb-3">
      <label class="form-label" id="lbl-confirm">Confirm Password</label>
      <input type="password" class="form-control" name="cPwd" placeholder="Confirm password" required>
    </div>

    <!-- Register Button -->
    <button type="submit" class="btn btn-primary w-100 mb-3" id="btn-register">Register</button>

    <!-- Login Link -->
    <div class="text-center">
      <small id="login-text">Already have an account? <a href="Login.jsp" class="fw-bold">Login here</a></small>
    </div>
  </form>
</div>

<script>
  const translationsRegister = {
    en: {
      title: "Infrastructure Complaint Management System",
      "language-label": "Language",
      "register-title": "Register",
      "lbl-fname": "First Name",
      "lbl-lname": "Last Name",
      "lbl-username": "Username",
      "lbl-email": "Email",
      "lbl-password": "Password",
      "lbl-confirm": "Confirm Password",
      "btn-register": "Register",
      "login-text": "Already have an account? <a href='Login.html' class='fw-bold'>Login here</a>"
    },
    si: {
      title: "පහසුකම් ගැටළු කළමනාකරණ පද්ධතිය",
      "language-label": "භාෂාව",
      "register-title": "ලියාපදිංචි වන්න",
      "lbl-fname": "මුල් නම",
      "lbl-lname": "අවසන් නම",
      "lbl-username": "පරිශීලක නාමය",
      "lbl-email": "ඊමේල්",
      "lbl-password": "රහස්පදය",
      "lbl-confirm": "රහස්පදය නැවත ඇතුල් කරන්න",
      "btn-register": "ලියාපදිංචි වන්න",
      "login-text": "දැනටමත් ගිණුමක් තිබේද? <a href='Login.html' class='fw-bold'>මෙතනින් ඇතුල් වන්න</a>"
    },
    ta: {
      title: "அடித்தள புகார் மேலாண்மை அமைப்பு",
      "language-label": "மொழி",
      "register-title": "பதிவு",
      "lbl-fname": "முதல் பெயர்",
      "lbl-lname": "கடைசி பெயர்",
      "lbl-username": "பயனர்பெயர்",
      "lbl-email": "மின்னஞ்சல்",
      "lbl-password": "கடவுச்சொல்",
      "lbl-confirm": "கடவுச்சொல்லை உறுதிப்படுத்துக",
      "btn-register": "பதிவு",
      "login-text": "ஏற்கனவே கணக்கு உள்ளதா? <a href='Login.html' class='fw-bold'>இங்கே உள்நுழைக</a>"
    }
  };

  function setLanguage(lang) {
    for (const key in translationsRegister[lang]) {
      const el = document.getElementById(key);
      if (el) el.innerHTML = translationsRegister[lang][key];
    }
  }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
