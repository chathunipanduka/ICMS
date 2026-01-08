<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register - Infrastructure Complaint Management System</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link rel="icon" type="image/x-icon" href="media/BPS_LOGO.png">

<style>
body {
	background-image: url('media/bpms_bg.jpg');
	background-repeat: no-repeat;
	background-attachment: fixed;
	background-size: cover;
	margin: 0;
	min-height: 100vh;
}
body::before {
	content: '';
	position: fixed;
	inset: 0;
	background: rgba(255, 255, 255, 0.6);
	z-index: -1;
}

/* ===== NAVBAR (MATCHED EXACTLY) ===== */
.navbar {
	background-color: #002b5c;
}
.navbar-brand,
.navbar-brand span,
.nav-link {
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

/* Google Translate */
#google_translate_element {
	display: inline-block;
	margin: 10px;
}
.goog-te-gadget-simple {
	background-color: #f8f9fa !important;
	border: 1px solid #ccc !important;
	border-radius: 6px;
	padding: 5px 10px;
	display: inline-flex;
	align-items: center;
}
.goog-te-gadget-simple img {
	display: none;
}
.goog-te-gadget-simple span {
	color: #333 !important;
	font-size: 14px;
}

/* ===== REGISTER BOX ===== */
.register-box {
	max-width: 500px;
	margin: 80px auto;
	background: rgba(255, 255, 255, 0.95);
	padding: 40px;
	border-radius: 15px;
}
.btn-primary {
	background-color: #002b5c;
	border: none;
}

/* Password strength */
#strengthMeter { height: 6px; }
.strength-weak { width: 33%; background: #dc3545; }
.strength-medium { width: 66%; background: #ffc107; }
.strength-strong { width: 100%; background: #28a745; }

.toggle-password { cursor: pointer; }
</style>
</head>

<body>

<!-- Google Translate -->
<script>
	function googleTranslateElementInit() {
		new google.translate.TranslateElement({
			pageLanguage: 'en',
			includedLanguages: 'en,si,ta',
			layout: google.translate.TranslateElement.InlineLayout.SIMPLE
		}, 'google_translate_element');
	}
</script>
<script src="https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>

<!-- ===== NAVBAR ===== -->
<nav class="navbar navbar-expand-lg">
	<div class="container-fluid">
		<a class="navbar-brand fw-bold" href="Home.jsp">
			<img src="media/BPS_LOGO.png" alt="Logo" width="45" class="me-2">
			<span>Infrastructure Complaint Management System</span>
		</a>

		<button class="navbar-toggler" type="button"
			data-bs-toggle="collapse" data-bs-target="#navbarContent">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse" id="navbarContent">
			<ul class="navbar-nav ms-auto align-items-lg-center">
				<li><div id="google_translate_element"></div></li>
				<li class="nav-item"><a class="nav-link" href="Home.jsp">Home</a></li>
				<li class="nav-item"><a class="nav-link" href="About.jsp">About Us</a></li>
				<li class="nav-item"><a class="nav-link" href="Login.jsp">Login</a></li>
				<li class="nav-item"><a class="nav-link active" href="Register.jsp">Register</a></li>
				<li class="nav-item"><a class="nav-link" href="FAQ.jsp">FAQ</a></li>
			</ul>
		</div>
	</div>
</nav>

<!-- Register Box -->
<div class="register-box">
	<h3 class="text-center mb-4">Register</h3>

	<form action="RegisterServlet" method="post" onsubmit="return validateForm()">

		<div class="mb-3">
			<label class="form-label">First Name</label>
			<input type="text" class="form-control" name="fName" required>
		</div>

		<div class="mb-3">
			<label class="form-label">Last Name</label>
			<input type="text" class="form-control" name="lName" required>
		</div>

		<div class="mb-3">
			<label class="form-label">Username</label>
			<input type="text" class="form-control" name="uName" required>
		</div>

		<div class="mb-3">
			<label class="form-label">Email</label>
			<input type="email" class="form-control" name="email" required>
		</div>

		<div class="mb-3">
			<label class="form-label">Contact No</label>
			<input type="text" class="form-control" name="contact" required
				pattern="^(07\d{8}|\+947\d{8})$">
		</div>

		<div class="mb-3">
			<label class="form-label">Password</label>
			<div class="input-group">
				<input type="password" class="form-control" id="Pwd" name="Pwd"
					required onkeyup="checkStrength()">
				<span class="input-group-text toggle-password"
					onclick="togglePassword('Pwd', this)">
					<i class="bi bi-eye-slash"></i>
				</span>
			</div>
			<div class="progress mt-2">
				<div id="strengthMeter" class="progress-bar"></div>
			</div>
			<small id="strengthText" class="fw-bold"></small>
		</div>

		<div class="mb-3">
			<label class="form-label">Confirm Password</label>
			<div class="input-group">
				<input type="password" class="form-control" id="cPwd" name="cPwd" required>
				<span class="input-group-text toggle-password"
					onclick="togglePassword('cPwd', this)">
					<i class="bi bi-eye-slash"></i>
				</span>
			</div>
		</div>

		<button type="submit" class="btn btn-primary w-100">Register</button>
	</form>
</div>

<footer class="text-center text-white mt-4 p-3" style="background:#002b5c;">
	&copy; 2025 Biyagama Pradeshiya Sabha. All rights reserved.
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
