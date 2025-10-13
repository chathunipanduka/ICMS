package ICMSpackage;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/AnonymousSubmitComplaintServlet")
@MultipartConfig(maxFileSize = 10485760) // 10MB
public class AnonymousSubmitComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String description = request.getParameter("description");
        String deptName = request.getParameter("category-select");
        String location = request.getParameter("location");
        Part mediaPart = request.getPart("media");

        try (Connection conn = IcmsConnection.getConnection()) {

            // 1. Get user_id for 'Anonymous'
            int userId = 0;
            String userSql = "SELECT id_login_tb FROM login_tb WHERE uName = ?";
            try (PreparedStatement psUser = conn.prepareStatement(userSql)) {
                psUser.setString(1, "Anonymous");
                ResultSet rs = psUser.executeQuery();
                if (rs.next()) {
                    userId = rs.getInt("id_login_tb");
                } else {
                    response.getWriter().println("Anonymous user not found in database.");
                    return;
                }
            }

            // 2. Get dept_id
            int deptId = 0;
            String deptSql = "SELECT id_dept_tb FROM dept_tb WHERE deptName = ?";
            try (PreparedStatement psDept = conn.prepareStatement(deptSql)) {
                psDept.setString(1, deptName);
                ResultSet rsDept = psDept.executeQuery();
                if (rsDept.next()) {
                    deptId = rsDept.getInt("id_dept_tb");
                } else {
                    response.getWriter().println("Department not found.");
                    return;
                }
            }

            // 3. Insert complaint
            String insertSql = "INSERT INTO complaint_tb (user_id, dept_id, description, status, media, location, date_time) VALUES (?, ?, ?, ?, ?, ?, NOW())";

            try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                psInsert.setInt(1, userId);
                psInsert.setInt(2, deptId);
                psInsert.setString(3, description);
                psInsert.setString(4, "Pending");

                if (mediaPart != null && mediaPart.getSize() > 0) {
                    InputStream mediaInputStream = mediaPart.getInputStream();
                    psInsert.setBlob(5, mediaInputStream);
                } else {
                    psInsert.setNull(5, java.sql.Types.BLOB);
                }

                psInsert.setString(6, location);

                int inserted = psInsert.executeUpdate();

                try (PrintWriter out = response.getWriter()) {
                    if (inserted > 0) {
                        out.println("<script type='text/javascript'>");
                        out.println("alert('Complaint submitted successfully!');");
                        out.println("window.location.href='" + request.getContextPath() + "/Home.jsp';");
                        out.println("</script>");
                    } else {
                        out.println("<script type='text/javascript'>");
                        out.println("alert('Failed to submit complaint! Please try again.');");
                        out.println("window.location.href='" + request.getContextPath() + "/Home.jsp';");
                        out.println("</script>");
                    }
                }
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
