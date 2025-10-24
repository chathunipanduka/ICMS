<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Profile - ICMS</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
  body {
  font-family: 'Poppins', sans-serif;
  background-color: #f5f7fa;
}

/* Floating Modal Background */
.modal {
  display: none;
  position: fixed;
  z-index: 999;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  backdrop-filter: blur(4px);
  background-color: rgba(0, 0, 0, 0.3);
}

/* Modal Content Box */
.modal-content {
  background: white;
  border-radius: 20px;
  max-width: 400px;
  margin: 5% auto;
  padding: 30px 40px;
  box-shadow: 0 10px 25px rgba(0,0,0,0.2);
  position: relative;
  text-align: center;
}

/* Close Button */
.close-btn {
  position: absolute;
  top: 20px;
  right: 25px;
  font-size: 24px;
  cursor: pointer;
  color: #555;
}

/* Profile Picture */
.profile-pic {
  position: relative;
  display: inline-block;
}
.profile-pic img {
  width: 100px;
  height: 100px;
  border-radius: 50%;
}
.camera-icon {
  position: absolute;
  bottom: 0;
  right: 0;
  background: #f0f0f0;
  padding: 5px;
  border-radius: 50%;
}

/* Inputs */
input {
  width: 100%;
  padding: 8px;
  margin: 8px 0 16px 0;
  border-radius: 6px;
  border: 1px solid #ccc;
  background-color: #e9eef7;
}

/* Buttons */
.save-btn, .open-btn {
  background-color: #1e3a8a;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 8px;
  cursor: pointer;
}
.save-btn:hover, .open-btn:hover {
  background-color: #172c69;
}
</style>
  
</head>
<body>
  <!-- Profile Button (for demo) -->
<button id="openProfileBtn" class="open-btn">Open Profile</button>

<!-- Floating Profile Modal -->
<div id="profileModal" class="modal">
  <div class="modal-content">
    <span class="close-btn" id="closeProfileBtn">&times;</span>
    <h2 class="title">Profile</h2>

    <div class="profile-pic">
      <img src="profile-icon.png" alt="Profile Picture">
      <div class="camera-icon">
        <i class="fa fa-camera"></i>
      </div>
    </div>

    <div class="info">
      <p><strong>Username:</strong> Saman</p>
      <p><strong>Department:</strong> Road and Pot Hole</p>

      <label>Contact No:</label>
      <input type="text" value="071 234 5678">

      <label>Email:</label>
      <input type="email" value="saman@gmail.com">

      <button class="save-btn">Save Updates</button>
    </div>
  </div>
</div>
<script type="text/javascript"> 

document.getElementById("openProfileBtn").onclick = function() {
	  document.getElementById("profileModal").style.display = "block";
	};

	document.getElementById("closeProfileBtn").onclick = function() {
	  document.getElementById("profileModal").style.display = "none";
	};

	window.onclick = function(event) {
	  const modal = document.getElementById("profileModal");
	  if (event.target === modal) {
	    modal.style.display = "none";
	  }
	};


</script>
</body>
</html>
