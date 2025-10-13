package ICMSpackage;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;

@WebServlet("/UpdateCategoryServlet")
public class UpdateCategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        int id = Integer.parseInt(request.getParameter("id"));
        String categoryName = request.getParameter("category_name");
        int deptId = Integer.parseInt(request.getParameter("dept_id"));

        try (Connection con = IcmsConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE category_tb SET category_name=?, dept_id=? WHERE id_category_tb=?")) {

            ps.setString(1, categoryName);
            ps.setInt(2, deptId);
            ps.setInt(3, id);

            int updated = ps.executeUpdate();

            if (updated > 0) {
                response.sendRedirect("SupAdmin/AddCategory.jsp");
            } else {
                response.getWriter().println("Failed to update category!");
            }

        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        }
    }
}
