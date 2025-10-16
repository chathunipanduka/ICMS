<%@ page import="java.sql.*, java.util.*, ICMSpackage.IcmsConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Super Admin Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
    body {
        background-color: #f8f9fa;
    }
    .card {
        border-radius: 15px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        transition: transform 0.2s;
    }
    .card:hover {
        transform: translateY(-5px);
    }
    .status-count {
        font-size: 1.1rem;
        font-weight: 600;
    }
</style>
</head>
<body>

<div class="container mt-5">

    <h2 class="text-center mb-5 fw-bold text-primary">Super Admin Dashboard Overview</h2>

    <%
        Connection con = null;
        PreparedStatement psDept = null, psCount = null, psSummary = null;
        ResultSet rsDept = null, rsCount = null, rsSummary = null;

        List<String> deptNames = new ArrayList<>();
        List<Integer> deptTotals = new ArrayList<>();

        // For card data
        List<Map<String, Object>> deptData = new ArrayList<>();

        int totalPending = 0, totalInProgress = 0, totalSolved = 0;

        try {
            con = IcmsConnection.getConnection();

            // ✅ 1. Get total counts by status
            psSummary = con.prepareStatement(
                "SELECT " +
                "SUM(CASE WHEN status='Pending' THEN 1 ELSE 0 END) AS pending, " +
                "SUM(CASE WHEN status='InProgress' THEN 1 ELSE 0 END) AS inProgress, " +
                "SUM(CASE WHEN status='Solved' THEN 1 ELSE 0 END) AS solved " +
                "FROM complaint_tb"
            );
            rsSummary = psSummary.executeQuery();
            if (rsSummary.next()) {
                totalPending = rsSummary.getInt("pending");
                totalInProgress = rsSummary.getInt("inProgress");
                totalSolved = rsSummary.getInt("solved");
            }

            // ✅ 2. Get department-wise totals and store in list
            psDept = con.prepareStatement("SELECT * FROM dept_tb");
            rsDept = psDept.executeQuery();

            while (rsDept.next()) {
                int deptId = rsDept.getInt("id_dept_tb");
                String deptName = rsDept.getString("deptName");

                psCount = con.prepareStatement(
                    "SELECT " +
                    "SUM(CASE WHEN status='Pending' THEN 1 ELSE 0 END) AS pending, " +
                    "SUM(CASE WHEN status='InProgress' THEN 1 ELSE 0 END) AS inProgress, " +
                    "SUM(CASE WHEN status='Solved' THEN 1 ELSE 0 END) AS solved, " +
                    "COUNT(*) AS total " +
                    "FROM complaint_tb WHERE dept_id=?"
                );
                psCount.setInt(1, deptId);
                rsCount = psCount.executeQuery();

                int pending = 0, inProgress = 0, solved = 0, total = 0;
                if (rsCount.next()) {
                    pending = rsCount.getInt("pending");
                    inProgress = rsCount.getInt("inProgress");
                    solved = rsCount.getInt("solved");
                    total = rsCount.getInt("total");
                }

                deptNames.add(deptName);
                deptTotals.add(total);

                Map<String, Object> deptMap = new HashMap<>();
                deptMap.put("id", deptId);
                deptMap.put("name", deptName);
                deptMap.put("pending", pending);
                deptMap.put("inProgress", inProgress);
                deptMap.put("solved", solved);
                deptMap.put("total", total);

                deptData.add(deptMap);
            }
    %>
    
    <!-- ✅ Department Cards -->
    <div class="row gy-4">
        <%
            for (Map<String, Object> dept : deptData) {
                int deptId = (Integer) dept.get("id");
                String deptName = (String) dept.get("name");
                int pending = (Integer) dept.get("pending");
                int inProgress = (Integer) dept.get("inProgress");
                int solved = (Integer) dept.get("solved");
                int total = (Integer) dept.get("total");
        %>

        <div class="col-md-4">
            <div class="card border-0 p-3">
                <div class="card-body text-center">
                    <h4 class="card-title text-primary"><%= deptName %></h4>
                    <hr>
                    <p class="status-count text-warning">Pending: <%= pending %></p>
                    <p class="status-count text-info">In Progress: <%= inProgress %></p>
                    <p class="status-count text-success">Solved: <%= solved %></p>
                    <p class="status-count text-secondary">Total: <%= total %></p>
                    <a href="ViewDeptComplaints.jsp?deptId=<%= deptId %>" class="btn btn-primary mt-3">View Complaints</a>
                </div>
            </div>
        </div>

        <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rsDept != null) rsDept.close();
                if (rsCount != null) rsCount.close();
                if (rsSummary != null) rsSummary.close();
                if (psDept != null) psDept.close();
                if (psCount != null) psCount.close();
                if (psSummary != null) psSummary.close();
                if (con != null) con.close();
            } catch (Exception ex) { ex.printStackTrace(); }
        }
    %>
    </div>
    <br>
    <br>
    <br>
    


    <!-- ✅ Charts Section -->
    <div class="row mb-5">
        <!-- Department Wise Bar Chart -->
        <div class="col-md-6">
            <div class="card p-3">
                <h5 class="text-center text-primary">Department-wise Complaint Count</h5>
                <canvas id="deptBarChart"></canvas>
            </div>
        </div>

        <!-- Status Wise Bar Chart -->
        <div class="col-md-6">
            <div class="card p-3">
                <h5 class="text-center text-primary">Complaint Status Summary</h5>
                <canvas id="statusBarChart"></canvas>
            </div>
        </div>
    </div>
    

    

<!-- ✅ Chart.js Scripts -->
<script>
    // Department-wise chart
    const deptLabels = <%= deptNames.toString().replace("[", "['").replace("]", "']").replaceAll(", ", "', '") %>;
    const deptCounts = <%= deptTotals.toString() %>;

    new Chart(document.getElementById('deptBarChart').getContext('2d'), {
        type: 'bar',
        data: {
            labels: deptLabels,
            datasets: [{
                label: 'Complaints per Department',
                data: deptCounts,
                backgroundColor: '#0d6efd'
            }]
        },
        options: {
            responsive: true,
            scales: { y: { beginAtZero: true } }
        }
    });

    // Status-wise chart
    new Chart(document.getElementById('statusBarChart').getContext('2d'), {
        type: 'bar',
        data: {
            labels: ['Pending', 'In Progress', 'Solved'],
            datasets: [{
                label: 'Total Complaints by Status',
                data: [<%= totalPending %>, <%= totalInProgress %>, <%= totalSolved %>],
                backgroundColor: ['#ffc107', '#17a2b8', '#28a745']
            }]
        },
        options: {
            responsive: true,
            scales: { y: { beginAtZero: true } }
        }
    });
</script>

</body>
</html>
