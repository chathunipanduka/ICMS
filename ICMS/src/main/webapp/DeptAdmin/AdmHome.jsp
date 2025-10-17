<%@ page import="java.sql.*, ICMSpackage.IcmsConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"> <!-- ✅ Makes responsive -->
<title>Admin Home</title>

<!-- Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body {
  background-color: #f8f9fa;
}
.card {
  border-radius: 12px;
  box-shadow: 0 3px 8px rgba(0, 0, 0, 0.1);
}
.count {
  font-size: 2.2rem;
  font-weight: bold;
  color: #0d6efd;
}
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

/* ✅ Responsive Chart Containers */
.chart-container {
  position: relative;
  width: 100%;
  max-width: 400px;
  height: 300px;
  margin: 0 auto;
}

/* ✅ Mobile Adjustments */
@media (max-width: 768px) {
  .card {
    padding: 1rem !important;
  }
  .count {
    font-size: 1.8rem;
  }
  h2, h3 {
    font-size: 1.5rem;
  }
  footer {
    font-size: 12px;
    padding: 10px;
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

    String deptName = "";
    try (Connection con = IcmsConnection.getConnection()) {
        String sql = "SELECT dept_name FROM dept_admin_tb WHERE deptAdmUname = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            deptName = rs.getString("dept_name");
        }
    } catch (Exception e) { e.printStackTrace(); }

    int solvedCount = 0, pendingCount = 0, inprogressCount = 0;
    try (Connection con = IcmsConnection.getConnection()) {
        String sql = "SELECT status, COUNT(*) AS count FROM complaint_tb " +
                     "WHERE dept_id = (SELECT id_dept_tb FROM dept_tb WHERE deptName = ?) " +
                     "GROUP BY status";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, deptName);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            String status = rs.getString("status");
            int count = rs.getInt("count");
            if ("Solved".equalsIgnoreCase(status)) solvedCount = count;
            else if ("Pending".equalsIgnoreCase(status)) pendingCount = count;
            else if ("InProgress".equalsIgnoreCase(status)) inprogressCount = count;
        }
    } catch (Exception e) { e.printStackTrace(); }
%>

<div class="container mt-4">
  <h2 class="text-center text-primary mb-4">Complaints Overview</h2>

  <div class="row g-4 justify-content-center">
    <!-- Solved Complaints -->
    <div class="col-10 col-sm-6 col-md-4">
      <div class="card text-center p-4">
        <h5 class="card-title text-success">Solved Complaints</h5>
        <div class="count"><%= solvedCount %></div>
        <a href="AdmComplaints.jsp" class="btn btn-success mt-3 w-100">View</a>
      </div>
    </div>

    <!-- Pending Complaints -->
    <div class="col-10 col-sm-6 col-md-4">
      <div class="card text-center p-4">
        <h5 class="card-title text-warning">Pending Complaints</h5>
        <div class="count"><%= pendingCount %></div>
        <a href="dmComplaints.jsp" class="btn btn-warning mt-3 w-100 text-white">View</a>
      </div>
    </div>

    <!-- In Progress Complaints -->
    <div class="col-10 col-sm-6 col-md-4">
      <div class="card text-center p-4">
        <h5 class="card-title text-primary">In Progress</h5>
        <div class="count"><%= inprogressCount %></div>
        <a href="dmComplaints.jsp" class="btn btn-primary mt-3 w-100">View</a>
      </div>
    </div>
  </div>
</div>

<hr>

<div class="container mt-5">
  <h3 class="text-center text-primary mb-4">Complaints Summary</h3>

  <div class="row justify-content-center gy-5">
    <!-- Pie Chart -->
    <div class="col-12 col-md-6 text-center">
      <h5 class="text-secondary mb-3">Complaints by Status</h5>
      <div class="chart-container">
        <canvas id="complaintPieChart"></canvas>
      </div>
    </div>

    <!-- Bar Chart -->
    <div class="col-12 col-md-6 text-center">
      <h5 class="text-secondary mb-3">Complaints Comparison</h5>
      <div class="chart-container">
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

const pieData = {
  labels: ['Solved', 'Pending', 'In Progress'],
  datasets: [{
    data: [solved, pending, inProgress],
    backgroundColor: ['#28a745a0','#ffc107a0','#0d6efd90'],
    borderColor: ['#28a745','#ffc107','#0d6efd'],
    borderWidth: 2
  }]
};
new Chart(document.getElementById('complaintPieChart'), {
  type: 'pie',
  data: pieData,
  options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } }
});

const barData = {
  labels: ['Solved', 'Pending', 'In Progress'],
  datasets: [{
    label: 'Number of Complaints',
    data: [solved, pending, inProgress],
    backgroundColor: ['#28a745a0','#ffc107a0','#0d6efd90'],
    borderColor: ['#28a745','#ffc107','#0d6efd'],
    borderWidth: 2
  }]
};
new Chart(document.getElementById('complaintBarChart'), {
  type: 'bar',
  data: barData,
  options: {
    responsive: true,
    maintainAspectRatio: false,
    scales: { y: { beginAtZero: true } },
    plugins: { legend: { display: false } }
  }
});
</script>

<footer class="mt-5">
  Biyagama Pradeshiya Sabha<br>
  Contact: +94 123456789<br>
  Email: biyagamapradehsiyasabha@gmail.com
</footer>

</body>
</html>
