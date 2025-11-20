<%@ page import="java.sql.*, ICMSpackage.IcmsConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Edit User - Super Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f7f9fb;
            font-family: "Segoe UI", sans-serif;
        }
        .container {
            margin-top: 40px;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            max-width: 800px;
        }
    </style>
</head>
<body>
<%
String username = (String) session.getAttribute("username");
if (username == null) {
    response.sendRedirect(request.getContextPath() + "/Login.jsp");
    return;
}

String userId = request.getParameter("id");
if (userId == null || userId.trim().isEmpty()) {
    response.sendRedirect("AllUsers.jsp");
    return;
}

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

String firstName = "", lastName = "", email = "", contactNo = "", uName = "";
int isBlocked = 0;

try {
    conn = IcmsConnection.getConnection();
    String sql = "SELECT id_login_tb, firstName, lastName, email, contactNo, uName, isBlocked FROM user_tb WHERE id_login_tb = ?";
    ps = conn.prepareStatement(sql);
    ps.setInt(1, Integer.parseInt(userId));
    rs = ps.executeQuery();
    
    if (rs.next()) {
        firstName = rs.getString("firstName");
        lastName = rs.getString("lastName");
        email = rs.getString("email");
        contactNo = rs.getString("contactNo");
        uName = rs.getString("uName");
        isBlocked = rs.getInt("isBlocked");
    } else {
        response.sendRedirect("AllUsers.jsp?error=User not found");
        return;
    }
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("AllUsers.jsp?error=Database error");
    return;
} finally {
    try { if (rs != null) rs.close(); } catch (Exception ignored) {}
    try { if (ps != null) ps.close(); } catch (Exception ignored) {}
    try { if (conn != null) conn.close(); } catch (Exception ignored) {}
}
%>

<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-person-gear"></i> Edit User</h2>
        <a href="UserManage.jsp" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left"></i> Back to Users
        </a>
    </div>

    <form action="<%= request.getContextPath() %>/UpdateUserServlet" method="post">
        <input type="hidden" name="id" value="<%= userId %>">
        
        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="firstName" class="form-label">First Name *</label>
                <input type="text" class="form-control" id="firstName" name="firstName" 
                       value="<%= firstName %>" required>
            </div>
            
            <div class="col-md-6 mb-3">
                <label for="lastName" class="form-label">Last Name *</label>
                <input type="text" class="form-control" id="lastName" name="lastName" 
                       value="<%= lastName %>" required>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="email" class="form-label">Email *</label>
                <input type="email" class="form-control" id="email" name="email" 
                       value="<%= email %>" required>
            </div>
            
            <div class="col-md-6 mb-3">
                <label for="contactNo" class="form-label">Contact Number</label>
                <input type="tel" class="form-control" id="contactNo" name="contactNo" 
                       value="<%= contactNo != null ? contactNo : "" %>">
            </div>
        </div>

        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="userName" class="form-label">Username</label>
                <input type="text" class="form-control" id="userName" name="userName" 
                       value="<%= uName != null ? uName : "" %>">
            </div>
            
            <div class="col-md-6 mb-3">
                <label for="password" class="form-label">New Password</label>
                <input type="password" class="form-control" id="password" name="password" 
                       placeholder="Leave blank to keep current password">
                <div class="form-text">Enter new password only if you want to change it.</div>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Current Status</label>
            <div>
                <span class="badge <%= isBlocked == 1 ? "bg-danger" : "bg-success" %>">
                    <%= isBlocked == 1 ? "Blocked" : "Active" %>
                </span>
            </div>
            <div class="form-text">
                To block/unblock user, use the actions on the main users page.
            </div>
        </div>

        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
            <a href="AllUsers.jsp" class="btn btn-secondary me-md-2">Cancel</a>
            <button type="submit" class="btn btn-primary">
                <i class="bi bi-check-circle"></i> Update User
            </button>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>