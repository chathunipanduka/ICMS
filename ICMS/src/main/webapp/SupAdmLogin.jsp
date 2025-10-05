<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Super Admin Login - ICMS</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background-color: #f8f9fa; font-family: 'Segoe UI', sans-serif; }
    .login-box { max-width: 400px; margin: 80px auto; background: #fff; padding: 40px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); }
    .btn-primary { background-color: #003366; border: none; }
    .btn-primary:hover { background-color: #002244; }
    .google-btn {
      background: white; border: 1px solid #ddd; border-radius: 5px;
      display: flex; align-items: center; justify-content: center; gap: 8px;
    }
    .google-btn img { width: 20px; }
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

<div class="login-box">
  <h3 class="text-center mb-4">Super Admin Login</h3>

  <form action="SuperAdminLogin" method="post">
    <div class="mb-3">
      <label class="form-label">Username</label>
      <input type="text" name="superAdminName" class="form-control" placeholder="Enter username" required>
    </div>

    <div class="mb-3">
      <label class="form-label">Password</label>
      <input type="password" name="superAdminPwd" class="form-control" placeholder="Enter password" required>
    </div>

    <button type="submit" class="btn btn-primary w-100 mb-3">Login</button>

    <!-- Google Login 
    <button type="button" class="google-btn w-100 mb-3">
      <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google logo">
      <span>Login with Google</span>
    </button>-->

    <p class="text-center">
      <a href="Login.jsp">Back to User/Admin Login</a>
    </p>
  </form>
</div>
<footer>
  <p>© 2025 Biyagama Pradeshiya Sabha | Infrastructure Complaint Management System</p>
  <p>Designed and Developed for Public Service</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
