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

      <div class="mb-3">
        <label class="form-label fw-bold">Admin Name</label>
        <input type="text" name="Name" class="form-control" placeholder="Enter Admin Name" required>
      </div>
      
      <div class="mb-3">
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
                      <option value="<%=rs.getString("deptName")%>">
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

      <div class="mb-3">
        <label class="form-label fw-bold">Contact No</label>
        <input type="text" name="contactNo" class="form-control" placeholder="Enter Contact No" required>
      </div>
      
      <div class="mb-3">
        <label class="form-label fw-bold">Email</label>
        <input type="email" name="email" class="form-control" placeholder="Enter Email" required>
      </div>
      
      <div class="mb-3">
        <label class="form-label fw-bold">User Name</label>
        <input type="text" name="userName" class="form-control" placeholder="Enter User Name" required>
      </div>
      
      <div class="mb-3">
        <label class="form-label fw-bold">Password</label>
        <input type="password" name="pwd" class="form-control" placeholder="Enter Password" required>
      </div>

      <div class="text-center">
        <button type="submit" class="btn btn-primary w-50">Add Admin</button>
      </div>
    </form>

    <hr>

    <!-- Display All Admins -->
    <h4 class="text-center text-success mb-3">Existing Admins</h4>
    <table class="table table-striped table-bordered">
      <thead class="table-dark text-center">
        <tr>
          <th>ID</th>
          <th>Admin Name</th>
          <th>Department</th>
          <th>Contact No</th>
          <th>Email</th>
          <th>Username</th>
          <th>Password</th>
          <th>Status</th>
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
              String query = "SELECT iddept_admin_tb, deptAdmName, dept_name, deptAdmContactNo, deptAdmEmail, deptAdmUname, deptAdmPwd, isBlocked FROM dept_admin_tb";
              ps2 = con2.prepareStatement(query);
              rs2 = ps2.executeQuery();
              while (rs2.next()) {
            	  int id = rs2.getInt("iddept_admin_tb");
            	  int isBlocked = rs2.getInt("isBlocked");
            	  String blockStatus = (isBlocked == 1) ? "Blocked" : "Active";
        %>
        <tr>
          <td><%= id %></td>
          <td><%= rs2.getString("deptAdmName") %></td>
          <td><%= rs2.getString("dept_name") %></td>
          <td><%= rs2.getString("deptAdmContactNo") %></td>
          <td><%= rs2.getString("deptAdmEmail") %></td>
          <td><%= rs2.getString("deptAdmUname") %></td>
          <td><%= rs2.getString("deptAdmPwd") %></td>
          <td><%= blockStatus %></td>
          <td>
            <a href="EditAdmin.jsp?id=<%= id %>" class="btn btn-sm btn-warning">Edit</a>
            <a href="${pageContext.request.contextPath}/DeleteAdminServlet?id=<%= id %>" 
               class="btn btn-sm btn-danger" 
               onclick="return confirm('Are you sure you want to delete this admin?');">Delete</a>

            <% if (blockStatus.equals("Active")) { %>
              <a href="<%= request.getContextPath() %>/BlockAdmServlet?id=<%= id %>&action=block"
                 class="btn btn-sm btn-secondary"
                 onclick="return confirm('Block this admin?');">Block</a>
            <% } else { %>
              <a href="<%= request.getContextPath() %>/BlockAdmServlet?id=<%= id %>&action=unblock"
                 class="btn btn-sm btn-success"
                 onclick="return confirm('Unblock this admin?');">Unblock</a>
            <% } %>
          </td>
        </tr>
        <%
              }
          } catch (Exception e) {
              out.println("<tr><td colspan='9' class='text-center text-danger'>Error: " + e.getMessage() + "</td></tr>");
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


</body>
</html>
