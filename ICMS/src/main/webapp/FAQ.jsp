<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/x-icon" href="media/BPS_LOGO.png">
<title>ICMS - FAQ</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
/* ================= GLOBAL ================= */
body {
	background-image: url('media/bpms_bg.jpg');
	background-repeat: no-repeat;
	background-attachment: fixed;
	background-size: cover;
	margin: 0;
	min-height: 100vh;
	font-family: 'Segoe UI', sans-serif;
}

body::before {
	content: '';
	position: fixed;
	inset: 0;
	background: rgba(255, 255, 255, 0.6);
	z-index: -1;
}

/* ================= NAVBAR ================= */
.navbar {
	background-color: #002b5c;
}

.navbar-brand, .nav-link {
	color: #ffffff !important;
}

.navbar-toggler {
	border: none;
}

.navbar-toggler-icon {
	background-image:
		url("data:image/svg+xml;charset=utf8,%3Csvg viewBox='0 0 30 30' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath stroke='white' stroke-width='2' stroke-linecap='round' d='M4 7h22M4 15h22M4 23h22'/%3E%3C/svg%3E");
}

.navbar .nav-link.active::after {
	content: "";
	display: block;
	height: 2px;
	background-color: #ffffff;
}

/* ================= FAQ ================= */
.icms-header-bg {
	background: #003366;
	color: white;
	padding: 20px 0;
	text-align: center;
	font-size: 28px;
	font-weight: bold;
}

.faq-category {
	background: #003366;
	color: white;
	padding: 12px 18px;
	border-radius: 6px;
	margin-top: 30px;
	margin-bottom: 10px;
	font-size: 20px;
}

.search-box input {
	border-radius: 8px;
	padding: 12px;
	border: 1px solid #ccc;
	font-size: 15px;
}

.accordion-button {
	font-size: 17px;
	font-weight: 600;
}

.accordion-body {
	font-size: 15px;
	line-height: 1.6;
}

/* ================= FOOTER ================= */
footer {
	background-color: #002b5c;
	color: #ffffff;
	text-align: center;
	padding: 20px 10px;
	border-radius: 15px 15px 0 0;
	margin-top: 40px;
}

/* ================= MOBILE (MATCH HOME) ================= */

/* Tablets */
@media ( max-width : 992px) {
	.icms-header-bg {
		font-size: 22px;
	}
	.faq-category {
		font-size: 18px;
	}
	.accordion-button {
		font-size: 15px;
	}
	.accordion-body {
		font-size: 14px;
	}
}

/* Phones */
@media ( max-width : 768px) {
	.icms-header-bg {
		font-size: 18px;
		padding: 16px;
	}
	.faq-category {
		font-size: 15px;
		padding: 10px 14px;
	}
	.accordion-button {
		font-size: 14px;
		padding: 12px;
	}
	.accordion-body {
		font-size: 14px;
	}
	.search-box input {
		font-size: 14px;
	}
	.navbar-brand span {
		font-size: 14px;
	}
	.nav-link {
		font-size: 14px;
	}
}

/* Small phones */
@media ( max-width : 576px) {
	.icms-header-bg {
		font-size: 16px;
	}
	.faq-category {
		font-size: 14px;
	}
	.accordion-button {
		font-size: 13px;
	}
	.accordion-body {
		font-size: 13px;
	}
	footer p, footer a {
		font-size: 12px;
	}
}

/* Extra small */
@media ( max-width : 400px) {
	.icms-header-bg {
		font-size: 14px;
	}
	.accordion-button {
		font-size: 12.5px;
	}
	.accordion-body {
		font-size: 12.5px;
	}
	.navbar-brand span {
		font-size: 12px;
	}
}

/* ================= GOOGLE TRANSLATE ================= */
#google_translate_element {
	margin: 10px;
}

.goog-te-gadget-simple {
	background-color: #f8f9fa !important;
	border: 1px solid #ccc !important;
	border-radius: 6px;
	padding: 5px 10px;
}

.goog-te-gadget-simple img {
	display: none;
}

.goog-te-gadget-simple span {
	font-size: 14px !important;
}
</style>

<script>
function searchFAQ() {
  let input = document.getElementById("faqSearch").value.toLowerCase();
  document.querySelectorAll(".accordion-item").forEach(item => {
    item.style.display = item.innerText.toLowerCase().includes(input) ? "block" : "none";
  });
}
</script>
</head>

<body>

	<script>
