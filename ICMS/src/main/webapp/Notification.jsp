<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Notifications</title>
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

</body>
</html>