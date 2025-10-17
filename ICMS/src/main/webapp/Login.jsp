<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login - ICMS</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="icon" type="image/x-icon" href="media/ICMS.png">
  <style>
    body {
      background-color: #f8f9fa;
      font-family: 'Segoe UI', sans-serif;
    }

    .login-box {
      max-width: 400px;
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

    .navbar {
      background-color: #00274d;
    }

    /* Responsive Adjustments */
    @media (max-width: 768px) {
      .login-box {
        margin: 40px 15px;
        padding: 30px 20px;
      }

      .navbar-brand span {
        font-size: 0.9rem;
      }

      .navbar-brand img {
        width: 35px;
      }

      #loginBtn {
        margin-bottom: 10px;
      }
    }

    @media (max-width: 480px) {
      .login-box {
        margin-top: 30px;
        padding: 25px 15px;
      }

      .navbar-brand span {
        display: block;
        font-size: 0.85rem;
        text-align: center;
      }

      .navbar-brand img {
        display: block;
        margin: 0 auto 5px;
      }
    }
  </style>
</head>

<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold d-flex align-items-center" href="Home.jsp">
      <img src="media/ICMS.png" alt="Logo" width="40" class="me-2">
      <span id="header-title">Infrastructure Complaint Management System</span>
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMenu">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse justify-content-end" id="navbarMenu">
      <ul class="navbar-nav mb-2 mb-lg-0">
        <li class="nav-item me-2">
          <a href="Home.jsp" class="btn btn-outline-light btn-sm w-100 mb-2" id="loginBtn">Home</a>
        </li>
        <li class="nav-item dropdown">
          <button class="btn btn-outline-light dropdown-toggle btn-sm w-100" type="button" data-bs-toggle="dropdown">
            <span id="language-label">Language</span>
          </button>
          <ul class="dropdown-menu dropdown-menu-end">
            <li><a class="dropdown-item" href="#" onclick="setLanguage('en')">English</a></li>
            <li><a class="dropdown-item" href="#" onclick="setLanguage('si')">සිංහල</a></li>
            <li><a class="dropdown-item" href="#" onclick="setLanguage('ta')">தமிழ்</a></li>
          </ul>
        </li>
      </ul>
    </div>
  </div>
</nav>

<!-- Login Box -->
<div class="login-box">
  <h3 class="text-center mb-4" id="login-title">Login</h3>
  <form action="${pageContext.request.contextPath}/Dashboard" method="post">
    <div class="mb-3">
      <label class="form-label" id="lbl-username">Username/Email</label>
      <input type="text" name="txtName" class="form-control" placeholder="Enter Username/Email" required>
    </div>

    <div class="mb-3">
      <label class="form-label" id="lbl-password">Password</label>
      <input type="password" name="txtPwd" class="form-control" placeholder="Enter password" required>
    </div>

    <button type="submit" class="btn btn-primary w-100 mb-3" id="btn-login">Login</button>

    <div class="text-center">
      <small id="register-text">New User? <a href="Register.jsp" class="fw-bold">Register here</a></small>
    </div>
  </form>
</div>

<script>
  const translations = {
    en: {
      title: "Infrastructure Complaint Management System",
      "header-title": "Infrastructure Complaint Management System",
      "language-label": "Language",
      "login-title": "Login",
      "lbl-username": "Username/Email",
      "lbl-password": "Password",
      "btn-login": "Login",
      "register-text": "New User? <a href='Register.jsp' class='fw-bold'>Register here</a>"
    },
    si: {
      title: "පහසුකම් ගැටළු කළමනාකරණ පද්ධතිය",
      "header-title": "පහසුකම් ගැටළු කළමනාකරණ පද්ධතිය",
      "language-label": "භාෂාව",
      "login-title": "ඇතුල් වන්න",
      "lbl-username": "පරිශීලක නාමය / ඊමේල්",
      "lbl-password": "රහස්පදය",
      "btn-login": "ඇතුල් වන්න",
      "register-text": "අලුත් පරිශීලකයෙක් ද? <a href='Register.jsp' class='fw-bold'>මෙතන ලියාපදිංචි වන්න</a>"
    },
    ta: {
      title: "அடித்தள புகார் மேலாண்மை அமைப்பு",
      "header-title": "அடித்தள புகார் மேலாண்மை அமைப்பு",
      "language-label": "மொழி",
      "login-title": "உள்நுழை",
      "lbl-username": "பயனர்பெயர் / மின்னஞ்சல்",
      "lbl-password": "கடவுச்சொல்",
      "btn-login": "உள்நுழை",
      "register-text": "புதிய பயனரா? <a href='Register.jsp' class='fw-bold'>இங்கே பதிவு செய்யவும்</a>"
    }
  };

  function setLanguage(lang) {
    for (const key in translations[lang]) {
      const el = document.getElementById(key);
      if (el) el.innerHTML = translations[lang][key];
    }
    document.title = translations[lang].title;
  }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
