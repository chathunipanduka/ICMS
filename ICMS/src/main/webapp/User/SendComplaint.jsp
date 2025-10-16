<%@ page import="java.sql.*, ICMSpackage.IcmsConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Send Complaint</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="icon" type="image/x-icon" href="media/logo.png">
</head>
<body>
	<div class="p-4">
		<h3 id="send-title">Send Complaint</h3>
		<form method="post"
			action="${pageContext.request.contextPath}/SubmitComplaintServlet"
			enctype="multipart/form-data">
			<div class="mb-3">
				<label id="lbl-complaint">Complaint</label>
				<textarea name="description" class="form-control" rows="3"></textarea>
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
                  ps = con.prepareStatement("SELECT id_category_tb, category_name FROM category_tb");
                  rs = ps.executeQuery();
                  while (rs.next()) {
          %>
                      <option value="<%=rs.getString("category_name")%>">
                          <%=rs.getString("category_name")%>
                      </option>
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
				<label id="lbl-media">Upload Media</label> <input type="file"
					class="form-control" name="media">
			</div>
			<div class="mb-3">
				<label id="lbl-location">Location</label> <input type="text"
					class="form-control" placeholder="Tag Location" name="location">
			</div>
			<button type="submit" class="btn btn-primary" id="btn-submit">Submit
				Complaint</button>
		</form>
	</div>



	<script>
const translationsSend = {
  en: {
    "send-title": "Send Complaint",
    "lbl-complaint": "Complaint",
    "lbl-category": "Category",
    "lbl-media": "Upload Media",
    "lbl-location": "Location",
    "btn-submit": "Submit Complaint",
    "category-select": ["Roads and Pot Holes", "Water", "Electricity", "Garbage", "Other"]
  },
  si: {
    "send-title": "පැමිණිල්ල යවන්න",
    "lbl-complaint": "පැමිණිල්ල",
    "lbl-category": "කාණ්ඩය",
    "lbl-media": "මාධ්‍ය උඩුගත කරන්න",
    "lbl-location": "ස්ථානය",
    "btn-submit": "පැමිණිල්ල යවන්න",
    "category-select": ["මාර්ග", "ජලය", "විදුලි", "කුණු", "වෙනත්"]
  },
  ta: {
    "send-title": "புகார் அனுப்பவும்",
    "lbl-complaint": "புகார்",
    "lbl-category": "வகை",
    "lbl-media": "மீடியா பதிவேற்றுக",
    "lbl-location": "இடம்",
    "btn-submit": "புகார் சமர்ப்பிக்கவும்",
    "category-select": ["சாலைகள்", "தண்ணீர்", "மின்சாரம்", "குப்பை", "மற்றவை"]
  }
};

// Change this to 'si' or 'ta' to test
let lang = window.language || 'en';

// Set text labels (excluding select)
for (const key in translationsSend[lang]) {
  if (key === "category-select") continue; // skip select for now
  const el = document.getElementById(key);
  if (el) el.innerText = translationsSend[lang][key];
}

// Populate category select
const select = document.getElementById("category-select");
select.innerHTML = ""; // clear default options
translationsSend[lang]["category-select"].forEach(opt => {
  const option = document.createElement("option");
  option.value = opt;
  option.text = opt;
  select.add(option);
});
</script>

</body>
</html>
