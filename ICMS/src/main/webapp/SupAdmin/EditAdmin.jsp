<%@ page import="java.sql.*, ICMSpackage.IcmsConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Admin</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<a href="AddAdmin.jsp" class="btn btn-secondary mt-3 ms-3">← Back</a>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    String adminName = "";
    String contactNo = "";
    String email = "";
    String userName = "";
    String pwd = "";
    String deptName = "";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = IcmsConnection.getConnection();
        ps = con.prepareStatement("SELECT * FROM dept_admin_tb WHERE iddept_admin_tb = ?");
        ps.setInt(1, id);
        rs = ps.executeQuery();

        if (rs.next()) {
            adminName = rs.getString("deptAdmName");
            contactNo = rs.getString("deptAdmContactNo");
            email = rs.getString("deptAdmEmail");
            userName = rs.getString("deptAdmUname");
            pwd = rs.getString("deptAdmPwd");
            deptName = rs.getString("dept_name"); // from foreign key column
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>

<div class="container mt-5">
  <div class="card shadow p-4">
    <h3 class="mb-4 text-primary text-center">Edit Department Admin</h3>

    <form action="${pageContext.request.contextPath}/UpdateAdminServlet" method="post">
      <input type="hidden" name="id" value="<%=id%>">

      <!-- Admin Name -->
      <div class="mb-3">
        <label class="form-label fw-bold">Admin Name</label>
        <input type="text" name="deptAdmName" class="form-control" value="<%=adminName%>" required>
      </div>

      <!-- Department Dropdown -->
      <div class="mb-3">
        <label class="form-label fw-bold">Department</label>
        <select name="dept_name" class="form-select" required>
          <option value="">Select Department</option>
          <%
              Connection con2 = null;
              PreparedStatement ps2 = null;
              ResultSet rs2 = null;
              try {
                  con2 = IcmsConnection.getConnection();
                  ps2 = con2.prepareStatement("SELECT deptName FROM dept_tb");
                  rs2 = ps2.executeQuery();
                  while (rs2.next()) {
                      String dName = rs2.getString("deptName");
          %>
                      <option value="<%=dName%>" <%= dName.equals(deptName) ? "selected" : "" %>><%=dName%></option>
          <%
                  }
              } catch (Exception e) {
                  out.println("<option>Error loading departments</option>");
              } finally {
                  if (rs2 != null) rs2.close();
                  if (ps2 != null) ps2.close();
                  if (con2 != null) con2.close();
              }
          %>
        </select>
      </div>

      <!-- Contact No -->
      <div class="mb-3">
        <label class="form-label fw-bold">Contact No</label>
        <input type="text" name="deptAdmContactNo" class="form-control" value="<%=contactNo%>" required>
      </div>

      <!-- Email -->
      <div class="mb-3">
        <label class="form-label fw-bold">Email</label>
        <input type="email" name="deptAdmEmail" class="form-control" value="<%=email%>" required>
      </div>

      <!-- Username -->
      <div class="mb-3">
        <label class="form-label fw-bold">Username</label>
        <input type="text" name="deptAdmUname" class="form-control" value="<%=userName%>" required>
      </div>

      <!-- Password -->
      <div class="mb-3">
        <label class="form-label fw-bold">Password</label>
        <input type="text" name="deptAdmPwd" class="form-control" value="<%=pwd%>" required>
      </div>

      <!-- Submit Button -->
      <div class="text-center">
        <button type="submit" class="btn btn-primary w-50">Update Admin</button>
      </div>
    </form>
  </div>
</div>
</body>
</html>
