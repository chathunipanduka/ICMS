package ICMSpackage;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ViewMediaServlet")
public class ViewMediaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        if (id == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing complaint ID");
            return;
        }

        try (Connection conn = IcmsConnection.getConnection()) {
            String sql = "SELECT media FROM complaint_tb WHERE id_complaint_tb = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(id));
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Blob blob = rs.getBlob("media");

                if (blob != null && blob.length() > 0) {
                    // Set the response type (JPEG/PNG)
                    response.setContentType("image/jpeg");

                    InputStream inputStream = blob.getBinaryStream();
                    OutputStream outputStream = response.getOutputStream();

                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }

                    inputStream.close();
                    outputStream.close();
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "No image found");
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Complaint not found");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
