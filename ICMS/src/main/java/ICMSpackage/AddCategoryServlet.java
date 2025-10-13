package ICMSpackage;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;

@WebServlet("/AddCategoryServlet")
public class AddCategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String categoryName = request.getParameter("category_name");
        int deptId = Integer.parseInt(request.getParameter("dept_id"));

        try (Connection con = IcmsConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO category_tb (category_name, dept_id) VALUES (?, ?)")) {

            ps.setString(1, categoryName);
            ps.setInt(2, deptId);

            int inserted = ps.executeUpdate();

            if (inserted > 0) {
                response.sendRedirect("SupAdmin/AddCategory.jsp");
            } else {
                response.getWriter().println("Failed to add category!");
            }

        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        }
    }
}
