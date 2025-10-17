<%@ page import="java.sql.*, ICMSpackage.IcmsConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Admin</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<a href="DepartmentManage.jsp" class="btn btn-secondary mt-3 ms-3">← Back</a>

<div class="container mt-5">
  <div class="card shadow p-4">
    <h3 class="mb-4 text-primary text-center">Add New Admin</h3>

    <!-- Add Form -->
    <form action="${pageContext.request.contextPath}/AddAdminServlet" method="post" class="mb-4">

      <!-- Department Dropdown -->
      <div class="mb-3">
      
      <div class="mb-3">
        <label class="form-label fw-bold">Admin Name</label>
        <input type="text" name="Name" class="form-control" placeholder="Enter Contact No" required>
      </div>
      
        <label class="form-label fw-bold">Department</label>
        <select name="dept_name" class="form-select" required>
          <option value="">Select Department</option>
          <%
              Connection con = null;
              PreparedStatement ps = null;
              ResultSet rs = null;
              try {
                  con = IcmsConnection.getConnection();
                  ps = con.prepareStatement("SELECT id_dept_tb, deptName FROM dept_tb");
                  rs = ps.executeQuery();
                  while (rs.next()) {
          %>
                      <option value="<%=rs.getInt("deptName")%>">
                          <%=rs.getString("deptName")%>
                      </option>
          <%
                  }
              } catch (Exception e) {
                  out.println("<option>Error loading departments</option>");
              } finally {
                  if (rs != null) rs.close();
                  if (ps != null) ps.close();
                  if (con != null) con.close();
              }
          %>
        </select>
      </div>

      <!-- Category Name -->
      <div class="mb-3">
        <label class="form-label fw-bold">Contact No</label>
        <input type="text" name="contactNo" class="form-control" placeholder="Enter Contact No" required>
      </div>
      
      <div class="mb-3">
        <label class="form-label fw-bold">Email</label>
        <input type="text" name="email" class="form-control" placeholder="Enter Email" required>
      </div>
      
      <div class="mb-3">
        <label class="form-label fw-bold">User Name</label>
        <input type="text" name="userName" class="form-control" placeholder="Enter User Name" required>
      </div>
      
      <div class="mb-3">
        <label class="form-label fw-bold">Password</label>
        <input type="text" name="pwd" class="form-control" placeholder="Enter Password" required>
      </div>

      <!-- Submit Button -->
      <div class="text-center">
        <button type="submit" class="btn btn-primary w-50">Add Admin</button>
      </div>
    </form>

    <hr>

    <!-- Display All Categories -->
    <h4 class="text-center text-success mb-3">Existing Categories</h4>
    <table class="table table-striped table-bordered">
      <thead class="table-dark text-center">
        <tr>
          <th>ID</th>
          <th>AdminName</th>
          <th>Department</th>
          <th>Contact No</th>
          <th>Email</th>
          <th>Username</th>
          <th>Password</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
       <%
          Connection con2 = null;
          PreparedStatement ps2 = null;
          ResultSet rs2 = null;
          try {
              con2 = IcmsConnection.getConnection();
              String query = "SELECT a.iddept_admin_tb, a.deptAdmName, a.dept_name, a.deptAdmContactNo, a.deptAdmEmail, a.deptAdmUname, a.deptAdmPwd FROM dept_admin_tb a";
              ps2 = con2.prepareStatement(query);
              rs2 = ps2.executeQuery();
              while (rs2.next()) {
        %>
        <tr>
          <td><%=rs2.getInt("iddept_admin_tb")%></td>
          <td><%=rs2.getString("deptAdmName")%></td>
          <td><%=rs2.getString("dept_name")%></td>
          <td><%=rs2.getString("deptAdmContactNo")%></td>
          <td><%=rs2.getString("deptAdmEmail")%></td>
          <td><%=rs2.getString("deptAdmUname")%></td>
          <td><%=rs2.getString("deptAdmPwd")%></td>
          <td>
            <a href="EditAdmin.jsp?id=<%=rs2.getInt("iddept_admin_tb")%>" class="btn btn-sm btn-warning">Edit</a>
            <a href="${pageContext.request.contextPath}/DeleteAdminServlet?id=<%=rs2.getInt("iddept_admin_tb")%>" 
               class="btn btn-sm btn-danger" 
               onclick="return confirm('Are you sure you want to delete this admin?');">Delete</a>
          </td>
        </tr>
        <%
              }
          } catch (Exception e) {
              out.println("<tr><td colspan='4' class='text-center text-danger'>Error loading data</td></tr>");
          } finally {
              if (rs2 != null) rs2.close();
              if (ps2 != null) ps2.close();
              if (con2 != null) con2.close();
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
