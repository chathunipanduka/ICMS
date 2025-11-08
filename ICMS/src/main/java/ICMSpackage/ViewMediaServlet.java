package ICMSpackage;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ViewMediaServlet")
public class ViewMediaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String mediaId = request.getParameter("mediaId");
        if (mediaId == null || mediaId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing media ID");
            return;
        }

        try (Connection conn = IcmsConnection.getConnection()) {
            String sql = "SELECT media, file_name FROM complaint_media_tb WHERE id_media = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(mediaId));
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Blob blob = rs.getBlob("media");
                String fileName = rs.getString("file_name");

                // Detect media type based on filename
                String mediaType = "image/jpeg";
                if (fileName != null) {
                    fileName = fileName.toLowerCase();
                    if (fileName.endsWith(".png")) mediaType = "image/png";
                    else if (fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")) mediaType = "image/jpeg";
                    else if (fileName.endsWith(".gif")) mediaType = "image/gif";
                }

                if (blob != null && blob.length() > 0) {
                    response.setContentType(mediaType);
                    try (InputStream input = blob.getBinaryStream();
                         OutputStream output = response.getOutputStream()) {
                        input.transferTo(output);
                    }
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "No image found");
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Media not found");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
