package ICMSpackage;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/SubmitRatingServlet")
public class SubmitRatingServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String complaintId = request.getParameter("complaint_id");
        int rating = Integer.parseInt(request.getParameter("rating"));
        int userId = 0;
        //String userEmail = null;
        HttpSession session = request.getSession(false);
        String username = (session != null) ? (String) session.getAttribute("username") : null;

        try (Connection con = IcmsConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("UPDATE complaint_tb SET rating=? WHERE id_complaint_tb=?");
            ps.setInt(1, rating);
            ps.setString(2, complaintId);
            ps.executeUpdate();
            
            
         // 1️⃣ Get user_id and email
            
            String userSql = "SELECT id_login_tb, email FROM user_tb WHERE uName = ?";
            try (PreparedStatement psUser = con.prepareStatement(userSql)) {
                psUser.setString(1, username);
                try (ResultSet rs = psUser.executeQuery()) {
                    if (rs.next()) {
                        userId = rs.getInt("id_login_tb");
                        //userEmail = rs.getString("email");
                    } else {
                        response.getWriter().println("User not found.");
                        return;
                    }
                }
            }
            
            
            
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
      //Add Activity Logger--------------------------------------------------------------
        String ip = request.getRemoteAddr();
        String userAgent = request.getHeader("User-Agent");

        ActivityLogger.log(userId,"User", "Rate to Complaint", "Complaint ID: " + complaintId + " Add " + rating + " rate", ip, userAgent);
        //-----------------------------------------------------------------------------------------


        response.sendRedirect("Complaints.jsp");
    }
}
