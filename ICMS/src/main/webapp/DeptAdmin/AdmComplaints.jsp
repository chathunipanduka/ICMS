<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ page import="ICMSpackage.IcmsConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"> <!-- ✅ Key for responsiveness -->
<title>All Complaints</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Optionally add Bootstrap for spinner -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<style>
body {
  background-color: #f7f9fb;
  font-family: "Segoe UI", sans-serif;
}
.container {
  margin: 10px auto;
  background: #fff;
  padding: 15px;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0,0,0,0.1);
}
h2 {
  color: #003366;
  margin-bottom: 25px;
  text-align: center;
}
.table thead th {
  background-color: #003366;
  color: white;
  text-align: center;
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


/* ✅ Mobile-friendly tweaks */
@media (max-width: 768px) {
  .container {
    padding: 10px;
  }
  h2 {
    font-size: 1.4rem;
  }
  .table {
    font-size: 13px;
  }
  th, td {
    padding: 6px !important;
  }
  .media-preview {
    width: 55px;
    height: 55px;
  }
  footer {
    font-size: 12px;
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

  String deptName = "";
  try (Connection con = IcmsConnection.getConnection()) {
      PreparedStatement ps = con.prepareStatement("SELECT dept_name FROM dept_admin_tb WHERE deptAdmUname = ?");
      ps.setString(1, username);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) deptName = rs.getString("dept_name");
  } catch (Exception e) { e.printStackTrace(); }
%>

<div class="container-fluid mt-3">
  <div class="row justify-content-center">
    <div class="col-12 col-md-11">
      <div class="card shadow rounded-3 p-4">
        <h2>📋 All Submitted Complaints</h2>

        <!-- --- FILTERS ADDED: start --- -->
        <form method="post" class="row g-2 mb-4">
          <!-- Department locked to admin's department (read-only as you requested earlier) -->
          <div class="col-md-3">
            <label class="form-label">Department</label>
            <input type="text" name="department" class="form-control" value="<%= deptName %>" readonly>
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
        
        <form method="post" action="${pageContext.request.contextPath}/ComplaintReportServlet">
  <!-- Include all your filter inputs (hidden) to maintain filters in export -->
  <input type="hidden" name="department" value="<%= deptName %>">
  <input type="hidden" name="status" value="<%= request.getParameter("status") != null ? request.getParameter("status") : "" %>">
  <input type="hidden" name="location" value="<%= request.getParameter("location") != null ? request.getParameter("location") : "" %>">
  <input type="hidden" name="fromDate" value="<%= request.getParameter("fromDate") != null ? request.getParameter("fromDate") : "" %>">
  <input type="hidden" name="toDate" value="<%= request.getParameter("toDate") != null ? request.getParameter("toDate") : "" %>">
  <input type="hidden" name="search" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
  
  <button type="submit" name="exportType" value="excel" class="btn btn-success">Export Excel</button>
  <button type="submit" name="exportType" value="pdf" class="btn btn-danger">Export PDF</button>
</form>
<br>
       
        

        <!-- ✅ Responsive table wrapper -->
        <div class="table-responsive">
          <table class="table table-bordered table-hover align-middle text-center">
            <thead>
              <tr>
                <th>ID</th>
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

  // --- FILTERS: read parameters (only added) ---
  String fDepartment = request.getParameter("department"); // will be deptName (readonly) unless user modified querystring
  String fStatus = request.getParameter("status");
  String fLocation = request.getParameter("location");
  String fFromDate = request.getParameter("fromDate");
  String fToDate = request.getParameter("toDate");
  String fSearch = request.getParameter("search");
  // --- end filter parameters ---

  try {
      conn = IcmsConnection.getConnection();

      // Base SQL (kept original join/columns)
      StringBuilder sql = new StringBuilder(
        "SELECT c.id_complaint_tb, c.description, c.status, c.media, c.location, c.date_time, c.updated, " +
        "d.deptName, l.uName AS username " +
        "FROM complaint_tb c " +
        "LEFT JOIN dept_tb d ON c.dept_id = d.id_dept_tb " +
        "LEFT JOIN login_tb l ON c.user_id = l.id_login_tb " +
        "WHERE d.deptName = ? "
      );

      // Append filters WITHOUT changing other logic
      List<Object> bindParams = new ArrayList<Object>();
      bindParams.add(deptName); // original behavior: limit to admin's department

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
          sql.append(" AND (c.id_complaint_tb LIKE ? OR c.description LIKE ? OR l.uName LIKE ? OR c.location LIKE ? ) ");
          String s = "%" + fSearch.trim() + "%";
          bindParams.add(s);
          bindParams.add(s);
          bindParams.add(s);
      }

      sql.append(" ORDER BY c.date_time DESC");

      ps = conn.prepareStatement(sql.toString());

      // bind parameters in order
      for (int i = 0; i < bindParams.size(); i++) {
          Object o = bindParams.get(i);
          if (o instanceof java.sql.Date) {
              ps.setDate(i + 1, (java.sql.Date) o);
          } else {
              ps.setObject(i + 1, o);
          }
      }

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
  <td class="text-start"><%= desc %></td>
  <td>
    <form method="post" action="${pageContext.request.contextPath}/UpdateComplaintStatusServlet" onsubmit="showLoading()">
      <input type="hidden" name="id" value="<%= id %>">
      <select name="status" class="form-select form-select-sm">
        <option value="Pending" <%= "Pending".equalsIgnoreCase(status) ? "selected" : "" %>>Pending</option>
        <option value="InProgress" <%= "InProgress".equalsIgnoreCase(status) ? "selected" : "" %>>In Progress</option>
        <option value="Solved" <%= "Solved".equalsIgnoreCase(status) ? "selected" : "" %>>Solved</option>
      </select>
  </td>
  <td>
    <%
    // --- IMAGE LOGIC KEPT EXACTLY AS ORIGINAL (no change) ---
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
    // --- end original image logic ---
%>
  </td>
  <td><%= user_name != null ? user_name : "N/A" %></td>
  <td><%= location != null ? location : "N/A" %></td>
  <td><%= dateTime %></td>
  <td><%= updatedTime != null ? updatedTime : "-" %></td>
  <td><button type="submit" class="btn btn-sm btn-primary mt-1">Update</button></form></td>
</tr>
<%
      }
  } catch (Exception e) { e.printStackTrace(); } 
  finally {
      try { if (rs != null) rs.close(); } catch (Exception ignored) {}
      try { if (ps != null) ps.close(); } catch (Exception ignored) {}
      try { if (conn != null) conn.close(); } catch (Exception ignored) {}
  }
