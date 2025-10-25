<!DOCTYPE html>
<html>
<head>
<title>Reset Password</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
  <div class="card p-4 shadow-sm">
    <h3>Reset Your Password</h3>
    <form action="ResetPasswordServlet" method="post">
      <div class="mb-3">
        <label for="newPwd" class="form-label">New Password</label>
        <input type="password" class="form-control" name="newPwd" required>
      </div>
      <div class="mb-3">
        <label for="confirmPwd" class="form-label">Confirm Password</label>
        <input type="password" class="form-control" name="confirmPwd" required>
      </div>
      <button type="submit" class="btn btn-primary">Reset Password</button>
    </form>
  </div>
</div>
</body>
</html>
