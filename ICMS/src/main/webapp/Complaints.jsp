<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ page import="ICMSpackage.IcmsConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
String username = (String) session.getAttribute("username");
if (username == null) {
	response.sendRedirect(request.getContextPath() + "/Login.jsp");
	return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>My Complaints</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

<style>
/* =======================
   BASE UI
   ======================= */
body {
	background: linear-gradient(135deg, #f4f7fb, #eef2f7);
	font-family: "Segoe UI", sans-serif;
	margin-top: 20px;
}

/* Card container */
.page-card {
	background: #ffffff;
	border-radius: 16px;
	padding: 20px;
	box-shadow: 0 15px 40px rgba(0,0,0,0.08);
}

/* Title */
h2 {
	color: #00274d;
	font-weight: 700;
	letter-spacing: 0.5px;
}

/* =======================
   TABLE UX
   ======================= */
.table {
	font-size: 15px;
	border-collapse: separate;
	border-spacing: 0 10px;
}

thead th {
	background: #00274d;
	color: #fff;
	border: none;
	padding: 14px;
}

tbody tr {
	background: #ffffff;
	box-shadow: 0 6px 14px rgba(0,0,0,0.06);
	border-radius: 12px;
	transition: transform 0.15s ease;
}

tbody tr:hover {
	transform: translateY(-3px);
}

td {
	border: none;
	vertical-align: middle;
	padding: 14px;
}

/* =======================
   STATUS BADGES
   ======================= */
.status {
	padding: 6px 12px;
	border-radius: 20px;
	font-size: 13px;
	font-weight: 600;
	display: inline-block;
}

.status.pending {
	background: #fff3cd;
	color: #856404;
}

.status.solved {
	background: #d4edda;
	color: #155724;
}

.status.inprogress {
	background: #f8d7da;
	color: #721c24;
}

/* =======================
   MEDIA
   ======================= */
.media-preview {
	width: 70px;
	height: 70px;
	border-radius: 12px;
	object-fit: cover;
	cursor: pointer;
	box-shadow: 0 4px 10px rgba(0,0,0,0.15);
	transition: transform 0.2s ease;
}

.media-preview:hover {
	transform: scale(1.08);
}

/* =======================
   RATING
   ======================= */
.rating-stars i {
	font-size: 1.2rem;
	color: #ccc;
	cursor: pointer;
}

.rating-stars i.bi-star-fill {
	color: #ffc107;
}

/* =======================
   BUTTONS
   ======================= */
.btn-action {
	border-radius: 20px;
	font-size: 13px;
	padding: 6px 12px;
}

/* =======================
   MOBILE UX
   ======================= */
@media (max-width: 768px) {

	h2 {
		font-size: 1.4rem;
	}

	.table {
		font-size: 13px;
	}

	td, th {
		padding: 10px;
	}

	.btn-action {
		width: 100%;
		margin-bottom: 6px;
	}

	.media-preview {
		width: 55px;
		height: 55px;
	}
}

@media (max-width: 576px) {

	h2 {
		font-size: 1.25rem;
	}

	.table {
		font-size: 12px;
	}

	.media-preview {
		width: 48px;
		height: 48px;
	}
}
</style>
</head>
<body>

<div class="container">
	<div class="page-card">
		<h2 class="text-center mb-4">My Submitted Complaints</h2>

		<div class="table-responsive">
			<table class="table align-middle text-center">
				<thead>
					<tr>
						<th>ID</th>
						<th>Department</th>
						<th>Description</th>
						<th>Status</th>
						<th>Media</th>
						<th>Date/Time</th>
						<th>Rating</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>

					<%
					Connection conn = null;
					PreparedStatement ps = null;
					ResultSet rs = null;
					try {
						conn = IcmsConnection.getConnection();

						String sql = "SELECT c.id_complaint_tb, c.description, c.status, c.media, c.date_time, c.rating, d.deptName, c.location "
								+ "FROM complaint_tb c "
								+ "LEFT JOIN dept_tb d ON c.dept_id = d.id_dept_tb "
								+ "WHERE c.user_id = (SELECT id_login_tb FROM user_tb WHERE uName = ?) "
								+ "ORDER BY c.date_time DESC";

						ps = conn.prepareStatement(sql);
						ps.setString(1, username);
						rs = ps.executeQuery();

						boolean hasData = false;
						while (rs.next()) {
							hasData = true;
							int id = rs.getInt("id_complaint_tb");
							String deptName = rs.getString("deptName");
							String desc = rs.getString("description");
							String status = rs.getString("status");
							int rating = rs.getInt("rating");
							Timestamp dateTime = rs.getTimestamp("date_time");
							String location = rs.getString("location");
							Blob media = rs.getBlob("media");
							
							// Check if complaint is within 7 days and not solved
							Calendar cal = Calendar.getInstance();
							cal.add(Calendar.DAY_OF_MONTH, -7);
							Timestamp sevenDaysAgo = new Timestamp(cal.getTimeInMillis());
							boolean canEditDelete = dateTime.after(sevenDaysAgo) && !"Solved".equalsIgnoreCase(status);
					%>
					<tr>
						<td><%=id%></td>
						<td><%=(deptName != null ? deptName : "N/A")%></td>
						<td><%=desc%></td>
						<td class="status <%=status.toLowerCase()%>"><%=status%></td>
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
						<td><%=dateTime%></td>
						<td>
							<% if ("Solved".equalsIgnoreCase(status)) { %>
								<% if (rating == 0) { %>
									<form action="SubmitRatingServlet" method="post" class="rating-form">
										<input type="hidden" name="complaint_id" value="<%= id %>">
										<input type="hidden" name="rating" class="rating-value" value="0">
										<div class="rating-stars">
											<i class="bi bi-star" data-value="1"></i>
											<i class="bi bi-star" data-value="2"></i>
											<i class="bi bi-star" data-value="3"></i>
											<i class="bi bi-star" data-value="4"></i>
											<i class="bi bi-star" data-value="5"></i>
										</div>
										<button type="submit" class="btn btn-sm btn-primary mt-1">Submit</button>
									</form>
								<% } else { %>
									<% for (int i = 1; i <= rating; i++) { %>
										<i class="bi bi-star-fill text-warning"></i>
									<% } %>
									<% for (int i = rating + 1; i <= 5; i++) { %>
										<i class="bi bi-star text-secondary"></i>
									<% } %>
								<% } %>
							<% } else { %>
								<em>Pending</em>
							<% } %>
						</td>
						<td>
							<% if (canEditDelete) { %>
								<!-- Edit Button -->
								<button class="btn btn-warning btn-sm btn-action" 
								        data-bs-toggle="modal" 
								        data-bs-target="#editModal"
								        data-complaint-id="<%= id %>"
								        data-description="<%= desc %>"
								        data-location="<%= location != null ? location : "" %>"
								        data-department="<%= deptName %>">
									<i class="bi bi-pencil"></i> Edit
								</button>
								
								<!-- Delete Button -->
								<button class="btn btn-danger btn-sm btn-action" 
								        data-bs-toggle="modal" 
								        data-bs-target="#deleteModal"
								        data-complaint-id="<%= id %>">
									<i class="bi bi-trash"></i> Delete
								</button>
							<% } else { %>
								<span class="text-muted">Locked</span>
							<% } %>
						</td>
					</tr>
					<%
						}

						if (!hasData) {
							out.println("<tr><td colspan='8' class='text-muted'>No complaints submitted yet.</td></tr>");
						}

					} catch (Exception e) {
						out.println("<tr><td colspan='8' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
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

<!-- Edit Complaint Modal -->
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="editModalLabel">Edit Complaint</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="UpdateComplaintServlet" method="post" enctype="multipart/form-data">
        <div class="modal-body">
          <input type="hidden" name="complaint_id" id="editComplaintId">
          
          <div class="mb-3">
            <label for="editDepartment" class="form-label">Department</label>
            <input type="text" class="form-control" id="editDepartment" readonly>
          </div>
          
          <div class="mb-3">
            <label for="editDescription" class="form-label">Description</label>
            <textarea class="form-control" id="editDescription" name="description" rows="4" maxlength="220" required></textarea>
          </div>
          
          <div class="mb-3">
            <label for="editLocation" class="form-label">Location</label>
            <input type="text" class="form-control" id="editLocation" name="location" maxlength="220">
          </div>
          
          <div class="mb-3">
            <label for="editMedia" class="form-label">Update Media (Optional)</label>
            <input type="file" class="form-control" id="editMedia" name="media" multiple accept="image/*,video/*">
            <div class="form-text">You can select multiple files. Leave empty to keep existing media.</div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Update Complaint</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="deleteModalLabel">Confirm Deletion</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="DeleteComplaintServlet" method="post">
        <div class="modal-body">
          <input type="hidden" name="complaint_id" id="deleteComplaintId">
          <p>Are you sure you want to delete this complaint? This action cannot be undone.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-danger">Delete Complaint</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // ⭐ Rating stars click
    document.querySelectorAll('.rating-stars').forEach(container => {
        const stars = container.querySelectorAll('i');
        const ratingInput = container.parentElement.querySelector('.rating-value');
        stars.forEach(star => {
            star.addEventListener('click', () => {
                const value = parseInt(star.getAttribute('data-value'));
                ratingInput.value = value;
                stars.forEach(s => s.classList.remove('bi-star-fill', 'text-warning'));
                for (let i = 0; i < value; i++) {
                    stars[i].classList.add('bi-star-fill', 'text-warning');
                }
            });
        });
    });

    // 📸 Modal image loading
    const mediaModal = document.getElementById('mediaModal');
    const mediaContainer = document.getElementById('mediaContainer');
    const contextPath = '<%= request.getContextPath() %>';

    mediaModal.addEventListener('show.bs.modal', function (event) {
        const triggerImg = event.relatedTarget;
        if (!triggerImg) return;
        const complaintId = triggerImg.getAttribute('data-complaint');
        mediaContainer.innerHTML = "<p class='text-muted'>Loading images...</p>";
        fetch(contextPath + '/GetComplaintImagesServlet?complaintId=' + complaintId)
            .then(response => response.text())
            .then(html => { mediaContainer.innerHTML = html; })
            .catch(err => {
                console.error('Image load error:', err);
                mediaContainer.innerHTML = "<p class='text-danger'>Failed to load images.</p>";
            });
    });

    // Edit Modal setup
    const editModal = document.getElementById('editModal');
    editModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        const complaintId = button.getAttribute('data-complaint-id');
        const description = button.getAttribute('data-description');
        const location = button.getAttribute('data-location');
        const department = button.getAttribute('data-department');
        
        document.getElementById('editComplaintId').value = complaintId;
        document.getElementById('editDescription').value = description;
        document.getElementById('editLocation').value = location || '';
        document.getElementById('editDepartment').value = department || 'N/A';
    });

    // Delete Modal setup
    const deleteModal = document.getElementById('deleteModal');
    deleteModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        const complaintId = button.getAttribute('data-complaint-id');
        document.getElementById('deleteComplaintId').value = complaintId;
    });
});
</script>
</div>

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