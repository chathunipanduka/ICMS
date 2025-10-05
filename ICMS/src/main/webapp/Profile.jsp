<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Profile - ICMS</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
  <div id="profile-section" class="p-4">
    <h3 id="profile-title">Profile</h3>
    <p id="profile-desc">Manage your profile details here.</p>
    <form>
      <div class="mb-3">
        <label id="lbl-name">Name</label>
        <input type="text" class="form-control" placeholder="">
      </div>
      <div class="mb-3">
        <label id="lbl-email">Email</label>
        <input type="email" class="form-control" placeholder="">
      </div>
      <button class="btn btn-primary" id="btn-update">Update Profile</button>
    </form>
  </div>

  <script>
    const translationsProfile = {
      en: {
        "profile-title": "Profile",
        "profile-desc": "Manage your profile details here.",
        "lbl-name": "Name",
        "lbl-email": "Email",
        "btn-update": "Update Profile"
      },
      si: {
        "profile-title": "පැතිකඩ",
        "profile-desc": "ඔබේ පැතිකඩ විස්තර මෙහි කළමනාකරණය කරන්න.",
        "lbl-name": "නම",
        "lbl-email": "විද්‍යුත් තැපෑල",
        "btn-update": "පැතිකඩ යාවත්කාලීන කරන්න"
      },
      ta: {
        "profile-title": "சுயவிவரம்",
        "profile-desc": "உங்கள் சுயவிவர விவரங்களை இங்கே நிர்வகிக்கவும்.",
        "lbl-name": "பெயர்",
        "lbl-email": "மின்னஞ்சல்",
        "btn-update": "சுயவிவரத்தை புதுப்பிக்கவும்"
      }
    };

    // Expose function to dashboard
    document.getElementById('profile-section').updateLanguage = function(lang) {
      for (const key in translationsProfile[lang]) {
        const el = document.getElementById(key);
        if(el) el.innerText = translationsProfile[lang][key];
      }
    };
  </script>
</body>
</html>
