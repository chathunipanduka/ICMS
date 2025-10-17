<%@ page import="java.sql.*, ICMSpackage.IcmsConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"> <!-- ✅ Critical for mobile responsiveness -->
<title>Admin Home</title>

<!-- Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body {
  background-color: #f8f9fa;
  font-family: "Segoe UI", sans-serif;
  margin: 0;
  padding: 0;
}

/* Footer */
footer {
  width: 100%;
  background-color: #00274d;
  text-align: center;
  padding: 15px;
  font-size: 14px;
  color: #ffffff;
  box-shadow: 0 -2px 5px rgba(0,0,0,0.1);
}

/* Card Styling */
.card {
  border-radius: 12px;
  box-shadow: 0 3px 8px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s, box-shadow 0.2s;
}
.card:hover {
  transform: scale(1.03);
  box-shadow: 0 5px 12px rgba(0, 0, 0, 0.15);
}

/* Number Count */
.count {
  font-size: 2.5rem;
  font-weight: bold;
  color: #0d6efd;
}

/* Chart Containers */
#complaintChart, #complaintPieChart, #complaintBarChart {
  width: 100% !important;
  height: auto !important;
  max-width: 500px;
  max-height: 400px;
  margin: 0 auto;
}

/* Responsive layout tweaks */
@media (max-width: 992px) {
  .count {
    font-size: 2rem;
  }
}

@media (max-width: 768px) {
  h2, h3 {
    font-size: 1.4rem;
  }
  .card {
    padding: 20px 10px;
  }
  .count {
    font-size: 1.8rem;
  }
  footer {
    font-size: 12px;
    padding: 10px;
  }
}

@media (max-width: 576px) {
  .row.g-4 > div {
    width: 100%;
  }
  .card {
    margin-bottom: 20px;
  }
  .count {
    font-size: 1.6rem;
  }
  h5 {
    font-size: 1rem;
  }
}
</style>
</head>

<body>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
%>

<!-- ======== Complaint Overview Cards ======== -->
<div class="container mt-5">
  <h2 class="text-center text-primary mb-4">Complaints Overview</h2>

  <div class="row g-4 justify-content-center">
    <%
      int solvedCount = 0, pendingCount = 0, inprogressCount = 0;

      try (Connection con = IcmsConnection.getConnection()) {
          String sql = "SELECT status, COUNT(*) AS count " +
                       "FROM complaint_tb " +
                       "WHERE user_id = (SELECT id_login_tb FROM login_tb WHERE uName = ?) " +
                       "GROUP BY status";

          PreparedStatement ps = con.prepareStatement(sql);
          ps.setString(1, username);
          ResultSet rs = ps.executeQuery();

          while (rs.next()) {
              String status = rs.getString("status");
              int count = rs.getInt("count");
              if ("Solved".equalsIgnoreCase(status)) solvedCount = count;
              else if ("Pending".equalsIgnoreCase(status)) pendingCount = count;
              else if ("InProgress".equalsIgnoreCase(status)) inprogressCount = count;
          }

          rs.close();
          ps.close();

      } catch (Exception e) {
          e.printStackTrace();
      }
    %>

    <!-- Solved Complaints -->
    <div class="col-md-4 col-sm-6">
      <div class="card text-center p-4">
        <h5 class="card-title text-success">Solved Complaints</h5>
        <div class="count"><%= solvedCount %></div>
        <a href="../Complaints.jsp" class="btn btn-success mt-3 w-75">View</a>
      </div>
    </div>

    <!-- Pending Complaints -->
    <div class="col-md-4 col-sm-6">
      <div class="card text-center p-4">
        <h5 class="card-title text-warning">Pending Complaints</h5>
        <div class="count"><%= pendingCount %></div>
        <a href="../Complaints.jsp" class="btn btn-warning mt-3 w-75 text-white">View</a>
      </div>
    </div>

    <!-- In Progress Complaints -->
    <div class="col-md-4 col-sm-6">
      <div class="card text-center p-4">
        <h5 class="card-title text-primary">Complaints In Progress</h5>
        <div class="count"><%= inprogressCount %></div>
        <a href="../Complaints.jsp" class="btn btn-primary mt-3 w-75">View</a>
      </div>
    </div>

  </div>
</div>

<hr class="my-5">

<!-- ======== Charts Section ======== -->
<div class="container mb-5">
  <h3 class="text-center text-primary mb-4">Complaints Summary</h3>

  <div class="row justify-content-center align-items-center gy-5">
    <!-- Pie Chart -->
    <div class="col-lg-6 col-md-12 text-center">
      <h5 class="text-secondary mb-3">Complaints by Status</h5>
      <div style="width:100%; max-width:400px; height:300px; margin:auto;">
        <canvas id="complaintPieChart"></canvas>
      </div>
    </div>

    <!-- Bar Chart -->
    <div class="col-lg-6 col-md-12 text-center">
      <h5 class="text-secondary mb-3">Complaints Comparison</h5>
      <div style="width:100%; max-width:400px; height:300px; margin:auto;">
        <canvas id="complaintBarChart"></canvas>
      </div>
    </div>
  </div>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
  const solved = <%= solvedCount %>;
  const pending = <%= pendingCount %>;
  const inProgress = <%= inprogressCount %>;

  // ---------- PIE CHART ----------
  new Chart(document.getElementById('complaintPieChart'), {
    type: 'pie',
    data: {
      labels: ['Solved', 'Pending', 'In Progress'],
      datasets: [{
        data: [solved, pending, inProgress],
        backgroundColor: [
          'rgba(40, 167, 69, 0.7)',
          'rgba(255, 193, 7, 0.7)',
          'rgba(13, 110, 253, 0.7)'
        ],
        borderColor: [
          'rgba(40, 167, 69, 1)',
          'rgba(255, 193, 7, 1)',
          'rgba(13, 110, 253, 1)'
        ],
        borderWidth: 2
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { position: 'bottom' },
        tooltip: { enabled: true }
      }
    }
  });

  // ---------- BAR CHART ----------
  new Chart(document.getElementById('complaintBarChart'), {
    type: 'bar',
    data: {
      labels: ['Solved', 'Pending', 'In Progress'],
      datasets: [{
        label: 'Number of Complaints',
        data: [solved, pending, inProgress],
        backgroundColor: [
          'rgba(40, 167, 69, 0.7)',
          'rgba(255, 193, 7, 0.7)',
          'rgba(13, 110, 253, 0.7)'
        ],
        borderColor: [
          'rgba(40, 167, 69, 1)',
          'rgba(255, 193, 7, 1)',
          'rgba(13, 110, 253, 1)'
        ],
        borderWidth: 2
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        y: { beginAtZero: true, ticks: { stepSize: 1 } }
      },
      plugins: {
        legend: { display: false },
        tooltip: { enabled: true }
      }
    }
  });
</script>

<footer>
  Biyagama Pradeshiya Sabha<br>
  Contact: +94 123456789<br>
  Email: biyagamapradehsiyasabha@gmail.com
</footer>

</body>
</html>
