<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>OTP Verification</title>
<style>
body {
  background: #f8f9fa;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  font-family: Arial, sans-serif;
}
.card {
  background: white;
  padding: 30px;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  width: 320px;
  text-align: center;
}
input {
  width: 100%;
  padding: 10px;
  margin-top: 10px;
}
button {
  background: #00274d;
  color: white;
  border: none;
  padding: 10px;
  width: 100%;
  margin-top: 10px;
  border-radius: 5px;
}
</style>
</head>
<body>
<div class="card">
  <h3>OTP Verification</h3>
  <form action="VerifyOTPServlet" method="post">
    <input type="text" name="otp" placeholder="Enter your OTP" required>
    <button type="submit">Verify</button>
  </form>
</div>
</body>
</html>
