<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title >Login - ICMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="icon" type="image/x-icon" href="media/ICMS.png">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', sans-serif; }
        .login-box { max-width: 400px; margin: 50px auto; background: #fff; padding: 40px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); }
        .btn-primary { background-color: #003366; border: none; }
        .btn-primary:hover { background-color: #002244; }
        .btn-google { border: 1px solid #ccc; background-color: #fff; color: #333; }
        .btn-google img { width: 20px; margin-right: 8px; }
        .navbar {
      background-color: #00274d; /* Dark Blue */
    }
    </style>
</head>
<body>
<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="Home.jsp">
      <img src="media/logo.png" alt="Logo" width="40" class="me-2">
      <span id="header-title">Infrastructure Complaint Management System</span>
    </a>
    <div class="ms-auto">
      <div class="dropdown">
      <a href="Home.jsp">
        <button class="btn btn-outline-light btn-sm me-3" id="loginBtn">Home</button>
      </a>
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

<!-- Login -->
<div class="login-box">
    <h3 class="text-center mb-4" id="login-title">Login</h3>
    <form action="${pageContext.request.contextPath}/Dashboard" method="post">
        <div class="mb-3">
            <label class="form-label" id="lbl-role">Role</label>
            <select class="form-select" name="lbl-role" required>
                <option value="User" id="role-user">User</option>
                <option value="Admin" id="role-admin">Admin</option>
            </select>
        </div>
        <div class="mb-3">
            <label class="form-label" id="lbl-username">Username/Email</label>
            <input type="text" name="txtName" class="form-control" placeholder="Enter Username/ Email" required>
        </div>
        <div class="mb-3">
            <label class="form-label" id="lbl-password">Password</label>
            <input type="password" name="txtPwd" class="form-control" placeholder="Enter password" required>
        </div>
        <button type="submit" class="btn btn-primary w-100" id="btn-login">Login</button>
      <!--    <div class="text-center my-2" id="or-text">OR</div>
        <button type="button" class="btn btn-google w-100 mb-3">
            <img src="https://www.svgrepo.com/show/475656/google-color.svg" alt="Google Logo">
            <span id="google-text">Login with Google</span>
        </button>-->
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
            "lbl-role": "Role",
            "role-user": "User",
            "role-admin": "Admin",
            "lbl-username": "Username",
            "lbl-password": "Password",
            "btn-login": "Login",
            "or-text": "OR",
            "google-text": "Login with Google",
            "register-text": "New User? <a href='Register.jsp' class='fw-bold'>Register here</a>"
        },
        si: {
            title: "පහසුකම් ගැටළු කළමනාකරණ පද්ධතිය",
            "header-title": "පහසුකම් ගැටළු කළමනාකරණ පද්ධතිය",
            "language-label": "භාෂාව",
            "login-title": "ඇතුල් වන්න",
            "lbl-role": "භූමිකාව",
            "role-user": "පරිශීලක",
            "role-admin": "පරිපාලක",
            "lbl-username": "පරිශීලක නාමය",
            "lbl-password": "රහස්පදය",
            "btn-login": "ඇතුල් වන්න",
            "or-text": "හෝ",
            "google-text": "Google මඟින් ඇතුල් වන්න",
            "register-text": "අලුත් පරිශීලකයෙක් ද? <a href='Register.jsp' class='fw-bold'>මෙතන ලියාපදිංචි වන්න</a>"
        },
        ta: {
            title: "அடித்தள புகார் மேலாண்மை அமைப்பு",
            "header-title": "அடித்தள புகார் மேலாண்மை அமைப்பு",
            "language-label": "மொழி",
            "login-title": "உள்நுழை",
            "lbl-role": "பங்கு",
            "role-user": "பயனர்",
            "role-admin": "நிர்வாகி",
            "lbl-username": "பயனர்பெயர்",
            "lbl-password": "கடவுச்சொல்",
            "btn-login": "உள்நுழை",
            "or-text": "அல்லது",
            "google-text": "Google மூலம் உள்நுழைக",
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

    setLanguage('en'); // Default
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
