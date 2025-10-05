<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>History</title>
</head>
<body>
<div class="p-4">
  <h3 id="history-title">Complaint History</h3>
  <p id="history-desc">List of previous complaints goes here.</p>

  <table class="table table-striped">
    <thead>
      <tr>
        <th id="th-id">ID</th>
        <th id="th-category">Category</th>
        <th id="th-complaint">Complaint</th>
        <th id="th-date">Date</th>
        <th id="th-status">Status</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>1</td>
        <td>Roads</td>
        <td>Potholes on main road</td>
        <td>2025-09-20</td>
        <td>Resolved</td>
      </tr>
    </tbody>
  </table>
</div>

<script>
const translationsHistory = {
  en: {
    "history-title":"Complaint History",
    "history-desc":"List of previous complaints goes here.",
    "th-id":"ID","th-category":"Category","th-complaint":"Complaint","th-date":"Date","th-status":"Status"
  },
  si: {
    "history-title":"පැමිණිලි ඉතිහාසය",
    "history-desc":"පෙර පැමිණිලි ලැයිස්තුව මෙහි දක්වා ඇත.",
    "th-id":"අංකය","th-category":"කාණ්ඩය","th-complaint":"පැමිණිල්ල","th-date":"දිනය","th-status":"තත්ත්වය"
  },
  ta: {
    "history-title":"புகார் வரலாறு",
    "history-desc":"முந்தைய புகார்களின் பட்டியல் இங்கே உள்ளது.",
    "th-id":"அடையாளம்","th-category":"வகை","th-complaint":"புகார்","th-date":"தேதி","th-status":"நிலை"
  }
};

let lang = window.language || 'en';
for (const key in translationsHistory[lang]) {
  const el = document.getElementById(key);
  if(el) el.innerText = translationsHistory[lang][key];
}
</script>

</body>
</html>