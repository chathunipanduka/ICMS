<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ page import="ICMSpackage.IcmsConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"> <!-- ✅ Important for responsiveness -->
<title>All Complaints - Super Admin</title>

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

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
.media-preview {
  width: 70px;
  height: 70px;
  border-radius: 8px;
  object-fit: cover;
  transition: transform 0.2s, box-shadow 0.2s;
  cursor: pointer;
}
.media-preview:hover {
  transform: scale(1.05);
  box-shadow: 0 0 6px rgba(0,0,0,0.3);
}
.no-media {
  color: #999;
  font-size: 13px;
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

  .media-preview {
    width: 60px;
    height: 60px;
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
  <h2 class="text-center mb-4">📋 All Submitted Complaints</h2>

  <!-- ✅ Responsive table wrapper -->
  <div class="table-responsive">
    <table class="table table-bordered table-hover align-middle text-center">
      <thead>
        <tr>
          <th>ID</th>
          <th>Department</th>
          <th>Description</th>
          <th>Status</th>
          <th>Media</th>
          <th>User</th>
          <th>Location</th>
          <th>Date/Time</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
<%
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
try {
    conn = IcmsConnection.getConnection();
    String sql = "SELECT c.id_complaint_tb, c.description, c.status, c.media, c.location, c.date_time, " +
                 "d.deptName, l.uName AS username " +
                 "FROM complaint_tb c " +
                 "LEFT JOIN dept_tb d ON c.dept_id = d.id_dept_tb " +
                 "LEFT JOIN login_tb l ON c.user_id = l.id_login_tb " +
                 "ORDER BY c.date_time DESC";
    ps = conn.prepareStatement(sql);
    rs = ps.executeQuery();

    boolean hasData = false;
    while (rs.next()) {
        hasData = true;
        int id = rs.getInt("id_complaint_tb");
        String dept_Name = rs.getString("deptName");
        String desc = rs.getString("description");
        String status = rs.getString("status");
        String location = rs.getString("location");
        String user_name = rs.getString("username");
        Timestamp dateTime = rs.getTimestamp("date_time");
        Blob media = rs.getBlob("media");
%>
<tr>
  <td><%= id %></td>
  <td><%= dept_Name != null ? dept_Name : "N/A" %></td>
  <td class="text-break" style="max-width:200px;"><%= desc %></td>
  <td>
    <% if ("Pending".equalsIgnoreCase(status)) { %>
        <span class="badge bg-warning text-dark">Pending</span>
    <% } else if ("InProgress".equalsIgnoreCase(status)) { %>
        <span class="badge bg-info text-dark">In Progress</span>
    <% } else if ("Solved".equalsIgnoreCase(status)) { %>
        <span class="badge bg-success">Solved</span>
    <% } else { %>
        <span class="badge bg-secondary">Unknown</span>
    <% } %>
  </td>
  <td>
    <%
    PreparedStatement psMedia = conn.prepareStatement(
        "SELECT id_media FROM complaint_media_tb WHERE complaint_id = ? LIMIT 1");
    psMedia.setInt(1, id);
    ResultSet rsMedia = psMedia.executeQuery();

    if (rsMedia.next()) {
        int firstMediaId = rsMedia.getInt("id_media");
%>
        <img src="${pageContext.request.contextPath}/ViewMediaServlet?mediaId=<%= firstMediaId %>" 
             class="media-preview" 
             alt="Complaint Image"
             data-bs-toggle="modal" 
             data-bs-target="#mediaModal" 
             data-complaint="<%= id %>">
<%
    } else {
%>
        <span class="no-media">No Media</span>
<%
    }
    rsMedia.close();
    psMedia.close();
%>
  </td>
  <td><%= user_name != null ? user_name : "N/A" %></td>
  <td><%= location != null ? location : "N/A" %></td>
  <td><%= dateTime %></td>
  <td>
    <a href="EditComplaint.jsp?id=<%= id %>" class="btn btn-sm btn-warning mb-1">Edit</a>
    <a href="${pageContext.request.contextPath}/DeleteComplaintServlet?id=<%= id %>"
       class="btn btn-sm btn-danger"
       onclick="return confirm('Are you sure you want to delete this complaint?');">Delete</a>
  </td>
</tr>
<%
    }
    if (!hasData) {
        out.println("<tr><td colspan='9' class='text-muted'>No complaints submitted yet.</td></tr>");
    }
} catch (Exception e) {
    out.println("<tr><td colspan='9' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
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
<br>
<br>

	<!-- 📸 Modal to View All Images -->
<div class="modal fade" id="mediaModal" tabindex="-1" aria-labelledby="mediaModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="mediaModalLabel">Complaint Images</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body text-center" id="mediaContainer">
        <p class="text-muted">Loading images...</p>
      </div>
    </div>
  </div>
</div>
<!-- Bootstrap JS (with Popper) -->
<!-- Bootstrap JS Bundle (includes Popper) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Your custom JS -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const mediaModal = document.getElementById('mediaModal');
    const mediaContainer = document.getElementById('mediaContainer');
    const contextPath = '<%= request.getContextPath() %>';

    // Listen for modal show
    mediaModal.addEventListener('show.bs.modal', function (event) {
        const triggerImg = event.relatedTarget; // The clicked image
        if (!triggerImg) return;

        const complaintId = triggerImg.getAttribute('data-complaint');

        mediaContainer.innerHTML = "<p class='text-muted'>Loading images...</p>";

        fetch(contextPath + '/GetComplaintImagesServlet?complaintId=' + complaintId)
            .then(response => response.text())
            .then(html => {
                mediaContainer.innerHTML = html;
            })
            .catch(err => {
                console.error('Image load error:', err);
                mediaContainer.innerHTML = "<p class='text-danger'>Failed to load images.</p>";
            });
    });
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
