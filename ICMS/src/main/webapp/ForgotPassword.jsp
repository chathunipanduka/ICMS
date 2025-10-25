<!DOCTYPE html>
<html>
<head>
<title>Forgot Password</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
  <div class="card p-4 shadow-sm">
    <h3>Forgot Password</h3>
    <form action="${pageContext.request.contextPath}/ForgotPasswordServlet" method="post">
      <div class="mb-3">
        <label for="email" class="form-label">Enter your email</label>
        <input type="email" class="form-control" name="email" required>
      </div>
      <button type="submit" class="btn btn-primary">Send OTP</button>
    </form>
  </div>
</div>
</body>
</html>
