<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ page import="ICMSpackage.IcmsConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Edit Department Admin</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
	background-color: #f7f9fb;
	font-family: "Segoe UI", sans-serif;
}
.container {
	margin-top: 50px;
	background: #fff;
	padding: 25px;
	border-radius: 10px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}
h3 {
	color: #003366;
	margin-bottom: 25px;
	text-align: center;
}
</style>
</head>
<body>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    String adminName = "", contactNo = "", email = "", userName = "", pwd = "", deptName = "";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = IcmsConnection.getConnection();
        ps = con.prepareStatement("SELECT * FROM dept_admin_tb WHERE iddept_admin_tb = ?");
        ps.setInt(1, id);
        rs = ps.executeQuery();
        if(rs.next()){
            adminName = rs.getString("deptAdmName");
            contactNo = rs.getString("deptAdmContactNo");
            email = rs.getString("deptAdmEmail");
            userName = rs.getString("deptAdmUname");
            pwd = rs.getString("deptAdmPwd");
            deptName = rs.getString("dept_name");
        }
    } catch(Exception e){
        e.printStackTrace();
    } finally {
        try { if(rs != null) rs.close(); } catch(Exception ignored){}
        try { if(ps != null) ps.close(); } catch(Exception ignored){}
        try { if(con != null) con.close(); } catch(Exception ignored){}
    }
%>

<div class="container">
  <a href="AddAdmin.jsp" class="btn btn-secondary mb-3">← Back</a>
  <div class="card shadow p-4">
    <h3>Edit Department Admin</h3>
    <form action="UpdateAdminServlet" method="post">
      <input type="hidden" name="id" value="<%=id%>">

      <div class="mb-3">
        <label class="form-label">Admin Name</label>
        <input type="text" name="deptAdmName" class="form-control" value="<%=adminName%>" required>
      </div>

      <div class="mb-3">
        <label class="form-label">Department</label>
        <select name="dept_name" class="form-select" required>
            <option value="">Select Department</option>
            <%
                Connection con2 = null;
                PreparedStatement ps2 = null;
                ResultSet rs2 = null;
                try{
                    con2 = IcmsConnection.getConnection();
                    ps2 = con2.prepareStatement("SELECT deptName FROM dept_tb");
                    rs2 = ps2.executeQuery();
                    while(rs2.next()){
                        String dName = rs2.getString("deptName");
            %>
                        <option value="<%=dName%>" <%= dName.equals(deptName) ? "selected" : "" %>><%=dName%></option>
            <%
                    }
                }catch(Exception e){ out.println("<option>Error loading departments</option>"); }
                finally{
                    try{if(rs2!=null) rs2.close();}catch(Exception ignored){}
                    try{if(ps2!=null) ps2.close();}catch(Exception ignored){}
                    try{if(con2!=null) con2.close();}catch(Exception ignored){}
                }
            %>
        </select>
      </div>

      <div class="mb-3">
        <label class="form-label">Contact No</label>
        <input type="text" name="deptAdmContactNo" class="form-control" value="<%=contactNo%>" required>
      </div>

      <div class="mb-3">
        <label class="form-label">Email</label>
        <input type="email" name="deptAdmEmail" class="form-control" value="<%=email%>" required>
      </div>

      <div class="mb-3">
        <label class="form-label">Username</label>
        <input type="text" name="deptAdmUname" class="form-control" value="<%=userName%>" required>
      </div>

      <div class="mb-3">
        <label class="form-label">Password</label>
        <input type="text" name="deptAdmPwd" class="form-control" value="<%=pwd%>" required>
      </div>

      <div class="text-center">
        <button type="submit" class="btn btn-primary w-50">Update Admin</button>
      </div>
    </form>
  </div>
</div>
</body>
</html>
