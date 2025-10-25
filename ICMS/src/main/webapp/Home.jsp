<%@ page import="java.sql.*, ICMSpackage.IcmsConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Infrastructure Complaint Management System - Biyagama Pradeshiya Sabha</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="icon" type="image/x-icon" href="media/BPS_LOGO.png">

<style>
body {
  font-family: 'Segoe UI', sans-serif;
  position: relative;
  min-height: 100vh;
  margin: 0;
}

/* Background */
body::before {
  content: "";
  background-color: #E6F0FA;
  position: absolute;
  top: 0; left: 0;
  width: 100%; height: 100%;
  z-index: -1;
}

/* Navbar */
.navbar {
  background-color: #002b5c;
}
.navbar-brand, .nav-link, .dropdown-toggle {
  color: #ffffff !important;
}
.navbar-toggler {
  border: none;
}
.navbar-toggler-icon {
  background-image: url("data:image/svg+xml;charset=utf8,%3Csvg viewBox='0 0 30 30' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath stroke='white' stroke-width='2' stroke-linecap='round' stroke-miterlimit='10' d='M4 7h22M4 15h22M4 23h22'/%3E%3C/svg%3E");
}

/* Complaint Section */
.complaint-section {
  background-color: rgba(255,255,255,0.9);
  padding: 40px;
  border-radius: 15px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  margin-top: -40px;
}

/* Buttons */
.btn-primary {
  background-color: #002b5c;
  border: none;
}
.btn-primary:hover {
  background-color: #001a38;
}
.btn-outline-light:hover {
  background-color: #ffffff;
  color: #002b5c !important;
}

/* Cards */
.card {
  border: none;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  border-radius: 12px;
  background-color: #ffffff;
}

/* Footer */
footer {
  background-color: #002b5c;
  color: #ffffff;
  text-align: center;
  padding: 20px 10px;
  border-radius: 15px 15px 0 0;
  margin-top: 40px;
}

/* Responsive Adjustments */
@media (max-width: 992px) {
  .navbar .d-flex {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }
}

@media (max-width: 768px) {
  .complaint-section {
    padding: 25px;
    margin-top: 0;
  }
  #hero-title, #hero-sub {
    font-size: 16px;
    text-align: center;
  }
  .navbar-brand img {
    width: 35px;
  }
  .navbar-brand span {
    font-size: 14px;
  }
  .carousel-caption {
    padding: 10px;
  }
}

@media (max-width: 576px) {
  #hero-title {
    font-size: 15px;
    padding: 6px 12px;
  }
  #hero-sub {
    font-size: 13px;
    padding: 5px 10px;
  }
  .btn {
    font-size: 13px;
    padding: 6px 10px;
  }
  footer p {
    font-size: 12px;
  }
  .card p {
    font-size: 14px;
  }
  .card {
    padding: 15px !important;
  }
}

@media (max-width: 400px) {
  .navbar-brand span {
    display: block;
    font-size: 12px;
    line-height: 1.2;
  }
  #lbt-view {
    font-size: 12px;
  }
  .complaint-section h3 {
    font-size: 16px;
  }
}

/* Underline active navbar link */
.navbar .nav-link.active {
  position: relative;
  color: #ffffff !important;
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

@media (max-width: 768px) {
  #hero-title { font-size: 1rem; }
  #hero-sub { font-size: 0.9rem; }
  .carousel-caption button { font-size: 0.8rem; padding: 6px 10px; }
}

#google_translate_element {
    display: inline-block;
    margin: 10px;
  }

  .goog-te-gadget-simple {
    background-color: #f8f9fa !important;
    border: 1px solid #ccc !important;
    border-radius: 6px;
    padding: 5px 10px;
    font-family: 'Segoe UI', sans-serif !important;
    color: #333 !important;
    display: inline-flex;
    align-items: center;
  }

  .goog-te-gadget-simple img {
    display: none; /* Hide Google icon if you want */
  }

  .goog-te-gadget-simple span {
    color: #333 !important;
    font-size: 14px !important;
  }


</style>
</head>
<body>
<!-- Google Translate Element -->
<div id="google_translate_element"></div>

