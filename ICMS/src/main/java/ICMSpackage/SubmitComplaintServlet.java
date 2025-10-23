package ICMSpackage;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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

// 1️⃣ Get user_id and email----------------------------------------------------------------------------------------------------------
            int userId = 0;
            String userEmail = null;
            String userSql = "SELECT id_login_tb, email FROM login_tb WHERE uName = ?";
            try (PreparedStatement psUser = conn.prepareStatement(userSql)) {
                psUser.setString(1, username);
                ResultSet rs = psUser.executeQuery();
                if (rs.next()) {
                    userId = rs.getInt("id_login_tb");
                    userEmail = rs.getString("email");
                } else {
                    response.getWriter().println("User not found.");
                    return;
                }
            }

 // 2️⃣ Get dept_id-------------------------------------------------------------------------------------------------------------------
            int deptId = 0;
            String catgSql = "SELECT id_category_tb, dept_id FROM category_tb WHERE category_name = ?";
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
            
            

            
            

// 3️⃣ Insert complaint----------------------------------------------------------------------------------------------------------------
            String insertSql = "INSERT INTO complaint_tb (user_id, dept_id, description, status, media, location, date_time) VALUES (?, ?, ?, ?, ?, ?, NOW())";
            psInsert = conn.prepareStatement(insertSql);

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

            if (inserted > 0) {
            	
//  Get complaint_id-----------------------------------------------------------------------------------------------------------------
            	int complaintId = 0;
            	String maxIdSql = "SELECT MAX(id_complaint_tb) AS id FROM complaint_tb";
            	try (PreparedStatement psMax = conn.prepareStatement(maxIdSql);
            	     ResultSet rsMax = psMax.executeQuery()) {
            	    if (rsMax.next()) {
            	        complaintId = rsMax.getInt("id");
            	    }
            	}
            	
// ✅ Send email to user from DB------------------------------------------------------------------------------------------------------
            	String subject = "Complaint Submitted Successfully";
            	String body = "Dear user,<br>Your complaint about <b>" + catgName + "</b> has been submitted successfully.<hr>\r\n"
            			+ "                    <footer style=\"font-size: 12px; color: #777;\">\r\n"
            			+ "                        This is an automated message from ICMS.<br>\r\n"
            			+ "                        Please do not reply to this email.<br>\r\n"
            			+ "                        © ICMS Team\r\n"
            			+ "                    </footer>";
            	EmailHelper.sendEmail(userEmail, subject, body);
            	
            	String title = "New Complaint Recieved";
            	String message = "A New Complaint Submitted "+complaintId;
            	String type = "new_complaint";
            	
            	createNotification(conn, complaintId, deptId, userId, title, message, type);



                try (PrintWriter out = response.getWriter()) {
                    out.println("<script type='text/javascript'>");
                    out.println("alert('Complaint submitted successfully!');");
                    out.println("window.location.href='User/SendComplaint.jsp';");
                    out.println("</script>");
                }
            } else {
                try (PrintWriter out = response.getWriter()) {
                    out.println("<script type='text/javascript'>");
                    out.println("alert('Failed to submit complaint! Please try again.');");
                    out.println("window.location.href='User/SendComplaint.jsp';");
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
    
//Create Notification-----------------------------------------------------------------------------------------------------------------
    
    private void createNotification(Connection conn, int id, int deptID, int userID, String title, String message, String type) throws SQLException {
    	String sql = "INSERT INTO notification_tb (complaint_id, dept_id, user_id, message, type) VALUES (?,?,?,?,?)";
    	try (PreparedStatement ps = conn.prepareStatement(sql)) {
    	ps.setInt(1, id);
    	ps.setInt(2, deptID);
    	ps.setInt(3, userID);
    	ps.setString(4, message);
    	ps.setString(5, type);
    	ps.executeUpdate();

    	System.out.println("SQL: " + sql.toString());
    	}
    	}
}
