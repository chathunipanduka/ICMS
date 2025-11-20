<%@ page import="java.sql.*, ICMSpackage.IcmsConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    body {
        background-color: #f0f4f8;
    }
    .card {
        border: none;
        border-radius: 15px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        transition: transform 0.2s ease;
    }
    .card:hover {
        transform: scale(1.05);
    }
    .card-title {
        font-size: 1.5rem;
        font-weight: 600;
    }
    .count {
        font-size: 2.5rem;
        font-weight: bold;
        color: #003366;
    }
    .iframe-container-bottom {
  width: 100%;
  height:1400px%; /* adjust height as needed */
  margin-top: 30px;
  overflow: hidden;
  border-radius: 12px;
  box-shadow: 0 4px 10px rgba(0,0,0,0.1);
}

.iframe-container-bottom iframe {
  width: 100%;
  height: 1400px;
  border: none;
}
    
</style>
</head>
<body>

<div class="container mt-5">
   <h2 class="text-center mb-5 fw-bold" style="color: #00274d;">Department Administration</h2>
    <div class="row g-4 justify-content-center">

        <%
            int deptCount = 0, catCount = 0, adminCount = 0;

            try (Connection con = IcmsConnection.getConnection()) {

                // Department count
                PreparedStatement psDept = con.prepareStatement("SELECT COUNT(*) FROM dept_tb");
                ResultSet rsDept = psDept.executeQuery();
                if (rsDept.next()) deptCount = rsDept.getInt(1);
                rsDept.close();
                psDept.close();

                // Category count
                PreparedStatement psCat = con.prepareStatement("SELECT COUNT(*) FROM category_tb");
                ResultSet rsCat = psCat.executeQuery();
                if (rsCat.next()) catCount = rsCat.getInt(1);
                rsCat.close();
                psCat.close();

                // Admin count
                PreparedStatement psAdmin = con.prepareStatement("SELECT COUNT(*) FROM dept_admin_tb");
                ResultSet rsAdmin = psAdmin.executeQuery();
                if (rsAdmin.next()) adminCount = rsAdmin.getInt(1);
                rsAdmin.close();
                psAdmin.close();

            } catch (Exception e) {
                e.printStackTrace();
            }
        %>

        <!-- Department Card -->
        <div class="col-md-4">
            <div class="card text-center p-4">
                <h5 class="card-title text-secondary">Departments</h5>
                <div class="count"><%= deptCount %></div>
                <a href="AddNewDepartment.jsp" target="bottomFrame" onclick="load" class="btn btn-primary mt-3 w-75">View Departments</a>
            </div>
        </div>

        <!-- Category Card -->
        <div class="col-md-4">
            <div class="card text-center p-4">
                <h5 class="card-title text-secondary">Categories</h5>
                <div class="count"><%= catCount %></div>
                <a href="AddCategory.jsp" target="bottomFrame" onclick="'load()'" class="btn btn-success mt-3 w-75">View Categories</a>
            </div>
        </div>

        <!-- Admin Card -->
        <div class="col-md-4">
            <div class="card text-center p-4">
                <h5 class="card-title text-secondary">Admins</h5>
                <div class="count"><%= adminCount %></div>
                <a href="AddAdmin.jsp" target="bottomFrame" onclick="load" class="btn btn-warning mt-3 w-75">View Admins</a>
            </div>
        </div>

    </div>
</div>
<br>
<br>

<div class="mt-5"></div> <!-- adds margin-top -->
<div class="iframe-container-bottom">
  <iframe src="AddNewDepartment.jsp" name="bottomFrame" ></iframe>
</div>


<script>
window.addEventListener('load', function() {
    const iframe = document.querySelector('iframe[name="bottomFrame"]');
    iframe.focus(); // Focus the iframe container
});
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