<script type="text/javascript">
  function googleTranslateElementInit() {
    new google.translate.TranslateElement(
      {
        pageLanguage: 'en',          // Your site’s original language
        includedLanguages: 'en,si,ta', // Optional: restrict languages (English, Sinhala, Tamil)
        layout: google.translate.TranslateElement.InlineLayout.SIMPLE
      },
      'google_translate_element'
    );
  }
</script>

<!-- Google Translate Script -->
<script type="text/javascript" 
  src="https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit">
</script>



<!-- Navbar -->
<nav class="navbar navbar-expand-lg">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="Home.jsp">
      <img src="media/BPS_LOGO.png" alt="Sri Lanka Logo" width="45" class="me-2">
      <span id="title">Infrastructure Complaint Management System</span>
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarContent">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link active" href="Home.jsp">Home</a></li>
        <li class="nav-item"><a class="nav-link" href="About.jsp">About Us</a></li>
        <li class="nav-item"><a class="nav-link" href="Login.jsp">Login</a></li>
        <li class="nav-item"><a class="nav-link" href="Register.jsp">SignUp</a></li>
      </ul>
    </div>
  </div>
</nav>

<!-- Carousel -->
<div id="icmsCarousel" class="carousel slide" data-bs-ride="carousel">
  <div class="carousel-inner">

    <div class="carousel-item active">
      <img src="media/slide1.png" class="d-block w-100" alt="Slide 1" style="height:400px; object-fit:cover;">
    </div>

    <div class="carousel-item">
      <img src="media/slide2.png" class="d-block w-100" alt="Slide 2" style="height:400px; object-fit:cover;">
    </div>

    <div class="carousel-item">
      <img src="media/slide3.png" class="d-block w-100" alt="Slide 3" style="height:400px; object-fit:cover;">
    </div>

  </div>

  <!-- Overlay -->
  <div class="carousel-caption d-flex flex-column justify-content-center align-items-center h-100 text-center px-3" 
       style="background: rgba(0, 0, 0, 0.45); top: 0; left: 0; width: 100%; height: 100%;">
       <img src="media/logo.png" alt="Sri Lanka Logo" width="80" class="me-2">
    <h2 id="hero-title" class="fw-bold text-white p-2 rounded">Welcome to Infrastructure Complaint Management System</h2>
    <p id="hero-sub" class="fw-medium text-light p-2 rounded">Report infrastructure complaints quickly and anonymously</p>
    <a href="Login.jsp" class="mt-3">
      <button class="btn btn-outline-light btn-sm">View Status →</button>
    </a>
  </div>

  <!-- Optional controls -->
  <button class="carousel-control-prev" type="button" data-bs-target="#icmsCarousel" data-bs-slide="prev">
    <span class="carousel-control-prev-icon"></span>
  </button>
  <button class="carousel-control-next" type="button" data-bs-target="#icmsCarousel" data-bs-slide="next">
    <span class="carousel-control-next-icon"></span>
  </button>
</div>


<!-- Complaint Form -->
<div class="container my-5">
  <div class="complaint-section">
    <h3 id="form-title" class="mb-4 text-center">Send Complaint Anonymously</h3>
    <form action="AnonymousSubmitComplaintServlet" method="post" enctype="multipart/form-data">
      <div class="mb-3">
        <label id="lbl-complaint" class="form-label">Enter Complaint</label>
        <textarea class="form-control" rows="3" name="description"></textarea>
      </div>
      <div class="mb-3">
        <label class="form-label">Category</label>
        <select name="category" class="form-select" required>
          <option value="">Select Category</option>
          <%
              Connection con = null;
              PreparedStatement ps = null;
              ResultSet rs = null;
              try {
                  con = IcmsConnection.getConnection();
                  ps = con.prepareStatement("SELECT category_name FROM category_tb");
                  rs = ps.executeQuery();
                  while (rs.next()) {
          %>
          <option value="<%=rs.getString("category_name")%>"><%=rs.getString("category_name")%></option>
          <%
                  }
              } catch (Exception e) {
                  out.println("<option>Error loading category</option>");
              } finally {
                  if (rs != null) rs.close();
                  if (ps != null) ps.close();
                  if (con != null) con.close();
              }
          %>
        </select>
      </div>
      <div class="mb-3">
        <label id="lbl-media" class="form-label">Upload Media</label>
        <input type="file" class="form-control" name="media">
      </div>
      <div class="mb-3">
        <label id="lbl-location" class="form-label">Tag Location</label>
        <input type="text" class="form-control" placeholder="Enter location" name="location">
      </div>
      <small id="private-reply" class="text-muted">If you want a private reply, please <a href="Login.jsp" id="login-link">Login here</a></small>
      <button type="submit" class="btn btn-primary w-100 mt-3" id="btn-submit">Submit Complaint</button>
    </form>
  </div>
