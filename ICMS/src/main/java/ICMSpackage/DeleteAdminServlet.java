package ICMSpackage;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;

@WebServlet("/DeleteAdminServlet")
public class DeleteAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection con = IcmsConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM dept_admin_tb WHERE iddept_admin_tb=?")) {

            ps.setInt(1, id);
            int deleted = ps.executeUpdate();

            if (deleted > 0) {
                response.sendRedirect("SupAdmin/AddAdmin.jsp");
            } else {
                response.getWriter().println("Failed to delete category!");
            }

        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        }
    }
}
