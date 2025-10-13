<%@ page import="java.sql.*, ICMSpackage.IcmsConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    body {
        background-color: #f0f4f8;
    }
    .card {
        border: none;
        border-radius: 15px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        transition: transform 0.2s ease;
    }
    .card:hover {
        transform: scale(1.05);
    }
    .card-title {
        font-size: 1.5rem;
        font-weight: 600;
    }
    .count {
        font-size: 2.5rem;
        font-weight: bold;
        color: #003366;
    }
</style>
</head>
<body>

<div class="container mt-5">
    <h2 class="text-center text-primary mb-4">Department Overview</h2>

    <div class="row g-4 justify-content-center">

        <%
            int deptCount = 0, catCount = 0, adminCount = 0;

            try (Connection con = IcmsConnection.getConnection()) {

                // Department count
                PreparedStatement psDept = con.prepareStatement("SELECT COUNT(*) FROM dept_tb");
                ResultSet rsDept = psDept.executeQuery();
                if (rsDept.next()) deptCount = rsDept.getInt(1);
                rsDept.close();
                psDept.close();

                // Category count
                PreparedStatement psCat = con.prepareStatement("SELECT COUNT(*) FROM category_tb");
                ResultSet rsCat = psCat.executeQuery();
                if (rsCat.next()) catCount = rsCat.getInt(1);
                rsCat.close();
                psCat.close();

                // Admin count
                PreparedStatement psAdmin = con.prepareStatement("SELECT COUNT(*) FROM dept_admin_tb");
                ResultSet rsAdmin = psAdmin.executeQuery();
                if (rsAdmin.next()) adminCount = rsAdmin.getInt(1);
                rsAdmin.close();
                psAdmin.close();

            } catch (Exception e) {
                e.printStackTrace();
            }
        %>

        <!-- Department Card -->
        <div class="col-md-4">
            <div class="card text-center p-4">
                <h5 class="card-title text-secondary">Departments</h5>
                <div class="count"><%= deptCount %></div>
                <a href="AddNewDepartment.jsp" class="btn btn-primary mt-3 w-75">View Departments</a>
            </div>
        </div>

        <!-- Category Card -->
        <div class="col-md-4">
            <div class="card text-center p-4">
                <h5 class="card-title text-secondary">Categories</h5>
                <div class="count"><%= catCount %></div>
                <a href="AddCategory.jsp" class="btn btn-success mt-3 w-75">View Categories</a>
            </div>
        </div>

        <!-- Admin Card -->
        <div class="col-md-4">
            <div class="card text-center p-4">
                <h5 class="card-title text-secondary">Admins</h5>
                <div class="count"><%= adminCount %></div>
                <a href="AddAdmin.jsp" class="btn btn-warning mt-3 w-75">View Admins</a>
            </div>
        </div>

    </div>
</div>

</body>
</html>
