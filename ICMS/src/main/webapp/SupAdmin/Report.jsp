<%@ page import="java.sql.*, java.util.*, ICMSpackage.IcmsConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Complaint Report</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { background-color: #e9f2fb; font-family: 'Segoe UI', sans-serif; }
.table th { background-color: black; color: white; }
.table td { background-color: #d9d9d9; }
.filter-box { background: #dce6f7; padding: 15px; border-radius: 10px; margin-bottom: 15px; }
.btn-primary { background-color: #1d3557; border: none; }
.btn-primary:hover { background-color: #0b2e59; }
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
.no-media { color: #999; font-size: 13px; }
</style>
</head>
<body class="container mt-4">

<h3 class="text-center mb-3">Complaint Report</h3>

<%
String selectedDept = request.getParameter("dept_id");
String selectedStatus = request.getParameter("status");
String enteredLocation = request.getParameter("location");
String fromDate = request.getParameter("from");
String toDate = request.getParameter("to");
%>

<form action="${pageContext.request.contextPath}/ReportFilterServlet" method="get" class="filter-box row g-3 align-items-center">
    <div class="col-md-3">
        <label>Department:</label>
        <select name="dept_id" class="form-select">
            <option value="">All</option>
            <%
            try(Connection con = IcmsConnection.getConnection();
                PreparedStatement ps = con.prepareStatement("SELECT id_dept_tb, deptName FROM dept_tb");
                ResultSet rsDept = ps.executeQuery()) {
                while(rsDept.next()) {
                    String idDept = String.valueOf(rsDept.getInt("id_dept_tb"));
                    String deptName = rsDept.getString("deptName");
                    String selected = idDept.equals(selectedDept) ? "selected" : "";
            %>
                <option value="<%= idDept %>" <%= selected %>><%= deptName %></option>
            <%
                }
            } catch(Exception e){ e.printStackTrace(); }
            %>
        </select>
    </div>

    <div class="col-md-2">
        <label>Status:</label>
        <select name="status" class="form-select">
            <option value="">All</option>
            <option value="Pending" <%= "Pending".equals(selectedStatus) ? "selected" : "" %>>Pending</option>
            <option value="InProgress" <%= "InProgress".equals(selectedStatus) ? "selected" : "" %>>In Progress</option>
            <option value="Solved" <%= "Solved".equals(selectedStatus) ? "selected" : "" %>>Solved</option>
        </select>
    </div>

    <div class="col-md-3">
        <label>Location:</label>
        <input type="text" name="location" class="form-control" placeholder="Enter location" value="<%= enteredLocation != null ? enteredLocation : "" %>">
    </div>

    <div class="col-md-2">
        <label>From:</label>
        <input type="date" name="from" class="form-control" value="<%= fromDate != null ? fromDate : "" %>">
    </div>

    <div class="col-md-2">
        <label>To:</label>
        <input type="date" name="to" class="form-control" value="<%= toDate != null ? toDate : "" %>">
    </div>

    <div class="col-md-12 text-center mt-3">
        <button type="submit" class="btn btn-primary px-4">Filter</button>

        <!-- Updated Excel/PDF download links -->
        <a href="${pageContext.request.contextPath}/ExcelReportServlet?dept_id=<%= selectedDept != null ? selectedDept : "" %>
&status=<%= selectedStatus != null ? selectedStatus : "" %>
&location=<%= enteredLocation != null ? enteredLocation : "" %>
&from=<%= fromDate != null ? fromDate : "" %>
&to=<%= toDate != null ? toDate : "" %>"
   class="btn btn-success px-4">Download Excel</a>

<a href="${pageContext.request.contextPath}/PdfReportServlet?dept_id=<%= selectedDept != null ? selectedDept : "" %>
&status=<%= selectedStatus != null ? selectedStatus : "" %>
&location=<%= enteredLocation != null ? enteredLocation : "" %>
&from=<%= fromDate != null ? fromDate : "" %>
&to=<%= toDate != null ? toDate : "" %>"
   class="btn btn-danger px-4">Download PDF</a>
    </div>
</form>

<div class="container">
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
          <th>Create Date</th>
          <th>Update Date</th>
        </tr>
      </thead>
      <tbody>
<%
List<Map<String, Object>> complaintList = (List<Map<String, Object>>) request.getAttribute("complaintList");

if (complaintList != null) {
    if (!complaintList.isEmpty()) {
        for (Map<String, Object> row : complaintList) {
%>
<tr>
  <td><%= row.get("id") %></td>
  <td><%= row.get("deptName") != null ? row.get("deptName") : "N/A" %></td>
  <td class="text-break" style="max-width:200px;"><%= row.get("description") %></td>
  <td>
    <% String status = (String) row.get("status");
       if ("Pending".equalsIgnoreCase(status)) { %>
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
    <% if ((boolean) row.get("hasMedia")) { %>
      <a href="ViewMediaServlet?id=<%= row.get("id") %>" target="_blank">
        <img src="ViewMediaServlet?id=<%= row.get("id") %>" class="media-preview" alt="Complaint Image">
      </a>
    <% } else { %>
      <span class="no-media">No Media</span>
    <% } %>
  </td>
  <td><%= row.get("username") != null ? row.get("username") : "N/A" %></td>
  <td><%= row.get("location") != null ? row.get("location") : "N/A" %></td>
  <td><%= row.get("date_time") %></td>
  <td><%= row.get("updated") %></td>
</tr>
<%
        }
    } else {
        out.println("<tr><td colspan='9' class='text-muted'>No complaints found for selected filters.</td></tr>");
    }
} else {
    out.println("<tr><td colspan='9' class='text-muted'>Please use the filter to display data.</td></tr>");
}
%>
      </tbody>
    </table>
  </div>
</div>

</body>
</html>
