<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ page import="ICMSpackage.IcmsConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"> <!-- ✅ Key for responsiveness -->
<title>All Complaints</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body {
  background-color: #f7f9fb;
  font-family: "Segoe UI", sans-serif;
}
.container {
  margin: 10px auto;
  background: #fff;
  padding: 15px;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0,0,0,0.1);
}
h2 {
  color: #003366;
  margin-bottom: 25px;
  text-align: center;
}
.table thead th {
  background-color: #003366;
  color: white;
  text-align: center;
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
footer {
  background-color: #00274d;
  text-align: center;
  padding: 15px;
  font-size: 14px;
  color: #ffffff;
  box-shadow: 0 -2px 5px rgba(0,0,0,0.1);
  margin-top: 30px;
}

/* ✅ Mobile-friendly tweaks */
@media (max-width: 768px) {
  .container {
    padding: 10px;
  }
  h2 {
    font-size: 1.4rem;
  }
  .table {
    font-size: 13px;
  }
  th, td {
    padding: 6px !important;
  }
  .media-preview {
    width: 55px;
    height: 55px;
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
      PreparedStatement ps = con.prepareStatement("SELECT dept_name FROM dept_admin_tb WHERE deptAdmUname = ?");
      ps.setString(1, username);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) deptName = rs.getString("dept_name");
  } catch (Exception e) { e.printStackTrace(); }
%>

<div class="container-fluid mt-3">
  <div class="row justify-content-center">
    <div class="col-12 col-md-11">
      <div class="card shadow rounded-3 p-4">
        <h2>📋 All Submitted Complaints</h2>

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
                <th>Updated</th>
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
      String sql = "SELECT c.id_complaint_tb, c.description, c.status, c.media, c.location, c.date_time, c.updated, " +
                   "d.deptName, l.uName AS username " +
                   "FROM complaint_tb c " +
                   "LEFT JOIN dept_tb d ON c.dept_id = d.id_dept_tb " +
                   "LEFT JOIN login_tb l ON c.user_id = l.id_login_tb " +
                   "WHERE d.deptName = ? ORDER BY c.date_time DESC";
      ps = conn.prepareStatement(sql);
      ps.setString(1, deptName);
      rs = ps.executeQuery();

      while (rs.next()) {
          int id = rs.getInt("id_complaint_tb");
          String dept_Name = rs.getString("deptName");
          String desc = rs.getString("description");
          String status = rs.getString("status");
          String location = rs.getString("location");
          String user_name = rs.getString("username");
          Timestamp dateTime = rs.getTimestamp("date_time");
          Timestamp updatedTime = rs.getTimestamp("updated");
          Blob media = rs.getBlob("media");
%>
<tr>
  <td><%= id %></td>
  <td><%= dept_Name != null ? dept_Name : "N/A" %></td>
  <td class="text-start"><%= desc %></td>
  <td>
    <form method="post" action="${pageContext.request.contextPath}/UpdateComplaintStatusServlet">
      <input type="hidden" name="id" value="<%= id %>">
      <select name="status" class="form-select form-select-sm">
        <option value="Pending" <%= "Pending".equalsIgnoreCase(status) ? "selected" : "" %>>Pending</option>
        <option value="InProgress" <%= "InProgress".equalsIgnoreCase(status) ? "selected" : "" %>>In Progress</option>
        <option value="Solved" <%= "Solved".equalsIgnoreCase(status) ? "selected" : "" %>>Solved</option>
      </select>
  </td>
  <td>
    <% if (media != null && media.length() > 0) { %>
      <a href="../ViewMediaServlet?id=<%= id %>" target="_blank">
        <img src="../ViewMediaServlet?id=<%= id %>" class="media-preview" alt="Complaint Image">
      </a>
    <% } else { %>
      <span class="no-media">No Media</span>
    <% } %>
  </td>
  <td><%= user_name != null ? user_name : "N/A" %></td>
  <td><%= location != null ? location : "N/A" %></td>
  <td><%= dateTime %></td>
  <td><%= updatedTime != null ? updatedTime : "-" %></td>
  <td><button type="submit" class="btn btn-sm btn-primary mt-1">Update</button></form></td>
</tr>
<%
      }
  } catch (Exception e) { e.printStackTrace(); } 
  finally {
      try { if (rs != null) rs.close(); } catch (Exception ignored) {}
      try { if (ps != null) ps.close(); } catch (Exception ignored) {}
      try { if (conn != null) conn.close(); } catch (Exception ignored) {}
  }
%>
            </tbody>
          </table>
        </div> <!-- /table-responsive -->
      </div>
    </div>
  </div>
</div>

<footer>
  Biyagama Pradeshiya Sabha<br>
  Contact: +94 123456789<br>
  Email: biyagamapradehsiyasabha@gmail.com
</footer>
</body>
</html>
