package ICMSpackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 * Servlet implementation class UpdateProfileServlet
 */
@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String username = (String) request.getSession().getAttribute("username");
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        String email = request.getParameter("email");
        String contact = request.getParameter("contact");

        try (Connection conn = IcmsConnection.getConnection()) {
            String sql = "UPDATE login_tb SET email = ?, contactNo = ? WHERE uName = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, contact);
            ps.setString(3, username);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/User/UserDashboard.jsp");
        //Add Activity Logger--------------------------------------------------------------
        
        String ip = request.getRemoteAddr();
        String userAgent = request.getHeader("User-Agent");

        ActivityLogger.log(userId, "User","Update Profile", "User: " + username + " Update Profile", ip, userAgent);
        //-----------------------------------------------------------------------------------------
        
    }
}