</div>
<br>
<hr>
<div class="d-flex justify-content-center gap-5 bg-white p-5">
  <img src="media/BPS_LOGO.png" alt="Image 1" width="100" height="100">
  <img src="media/logo.png" alt="Image 2" width="130" height="100">
  <img src="media/ICMS.png" alt="Image 3" width="100" height="100">
  <img src="media/CEA.png" alt="Image 4" width="100" height="100">
  <img src="media/CEB.png" alt="Image 5" width="100" height="100">
</div>
<hr>
<br>

<!-- Department Cards -->
<div class="container mt-5">
  <h4 class="text-center mb-4" style="color:#002b5c">Department Overview</h4>
  <div class="row g-4 justify-content-center">
    <div class="col-sm-6 col-md-4">
      <div class="card text-center p-4">
<div class="text-center my-3">
    <img src="media/factory.png" alt="Sri Lanka Logo" width="45" class="img-fluid">
</div>
        <h5 class="card-title text-secondary">Industrial Division</h5>
        <p>Oversees regulation and development of industrial activities, ensuring compliance with environmental and safety standards.</p>
      </div>
    </div>
    <div class="col-sm-6 col-md-4">
      <div class="card text-center p-4">
      <div class="text-center my-3">
    <img src="media/division.png" alt="Sri Lanka Logo" width="45" class="img-fluid">
</div>
        <h5 class="card-title text-secondary">Sub Office</h5>
        <p>Provides essential public services and manages citizen requests closer to residents without visiting the main office.</p>
      </div>
    </div>
    <div class="col-sm-6 col-md-4">
      <div class="card text-center p-4">
      <div class="text-center my-3">
    <img src="media/electric-factory.png" alt="Sri Lanka Logo" width="45" class="img-fluid">
</div>
        <h5 class="card-title text-secondary">Electrical Division</h5>
        <p>Responsible for maintaining and repairing street lighting and public electrical systems ensuring reliable infrastructure.</p>
      </div>
    </div>
    <div class="col-sm-6 col-md-4">
      <div class="card text-center p-4">
      <div class="text-center my-3">
    <img src="media/public-health.png" alt="Sri Lanka Logo" width="45" class="img-fluid">
</div>
        <h5 class="card-title text-secondary">PHI</h5>
        <p>Ensures public health through sanitation monitoring, food safety, and disease prevention programs.</p>
      </div>
    </div>
    <div class="col-sm-6 col-md-4">
      <div class="card text-center p-4">
      <div class="text-center my-3">
    <img src="media/profit.png" alt="Sri Lanka Logo" width="45" class="img-fluid">
</div>
        <h5 class="card-title text-secondary">Revenue Inspector</h5>
        <p>Manages tax and fee collection to fund public services and infrastructure projects effectively.</p>
      </div>
    </div>
  </div>
</div>


<!-- Optional: Auto slide interval -->
<script>
  const icmsCarousel = document.querySelector('#icmsCarousel');
  const carousel = new bootstrap.Carousel(icmsCarousel, {
    interval: 4000,  // Auto slide every 4 seconds
    pause: 'hover'   // Stop sliding when hovered
  });
</script>


<!-- Footer -->
<footer class="text-light pt-4">
  <div class="container">
    <div class="row text-center text-md-start">
      <div class="col-md-4 mb-3">
        <h5>Biyagama Pradeshiya Sabha</h5>
        <p>Providing efficient infrastructure complaint management and citizen services for a better community.</p>
      </div>
      <div class="col-md-4 mb-3">
        <h5>Quick Links</h5>
        <ul class="list-unstyled">
          <li><a href="Home.jsp" class="text-light text-decoration-none">Home</a></li>
          <li><a href="Login.jsp" class="text-light text-decoration-none">Submit Complaint</a></li>
          <li><a href="About.jsp" class="text-light text-decoration-none">About Us</a></li>
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
    <div class="text-center pb-3">&copy; 2025 Biyagama Pradeshiya Sabha. All rights reserved.</div>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