function googleTranslateElementInit() {
  new google.translate.TranslateElement(
    { pageLanguage: 'en', includedLanguages: 'en,si,ta' },
    'google_translate_element'
  );
}
</script>
	<script
		src="https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>

	<!-- NAVBAR -->
	<nav class="navbar navbar-expand-lg">
		<div class="container-fluid">
			<a class="navbar-brand fw-bold d-flex align-items-center"
				href="Home.jsp"> <img src="media/BPS_LOGO.png" width="45"
				class="me-2"> <span>Infrastructure Complaint Management
					System</span>
			</a>
			<button class="navbar-toggler" data-bs-toggle="collapse"
				data-bs-target="#navbarContent">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarContent">
				<ul class="navbar-nav ms-auto">
					<li><div id="google_translate_element"></div></li>
					<li class="nav-item"><a class="nav-link" href="Home.jsp">Home</a></li>
					<li class="nav-item"><a class="nav-link" href="About.jsp">About
							Us</a></li>
					<li class="nav-item"><a class="nav-link" href="Login.jsp">Login</a></li>
					<li class="nav-item"><a class="nav-link" href="Register.jsp">Register</a></li>
					<li class="nav-item"><a class="nav-link active" href="FAQ.jsp">FAQ</a></li>
				</ul>
			</div>
		</div>
	</nav>

	<!-- CONTENT (UNCHANGED) -->
	<div class="container mt-4 mb-5">
		<div class="icms-header-bg">Frequently Asked Questions (FAQ)</div>

		<div class="search-box mt-4 mb-3">
			<input type="text" id="faqSearch" onkeyup="searchFAQ()"
				class="form-control" placeholder="Search FAQ...">
		</div>

		<!-- FAQ Sections -->
		<div class="accordion" id="faqAccordion">
			<!-- 1. General -->
			<div class="faq-category">1. General Questions</div>
			<div class="accordion-item">
				<h2 class="accordion-header">
					<button class="accordion-button collapsed"
						data-bs-toggle="collapse" data-bs-target="#g1">What is
						ICMS?</button>
				</h2>
				<div id="g1" class="accordion-collapse collapse">
					<div class="accordion-body">ICMS is an Integrated Complaint
						Management System used to submit, track, and manage public
						complaints.</div>
				</div>
			</div>
			<div class="accordion-item">
				<h2 class="accordion-header">
					<button class="accordion-button collapsed"
						data-bs-toggle="collapse" data-bs-target="#g2">Who can
						use ICMS?</button>
				</h2>
				<div id="g2" class="accordion-collapse collapse">
					<div class="accordion-body">Any registered or Non registered
						user or authorized officer can use the system.</div>
				</div>
			</div>
			<div class="accordion-item">
				<h2 class="accordion-header">
					<button class="accordion-button collapsed"
						data-bs-toggle="collapse" data-bs-target="#g3">Do I need
						an account to submit a complaint?</button>
				</h2>
				<div id="g3" class="accordion-collapse collapse">
					<div class="accordion-body">Yes, registration is required to
						submit and track complaints. Non Registered User can Submit the
						complaint but they didnt recieved the complaints status or any
						details. If you want updates about complaint you need to register.
					</div>
				</div>
			</div>
			<!-- 2. Account -->
			<div class="faq-category">2. Account & Profile</div>
			<div class="accordion-item">
				<h2 class="accordion-header">
					<button class="accordion-button collapsed"
						data-bs-toggle="collapse" data-bs-target="#a1">How do I
						create an account?</button>
				</h2>
				<div id="a1" class="accordion-collapse collapse">
					<div class="accordion-body">Click Register, enter your
						details, and submit the form. You Need to remeber your Username or
						Email and Password Next Login.</div>
				</div>
			</div>
			<div class="accordion-item">
				<h2 class="accordion-header">
					<button class="accordion-button collapsed"
						data-bs-toggle="collapse" data-bs-target="#a2">I forgot
						my password. What should I do?</button>
				</h2>
				<div id="a2" class="accordion-collapse collapse">
					<div class="accordion-body">Use the “Forgot Password” option
						to reset your password.</div>
				</div>
			</div>
			<!-- 3. Complaints -->
			<div class="faq-category">3. Complaints & Reporting</div>
			<div class="accordion-item">
				<h2 class="accordion-header">
					<button class="accordion-button collapsed"
						data-bs-toggle="collapse" data-bs-target="#c1">How do I
						submit a complaint?</button>
				</h2>
				<div id="c1" class="accordion-collapse collapse">
					<div class="accordion-body">Go to Add Complaint → Select
						category → Add details → Upload images → Submit.</div>
				</div>
			</div>
			<div class="accordion-item">
				<h2 class="accordion-header">
					<button class="accordion-button collapsed"
						data-bs-toggle="collapse" data-bs-target="#c2">Can I edit
						a complaint after submitting?</button>
				</h2>
				<div id="c2" class="accordion-collapse collapse">
					<div class="accordion-body">Editing is allowed, but editing
						is allowed within 7 days after submiting.</div>
				</div>
			</div>
			<!-- 4. Notifications -->
			<div class="faq-category">4. Notifications</div>
			<div class="accordion-item">
				<h2 class="accordion-header">
					<button class="accordion-button collapsed"
						data-bs-toggle="collapse" data-bs-target="#n1">Where do I
						receive notifications?</button>
				</h2>
				<div id="n1" class="accordion-collapse collapse">
					<div class="accordion-body">You will receive notifications in
						the bottom-left notification bell icon.</div>
				</div>
			</div>
			<!-- 5. Technical -->
			<div class="faq-category">5. Technical Issues</div>
			<div class="accordion-item">
				<h2 class="accordion-header">
					<button class="accordion-button collapsed"
						data-bs-toggle="collapse" data-bs-target="#t1">Website is
						not loading properly</button>
				</h2>
				<div id="t1" class="accordion-collapse collapse">
					<div class="accordion-body">Try refreshing, updating your
						browser, or checking your network.</div>
				</div>
			</div>
			<!-- 6. Admin -->
			<div class="faq-category">6. Admin & Officers</div>
			<div class="accordion-item">
				<h2 class="accordion-header">
					<button class="accordion-button collapsed"
						data-bs-toggle="collapse" data-bs-target="#ad1">How do
						officers log in?</button>
				</h2>
				<div id="ad1" class="accordion-collapse collapse">
					<div class="accordion-body">Officers log in using credentials
						provided by the administrator.</div>
				</div>
			</div>
			<!-- 7. Security -->
			<div class="faq-category">7. Security & Privacy</div>
			<div class="accordion-item">
				<h2 class="accordion-header">
					<button class="accordion-button collapsed"
						data-bs-toggle="collapse" data-bs-target="#s1">Is my
						information secure?</button>
				</h2>
				<div id="s1" class="accordion-collapse collapse">
					<div class="accordion-body">Yes, all data is stored securely
						and access is restricted.</div>
				</div>
			</div>
			<!-- 8. Support -->
			<div class="faq-category">8. Contact & Support</div>
			<div class="accordion-item">
				<h2 class="accordion-header">
					<button class="accordion-button collapsed"
						data-bs-toggle="collapse" data-bs-target="#cs1">How can I
						contact support?</button>
				</h2>
				<div id="cs1" class="accordion-collapse collapse">
					<div class="accordion-body">
						<p>Email: info@biyagama.ps.lk</p>
						<p>Phone: +94 11 234 5678</p>
						<p>Address: Biyagama Pradeshiya Sabha, Biyagama, Sri Lanka</p>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- FOOTER -->
	<footer>
		<div class="container">
			<div class="row text-center text-md-start">
				<div class="col-md-4 mb-3">
					<h5>Biyagama Pradeshiya Sabha</h5>
					<p>Providing efficient infrastructure complaint management and
						citizen services for a better community.</p>
				</div>
				<div class="col-md-4 mb-3">
					<h5>Quick Links</h5>
					<ul class="list-unstyled">
						<li><a href="Home.jsp"
							class="text-light text-decoration-none">Home</a></li>
						<li><a href="Login.jsp"
							class="text-light text-decoration-none">Login</a></li>
						<li><a href="Register.jsp"
							class="text-light text-decoration-none">SignUp</a></li>
					</ul>
				</div>
				<div class="col-md-4 mb-3">
					<h5>Contact Us</h5>
					<p>Email: info@biyagama.ps.lk</p>
					<p>Phone: +94 11 234 5678</p>
					<p>Address: Biyagama Pradeshiya Sabha, Biyagama, Sri Lanka</p>
				</div>
			</div>
			<hr class="bg-light">
			<div class="text-center pb-3">&copy; 2025 Biyagama Pradeshiya
				Sabha. All rights reserved.</div>
		</div>
	</footer>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
