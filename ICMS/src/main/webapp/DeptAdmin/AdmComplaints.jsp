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
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
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

/* Report Modal Styles */
.complaint-report {
    font-size: 14px;
}
.complaint-report .card {
    border: 1px solid #dee2e6;
    border-radius: 8px;
}
.complaint-report .card-header {
    font-weight: 600;
    border-bottom: 1px solid #dee2e6;
}
.complaint-report p {
    margin-bottom: 8px;
}

/* Print Styles */
@media print {
    .btn, .no-print {
        display: none !important;
    }
    .complaint-report {
        font-size: 12px !important;
    }
}


/* Report Image Styles */
.report-image {
    max-width: 100%;
    height: 150px;
    object-fit: cover;
    border: 1px solid #ddd;
    border-radius: 4px;
    transition: transform 0.2s;
}

.report-image:hover {
    transform: scale(1.05);
}

/* PDF Export Styles */
@media print {
    .report-image {
        max-width: 150px !important;
        height: auto !important;
        page-break-inside: avoid;
    }
    .img-thumbnail {
        border: 1px solid #000 !important;
    }
}

/* Loading animation for images */
.image-loading {
    background: #f8f9fa;
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 150px;
}

.image-loading::after {
    content: "Loading image...";
    color: #6c757d;
    font-size: 12px;
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
        <h2 class="text-center mb-5 fw-bold" style="color: #00274d;">All Complaints</h2>

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
        "LEFT JOIN user_tb l ON c.user_id = l.id_login_tb " +
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
  <td><form><button type="submit" class="btn btn-sm btn-primary mt-1">Update</button></form>
  
  <!-- View Report Button -->
  <button class="btn btn-sm btn-info w-100" 
          data-bs-toggle="modal" 
          data-bs-target="#reportModal"
          data-complaint-id="<%= id %>"
          onclick="loadComplaintReport(<%= id %>)">
    Report
  </button>
  </td>
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

<!-- 📊 Individual Complaint Report Modal -->
<div class="modal fade" id="reportModal" tabindex="-1" aria-labelledby="reportModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title" id="reportModalLabel">Complaint Report - #<span id="reportComplaintId"></span></h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body" id="reportContainer">
        <div class="text-center">
          <div class="spinner-border text-primary" role="status"></div>
          <p>Loading report...</p>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" class="btn btn-success" onclick="exportIndividualReport()">
          <i class="bi bi-download"></i> Export PDF
        </button>
        <button type="button" class="btn btn-warning" onclick="printReport()">
          <i class="bi bi-printer"></i> Print
        </button>
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



function loadComplaintReport(complaintId) {
    document.getElementById('reportComplaintId').textContent = complaintId;
    const reportContainer = document.getElementById('reportContainer');
    
    // Show loading spinner
    reportContainer.innerHTML = `
        <div class="text-center py-4">
            <div class="spinner-border text-primary" role="status"></div>
            <p class="mt-2">Loading report with images...</p>
        </div>
    `;
    
    fetch('${pageContext.request.contextPath}/GetComplaintReportServlet?complaintId=' + complaintId)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.text();
        })
        .then(html => {
            reportContainer.innerHTML = html;
            // Preload images for PDF export
            preloadImages(reportContainer);
        })
        .catch(err => {
            console.error('Report load error:', err);
            reportContainer.innerHTML = `
                <div class="alert alert-danger text-center">
                    <i class="bi bi-exclamation-triangle"></i> Failed to load report. Please try again.
                    <br><small>Error: ${err.message}</small>
                </div>
            `;
        });
}

// Preload images to ensure they're available for PDF export
function preloadImages(container) {
    const images = container.getElementsByTagName('img');
    let loadedCount = 0;
    const totalImages = images.length;
    
    if (totalImages === 0) return;
    
    Array.from(images).forEach(img => {
        const originalSrc = img.src;
        const newImg = new Image();
        newImg.onload = function() {
            loadedCount++;
            console.log(`Loaded image ${loadedCount}/${totalImages}`);
            img.src = originalSrc; // Ensure original image is loaded
        };
        newImg.onerror = function() {
            loadedCount++;
            console.log(`Failed to load image ${loadedCount}/${totalImages}`);
            img.alt = 'Failed to load image';
        };
        newImg.src = originalSrc + '&t=' + new Date().getTime(); // Cache busting
    });
}

