<%@ page import="java.sql.*, ICMSpackage.IcmsConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Categories</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<a href="DepartmentManage.jsp" class="btn btn-secondary mt-3 ms-3">← Back</a>

<div class="container mt-5">
  <div class="card shadow p-4">
    <h3 class="mb-4 text-primary text-center">Add New Category</h3>

    <!-- Add Form -->
    <form action="${pageContext.request.contextPath}/AddCategoryServlet" method="post" class="mb-4">

      <!-- Department Dropdown -->
      <div class="mb-3">
        <label class="form-label fw-bold">Department</label>
        <select name="dept_id" class="form-select" required>
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
                      <option value="<%=rs.getInt("id_dept_tb")%>">
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
        <label class="form-label fw-bold">Category Name</label>
        <input type="text" name="category_name" class="form-control" placeholder="Enter category name" required>
      </div>

      <!-- Submit Button -->
      <div class="text-center">
        <button type="submit" class="btn btn-primary w-50">Add Category</button>
      </div>
    </form>

    <hr>

    <!-- Display All Categories -->
    <h4 class="text-center text-success mb-3">Existing Categories</h4>
    <table class="table table-striped table-bordered">
      <thead class="table-dark text-center">
        <tr>
          <th>ID</th>
          <th>Category Name</th>
          <th>Department</th>
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
              String query = "SELECT c.id_category_tb, c.category_name, d.deptName FROM category_tb c JOIN dept_tb d ON c.dept_id = d.id_dept_tb";
              ps2 = con2.prepareStatement(query);
              rs2 = ps2.executeQuery();
              while (rs2.next()) {
        %>
        <tr>
          <td><%=rs2.getInt("id_category_tb")%></td>
          <td><%=rs2.getString("category_name")%></td>
          <td><%=rs2.getString("deptName")%></td>
          <td class="text-center">
            <a href="EditCategory.jsp?id=<%=rs2.getInt("id_category_tb")%>" class="btn btn-sm btn-warning">Edit</a>
            <a href="${pageContext.request.contextPath}/DeleteCategoryServlet?id=<%=rs2.getInt("id_category_tb")%>" 
               class="btn btn-sm btn-danger" 
               onclick="return confirm('Are you sure you want to delete this category?');">Delete</a>
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

</body>
</html>
