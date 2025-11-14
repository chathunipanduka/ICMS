<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ page import="ICMSpackage.IcmsConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>All Complaints - Super Admin</title>

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

<style>
body {
  background-color: #f7f9fb;
  font-family: "Segoe UI", sans-serif;
}

.container {
  margin-top: 40px;
  background: #fff;
  padding: 25px;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0,0,0,0.1);
}

/* Table styling */
table {
  font-size: 15px;
  vertical-align: middle;
}
th {
  background-color: #003366;
  color: #fff;
}
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
.no-media {
  color: #999;
  font-size: 13px;
}

/* Inline edit styles */
.editable {
  cursor: pointer;
  transition: background-color 0.2s;
}
.editable:hover {
  background-color: #fff3cd !important;
}
.edit-input {
  width: 100%;
  border: 2px solid #007bff;
  border-radius: 4px;
  padding: 4px 8px;
  font-size: 14px;
}
.edit-textarea {
  width: 100%;
  border: 2px solid #007bff;
  border-radius: 4px;
  padding: 4px 8px;
  font-size: 14px;
  resize: vertical;
  min-height: 80px;
}

/* Footer styling */
footer {
  background-color: #00274d;
  color: #fff;
  text-align: center;
  padding: 15px;
  font-size: 14px;
  margin-top: 40px;
}

/* ✅ Responsive adjustments */
@media (max-width: 992px) {
  .container {
    margin-top: 20px;
    padding: 15px;
  }
  table {
    font-size: 14px;
  }
  .media-preview {
    width: 60px;
    height: 60px;
  }
  h2 {
    font-size: 20px;
  }
}

@media (max-width: 768px) {
  .table-responsive {
    border: none;
  }
  table th, table td {
    white-space: nowrap;
  }
}

