package ICMSpackage;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/GetComplaintImagesServlet")
public class GetComplaintImagesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String complaintId = request.getParameter("complaintId");
        response.setContentType("text/html;charset=UTF-8");

        System.out.println("GetComplaintImagesServlet called for complaintId=" + complaintId);

        if (complaintId == null || complaintId.isEmpty()) {
            response.getWriter().write("<p class='text-danger'>Invalid complaint ID.</p>");
            return;
        }

        try (Connection conn = IcmsConnection.getConnection()) {
            String sql = "SELECT id_media FROM complaint_media_tb WHERE complaint_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(complaintId));
            ResultSet rs = ps.executeQuery();

            StringBuilder html = new StringBuilder();
            html.append("<div class='d-flex flex-wrap justify-content-center gap-3'>");
            boolean hasImages = false;

            while (rs.next()) {
                hasImages = true;
                int mediaId = rs.getInt("id_media");
                html.append("<img src='")
                    .append(request.getContextPath())
                    .append("/ViewMediaServlet?mediaId=")
                    .append(mediaId)
                    .append("' class='img-thumbnail' style='width:200px; height:200px; object-fit:cover;'>");
            }

            html.append("</div>");

            if (!hasImages) {
                html = new StringBuilder("<p class='text-muted'>No images found for this complaint.</p>");
            }

            System.out.println("HTML returned: " + html.toString());

            response.getWriter().write(html.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("<p class='text-danger'>Error loading images: " + e.getMessage() + "</p>");
        }
    }

}
