<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ page import="ICMSpackage.IcmsConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>All Users - Super Admin</title>

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Bootstrap Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

<style>
body {
  background-color: #f7f9fb;
  font-family: "Segoe UI", sans-serif;
}

.container {
  margin-top: 40px;
  background: #fff;
  padding: 25px;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0,0,0,0.1);
}

/* Table styling */
table {
  font-size: 15px;
  vertical-align: middle;
}
th {
  background-color: #003366;
  color: #fff;
}

.action-buttons {
  display: flex;
  gap: 5px;
  flex-wrap: wrap;
  justify-content: center;
}

.btn-sm {
  font-size: 0.75rem;
  padding: 0.25rem 0.5rem;
}

.status-badge {
  font-size: 0.7rem;
  padding: 0.25rem 0.5rem;
}

/* Footer styling */
footer {
  background-color: #00274d;
  color: #fff;
  text-align: center;
  padding: 15px;
  font-size: 14px;
  margin-top: 40px;
}

/* ✅ Responsive adjustments */
@media (max-width: 992px) {
  .container {
    margin-top: 20px;
    padding: 15px;
  }
  table {
    font-size: 14px;
  }
  h2 {
    font-size: 20px;
  }
}

@media (max-width: 768px) {
  .table-responsive {
    border: none;
  }
  table th, table td {
    white-space: nowrap;
  }
  .action-buttons {
    flex-direction: column;
    align-items: center;
  }
}

@media (max-width: 576px) {
  .container {
    padding: 10px;
  }
  footer {
    font-size: 13px;
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
%>

<div class="container">
  <h2 class="text-center mb-5 fw-bold" style="color: #00274d;">Manage Users</h2>
  
  <form method="get" class="row g-2 mb-4">
    <div class="col-md-3 mt-2">
      <label class="form-label">Search</label>
      <input type="text" name="search" class="form-control form-control-sm" placeholder="Keyword or ID"
             value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
    </div>
    <div class="col-md-2 align-self-end">
      <button type="submit" class="btn btn-primary btn-sm w-100">
        <i class="bi bi-search"></i> Search
      </button>
    </div>
  </form>

  <!-- Success/Error Messages -->
<%
    String successMsg = (String) session.getAttribute("successMessage");
    String errorMsg = (String) session.getAttribute("errorMessage");
    
    if (successMsg != null) {
%>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill"></i> <%= successMsg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<%
        session.removeAttribute("successMessage");
    }
    if (errorMsg != null) {
%>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill"></i> <%= errorMsg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<%
        session.removeAttribute("errorMessage");
    }
%>
  <!-- ✅ Responsive table wrapper -->
  <div class="table-responsive">
    <table class="table table-bordered table-hover align-middle text-center">
      <thead>
        <tr>
          <th>ID</th>
          <th>First Name</th>
          <th>Last Name</th>
          <th>Email</th>
          <th>Contact No</th>
          <th>User Name</th>
          <th>Status</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
<%
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

String fSearch = request.getParameter("search");
try {
    conn = IcmsConnection.getConnection();
    
    StringBuilder sql = new StringBuilder(
        "SELECT id_login_tb, firstName, lastName, email, contactNo, uName, pwd, isBlocked " +
        "FROM user_tb WHERE 1=1 "
    );
    
    List<String> params = new ArrayList<>();
    
    if (fSearch != null && !fSearch.trim().isEmpty()) {
        sql.append(" AND (id_login_tb LIKE ? OR firstName LIKE ? OR lastName LIKE ? OR uName LIKE ? OR email LIKE ?) ");
        String s = "%" + fSearch.trim() + "%";
        for (int i = 0; i < 5; i++) {
            params.add(s);
        }
    }
    
    sql.append(" ORDER BY id_login_tb DESC");
    
    ps = conn.prepareStatement(sql.toString());
    
    // Bind parameters
    for (int i = 0; i < params.size(); i++) {
        ps.setString(i + 1, params.get(i));
    }
    
    rs = ps.executeQuery();
    
    boolean hasData = false;
    while (rs.next()) {
        hasData = true;
        int id = rs.getInt("id_login_tb");
        String fName = rs.getString("firstName");
        String lName = rs.getString("lastName");
        String email = rs.getString("email");
        String contact = rs.getString("contactNo");
        String user_name = rs.getString("uName");
        int isBlocked = rs.getInt("isBlocked");
        String blockStatus = isBlocked == 1 ? "Blocked" : "Active";
        String statusBadgeClass = isBlocked == 1 ? "bg-danger" : "bg-success";
%>
<tr>
  <td><strong><%= id %></strong></td>
  <td><%= fName != null ? fName : "" %></td>
  <td><%= lName != null ? lName : "" %></td>
  <td><%= email != null ? email : "" %></td>
  <td><%= contact != null ? contact : "" %></td>
  <td><%= user_name != null ? user_name : "" %></td>
  <td>
    <span class="badge <%= statusBadgeClass %> status-badge"><%= blockStatus %></span>
  </td>
  <td>
    <div class="action-buttons">
      <!-- Edit Button -->
      <a href="EditUser.jsp?id=<%= id %>" 
         class="btn btn-warning btn-sm" 
         title="Edit User">
        <i class="bi bi-pencil-square"></i> Edit
      </a>
      
      <!-- Delete Button -->
      <a href="<%= request.getContextPath() %>/DeleteUserServlet?id=<%= id %>"
         class="btn btn-danger btn-sm"
         onclick="return confirm('Are you sure you want to delete user: <%= fName %> <%= lName %>? This action cannot be undone.');"
         title="Delete User">
        <i class="bi bi-trash"></i> Delete
      </a>
      
      <!-- Block/Unblock Button -->
      <% if (isBlocked == 0) { %>
        <a href="<%= request.getContextPath() %>/BlockUserServlet?id=<%= id %>&action=block"
           class="btn btn-secondary btn-sm"
           onclick="return confirm('Block user: <%= fName %> <%= lName %>?');"
           title="Block User">
          <i class="bi bi-lock"></i> Block
        </a>
      <% } else { %>
        <a href="<%= request.getContextPath() %>/BlockUserServlet?id=<%= id %>&action=unblock"
           class="btn btn-success btn-sm"
           onclick="return confirm('Unblock user: <%= fName %> <%= lName %>?');"
           title="Unblock User">
          <i class="bi bi-unlock"></i> Unblock
        </a>
      <% } %>
    </div>
  </td>
</tr>
<%
    }
    if (!hasData) {
        out.println("<tr><td colspan='8' class='text-muted py-3'>No users found.</td></tr>");
    }
} catch (Exception e) {
    out.println("<tr><td colspan='8' class='text-danger py-3'>Error loading users: " + e.getMessage() + "</td></tr>");
    e.printStackTrace();
} finally {
    try { if (rs != null) rs.close(); } catch (Exception ignored) {}
    try { if (ps != null) ps.close(); } catch (Exception ignored) {}
    try { if (conn != null) conn.close(); } catch (Exception ignored) {}
}
%>
      </tbody>
    </table>
  </div>
</div>





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

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
// Auto-dismiss alerts after 5 seconds
document.addEventListener('DOMContentLoaded', function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });
});
</script>
</body>
</html>