package ICMSpackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
@WebServlet("/AddAdminServlet")
public class AddAdminServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("Name");
        String dept = request.getParameter("dept_name");
        String contact = request.getParameter("contactNo");
        String email = request.getParameter("email");
        String uname = request.getParameter("userName");
        String pwd = request.getParameter("pwd");

        try {
            Connection con = IcmsConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO dept_admin_tb (deptAdmName, dept_name, deptAdmContactNo, deptAdmEmail, deptAdmUname, deptAdmPwd) VALUES (?,?,?,?,?,?)"
            );
            ps.setString(1, name);
            ps.setString(2, dept);
            ps.setString(3, contact);
            ps.setString(4, email);
            ps.setString(5, uname);
            ps.setString(6, pwd);

            int i = ps.executeUpdate();
            if(i > 0){
                response.sendRedirect("SupAdmin/AddAdmin.jsp");
            }else {
            	response.getWriter().println("Failed to add category!");
            }
            ps.close(); con.close();
        } catch(Exception e){
            e.printStackTrace();
        }
    }
}
