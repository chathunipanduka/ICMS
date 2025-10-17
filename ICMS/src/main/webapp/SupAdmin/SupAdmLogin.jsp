<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Super Admin Login - ICMS</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="icon" type="image/x-icon" href="../media/ICMS.png">

  <style>
    body {
      background-color: #f8f9fa;
      font-family: 'Segoe UI', sans-serif;
    }

    .navbar {
      background-color: #00274d;
    }

    .login-box {
      max-width: 400px;
      width: 90%;
      margin: 80px auto;
      background: #fff;
      padding: 40px 30px;
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

    .google-btn {
      background: white;
      border: 1px solid #ddd;
      border-radius: 5px;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
    }

    .google-btn img {
      width: 20px;
    }

    footer {
      background-color: #002b5c;
      color: #ffffff;
      text-align: center;
      padding: 20px 10px;
      border-radius: 15px 15px 0 0;
      margin-top: 60px;
    }

    /* 🔹 Responsive adjustments */
    @media (max-width: 768px) {
      .navbar-brand span {
        font-size: 14px;
      }
      .login-box {
        margin: 60px auto;
        padding: 30px 20px;
      }
      h3 {
        font-size: 20px;
      }
      footer p {
        font-size: 14px;
        margin: 5px 0;
      }
    }

    @media (max-width: 480px) {
      .navbar-brand img {
        width: 35px;
      }
      .navbar-brand span {
        font-size: 13px;
      }
      .login-box {
        padding: 25px 15px;
        margin: 40px auto;
      }
      h3 {
        font-size: 18px;
      }
      .btn {
        font-size: 14px;
      }
    }
  </style>
</head>
<body>

<!-- 🔹 Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold d-flex align-items-center" href="Home.jsp">
      <img src="../media/ICMS.png" alt="Logo" width="40" class="me-2">
      <span id="header-title">Infrastructure Complaint Management System</span>
    </a>
  </div>
</nav>

<!-- 🔹 Login Box -->
<div class="login-box">
  <h3 class="text-center mb-4">Super Admin Login</h3>

  <form action="${pageContext.request.contextPath}/SuperAdminLogin" method="post">
    <div class="mb-3">
      <label class="form-label">Username</label>
      <input type="text" name="superAdminName" class="form-control" placeholder="Enter username" required>
    </div>

    <div class="mb-3">
      <label class="form-label">Password</label>
      <input type="password" name="superAdminPwd" class="form-control" placeholder="Enter password" required>
    </div>

    <button type="submit" class="btn btn-primary w-100 mb-3">Login</button>

    <p class="text-center">
      <a href="../Login.jsp">Back to User/Admin Login</a>
    </p>
  </form>

  <% String error = (String) request.getAttribute("error"); %>
  <% if (error != null) { %>
    <div class="alert alert-danger text-center mt-3" role="alert">
        <%= error %>
    </div>
  <% } %>
</div>

<!-- 🔹 Footer -->
<footer>
  <p>© 2025 Biyagama Pradeshiya Sabha | Infrastructure Complaint Management System</p>
  <p>Designed and Developed for Public Service</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
