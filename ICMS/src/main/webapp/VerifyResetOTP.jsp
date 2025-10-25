<!DOCTYPE html>
<html>
<head>
<title>Verify OTP</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
  <div class="card p-4 shadow-sm">
    <h3>Verify OTP</h3>
    <form action="VerifyResetOTPServlet" method="post">
      <div class="mb-3">
        <label for="otp" class="form-label">Enter OTP</label>
        <input type="text" class="form-control" name="otp" required maxlength="6">
      </div>
      <button type="submit" class="btn btn-success">Verify</button>
    </form>
  </div>
</div>
</body>
</html>
