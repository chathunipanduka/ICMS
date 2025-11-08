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

@WebServlet("/AnonymousSubmitComplaintServlet")
@MultipartConfig(maxFileSize = 10485760) // 10MB per file
public class AnonymousSubmitComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String description = request.getParameter("description");
        String catgName = request.getParameter("category");
        String location = request.getParameter("location");

        try (Connection conn = IcmsConnection.getConnection()) {
            conn.setAutoCommit(false); // start transaction

            // 1️⃣ Get Anonymous user ID
            int userId = 0;
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT id_login_tb FROM login_tb WHERE uName = ?")) {
                ps.setString(1, "Anonymous");
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        userId = rs.getInt("id_login_tb");
                    } else {
                        response.getWriter().println("Anonymous user not found in DB");
                        return;
                    }
                }
            }

            // 2️⃣ Get department ID from category
            int deptId = 0;
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT dept_id FROM category_tb WHERE category_name = ?")) {
                ps.setString(1, catgName);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        deptId = rs.getInt("dept_id");
                    } else {
                        response.getWriter().println("Category not found.");
                        return;
                    }
                }
            }

            // 3️⃣ Insert complaint (without media)
            int complaintId = 0;
            String insertComplaint = "INSERT INTO complaint_tb (user_id, dept_id, description, status, media, location, date_time) "
                    + "VALUES (?, ?, ?, ?, NULL, ?, NOW())";
            try (PreparedStatement ps = conn.prepareStatement(insertComplaint, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setInt(2, deptId);
                ps.setString(3, description);
                ps.setString(4, "Pending");
                ps.setString(5, location);
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        complaintId = rs.getInt(1);
                    }
                }
            }

            // 4️⃣ Save multiple images in complaint_media_tb
            String insertImage = "INSERT INTO complaint_media_tb (complaint_id, media, file_name) VALUES (?, ?, ?)";
            try (PreparedStatement psImg = conn.prepareStatement(insertImage)) {
                Collection<Part> parts = request.getParts();

                for (Part part : parts) {
                    if (part.getName().equals("media") && part.getSize() > 0) {
                        InputStream inputStream = part.getInputStream();
                        byte[] imageBytes = inputStream.readAllBytes();  // ✅ fully load file in memory
                        inputStream.close();

                        psImg.setInt(1, complaintId);
                        psImg.setBytes(2, imageBytes);                   // ✅ use setBytes() instead of stream
                        psImg.setString(3, part.getSubmittedFileName());
                        psImg.addBatch();
                    }
                }

                psImg.executeBatch();
            }

            conn.commit(); // ✅ commit all
            try (PrintWriter out = response.getWriter()) {
                out.println("<script type='text/javascript'>");
                out.println("alert('Complaint submitted successfully!');");
                out.println("window.location.href='" + request.getContextPath() + "/Home.jsp';");
                out.println("</script>");
                
                //Add Activity Logger--------------------------------------------------------------
                String ip = request.getRemoteAddr();
                String userAgent = request.getHeader("User-Agent");

                ActivityLogger.log(userId, "User","Submit Complaint", "Complaint ID: " + complaintId + " submitted", ip, userAgent);
                //-----------------------------------------------------------------------------------------

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
}
