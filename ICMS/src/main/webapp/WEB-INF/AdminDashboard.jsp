<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Session handling – redirect to login if not logged in
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("adminUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String adminName = (String) sessionObj.getAttribute("adminUser");
    String adminEmail = (String) sessionObj.getAttribute("adminEmail");
    String adminPhone = (String) sessionObj.getAttribute("adminPhone");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard - Complaint Management</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body { background-color: #f8f9fa; }
    .sidebar { height: 100vh; background: #343a40; color: white; padding-top: 20px; }
    .sidebar a { color: white; display: block; padding: 10px 20px; text-decoration: none; cursor: pointer; }
    .sidebar a:hover { background: #495057; }
    .badge-card { text-align: center; padding: 20px; border-radius: 15px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
    .content-section { display: none; }
    .content-section.active { display: block; }
    .edit-icon { float: right; cursor: pointer; color: white; }
    footer {
      background-color: #002b5c;
      color: #ffffff;
      text-align: center;
      padding: 20px 10px;
      position: relative;
      bottom: 0;
      width: 100%;
      border-radius: 15px 15px 0 0;
      margin-top: 40px;
    }
  </style>
</head>
<body>
  <div class="container-fluid">
    <div class="row">
      <!-- Sidebar -->
      <nav class="col-md-2 sidebar">
        <h4 class="text-center">Admin Panel</h4>
        <a onclick="showSection('dashboard')"><i class="fas fa-home"></i> Dashboard</a>
        <a onclick="showSection('profile')"><i class="fas fa-user"></i> Profile</a>
        <a onclick="showSection('complaints')"><i class="fas fa-clipboard-list"></i> Complaints</a>
        <a onclick="showSection('notifications')"><i class="fas fa-bell"></i> Notifications</a>
        <form action="LogoutServlet" method="post">
          <button class="btn btn-link text-white"><i class="fas fa-sign-out-alt"></i> Logout</button>
        </form>
      </nav>

      <!-- Main Content -->
      <main class="col-md-10 p-4">
        <!-- Dashboard Section -->
        <div id="dashboard" class="content-section active">
          <h2>Welcome, <%= adminName %></h2>
          <p>Select an option from the sidebar to get started.</p>
          <div class="col-md-4">
            <div class="badge-card bg-light">
              <h5>Total Complaints</h5>
              <p><strong>100</strong></p>
            </div>
          </div>
        </div>

        <!-- Complaints Section -->
        <div id="complaints" class="content-section">
          <div class="card mb-4">
            <div class="card-header bg-primary text-white">
              <i class="fas fa-clipboard-list"></i> Complaints
            </div>
            <div class="card-body">
              <table class="table table-bordered table-hover">
                <thead class="table-dark">
                  <tr>
                    <th>ID</th>
                    <th>Complaint</th>
                    <th>File</th>
                    <th>Status</th>
                    <th>Complainant</th>
                    <th>Contact</th>
                    <th>Location</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  <!-- Example row (later replace with DB loop) -->
                  <tr>
                    <td>1</td>
                    <td>Broken Street Light</td>
                    <td><a href="uploads/streetlight.jpg" target="_blank">View File</a></td>
                    <td>
                      <select class="form-select form-select-sm">
                        <option selected>Pending</option>
                        <option>Processing</option>
                        <option>Resolved</option>
                      </select>
                    </td>
                    <td>John Doe</td>
                    <td>0711234567</td>
                    <td>Main Road, Biyagama</td>
                    <td><button class="btn btn-sm btn-primary">Update</button></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- Profile Section -->
        <div id="profile" class="content-section">
          <div class="row mb-4">
            <div class="col-md-6">
              <div class="card">
                <div class="card-header bg-info text-white">
                  <i class="fas fa-user"></i> Profile
                  <i class="fas fa-edit edit-icon" id="editProfileBtn" title="Edit Profile"></i>
                </div>
                <div class="card-body">
                  <form id="profileForm">
                    <div class="row mb-3">
                      <div class="col-md-6">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" value="<%= adminName %>" disabled>
                      </div>
                      <div class="col-md-6">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" value="<%= adminEmail %>" disabled>
                      </div>
                    </div>
                    <div class="row mb-3">
                      <div class="col-md-6">
                        <label class="form-label">Phone</label>
                        <input type="text" class="form-control" value="<%= adminPhone %>" disabled>
                      </div>
                      <div class="col-md-6">
                        <label class="form-label">Role</label>
                        <input type="text" class="form-control" value="Admin" disabled>
                      </div>
                    </div>
                    <div class="text-end">
                      <button type="submit" class="btn btn-success" id="saveProfileBtn" style="display:none;">
                        Save Changes
                      </button>
                    </div>
                  </form>
                </div>
              </div>
            </div>

            <div class="col-md-6">
              <div class="badge-card bg-light">
                <h5>Your Badge</h5>
                <p><strong>Solved Complaints: 65%</strong></p>
                <span class="badge bg-warning text-dark fs-5">Gold</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Notifications Section -->
        <div id="notifications" class="content-section">
          <div class="card">
            <div class="card-header bg-secondary text-white">
              <i class="fas fa-bell"></i> Notifications
            </div>
            <div class="card-body">
              <ul class="list-group">
                <li class="list-group-item"><i class="fas fa-user"></i> New complaint added by <b>John Doe</b></li>
                <li class="list-group-item"><i class="fas fa-user-shield"></i> Super Admin: Please review complaint #2</li>
              </ul>
            </div>
          </div>
        </div>

      </main>
    </div>
  </div>

  <footer>
    <p>© 2025 Biyagama Pradeshiya Sabha | Infrastructure Complaint Management System</p>
    <p>Designed and Developed for Public Service</p>
  </footer>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    function showSection(sectionId) {
      document.querySelectorAll('.content-section').forEach(sec => {
        sec.classList.remove('active');
      });
      document.getElementById(sectionId).classList.add('active');
    }

    // Profile Edit Functionality
    const editBtn = document.getElementById("editProfileBtn");
    const saveBtn = document.getElementById("saveProfileBtn");
    const inputs = document.querySelectorAll("#profileForm input");

    editBtn.addEventListener("click", () => {
      inputs.forEach(input => input.removeAttribute("disabled"));
      saveBtn.style.display = "inline-block";
    });

    document.getElementById("profileForm").addEventListener("submit", function(e) {
      e.preventDefault();
      inputs.forEach(input => input.setAttribute("disabled", true));
      saveBtn.style.display = "none";
      alert("Profile updated successfully!");
    });
  </script>
</body>
</html>
