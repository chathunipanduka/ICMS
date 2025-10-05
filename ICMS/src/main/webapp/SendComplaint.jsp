<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Send Complaints</title>
</head>
<body>
 <div class="p-4">
  <h3 id="send-title">Send Complaint</h3>
  <form>
    <div class="mb-3">
      <label id="lbl-complaint">Complaint</label>
      <textarea class="form-control" rows="3"></textarea>
    </div>
    <div class="mb-3">
      <label id="lbl-category">Category</label>
      <select class="form-select" id="select-category">
        <option>Roads</option>
        <option>Water</option>
        <option>Electricity</option>
        <option>Garbage</option>
        <option>Other</option>
      </select>
    </div>
    <div class="mb-3">
      <label id="lbl-media">Upload Media</label>
      <input type="file" class="form-control">
    </div>
    <div class="mb-3">
      <label id="lbl-location">Location</label>
      <input type="text" class="form-control" placeholder="Tag Location">
    </div>
    <button class="btn btn-primary" id="btn-submit">Submit Complaint</button>
  </form>
</div>

<script>
const translationsSend = {
  en: { "send-title":"Send Complaint","lbl-complaint":"Complaint","lbl-category":"Category","lbl-media":"Upload Media","lbl-location":"Location","btn-submit":"Submit Complaint","select-category":["Roads","Water","Electricity","Garbage","Other"]},
  si: { "send-title":"පැමිණිල්ල යවන්න","lbl-complaint":"පැමිණිල්ල","lbl-category":"කාණ්ඩය","lbl-media":"මාධ්‍ය උඩුගත කරන්න","lbl-location":"ස්ථානය","btn-submit":"පැමිණිල්ල යවන්න","select-category":["මාර්ග","ජලය","විදුලි","කුණු","වෙනත්"]},
  ta: { "send-title":"புகார் அனுப்பவும்","lbl-complaint":"புகார்","lbl-category":"வகை","lbl-media":"மீடியா பதிவேற்றுக","lbl-location":"இடம்","btn-submit":"புகார் சமர்ப்பிக்கவும்","select-category":["சாலைகள்","தண்ணீர்","மின்சாரம்","குப்பை","மற்றவை"]}
};

let lang = window.language || 'en';
for (const key in translationsSend[lang]) {
  const el = document.getElementById(key);
  if(el) {
    if(key==="select-category"){
      const select = document.getElementById("select-category");
      select.innerHTML = "";
      translationsSend[lang][key].forEach(opt => select.innerHTML += `<option>${opt}</option>`);
    } else el.innerText = translationsSend[lang][key];
  }
}
</script>

</body>
</html>