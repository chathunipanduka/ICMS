<%@ page import="java.sql.*, ICMSpackage.IcmsConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Department Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<a href="DepartmentManage.jsp" class="btn btn-secondary mt-3 ms-3">← Back</a>

<div class="container mt-5">

  <div class="card shadow p-4">
    <h3 class="mb-4 text-primary text-center">Add New Department</h3>
    <form action="${pageContext.request.contextPath}/AddDepartmentServlet" method="post">
      <div class="mb-3">
        <label class="form-label fw-bold">Department Name</label>
        <input type="text" name="deptName" class="form-control" placeholder="Enter department name" required>
      </div>
      <div class="mb-3">
        <label class="form-label fw-bold">Contact Number</label>
        <input type="text" name="deptContactNo" class="form-control" placeholder="Enter contact number" required>
      </div>
      <div class="text-center">
        <button type="submit" class="btn btn-primary w-50">Add Department</button>
      </div>
    </form>
  </div>

  <hr class="my-5">

  <div class="card shadow p-4">
    <h4 class="text-center text-secondary mb-4">Department List</h4>
    <table class="table table-striped">
      <thead>
        <tr>
          <th>ID</th>
          <th>Department Name</th>
          <th>Contact No</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <%
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                con = IcmsConnection.getConnection();
                ps = con.prepareStatement("SELECT * FROM dept_tb");
                rs = ps.executeQuery();
                while (rs.next()) {
        %>
                <tr>
                  <td><%= rs.getInt("id_dept_tb") %></td>
                  <td><%= rs.getString("deptName") %></td>
                  <td><%= rs.getString("deptConatctNo") %></td>
                  <td>
                    <a href="EditDepartment.jsp?id=<%=rs.getInt("id_dept_tb")%>" class="btn btn-warning btn-sm">Edit</a>
                    <a href="${pageContext.request.contextPath}/DeleteDepartmentServlet?id=<%=rs.getInt("id_dept_tb")%>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this department?')">Delete</a>
                  </td>
                </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='4'>Error loading data</td></tr>");
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            }
        %>
      </tbody>
    </table>
  </div>

</div>
<br>
<br>
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
