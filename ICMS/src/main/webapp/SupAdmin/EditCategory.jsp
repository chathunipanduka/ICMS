<%@ page import="java.sql.*, ICMSpackage.IcmsConnection" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    String categoryName = "";
    int deptId = 0;

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = IcmsConnection.getConnection();
        ps = con.prepareStatement("SELECT * FROM category_tb WHERE id_category_tb=?");
        ps.setInt(1, id);
        rs = ps.executeQuery();
        if (rs.next()) {
            categoryName = rs.getString("category_name");
            deptId = rs.getInt("dept_id");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Category</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<a href="AddCategory.jsp" class="btn btn-secondary mt-3 ms-3">← Back</a>

<div class="container mt-5">
  <div class="card shadow p-4">
    <h3 class="mb-4 text-primary text-center">Edit Category</h3>
    <form action="${pageContext.request.contextPath}/UpdateCategoryServlet" method="post">
      <input type="hidden" name="id" value="<%=id%>">

      <!-- Department -->
      <div class="mb-3">
        <label class="form-label fw-bold">Department</label>
        <select name="dept_id" class="form-select" required>
          <option value="">Select Department</option>
          <%
              Connection con2 = IcmsConnection.getConnection();
              PreparedStatement ps2 = con2.prepareStatement("SELECT * FROM dept_tb");
              ResultSet rs2 = ps2.executeQuery();
              while (rs2.next()) {
                  int depid = rs2.getInt("id_dept_tb");
          %>
                  <option value="<%=depid%>" <%= (depid == deptId) ? "selected" : "" %>><%=rs2.getString("deptName")%></option>
          <%
              }
              rs2.close();
              ps2.close();
              con2.close();
          %>
        </select>
      </div>

      <div class="mb-3">
        <label class="form-label fw-bold">Category Name</label>
        <input type="text" name="category_name" class="form-control" value="<%=categoryName%>" required>
      </div>

      <div class="text-center">
        <button type="submit" class="btn btn-primary w-50">Update</button>
      </div>
    </form>
  </div>
</div>
</body>
</html>
