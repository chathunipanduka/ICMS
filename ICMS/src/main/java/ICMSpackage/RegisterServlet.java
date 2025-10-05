package ICMSpackage;

//import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String fName = request.getParameter("fName");
        String lName = request.getParameter("lName");
        String uName = request.getParameter("uName");
        String email = request.getParameter("email");
        String pwd = request.getParameter("Pwd");
        String cPwd = request.getParameter("cPwd");

        // ✅ Password confirmation check
        if (!pwd.equals(cPwd)) {
            out.println("<div style='color:red;font-weight:bold;'>Passwords do not match!</div>");
            out.println("<a href='Register.jsp'>Try Again</a>");
            return;
        }

        try (Connection conn = IcmsConnection.getConnection()) {
            if (conn == null) {
                throw new ServletException("Database connection failed!");
            }

            // ✅ Check if username already exists
            String checkSql = "SELECT uName FROM login_tb WHERE uName=?";
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setString(1, uName);
                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        out.println("<div style='color:red;font-weight:bold;'>Username already exists!</div>");
                        out.println("<a href='Register.html'>Try Again</a>");
                        return;
                    }
                }
            }

            // ✅ Insert new user
            String sql = "INSERT INTO login_tb (firstname, lastname, uname, email, pwd) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, fName);
                ps.setString(2, lName);
                ps.setString(3, uName);
                ps.setString(4, email);
                ps.setString(5, pwd); // ⚠️ store hashed in production

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    // Redirect to login page with success message
                	out.println("<script type=\"text/javascript\">");
                    out.println("alert('Registration Successful! Please login.');");
                    out.println("window.location.href='Login.html';");
                    out.println("</script>");
                } else {
                    out.println("<div style='color:red;font-weight:bold;'>Registration Failed!</div>");
                    out.println("<a href='Register.html'>Try Again</a>");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<font color=red>Error: " + e.getMessage() + "</font>");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