document.addEventListener('DOMContentLoaded', function() {
    const mediaModal = document.getElementById('mediaModal');
    const mediaContainer = document.getElementById('mediaContainer');
    const contextPath = '<%= request.getContextPath() %>';

    // Listen for modal show
    mediaModal.addEventListener('show.bs.modal', function (event) {
        const triggerImg = event.relatedTarget;
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

// Load individual complaint report
function loadComplaintReport(complaintId) {
    document.getElementById('reportComplaintId').textContent = complaintId;
    const reportContainer = document.getElementById('reportContainer');
    
    // Show loading spinner
    reportContainer.innerHTML = `
        <div class="text-center py-4">
            <div class="spinner-border text-primary" role="status"></div>
            <p class="mt-2">Loading report with images...</p>
        </div>
    `;
    
    // Use proper string concatenation instead of template literals with EL
    var url = '<%= request.getContextPath() %>' + '/GetComplaintReportServlet?complaintId=' + complaintId;
    
    fetch(url)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.text();
        })
        .then(html => {
            reportContainer.innerHTML = html;
            // Preload images for PDF export
            preloadImages(reportContainer);
        })
        .catch(err => {
            console.error('Report load error:', err);
            reportContainer.innerHTML = `
                <div class="alert alert-danger text-center">
                    <i class="bi bi-exclamation-triangle"></i> Failed to load report. Please try again.
                    <br><small>Error: ${err.message}</small>
                </div>
            `;
        });
}

// Preload images to ensure they're available for PDF export
function preloadImages(container) {
    const images = container.getElementsByTagName('img');
    let loadedCount = 0;
    const totalImages = images.length;
    
    if (totalImages === 0) return;
    
    Array.from(images).forEach(img => {
        const originalSrc = img.src;
        const newImg = new Image();
        newImg.onload = function() {
            loadedCount++;
            console.log('Loaded image ' + loadedCount + '/' + totalImages);
            img.src = originalSrc; // Ensure original image is loaded
        };
        newImg.onerror = function() {
            loadedCount++;
            console.log('Failed to load image ' + loadedCount + '/' + totalImages);
            img.alt = 'Failed to load image';
        };
        // Use proper string concatenation
        newImg.src = originalSrc + '&t=' + Date.now(); // Cache busting with Date.now()
    });
}

// Export individual report as PDF with images
function exportIndividualReport() {
    const complaintId = document.getElementById('reportComplaintId').textContent;
    const reportContainer = document.getElementById('reportContainer');
    
    // Check if report content is loaded
    if (!reportContainer.innerHTML || reportContainer.innerHTML.includes('spinner-border')) {
        alert('Please wait for the report to load completely before exporting.');
        return;
    }
    
    // Check if images are loaded
    const images = reportContainer.getElementsByTagName('img');
    let allImagesLoaded = true;
    
    Array.from(images).forEach(img => {
        if (!img.complete || img.naturalHeight === 0) {
            allImagesLoaded = false;
        }
    });
    
    if (!allImagesLoaded) {
        if (!confirm('Some images are still loading. Exporting now may result in missing images. Continue anyway?')) {
            return;
        }
    }
    
    // Show export loading
    const originalHTML = reportContainer.innerHTML;
    reportContainer.innerHTML = `
        <div class="text-center py-4">
            <div class="spinner-border text-success" role="status"></div>
            <p class="mt-2">Generating PDF with images... This may take a moment.</p>
        </div>
    `;
    
    // Restore content for capture
    setTimeout(() => {
        reportContainer.innerHTML = originalHTML;
        
        // Give extra time for images to render
        setTimeout(() => {
            generatePDFWithImages(complaintId, reportContainer);
        }, 1000);
    }, 500);
}

// Generate PDF with images
function generatePDFWithImages(complaintId, reportContainer) {
    const { jsPDF } = window.jspdf;
    
    const options = {
        scale: 2,
        useCORS: true,
        logging: true,
        backgroundColor: '#ffffff',
        onclone: function(clonedDoc) {
            // Ensure all styles are preserved in the clone
            const images = clonedDoc.getElementsByTagName('img');
            Array.from(images).forEach(img => {
                img.style.maxWidth = '100%';
                img.style.height = 'auto';
            });
        }
    };
    
    html2canvas(reportContainer, options).then(canvas => {
        const imgData = canvas.toDataURL('image/png');
        const doc = new jsPDF('p', 'mm', 'a4');
        const pdfWidth = doc.internal.pageSize.getWidth();
        const pdfHeight = doc.internal.pageSize.getHeight();
        
        // Calculate image dimensions to fit page
        const imgWidth = pdfWidth - 20; // 10mm margins on each side
        const imgHeight = (canvas.height * imgWidth) / canvas.width;
        
        // Add header
        doc.setFillColor(0, 51, 102);
        doc.rect(0, 0, pdfWidth, 20, 'F');
        doc.setTextColor(255, 255, 255);
        doc.setFontSize(16);
        doc.setFont(undefined, 'bold');
        doc.text('Complaint Report - #' + complaintId, pdfWidth / 2, 12, { align: 'center' });
        
        // Add content
        doc.setTextColor(0, 0, 0);
        
        let heightLeft = imgHeight;
        let position = 25; // Start below header
        let pageHeight = pdfHeight - 30; // Account for header and footer
        
        // Add first page
        doc.addImage(imgData, 'PNG', 10, position, imgWidth, imgHeight);
        heightLeft -= pageHeight;
        
        // Add remaining pages if content is too long
        while (heightLeft > 0) {
            doc.addPage();
            position = -pageHeight + heightLeft;
            doc.addImage(imgData, 'PNG', 10, position, imgWidth, imgHeight);
            heightLeft -= pageHeight;
        }
        
        // Add footer with page numbers to all pages
        const totalPages = doc.getNumberOfPages();
        for (let i = 1; i <= totalPages; i++) {
            doc.setPage(i);
            doc.setFontSize(8);
            doc.setTextColor(100, 100, 100);
            doc.text('Page ' + i + ' of ' + totalPages, pdfWidth / 2, pdfHeight - 10, { align: 'center' });
            doc.text('Generated on: ' + new Date().toLocaleString(), 10, pdfHeight - 10);
        }
        
        // Save the PDF - use string concatenation instead of template literals
        doc.save('Complaint_Report_' + complaintId + '_' + Date.now() + '.pdf');
        
    }).catch(err => {
        console.error('PDF generation error:', err);
        alert('Error generating PDF: ' + err.message);
        
        // Fallback: export without images
        if (confirm('PDF generation failed. Would you like to export as text instead?')) {
            exportAsText(complaintId, reportContainer);
        }
    });
}

// Fallback text export
function exportAsText(complaintId, reportContainer) {
    const content = reportContainer.innerText;
    const blob = new Blob(['COMPLAINT REPORT #' + complaintId + '\n\n' + content], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'complaint_' + complaintId + '.txt';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}

// Print individual report with images
function printReport() {
    const complaintId = document.getElementById('reportComplaintId').textContent;
    const reportContainer = document.getElementById('reportContainer');
    
    if (!reportContainer.innerHTML || reportContainer.innerHTML.includes('spinner-border')) {
        alert('Please wait for the report to load completely before printing.');
        return;
    }
    
    // Use proper string concatenation
    var printContent = '<!DOCTYPE html>' +
        '<html>' +
        '<head>' +
        '<title>Complaint Report - #' + complaintId + '</title>' +
        '<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">' +
        '<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">' +
        '<style>' +
        'body { padding: 20px; font-family: Arial, sans-serif; }' +
        '.complaint-report { font-size: 14px; }' +
        '.card { border: 1px solid #ddd; margin-bottom: 15px; }' +
        '.card-header { background-color: #f8f9fa !important; font-weight: bold; }' +
        '.report-image { max-width: 200px; height: auto; margin: 5px; }' +
        '.report-header { text-align: center; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid #003366; }' +
        '@media print { ' +
        '.no-print { display: none !important; }' +
        '.btn { display: none !important; }' +
        'body { padding: 0; margin: 0; }' +
        '.card { border: 1px solid #000 !important; page-break-inside: avoid; }' +
        '.report-image { max-width: 150px !important; }' +
        '.row { display: flex; flex-wrap: wrap; }' +
        '}' +
        '@page { margin: 1cm; }' +
        '</style>' +
        '</head>' +
        '<body>' +
        '<div class="report-header">' +
        '<h2>Biyagama Pradeshiya Sabha</h2>' +
        '<h3>Complaint Report - #' + complaintId + '</h3>' +
        '<p>Generated on: ' + new Date().toLocaleString() + '</p>' +
        '</div>' +
        '<div class="complaint-report">' +
        reportContainer.innerHTML +
        '</div>' +
        '</body>' +
        '</html>';
    
    const printWindow = window.open('', '_blank');
    printWindow.document.write(printContent);
    printWindow.document.close();
    
    // Wait for images to load before printing
    printWindow.onload = function() {
        const images = printWindow.document.images;
        let loadedCount = 0;
        const totalImages = images.length;
        
        if (totalImages === 0) {
            printWindow.print();
            return;
        }
        
        Array.from(images).forEach(img => {
            img.onload = function() {
                loadedCount++;
                if (loadedCount === totalImages) {
                    setTimeout(() => {
                        printWindow.print();
                    }, 500);
                }
            };
            img.onerror = function() {
                loadedCount++;
                if (loadedCount === totalImages) {
                    setTimeout(() => {
                        printWindow.print();
                    }, 500);
                }
            };
        });
        
        // Fallback: print after 5 seconds even if some images fail
        setTimeout(() => {
            printWindow.print();
        }, 5000);
    };
}

// Simple page export function (if you have this)
function exportPageToPDF() {
    const { jsPDF } = window.jspdf;
    const element = document.body;
    const doc = new jsPDF('p', 'pt', 'a4');

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

        // Use string concatenation instead of template literal
        doc.save('Complaint_Report_' + Date.now() + '.pdf');
    });
}


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
