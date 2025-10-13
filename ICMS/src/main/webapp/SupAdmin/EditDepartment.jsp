<%@ page import="java.sql.*, ICMSpackage.IcmsConnection" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    String deptName = "", contactNo = "";
    try {
        Connection con = IcmsConnection.getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT * FROM dept_tb WHERE id_dept_tb=?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            deptName = rs.getString("deptName");
            contactNo = rs.getString("deptConatctNo");
        }
        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Department</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
  <div class="card shadow p-4">
    <h3 class="mb-4 text-primary text-center">Edit Department</h3>
    <form action="${pageContext.request.contextPath}/UpdateDepartmentServlet" method="post">
      <input type="hidden" name="id" value="<%= id %>">

      <div class="mb-3">
        <label class="form-label fw-bold">Department Name</label>
        <input type="text" name="deptName" class="form-control" value="<%= deptName %>" required>
      </div>

      <div class="mb-3">
        <label class="form-label fw-bold">Contact Number</label>
        <input type="text" name="deptContactNo" class="form-control" value="<%= contactNo %>" required>
      </div>

      <div class="text-center">
        <button type="submit" class="btn btn-success w-50">Update</button>
      </div>
    </form>
  </div>
</div>

</body>
</html>
