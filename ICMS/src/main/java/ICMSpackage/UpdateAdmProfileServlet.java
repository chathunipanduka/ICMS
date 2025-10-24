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
@WebServlet("/UpdateAdmProfileServlet")
public class UpdateAdmProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    	
        String admname = (String) request.getSession().getAttribute("username");
        String admemail = request.getParameter("email");
        String admcontact = request.getParameter("contact");

        try (Connection conn = IcmsConnection.getConnection()) {
            String sql = "UPDATE dept_admin_tb SET deptAdmEmail = ?, deptAdmContactNo = ? WHERE deptAdmUname = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, admemail);
            ps.setString(2, admcontact);
            ps.setString(3, admname);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/DeptAdmin/DeptAdmDashboard.jsp");
    }
}

