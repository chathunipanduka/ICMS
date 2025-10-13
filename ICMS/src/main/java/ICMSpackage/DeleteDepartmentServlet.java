package ICMSpackage;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;

@WebServlet("/DeleteDepartmentServlet")
public class DeleteDepartmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try (Connection con = IcmsConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM dept_tb WHERE id_dept_tb=?")) {

            ps.setInt(1, id);
            int deleted = ps.executeUpdate();

            if (deleted > 0) {
                out.println("<script>alert('Department deleted successfully!'); window.location='SupAdmin/AddNewDepartment.jsp';</script>");
            } else {
                out.println("<script>alert('Failed to delete department.'); window.location='SupAdmin/AddNewDepartment.jsp';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace(out);
        }
    }
}
