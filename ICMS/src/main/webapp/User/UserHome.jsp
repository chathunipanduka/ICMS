<%@ page import="java.sql.*, ICMSpackage.IcmsConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Home</title>

<!-- Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
footer {
  bottom: 0;
  left: 0;
  width: 100%;
  background-color: #00274d;
  text-align: center;
  padding: 15px;
  font-size: 14px;
  color: #ffffff;
  box-shadow: 0 -2px 5px rgba(0,0,0,0.1);
}
.card {
  border-radius: 12px;
  box-shadow: 0 3px 8px rgba(0, 0, 0, 0.1);
}
.count {
  font-size: 2.5rem;
  font-weight: bold;
  color: #0d6efd;
}
#complaintChart {
    max-width: 500px;   /* reduce width */
    max-height: 500px;  /* reduce height */
    margin: 0 auto;     /* center the chart */
  }
</style>
</head>

<body class="bg-light">
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
%>
<div class="container mt-5">
  <h2 class="text-center text-primary mb-4">Complaints Overview</h2>

  <div class="row g-4 justify-content-center">
    <%
      int solvedCount = 0, pendingCount = 0, inprogressCount = 0;

      try (Connection con = IcmsConnection.getConnection()) {

          // ✅ Correct SQL
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
    <div class="col-md-3">
      <div class="card text-center p-4">
        <h5 class="card-title text-success">Solved Complaints</h5>
        <div class="count"><%= solvedCount %></div>
        <a href="../Complaints.jsp" class="btn btn-success mt-3 w-75">View</a>
      </div>
    </div>

    <!-- Pending Complaints -->
    <div class="col-md-3">
      <div class="card text-center p-4">
        <h5 class="card-title text-warning">Pending Complaints</h5>
        <div class="count"><%= pendingCount %></div>
        <a href="../Complaints.jsp" class="btn btn-warning mt-3 w-75 text-white">View</a>
      </div>
    </div>

    <!-- In Progress Complaints -->
    <div class="col-md-3">
      <div class="card text-center p-4">
        <h5 class="card-title text-primary">Complaints In Progress</h5>
        <div class="count"><%= inprogressCount %></div>
        <a href="../Complaints.jsp" class="btn btn-primary mt-3 w-75">View</a>
      </div>
    </div>

  </div>
</div> <!-- complaint cards end -->
<br>
    <hr>
    <br>

<div class="container mt-5">
  <h3 class="text-center text-primary mb-4">Complaints Summary</h3>
  <br>

  <div class="row justify-content-center align-items-center">
    <!-- Pie Chart Column -->
    <div class="col-md-6 text-center">
      <h5 class="text-secondary mb-3">Complaints by Status</h5>
      <div style="width: 300px; height: 300px; margin: auto;">
        <canvas id="complaintPieChart"></canvas>
      </div>
    </div>

    <!-- Bar Chart Column -->
    <div class="col-md-6 text-center">
      <h5 class="text-secondary mb-3">Complaints Comparison</h5>
      <div style="width: 400px; height: 300px; margin: auto;">
        <canvas id="complaintBarChart"></canvas>
      </div>
    </div>
  </div>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
  // Chart Data from DB
  const solved = <%= solvedCount %>;
  const pending = <%= pendingCount %>;
  const inProgress = <%= inprogressCount %>;

  // ---------- PIE CHART ----------
  const pieData = {
    labels: ['Solved', 'Pending', 'In Progress'],
    datasets: [{
      data: [solved, pending, inProgress],
      backgroundColor: [
        'rgba(40, 167, 69, 0.7)',   // green
        'rgba(255, 193, 7, 0.7)',   // yellow
        'rgba(13, 110, 253, 0.7)'   // blue
      ],
      borderColor: [
        'rgba(40, 167, 69, 1)',
        'rgba(255, 193, 7, 1)',
        'rgba(13, 110, 253, 1)'
      ],
      borderWidth: 2
    }]
  };

  const pieConfig = {
    type: 'pie',
    data: pieData,
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { position: 'bottom' },
        tooltip: { enabled: true }
      }
    }
  };

  new Chart(document.getElementById('complaintPieChart'), pieConfig);


  // ---------- BAR CHART ----------
  const barData = {
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
  };

  const barConfig = {
    type: 'bar',
    data: barData,
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            stepSize: 1
          }
        }
      },
      plugins: {
        legend: { display: false },
        tooltip: { enabled: true }
      }
    }
  };

  new Chart(document.getElementById('complaintBarChart'), barConfig);
</script>




<footer class="mt-5">
  Biyagama Pradeshiya Sabha<br>
  Contact: +94 123456789<br>
  Email: biyagamapradehsiyasabha@gmail.com
</footer>

</body>
</html>
