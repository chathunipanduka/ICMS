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
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;


@WebServlet("/SubmitComplaintServlet")
@MultipartConfig(maxFileSize = 10485760) // 10MB
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
        Part mediaPart = request.getPart("media");

        Connection conn = null;
        PreparedStatement psInsert = null;

        try {
            conn = IcmsConnection.getConnection();

            // 1. Get user_id
            int userId = 0;
            String userSql = "SELECT id_login_tb FROM login_tb WHERE uName = ?";
            try (PreparedStatement psUser = conn.prepareStatement(userSql)) {
                psUser.setString(1, username);
                ResultSet rs = psUser.executeQuery();
                if (rs.next()) {
                    userId = rs.getInt("id_login_tb");
                } else {
                    response.getWriter().println("User not found.");
                    return;
                }
            }

            // 2. Get dept_id
            int deptId = 0;
            String catgSql = "SELECT id_category_tb, dept_id FROM category_tb WHERE category_name = ?";
            try (PreparedStatement psCatg = conn.prepareStatement(catgSql)) {
                psCatg.setString(1, catgName);
                System.out.println("Category received: " + catgName);
                try (ResultSet rsCatg = psCatg.executeQuery()) {
                    if (rsCatg.next()) {
                        //catgId = rsCatg.getInt("id_category_tb");
                        deptId = rsCatg.getInt("dept_id");
                    } else {
                        response.getWriter().println("Category not found.");
                        return;
                    }
                }
            }

            // 3. Insert into complaint_tb
            String insertSql = "INSERT INTO complaint_tb (user_id, dept_id, description, status, media, location, date_time) VALUES (?, ?, ?, ?, ?, ?, NOW())";
            psInsert = conn.prepareStatement(insertSql);

            psInsert.setInt(1, userId);
            psInsert.setInt(2, deptId);
            psInsert.setString(3, description);
            psInsert.setString(4, "Pending"); // default status

            if (mediaPart != null && mediaPart.getSize() > 0) {
                InputStream mediaInputStream = mediaPart.getInputStream();
                psInsert.setBlob(5, mediaInputStream);
            } else {
                psInsert.setNull(5, java.sql.Types.BLOB);
            }
            psInsert.setString(6, location);

            int inserted = psInsert.executeUpdate();

            response.setContentType("text/html;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) {
                if (inserted > 0) {
                    // Success alert and redirect
                    out.println("<script type='text/javascript'>");
                    out.println("alert('Complaint submitted successfully!');");
                    out.println("window.location.href='User/SendComplaint.jsp';"); // redirect after alert
                    out.println("</script>");
                } else {
                    // Failure alert and redirect
                    out.println("<script type='text/javascript'>");
                    out.println("alert('Failed to submit complaint! Please try again.');");
                    out.println("window.location.href='User/SendComplaint.jsp';"); // redirect back
                    out.println("</script>");
                }
            }

        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        } finally {
            if (psInsert != null) try { psInsert.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.getWriter().println("GET method is not supported. Use POST.");
    }
}
