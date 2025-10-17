<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Notifications</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="p-4">
  <h3 id="notification-title">Notifications</h3>
  <p id="notification-desc">All notifications for the user will appear here.</p>

  <ul class="list-group" id="notification-list">
    <li class="list-group-item">Your complaint #1 has been resolved.</li>
  </ul>
</div>

<script>
const translationsNotification = {
  en: {
    "notification-title":"Notifications",
    "notification-desc":"All notifications for the user will appear here.",
    "notification-list":["Your complaint #1 has been resolved."]
  },
  si: {
    "notification-title":"දැනුම්දීම්",
    "notification-desc":"පරිශීලකයාට සියලු දැනුම්දීම් මෙහි දක්වනු ඇත.",
    "notification-list":["ඔබේ පැමිණිල්ල #1 විසඳා ඇත."]
  },
  ta: {
    "notification-title":"அறிவிப்புகள்",
    "notification-desc":"பயனருக்கான அனைத்து அறிவிப்புகளும் இங்கே தோன்றும்.",
    "notification-list":["உங்கள் புகார் #1 தீர்க்கப்பட்டது."]
  }
};

let lang = window.language || 'en';
for (const key in translationsNotification[lang]) {
  const el = document.getElementById(key);
  if(el){
    if(key==="notification-list"){
      const list = document.getElementById("notification-list");
      list.innerHTML = "";
      translationsNotification[lang][key].forEach(item => {
        list.innerHTML += `<li class="list-group-item">${item}</li>`;
      });
    } else el.innerText = translationsNotification[lang][key];
  }
}
</script>

<!-- Footer -->
<footer class="text-light pt-4" style="background-color: #00274d; width: 99.5%; padding:15px;">
  <div class="container1">
    <div class="row text-center text-md-start">
      <!-- About Section -->
      <div class="col-md-4 mb-3">
        <h5>Biyagama Pradeshiya Sabha</h5>
        <p>Providing efficient infrastructure complaint management and citizen services for a better community.</p>
      </div>

      <!-- Quick Links -->
      <div class="col-md-4 mb-3">
        <h5>Quick Links</h5>
        <ul class="list-unstyled">
          <li><a href="Home.jsp" class="text-light text-decoration-none">Home</a></li>
          <li><a href="Login.jsp" class="text-light text-decoration-none">Submit Complaint</a></li>
          <li><a href="about.jsp" class="text-light text-decoration-none">About Us</a></li>
        </ul>
      </div>

      <!-- Contact Info -->
      <div class="col-md-4 mb-3">
        <h5>Contact Us</h5>
        <p>Email: info@biyagama.ps.lk</p>
        <p>Phone: +94 11 234 5678</p>
        <p>Address: Biyagama Pradeshiya Sabha, <br>Biyagama, Sri Lanka</p>
      </div>
    </div>

    <hr class="bg-light">

    <div class="text-center pb-3">
      &copy; 2025 Biyagama Pradeshiya Sabha. All rights reserved.
    </div>
  </div>
</footer>

</body>
</html>