@media (max-width: 576px) {
  .container {
    padding: 10px;
  }
  footer {
    font-size: 13px;
    padding: 10px;
  }
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
%>

<div class="container">
  <h2 class="text-center mb-4">📋 All Submitted Complaints</h2>
  
  <!-- Display success/error messages -->
  <% 
  String success = request.getParameter("success");
  String error = request.getParameter("error");
  if (success != null) { 
  %>
      <div class="alert alert-success alert-dismissible fade show" role="alert">
          ✅ <%= success %>
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
  <% } %>
  <% if (error != null) { %>
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
          ❌ <%= error %>
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
  <% } %>
  
  <!-- --- FILTERS ADDED: start --- -->
  <form method="get" class="row g-2 mb-4">
    <div class="col-md-3">
      <label class="form-label">Department</label>
      <select name="department" class="form-select form-select-sm">
        <option value="">All</option>
        <%
          try (Connection dcon = IcmsConnection.getConnection()) {
              PreparedStatement dps = dcon.prepareStatement("SELECT deptName FROM dept_tb");
              ResultSet drs = dps.executeQuery();
              while (drs.next()) {
                  String dep = drs.getString("deptName");
                  String sel = dep.equals(request.getParameter("department")) ? "selected" : "";
        %>
                  <option value="<%= dep %>" <%= sel %>><%= dep %></option>
        <%
              }
              drs.close();
              dps.close();
          } catch (Exception e) { }
        %>
      </select>
    </div>

    <div class="col-md-2">
      <label class="form-label">Status</label>
      <select name="status" class="form-select form-select-sm">
        <option value="">All</option>
        <option value="Pending" <%= "Pending".equalsIgnoreCase(request.getParameter("status")) ? "selected" : "" %>>Pending</option>
        <option value="InProgress" <%= "InProgress".equalsIgnoreCase(request.getParameter("status")) ? "selected" : "" %>>In Progress</option>
        <option value="Solved" <%= "Solved".equalsIgnoreCase(request.getParameter("status")) ? "selected" : "" %>>Solved</option>
      </select>
    </div>

    <div class="col-md-2">
      <label class="form-label">Location</label>
      <input type="text" name="location" class="form-control form-control-sm" placeholder="Location"
             value="<%= request.getParameter("location") != null ? request.getParameter("location") : "" %>">
    </div>

    <div class="col-md-2">
      <label class="form-label">From</label>
      <input type="date" name="fromDate" class="form-control form-control-sm"
             value="<%= request.getParameter("fromDate") != null ? request.getParameter("fromDate") : "" %>">
    </div>

    <div class="col-md-2">
      <label class="form-label">To</label>
      <input type="date" name="toDate" class="form-control form-control-sm"
             value="<%= request.getParameter("toDate") != null ? request.getParameter("toDate") : "" %>">
    </div>

    <div class="col-md-3 mt-2">
      <label class="form-label">Search</label>
      <input type="text" name="search" class="form-control form-control-sm" placeholder="Keyword or ID"
             value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
    </div>

    <div class="col-md-2 align-self-end">
      <button type="submit" class="btn btn-primary btn-sm w-100">Apply Filters</button>
    </div>
    <div class="col-md-2 align-self-end">
      <a href="<%= request.getRequestURI() %>" class="btn btn-secondary btn-sm w-100">Reset</a>
    </div>
  </form>
  <!-- --- FILTERS ADDED: end --- -->
  
  <!-- Export Buttons -->
  <div class="d-flex gap-2 mb-3">
    <form method="post" action="${pageContext.request.contextPath}/SupAdmComplaintReportServlet" class="d-inline">
      <input type="hidden" name="department" value="<%= request.getParameter("department") != null ? request.getParameter("department") : "" %>">
      <input type="hidden" name="status" value="<%= request.getParameter("status") != null ? request.getParameter("status") : "" %>">
      <input type="hidden" name="location" value="<%= request.getParameter("location") != null ? request.getParameter("location") : "" %>">
      <input type="hidden" name="fromDate" value="<%= request.getParameter("fromDate") != null ? request.getParameter("fromDate") : "" %>">
      <input type="hidden" name="toDate" value="<%= request.getParameter("toDate") != null ? request.getParameter("toDate") : "" %>">
      <input type="hidden" name="search" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
      
      <button type="submit" name="exportType" value="excel" class="btn btn-success">📊 Export Excel</button>
      <button type="submit" name="exportType" value="pdf" class="btn btn-danger">📄 Export PDF</button>
    </form>
  </div>
<br>
  
  <!-- ✅ Responsive table wrapper -->
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
          <th>Date/Time</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
<%
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

// filter params
String fDepartment = request.getParameter("department");
String fStatus = request.getParameter("status");
String fLocation = request.getParameter("location");
String fFromDate = request.getParameter("fromDate");
String fToDate = request.getParameter("toDate");
String fSearch = request.getParameter("search");


try {
    conn = IcmsConnection.getConnection();

    StringBuilder sql = new StringBuilder(
        "SELECT c.id_complaint_tb, c.description, c.status, c.media, c.location, c.date_time, " +
        "d.deptName, l.uName AS username " +
        "FROM complaint_tb c " +
        "LEFT JOIN dept_tb d ON c.dept_id = d.id_dept_tb " +
        "LEFT JOIN login_tb l ON c.user_id = l.id_login_tb " +
        "WHERE 1=1 "
    );

    List<Object> bindParams = new ArrayList<Object>();

    if (fDepartment != null && !fDepartment.trim().isEmpty()) {
        sql.append(" AND d.deptName = ? ");
        bindParams.add(fDepartment.trim());
    }

    if (fStatus != null && !fStatus.trim().isEmpty()) {
        sql.append(" AND c.status = ? ");
        bindParams.add(fStatus.trim());
    }

    if (fLocation != null && !fLocation.trim().isEmpty()) {
        sql.append(" AND c.location LIKE ? ");
        bindParams.add("%" + fLocation.trim() + "%");
    }

    if (fFromDate != null && !fFromDate.trim().isEmpty()) {
        sql.append(" AND DATE(c.date_time) >= ? ");
        bindParams.add(java.sql.Date.valueOf(fFromDate.trim()));
    }

    if (fToDate != null && !fToDate.trim().isEmpty()) {
        sql.append(" AND DATE(c.date_time) <= ? ");
        bindParams.add(java.sql.Date.valueOf(fToDate.trim()));
    }

    if (fSearch != null && !fSearch.trim().isEmpty()) {
        sql.append(" AND (c.id_complaint_tb LIKE ? OR c.description LIKE ? OR l.uName LIKE ?) ");
        String s = "%" + fSearch.trim() + "%";
        bindParams.add(s);
        bindParams.add(s);
        bindParams.add(s);
    }

    sql.append(" ORDER BY c.date_time DESC");

    ps = conn.prepareStatement(sql.toString());

    for (int i = 0; i < bindParams.size(); i++) {
        Object o = bindParams.get(i);
        if (o instanceof java.sql.Date) {
            ps.setDate(i + 1, (java.sql.Date) o);
        } else {
            ps.setObject(i + 1, o);
        }
    }

    rs = ps.executeQuery();

    boolean hasData = false;
    while (rs.next()) {
        hasData = true;
        int id = rs.getInt("id_complaint_tb");
        String dept_Name = rs.getString("deptName");
        String desc = rs.getString("description");
        String status = rs.getString("status");
        String location = rs.getString("location");
        String user_name = rs.getString("username");
        Timestamp dateTime = rs.getTimestamp("date_time");
%>
<tr>
  <td><%= id %></td>
  <td><%= dept_Name != null ? dept_Name : "N/A" %></td>
  
  <!-- Editable Description -->
  <td>
    <form method="post" action="${pageContext.request.contextPath}/SupAdmInlineEditComplaintServlet" class="d-inline">
      <input type="hidden" name="id" value="<%= id %>">
      <textarea name="description" class="form-control form-control-sm" rows="3" 
                style="font-size: 14px; min-height: 80px;"><%= desc %></textarea>
  </td>
  
  <!-- Editable Status -->
  <td>
      <select name="status" class="form-select form-select-sm" style="font-size: 14px;">
        <option value="Pending" <%= "Pending".equals(status) ? "selected" : "" %>>Pending</option>
        <option value="InProgress" <%= "InProgress".equals(status) ? "selected" : "" %>>In Progress</option>
        <option value="Solved" <%= "Solved".equals(status) ? "selected" : "" %>>Solved</option>
      </select>
  </td>
  
  <td>
    <%
    PreparedStatement psMedia = conn.prepareStatement(
        "SELECT id_media FROM complaint_media_tb WHERE complaint_id = ? LIMIT 1");
    psMedia.setInt(1, id);
    ResultSet rsMedia = psMedia.executeQuery();

    if (rsMedia.next()) {
        int firstMediaId = rsMedia.getInt("id_media");
    %>
        <img src="${pageContext.request.contextPath}/ViewMediaServlet?mediaId=<%= firstMediaId %>" 
             class="media-preview" 
             alt="Complaint Image"
             data-bs-toggle="modal" 
             data-bs-target="#mediaModal" 
             data-complaint="<%= id %>">
    <%
    } else {
    %>
        <span class="no-media">No Media</span>
    <%
    }
    rsMedia.close();
    psMedia.close();
    %>
  </td>
  
  <td><%= user_name != null ? user_name : "N/A" %></td>
  
  <!-- Editable Location -->
  <td>
      <input type="text" name="location" class="form-control form-control-sm" 
             value="<%= location != null ? location : "" %>" 
             style="font-size: 14px;">
  </td>
  
  <td><%= dateTime %></td>
  <td>
    <div class="btn-group-vertical" role="group" style="min-width: 120px;">
      <button type="submit" class="btn btn-sm btn-success mb-1">
        💾 Save
      </button>
      </form>
      
      <a href="${pageContext.request.contextPath}/SupAdmDeleteComplaintServlet?id=<%= id %>"
         class="btn btn-sm btn-danger"
         onclick="return confirm('Are you sure you want to delete complaint #<%= id %>?');">
        🗑️ Delete
      </a>
    </div>
  </td>
</tr>
<%
    }

    if (!hasData) {
%>
<tr><td colspan="9" class="text-muted">No complaints found for the selected filters.</td></tr>
<%
    }
} catch (Exception e) {
    out.println("<tr><td colspan='9' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
    e.printStackTrace();
} finally {
    try { if (rs != null) rs.close(); } catch (Exception ignored) {}
    try { if (ps != null) ps.close(); } catch (Exception ignored) {}
    try { if (conn != null) conn.close(); } catch (Exception ignored) {}
}
%>
      </tbody>
    </table>
  </div>
</div>

<!-- 📸 Modal to View All Images -->
<div class="modal fade" id="mediaModal" tabindex="-1" aria-labelledby="mediaModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="mediaModalLabel">Complaint Images</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body text-center" id="mediaContainer">
        <p class="text-muted">Loading images...</p>
      </div>
    </div>
  </div>
</div>

<!-- Bootstrap JS (with Popper) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
let editingRowId = null;

function enableEdit(rowId, field, element) {
    console.log('Enabling edit for row:', rowId, 'field:', field);
    
    if (editingRowId && editingRowId !== rowId) {
        cancelEdit(editingRowId);
    }
    
    editingRowId = rowId;
    
    const displayElement = document.getElementById(field + '-' + rowId);
    const editElement = document.getElementById('edit-' + field + '-' + rowId);
    
    if (displayElement && editElement) {
        displayElement.classList.add('d-none');
        editElement.classList.remove('d-none');
        editElement.focus();
    }
}

function cancelEdit(rowId) {
    console.log('Canceling edit for row:', rowId);
    const fields = ['description', 'status', 'location'];
    fields.forEach(field => {
        const displayElement = document.getElementById(field + '-' + rowId);
        const editElement = document.getElementById('edit-' + field + '-' + rowId);
        
        if (displayElement && editElement) {
            // Reset edit fields to original values
            if (field === 'description') {
                editElement.value = displayElement.textContent;
            } else if (field === 'location') {
                editElement.value = displayElement.textContent === 'N/A' ? '' : displayElement.textContent;
            }
            
            displayElement.classList.remove('d-none');
            editElement.classList.add('d-none');
        }
    });
    editingRowId = null;
}

function saveAllChanges(rowId) {
    console.log('=== SAVE ATTEMPT STARTED ===');
    console.log('Row ID:', rowId);
    
    // Get current values from edit fields
    const description = document.getElementById('edit-description-' + rowId)?.value || '';
    const status = document.getElementById('edit-status-' + rowId)?.value || '';
    const location = document.getElementById('edit-location-' + rowId)?.value || '';
    
    console.log('Values to save:');
    console.log('- Description:', description);
    console.log('- Status:', status);
    console.log('- Location:', location);
    
    // Validate data
    if (!description.trim()) {
        showMessage('❌ Description cannot be empty', 'danger');
        return;
    }
    
    if (!status) {
        showMessage('❌ Status cannot be empty', 'danger');
        return;
    }
    
    // Create form data
    const formData = new FormData();
    formData.append('id', rowId.toString());
    formData.append('description', description.trim());
    formData.append('status', status);
    formData.append('location', location.trim());
    
    // Show loading state
    const saveBtn = document.querySelector(`button[onclick="saveAllChanges(${rowId})"]`);
    const originalText = saveBtn.innerHTML;
    saveBtn.innerHTML = '⏳ Saving...';
    saveBtn.disabled = true;
    
    // Get context path
    const contextPath = '${pageContext.request.contextPath}';
    const url = contextPath + '/SupAdmInlineEditComplaintServlet';
    
    console.log('Sending POST request to:', url);
    
    // Send AJAX request
    fetch(url, {
        method: 'POST',
        body: formData
    })
    .then(response => {
        console.log('Response status:', response.status, response.statusText);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        console.log('Response data received:', data);
        
        // Restore button state
        saveBtn.innerHTML = originalText;
        saveBtn.disabled = false;
        
        if (data.success) {
            showMessage('✅ ' + data.message, 'success');
            
            // Update display with new values
            updateDisplayValues(rowId, description, status, location);
            
            // Exit edit mode
            cancelEdit(rowId);
            
            console.log('=== SAVE SUCCESSFUL ===');
        } else {
            showMessage('❌ ' + data.message, 'danger');
            console.error('Save failed:', data.message);
        }
    })
    .catch(error => {
        console.error('Fetch error:', error);
        
        // Restore button state
        saveBtn.innerHTML = originalText;
        saveBtn.disabled = false;
        
        showMessage('❌ Network error: ' + error.message, 'danger');
    });
}

function updateDisplayValues(rowId, description, status, location) {
    // Update description
    const descDisplay = document.getElementById('description-' + rowId);
    if (descDisplay) {
        descDisplay.textContent = description;
    }
    
    // Update location
    const locDisplay = document.getElementById('location-' + rowId);
    if (locDisplay) {
        locDisplay.textContent = location || 'N/A';
    }
    
    // Update status badge
    updateStatusBadge(rowId, status);
}

function updateStatusBadge(rowId, status) {
    let badgeClass = 'badge bg-secondary';
    let badgeText = 'Unknown';
    
    if (status === 'Pending') {
        badgeClass = 'badge bg-warning text-dark';
        badgeText = 'Pending';
    } else if (status === 'InProgress') {
        badgeClass = 'badge bg-info text-dark';
        badgeText = 'In Progress';
    } else if (status === 'Solved') {
        badgeClass = 'badge bg-success';
        badgeText = 'Solved';
    }
    
    const statusElement = document.getElementById('status-' + rowId);
    if (statusElement) {
        statusElement.innerHTML = `<span class="${badgeClass}">${badgeText}</span>`;
    }
}

function showMessage(message, type) {
    // Remove existing alerts
    const existingAlerts = document.querySelectorAll('.alert');
    existingAlerts.forEach(alert => alert.remove());
    
    // Create new alert
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `;
    
    // Insert after the h2
    const h2 = document.querySelector('h2');
    if (h2 && h2.parentNode) {
        h2.parentNode.insertBefore(alertDiv, h2.nextSibling);
    }
}

// Add keyboard support
document.addEventListener('DOMContentLoaded', function() {
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && editingRowId) {
            cancelEdit(editingRowId);
        }
    });
});
</script>

<!-- Footer -->
<footer class="text-light pt-4" style="background-color: #00274d; width: 99.5%; padding:15px;">
  <div class="container1">
    <div class="row text-center text-md-start">
      <div class="col-md-4 mb-3">
        <h5>Biyagama Pradeshiya Sabha</h5>
        <p>Providing efficient infrastructure complaint management and citizen services for a better community.</p>
      </div>
      <div class="col-md-4 mb-3">
        <h5>Quick Links</h5>
        <ul class="list-unstyled">
          <li><a href="Home.jsp" class="text-light text-decoration-none">Home</a></li>
          <li><a href="Login.jsp" class="text-light text-decoration-none">Submit Complaint</a></li>
          <li><a href="about.jsp" class="text-light text-decoration-none">About Us</a></li>
        </ul>
      </div>
      <div class="col-md-4 mb-3">
        <h5>Contact Us</h5>
        <p>Email: info@biyagama.ps.lk</p>
        <p>Phone: +94 11 234 5678</p>
        <p>Address: Biyagama Pradeshiya Sabha, <br>Biyagama, Sri Lanka</p>
      </div>
    </div>

    <hr class="bg-light">

    <div class="text-center pb-3">
      &copy; 2025 Biyagama Pradeshiya Sabha. All rights reserved.
    </div>
  </div>
</footer>
</body>
</html>