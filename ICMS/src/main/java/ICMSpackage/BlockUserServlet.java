package ICMSpackage;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/BlockUserServlet")
public class BlockUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String action = request.getParameter("action");

        if (idParam == null || action == null) {
            response.sendRedirect("AdminViewUsers.jsp");
            return;
        }

        int id = Integer.parseInt(idParam);
        int status = action.equals("block") ? 1 : 0;

        try (Connection conn = IcmsConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "UPDATE login_tb SET isBlocked = ? WHERE id_login_tb = ?")) {
            ps.setInt(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
      //Add Activity Logger--------------------------------------------------------------
        int userId = 1;
        String ip = request.getRemoteAddr();
        String userAgent = request.getHeader("User-Agent");

        ActivityLogger.log(userId, "SupAdmin","User Blocked", id+" User Blocked Status" + status , ip, userAgent);
        //-----------------------------------------------------------------------------------------


        response.sendRedirect("SupAdmin/UserManage.jsp"); // reload user list page
    }
}
