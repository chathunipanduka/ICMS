<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Infrastructure Complaint Management System - Biyagama Pradeshiya Sabha</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="icon" type="image/x-icon" href="media/ICMS.png">
<style>
  body {
    font-family: 'Segoe UI', sans-serif;
    position: relative;
    min-height: 100vh;
    margin: 0;
  }

  /* Blurred Background Image */
  body::before {
    content: "";
    background: url("media/slide2.png") no-repeat center center fixed;
    background-size: cover;
    filter: blur(2px);
    position: absolute;
    top: 0; left: 0;
    width: 100%; height: 100%;
    z-index: -1;
  }

  /* Navbar */
  .navbar {
    background-color: #002b5c; /* Dark Blue */
  }
  .navbar-brand, .nav-link, .dropdown-toggle {
    color: #ffffff !important;
  }

  /* Complaint Section */
  .complaint-section {
    background-color: rgba(255,255,255,0.9); /* semi-transparent white */
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

  .btn-outline-light {
    border-color: #ffffff;
  }
  .btn-outline-light:hover {
    background-color: #ffffff;
    color: #002b5c !important;
  }

  /* Footer */
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

<!-- Navbar -->
<nav class="navbar navbar-expand-lg">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="Home.jsp">
      <img src="media/ICMS.png" alt="Sri Lanka Logo" width="45" class="me-2">
      <span id="title">Infrastructure Complaint Management System</span>
    </a>
    <div class="d-flex">
      <a href="#">
        <button class="btn btn-outline-light btn-sm me-3" id="loginBtn">Home</button>
      </a>
      <a href="Login.jsp">
        <button class="btn btn-outline-light btn-sm me-3" id="loginBtn">Login</button>
      </a>
      <div class="dropdown">
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

<!-- Slideshow Section -->
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

  <!-- Welcome Text Overlay -->
  <div class="carousel-caption d-flex flex-column justify-content-center align-items-center h-100">
    <h2 id="hero-title" style="color:#002b5c; font-weight:bold; background:rgba(255,255,255,0.7); padding:10px 20px; border-radius:10px;">
      Welcome to Infrastructure Complaint Management System
    </h2>
    <p id="hero-sub" style="color:#002b5c; font-weight:bold; background:rgba(255,255,255,0.7); padding:10px 20px; border-radius:10px;">
      Report infrastructure complaints quickly and anonymously
    </p>
  </div>

  <button class="carousel-control-prev" type="button" data-bs-target="#icmsCarousel" data-bs-slide="prev">
    <span class="carousel-control-prev-icon"></span>
  </button>
  <button class="carousel-control-next" type="button" data-bs-target="#icmsCarousel" data-bs-slide="next">
    <span class="carousel-control-next-icon"></span>
  </button>
</div>
<br><br><br>

<!-- Complaint Form -->
<div class="container">
  <div class="complaint-section">
    <h3 id="form-title" class="mb-4">Send Complaint Anonymously</h3>
    <form action="AnonymousSubmitComplaintServlet" method="post" enctype="multipart/form-data">
      <div class="mb-3">
        <label id="lbl-complaint" class="form-label">Enter Complaint</label>
        <textarea class="form-control" rows="3" name="description"></textarea>
      </div>
      <div class="mb-3">
        <label id="lbl-category" class="form-label" >Category of Complaint</label>
        <select class="form-select" name="category-select">
          <option>Roads and Pot Holes</option>
          <option>Water</option>
          <option>Electricity</option>
          <option>Garbage</option>
          <option>Other</option>
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
      <div class="mb-3 text-muted">
        <small id="private-reply">If you want a private reply, please <a href="Login.jsp" id="login-link">Login here</a></small>
      </div>
      <button type="submit" class="btn btn-primary w-100" id="btn-submit">Submit Complaint</button>
    </form>
  </div>
</div>

<!-- Footer -->
<footer>
  <p>© 2025 Biyagama Pradeshiya Sabha | Infrastructure Complaint Management System</p>
  <p>Designed and Developed for Public Service</p>
</footer>

<script>
  const translations = {
    en: {
      title: "Infrastructure Complaint Management System",
      "language-label": "Language",
      "hero-title": "Welcome to Biyagama Pradeshiya Sabha",
      "hero-sub": "Report infrastructure complaints quickly and anonymously",
      "form-title": "Send Complaint Anonymously",
      "lbl-complaint": "Enter Complaint",
      "lbl-category": "Category of Complaint",
      "lbl-media": "Upload Media",
      "lbl-location": "Tag Location",
      "private-reply": "If you want a private reply, please <a href='#' id='login-link'>Login here</a>",
      "btn-submit": "Submit Complaint"
    },
    si: {
      title: "පහසුකම් ගැටළු කළමනාකරණ පද්ධතිය",
      "language-label": "භාෂාව",
      "hero-title": "බියගම ප්‍රාදේශීය සභාවට සාදරයෙන් පිළිගනිමු",
      "hero-sub": "ඔබගේ පහසුකම් ගැටළු වේගයෙන් සහ නාමරහිතව වාර්තා කරන්න",
      "form-title": "නාමරහිතව පැමිණිලි යවන්න",
      "lbl-complaint": "පැමිණිල්ල ඇතුලත් කරන්න",
      "lbl-category": "පැමිණිලි කාණ්ඩය",
      "lbl-media": "මාධ්‍යය උඩුගත කරන්න",
      "lbl-location": "ස්ථානය සදහන් කරන්න",
      "private-reply": "පෞද්ගලික පිළිතුරක් අවශ්‍ය නම් <a href='#' id='login-link'>මෙතන ලොග් වන්න</a>",
      "btn-submit": "පැමිණිල්ල යවන්න"
    },
    ta: {
      title: "அடித்தள புகார் மேலாண்மை அமைப்பு",
      "language-label": "மொழி",
      "hero-title": "பியகம பிரதேச சபைக்கு வரவேற்கிறோம்",
      "hero-sub": "உங்கள் அடித்தள புகார்களை விரைவாகவும் பெயரில்லாமல் அறிக்கையிடுங்கள்",
      "form-title": "பெயரில்லாமல் புகார் அனுப்பவும்",
      "lbl-complaint": "புகார் உள்ளிடவும்",
      "lbl-category": "புகார் வகை",
      "lbl-media": "மீடியா பதிவேற்றுக",
      "lbl-location": "இடத்தை குறிப்பிடுக",
      "private-reply": "நீங்கள் தனிப்பட்ட பதிலை விரும்பினால் <a href='#' id='login-link'>இங்கே உள்நுழைக</a>",
      "btn-submit": "புகார் சமர்ப்பிக்கவும்"
    }
  };

  function setLanguage(lang) {
    for (const key in translations[lang]) {
      const el = document.getElementById(key);
      if (el) el.innerHTML = translations[lang][key];
    }
  }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
