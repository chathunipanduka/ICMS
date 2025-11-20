package ICMSpackage;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.*;
import java.util.Collection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/SubmitComplaintServlet")
@MultipartConfig(maxFileSize = 10485760) // 10MB per file
public class SubmitComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        String username = (session != null) ? (String) session.getAttribute("username") : null;

        if (username == null) {
            response.getWriter().println("User not logged in.");
            return;
        }

        String description = request.getParameter("description");
        String catgName = request.getParameter("category");
        String location = request.getParameter("location");

        try (Connection conn = IcmsConnection.getConnection()) {
            conn.setAutoCommit(false); // start transaction

            // 1️⃣ Get user_id and email
            int userId = 0;
            String userEmail = null;
            String userSql = "SELECT id_login_tb, email FROM user_tb WHERE uName = ?";
            try (PreparedStatement psUser = conn.prepareStatement(userSql)) {
                psUser.setString(1, username);
                try (ResultSet rs = psUser.executeQuery()) {
                    if (rs.next()) {
                        userId = rs.getInt("id_login_tb");
                        userEmail = rs.getString("email");
                    } else {
                        response.getWriter().println("User not found.");
                        return;
                    }
                }
            }

            // 2️⃣ Get dept_id
            int deptId = 0;
            String catgSql = "SELECT dept_id FROM category_tb WHERE category_name = ?";
            try (PreparedStatement psCatg = conn.prepareStatement(catgSql)) {
                psCatg.setString(1, catgName);
                try (ResultSet rsCatg = psCatg.executeQuery()) {
                    if (rsCatg.next()) {
                        deptId = rsCatg.getInt("dept_id");
                    } else {
                        response.getWriter().println("Category not found.");
                        return;
                    }
                }
            }

            // 3️⃣ Insert complaint (without media)
            int complaintId = 0;
            String insertSql = "INSERT INTO complaint_tb (user_id, dept_id, description, status, media, location, date_time) VALUES (?, ?, ?, ?, NULL, ?, NOW())";
            try (PreparedStatement psInsert = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                psInsert.setInt(1, userId);
                psInsert.setInt(2, deptId);
                psInsert.setString(3, description);
                psInsert.setString(4, "Pending");
                psInsert.setString(5, location);
                psInsert.executeUpdate();

                try (ResultSet rs = psInsert.getGeneratedKeys()) {
                    if (rs.next()) {
                        complaintId = rs.getInt(1);
                    }
                }
            }

            // 4️⃣ Insert multiple images into complaint_media_tb
            String insertImage = "INSERT INTO complaint_media_tb (complaint_id, media, file_name) VALUES (?, ?, ?)";
            try (PreparedStatement psImg = conn.prepareStatement(insertImage)) {
                Collection<Part> parts = request.getParts();

                for (Part part : parts) {
                    if (part.getName().equals("media") && part.getSize() > 0) {
                        try (InputStream inputStream = part.getInputStream()) {
                            byte[] imageBytes = inputStream.readAllBytes(); // ✅ read safely
                            psImg.setInt(1, complaintId);
                            psImg.setBytes(2, imageBytes); // ✅ use bytes, not stream
                            psImg.setString(3, part.getSubmittedFileName());
                            psImg.addBatch();
                        }
                    }
                }

                psImg.executeBatch();
            }

            // 5️⃣ Send email to user
            String subject = "Complaint Submitted Successfully";
            String body = "Dear user,<br>Your complaint about <b>" + catgName + "</b> has been submitted successfully.<hr>"
                    + "<footer style='font-size:12px;color:#777;'>"
                    + "This is an automated message from ICMS.<br>"
                    + "Please do not reply to this email.<br>© ICMS Team</footer>";

            EmailHelper.sendEmail(userEmail, subject, body);

            // 6️⃣ Create notification
            String title = "New Complaint Received";
            String message = "A new complaint was submitted: " + complaintId;
            String type = "new_complaint";
            createNotification(conn, complaintId, deptId, userId, title, message, type);
            
            
          //Add Activity Logger--------------------------------------------------------------
            String ip = request.getRemoteAddr();
            String userAgent = request.getHeader("User-Agent");

            ActivityLogger.log(userId,"User", "Submit Complaint", "Complaint ID: " + complaintId + " submitted", ip, userAgent);
            //-----------------------------------------------------------------------------------------

            conn.commit(); // ✅ commit all changes

            try (PrintWriter out = response.getWriter()) {
                out.println("<script type='text/javascript'>");
                out.println("alert('Complaint submitted successfully!');");
                out.println("window.location.href='User/SendComplaint.jsp';");
                out.println("</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error while submitting complaint: " + e.getMessage());
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.getWriter().println("GET method is not supported. Use POST.");
    }

    // 🧩 Create notification helper
    private void createNotification(Connection conn, int id, int deptID, int userID,
                                    String title, String message, String type) throws SQLException {
        String sql = "INSERT INTO notification_tb (complaint_id, dept_id, user_id, message, type) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, deptID);
            ps.setInt(3, userID);
            ps.setString(4, message);
            ps.setString(5, type);
            ps.executeUpdate();
        }
    }
}
