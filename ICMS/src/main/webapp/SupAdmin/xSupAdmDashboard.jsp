<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Super Admin Dashboard - Complaint Management</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f8f9fa;
    }
    header {
      background-color: #002b5c; /* Dark Blue */
      color: #fff;
      padding: 12px;
      text-align: center;
    }
    footer {
      background-color: #002b5c; /* Dark Blue */
      color: #fff;
      text-align: center;
      padding: 15px 10px;
      border-radius: 15px 15px 0 0;
      margin-top: 40px;
    }
    .sidebar {
      height: 100vh;
      background: #343a40; /* Dark Sidebar */
      padding-top: 20px;
    }
    .sidebar a {
      color: #fff;
      text-decoration: none;
      display: block;
      padding: 12px 20px;
      border-radius: 8px;
      margin: 6px;
      transition: background 0.3s;
      cursor: pointer;
    }
    .sidebar a:hover, .sidebar a.active {
      background-color: #495057;
    }
    .content { padding: 20px; }
    .card {
      border-radius: 12px;
      box-shadow: 0 3px 10px rgba(0,0,0,0.1);
    }
    .section { display: none; }
    .section.active { display: block; }
  </style>
</head>
<body>

  <!-- Header -->
  <header>
    <h4>Super Admin Dashboard - Complaint Management System</h4>
  </header>

  <div class="container-fluid">
    <div class="row">
      
      <!-- Sidebar -->
      <nav class="col-md-3 col-lg-2 sidebar d-md-block">
        <a class="active" onclick="showSection('overview')">📊 Overview</a>
        <a onclick="showSection('deptComplaints')">🏢 Department-wise Complaints</a>
        <a onclick="showSection('reports')">📑 Generate Reports</a>
        <a onclick="showSection('users')">👥 User Management</a>
        <a onclick="showSection('departments')">🏛 Department Management</a>
        <a onclick="showSection('logout')">🚪 Logout</a>
      </nav>

      <!-- Main Content -->
      <main class="col-md-9 col-lg-10 content">
        
        <!-- Overview -->
        <div id="overview" class="section active">
          <div class="row">
            <div class="col-md-3 mb-3">
              <div class="card p-3 text-center">
                <h6>Total Users</h6>
                <h3>250</h3>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="card p-3 text-center">
                <h6>Total Departments</h6>
                <h3>5</h3>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="card p-3 text-center">
                <h6>Total Complaints</h6>
                <h3>980</h3>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="card p-3 text-center">
                <h6>Resolved Complaints</h6>
                <h3>740</h3>
              </div>
            </div>
          </div>

          <!-- Charts Row -->
          <div class="row mt-4">
            <div class="col-md-6 mb-4">
              <div class="card p-3">
                <h6 class="text-center">Complaints by Department</h6>
                <canvas id="barChart"></canvas>
              </div>
            </div>
            <div class="col-md-6 mb-4">
              <div class="card p-3">
                <h6 class="text-center">Complaint Status Distribution</h6>
                <canvas id="pieChart"></canvas>
              </div>
            </div>
          </div>
        </div>

        <!-- Department Wise Complaints -->
        <div id="deptComplaints" class="section">
          <div class="card p-4">
            <h5>Department-wise Complaints</h5>
            <table class="table table-striped">
              <thead class="table-dark">
                <tr>
                  <th>Department</th>
                  <th>Total Complaints</th>
                  <th>Resolved</th>
                  <th>Pending</th>
                  <th>Resolution Rate</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>Roads and Potholes</td>
                  <td>300</td>
                  <td>210</td>
                  <td>90</td>
                  <td>70%</td>
                </tr>
                <tr>
                  <td>Street Lights</td>
                  <td>200</td>
                  <td>160</td>
                  <td>40</td>
                  <td>80%</td>
                </tr>
                <tr>
                  <td>Drainage</td>
                  <td>180</td>
                  <td>120</td>
                  <td>60</td>
                  <td>66%</td>
                </tr>
                <tr>
                  <td>Garbage Collection</td>
                  <td>200</td>
                  <td>180</td>
                  <td>20</td>
                  <td>90%</td>
                </tr>
                <tr>
                  <td>Parks and Playgrounds</td>
                  <td>100</td>
                  <td>70</td>
                  <td>30</td>
                  <td>70%</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Reports -->
        <div id="reports" class="section">
          <div class="card p-4">
            <h5>Generate Reports</h5>
            <p>Download system-wide reports for performance analysis.</p>
            <button class="btn btn-outline-primary">Download Full Report (PDF)</button>
            <button class="btn btn-outline-success">Download Excel</button>
          </div>
        </div>

        <!-- User Management -->
        <div id="users" class="section">
          <div class="card p-4">
            <h5>User Management</h5>
            <table class="table table-bordered">
              <thead class="table-dark">
                <tr>
                  <th>User ID</th>
                  <th>Name</th>
                  <th>Email</th>
                  <th>Role</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>U001</td>
                  <td>John Doe</td>
                  <td>john@example.com</td>
                  <td>User</td>
                  <td>
                    <button class="btn btn-sm btn-warning">Edit</button>
                    <button class="btn btn-sm btn-danger">Delete</button>
                  </td>
                </tr>
                <tr>
                  <td>A002</td>
                  <td>Admin Dept</td>
                  <td>admin@dept.com</td>
                  <td>Admin</td>
                  <td>
                    <button class="btn btn-sm btn-warning">Edit</button>
                    <button class="btn btn-sm btn-danger">Delete</button>
                  </td>
                </tr>
              </tbody>
            </table>
            <button class="btn btn-success">Add New User</button>
          </div>
        </div>

        <!-- Department Management -->
        <div id="departments" class="section">
          <div class="card p-4">
            <h5>Department Management</h5>
            <table class="table table-striped">
              <thead class="table-dark">
                <tr>
                  <th>Dept. ID</th>
                  <th>Department Name</th>
                  <th>Head</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>D001</td>
                  <td>Roads and Potholes</td>
                  <td>Mr. Silva</td>
                  <td>
                    <button class="btn btn-sm btn-warning">Edit</button>
                    <button class="btn btn-sm btn-danger">Delete</button>
                  </td>
                </tr>
                <tr>
                  <td>D002</td>
                  <td>Garbage Collection</td>
                  <td>Ms. Perera</td>
                  <td>
                    <button class="btn btn-sm btn-warning">Edit</button>
                    <button class="btn btn-sm btn-danger">Delete</button>
                  </td>
                </tr>
              </tbody>
            </table>
            <button class="btn btn-primary">Add New Department</button>
          </div>
        </div>

        <!-- Logout -->
        <div id="logout" class="section">
          <div class="card p-4 text-center">
            <h5>Are you sure you want to logout?</h5>
            <a href="SupAdmLogin.jsp" ><button class="btn btn-danger">Logout</button></a>
          </div>
        </div>

      </main>
    </div>
  </div>

  <!-- Footer -->
  <footer>
    <p>&copy; 2025 Biyagama Pradeshiya Sabha | All Rights Reserved</p>
  </footer>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script>
    function showSection(id) {
      document.querySelectorAll('.section').forEach(sec => sec.classList.remove('active'));
      document.getElementById(id).classList.add('active');
      document.querySelectorAll('.sidebar a').forEach(a => a.classList.remove('active'));
      event.target.classList.add('active');
    }

    // Bar Chart
    const barCtx = document.getElementById('barChart').getContext('2d');
    new Chart(barCtx, {
      type: 'bar',
      data: {
        labels: ['Roads', 'Street Lights', 'Drainage', 'Garbage', 'Parks'],
        datasets: [{
          label: 'Complaints',
          data: [300, 200, 180, 200, 100],
          backgroundColor: ['#002b5c', '#495057', '#ff7f11', '#ffc107', '#6f42c1']
        }]
      },
      options: { responsive: true, plugins: { legend: { display: false } } }
    });

    // Pie Chart
    const pieCtx = document.getElementById('pieChart').getContext('2d');
    new Chart(pieCtx, {
      type: 'pie',
      data: {
        labels: ['Resolved', 'Pending'],
        datasets: [{
          data: [740, 240],
          backgroundColor: ['#28a745', '#dc3545']
        }]
      },
      options: { responsive: true }
    });
  </script>
</body>
</html>
