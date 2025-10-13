package ICMSpackage;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;

@WebServlet("/AddDepartmentServlet")
public class AddDepartmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String deptName = request.getParameter("deptName");
        String deptContactNo = request.getParameter("deptContactNo");

        try (Connection con = IcmsConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("INSERT INTO dept_tb (deptName, deptConatctNo) VALUES (?, ?)")) {

            ps.setString(1, deptName);
            ps.setString(2, deptContactNo);

            int inserted = ps.executeUpdate();

            if (inserted > 0) {
                out.println("<script>alert('Department added successfully!'); window.location='SupAdmin/AddNewDepartment.jsp';</script>");
            } else {
                out.println("<script>alert('Failed to add department.'); window.location='SupAdmin/AddNewDepartment.jsp';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace(out);
        }
    }
}
