<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ page import="ICMSpackage.IcmsConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>All Complaints</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { background-color: #f7f9fb; font-family: "Segoe UI", sans-serif; }
.container { margin-top: 10px; margin-right:10px; margin-left:10px; background: #fff; padding: 10px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1);}
h2 { color: #003366; margin-bottom: 25px; text-align: center;}
table { font-size: 15px; }
th { background-color: #003366; color: white; }
.media-preview { width: 80px; height: 80px; border-radius: 8px; object-fit: cover; transition: transform 0.2s, box-shadow 0.2s; cursor: pointer;}
.media-preview:hover { transform: scale(1.05); box-shadow: 0 0 6px rgba(0,0,0,0.3);}
.no-media { color: #999; font-size: 13px;}
.status { font-weight: bold; }
.status.pending { color: #e69500; }
.status.resolved { color: #28a745; }
.status.rejected { color: #dc3545; }
footer { bottom: 0; left: 0; width: 100%; background-color: #00274d; text-align: center; padding: 15px; font-size: 14px; color: #ffffff; box-shadow: 0 -2px 5px rgba(0,0,0,0.1);}
</style>
</head>
<body>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) { response.sendRedirect(request.getContextPath() + "/Login.jsp"); return; }

    String deptName = "";
    try {
        Connection con = IcmsConnection.getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT dept_name FROM dept_admin_tb WHERE deptAdmUname = ?");
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) deptName = rs.getString("dept_name");
        rs.close(); ps.close(); con.close();
    } catch (Exception e) { e.printStackTrace(); }
%>

<div class="container-fluid mt-3">
  <div class="row justify-content-center">
    <div class="col-lg-12 col-md-11 col-sm-12"> <!-- adjust width here -->
      <div class="card shadow rounded-3 p-4">
    <h2>📋 All Submitted Complaints</h2>

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
    <td><%= desc %></td>
    <td>
        <form method="post" action="${pageContext.request.contextPath}/UpdateComplaintStatusServlet" >
            <input type="hidden" name="id" value="<%= id %>">
            <select name="status" class="form-select form-select-sm">
                <option style="color: yellow;" value="Pending" <%= "Pending".equalsIgnoreCase(status) ? "selected" : "" %>>Pending</option>
                <option style="color: blue;" value="Resolved" <%= "InProgress".equalsIgnoreCase(status) ? "selected" : "" %>>In Progress</option>
                <option style="color: green;" value="Rejected" <%= "Solved".equalsIgnoreCase(status) ? "selected" : "" %>>Solved</option>
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
    <td>
            <button type="submit" class="btn btn-sm btn-primary mt-1">Update</button>
        </form>
    </td>
</tr>
<%
    } // while
} catch (Exception e) { e.printStackTrace(); } 
finally { try { if(rs!=null) rs.close(); } catch(Exception ignored){} try{if(ps!=null) ps.close();} catch(Exception ignored){} try{if(conn!=null) conn.close();} catch(Exception ignored){}}
%>
        </tbody>
    </table>
</div>
</div>
</div>
</div>
<br>

<footer>
    Biyagama Pradeshiya Sabha<br> Contact: +94 123456789<br>
    Email: biyagamapradehsiyasabha@gmail.com
</footer>
</body>
</html>
