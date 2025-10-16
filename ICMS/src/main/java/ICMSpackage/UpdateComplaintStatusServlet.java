package ICMSpackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/UpdateComplaintStatusServlet")
public class UpdateComplaintStatusServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String status = request.getParameter("status");

        try (Connection conn = IcmsConnection.getConnection()) {
            String sql = "UPDATE complaint_tb SET status = ?, updated = CURRENT_TIMESTAMP WHERE id_complaint_tb = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, Integer.parseInt(id));
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/DeptAdmin/AdmComplaints.jsp");
    }
}
