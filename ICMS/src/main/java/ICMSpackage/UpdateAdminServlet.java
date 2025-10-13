package ICMSpackage;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/UpdateAdminServlet")
public class UpdateAdminServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("deptAdmName");
        String dept = request.getParameter("dept_name");
        String contact = request.getParameter("deptAdmContactNo");
        String email = request.getParameter("deptAdmEmail");
        String uname = request.getParameter("deptAdmUname");
        String pwd = request.getParameter("deptAdmPwd");

        try (Connection con = IcmsConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE dept_admin_tb SET deptAdmName=?, dept_name=?, deptAdmContactNo=?, deptAdmEmail=?, deptAdmUname=?, deptAdmPwd=? WHERE iddept_admin_tb=?")) {

            ps.setString(1, name);
            ps.setString(2, dept);
            ps.setString(3, contact);
            ps.setString(4, email);
            ps.setString(5, uname);
            ps.setString(6, pwd);
            ps.setInt(7, id);

            int i = ps.executeUpdate();
            if (i > 0) {
                response.sendRedirect("SupAdmin/AddAdmin.jsp");
            } else {
                response.getWriter().println("Update failed!");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
