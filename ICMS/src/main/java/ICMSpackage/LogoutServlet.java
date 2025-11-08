package ICMSpackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
    	

    	HttpSession session = request.getSession(false);
    	if (session != null) {
    	    Integer userId = (Integer) session.getAttribute("userId"); // or "id_login_tb"
    	    String username = (String) session.getAttribute("username");
    	    String ip = request.getRemoteAddr();
    	    String userAgent = request.getHeader("User-Agent");

    	    if (userId != null) {
    	        ActivityLogger.log(userId,"User", "User Logout", "User: " + username + " Logged out", ip, userAgent);
    	    }

    	    session.invalidate(); // end session
    	}
        // redirect to login page
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
      
        
    }
}
