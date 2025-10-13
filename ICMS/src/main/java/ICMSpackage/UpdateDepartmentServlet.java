package ICMSpackage;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;

@WebServlet("/UpdateDepartmentServlet")
public class UpdateDepartmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        int id = Integer.parseInt(request.getParameter("id"));
        String deptName = request.getParameter("deptName");
        String contactNo = request.getParameter("deptContactNo");

        try (Connection con = IcmsConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("UPDATE dept_tb SET deptName=?, deptConatctNo=? WHERE id_dept_tb=?")) {

            ps.setString(1, deptName);
            ps.setString(2, contactNo);
            ps.setInt(3, id);

            int updated = ps.executeUpdate();

            if (updated > 0) {
                out.println("<script>alert('Department updated successfully!'); window.location='SupAdmin/AddNewDepartment.jsp';</script>");
            } else {
                out.println("<script>alert('Update failed.'); window.location='SupAdmin/AddNewDepartment.jsp';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace(out);
        }
    }
}
