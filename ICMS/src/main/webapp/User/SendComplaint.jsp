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
<!-- Optionally add Bootstrap for spinner -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<div class="p-4">
		<h3 class="text-center mb-5 fw-bold" style="color: #00274d;">Send Complaints</h3>
		<form method="post"
			action="${pageContext.request.contextPath}/SubmitComplaintServlet"
			enctype="multipart/form-data" onsubmit="return validateForm();"
			>
			
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
				<label id="lbl-complaint">Enter Complaint and Other Details</label>
				<textarea name="description" class="form-control" rows="3" placeholder="Example: Broken Light, Tower 18, Nearby Reception hall" required></textarea>
			</div>
			<div class="mb-3">
				<label id="lbl-media">Upload Media</label> 
				<input type="file" class="form-control" name="media" multiple accept=".jpg,.jpeg,.png,.mp4,.mov,.pdf">
			</div>
			<div class="mb-3">
				<label id="lbl-location">Location</label> 
				<input type="text" class="form-control"  name="location" placeholder="Example: Exact Location(Malwana Tower18) or Landmark(Near the Malwana water tank)" required>
			</div>
			<button type="submit" class="btn btn-primary" id="btn-submit">Submit
				Complaint</button>
		</form>
	</div>
	
	<!-- Loading overlay -->
<div id="loadingOverlay" style="
  display:none;
  position:fixed;
  top:0;
  left:0;
  width:100%;
  height:100%;
  background:rgba(255,255,255,0.8);
  z-index:9999;
  text-align:center;
  padding-top:200px;
  font-size:20px;
  color:#333;
">
  <div class="spinner-border text-primary" role="status"></div>
  <p>Sending email... Please wait.</p>
</div>

<script>
function showLoading() {
  document.getElementById('loadingOverlay').style.display = 'block';
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



	<script>

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

<script>
function validateForm() {
  const category = document.querySelector('select[name="category"]').value.trim();
  const description = document.querySelector('textarea[name="description"]').value.trim();
  const location = document.querySelector('input[name="location"]').value.trim();
  const files = document.querySelector('input[name="media"]').files;

  const allowedTypes = [
    "image/jpeg",
    "image/png",
    "video/mp4",
    "video/quicktime",
    "application/pdf"
  ];

  if (category === "" || description === "" || location === "") {
    alert("Please fill all required fields before submitting the complaint.");
    return false;
  }

  // File type validation (optional upload)
  for (let i = 0; i < files.length; i++) {
    if (!allowedTypes.includes(files[i].type)) {
      alert("Invalid file type. Only JPG, PNG, MP4, MOV or PDF files are allowed.");
      return false;
    }
  }

  showLoading();
  return true;
}
</script>


</body>
</html>