%>
            </tbody>
          </table>
        </div> <!-- /table-responsive -->
      </div>
    </div>
  </div>
</div>


<!-- Loading overlay -->
<div id="loadingOverlay" style="
  display:none;
  position:fixed;
  top:0;
  left:0;
  width:100%;
  height:100%;
  background:rgba(255,255,255,0.8);
  z-index:9999;
  text-align:center;
  padding-top:200px;
  font-size:20px;
  color:#333;
">
  <div class="spinner-border text-primary" role="status"></div>
  <p>Sending email... Please wait.</p>
</div>

<script>
function showLoading() {
  document.getElementById('loadingOverlay').style.display = 'block';
}
</script>


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
<!-- Bootstrap JS Bundle (includes Popper) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Your custom JS -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const mediaModal = document.getElementById('mediaModal');
    const mediaContainer = document.getElementById('mediaContainer');
    const contextPath = '<%= request.getContextPath() %>';

    // Listen for modal show
    mediaModal.addEventListener('show.bs.modal', function (event) {
        const triggerImg = event.relatedTarget; // The clicked image
        if (!triggerImg) return;

        const complaintId = triggerImg.getAttribute('data-complaint');

        mediaContainer.innerHTML = "<p class='text-muted'>Loading images...</p>";

        fetch(contextPath + '/GetComplaintImagesServlet?complaintId=' + complaintId)
            .then(response => response.text())
            .then(html => {
                mediaContainer.innerHTML = html;
            })
            .catch(err => {
                console.error('Image load error:', err);
                mediaContainer.innerHTML = "<p class='text-danger'>Failed to load images.</p>";
            });
    });
});
</script>

<script>
function exportPageToPDF() {
    const { jsPDF } = window.jspdf;
    const element = document.body; // Or a specific container e.g. document.querySelector('.container-fluid')
    const doc = new jsPDF('p', 'pt', 'a4'); // portrait, A3 page

    html2canvas(element, { scale: 2, useCORS: true }).then(canvas => {
        const imgData = canvas.toDataURL('image/png');

        const pdfWidth = doc.internal.pageSize.getWidth();
        const pdfHeight = doc.internal.pageSize.getHeight();

        const imgProps = doc.getImageProperties(imgData);
        const imgHeight = (imgProps.height * pdfWidth) / imgProps.width;

        let heightLeft = imgHeight;
        let position = 0;

        // Add first page
        doc.addImage(imgData, 'PNG', 0, position, pdfWidth, imgHeight);
        heightLeft -= pdfHeight;

        // Add remaining pages
        while (heightLeft > 0) {
            position = heightLeft - imgHeight;
            doc.addPage();
            doc.addImage(imgData, 'PNG', 0, position, pdfWidth, imgHeight);
            heightLeft -= pdfHeight;
        }

        // ✅ Add timestamp to filename
        doc.save(`Complaint_Report.pdf`);
    });
}
</script>






<!-- Footer -->
<footer class="text-light pt-4" style="background-color: #00274d; width: 99.5%; padding:15px;">
  <div class="container1">
    <div class="row text-center text-md-start">
      <!-- About Section -->
      <div class="col-md-4 mb-3">
        <h5>Biyagama Pradeshiya Sabha</h5>
        <p>Providing efficient infrastructure complaint management and citizen services for a better community.</p>
      </div>

      <!-- Quick Links -->
      <div class="col-md-4 mb-3">
        <h5>Quick Links</h5>
        <ul class="list-unstyled">
          <li><a href="Home.jsp" class="text-light text-decoration-none">Home</a></li>
          <li><a href="Login.jsp" class="text-light text-decoration-none">Submit Complaint</a></li>
          <li><a href="about.jsp" class="text-light text-decoration-none">About Us</a></li>
        </ul>
      </div>

      <!-- Contact Info -->
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
