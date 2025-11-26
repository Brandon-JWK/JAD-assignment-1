package util;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

@WebFilter("/*")
public class SessionFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getRequestURI();  // e.g. /JAD-Assignment-1/client/clientDashboard.jsp
        HttpSession session = request.getSession(false);

        // Allow static + public + auth pages through
        if (path.contains("/assets/")
                || path.contains("/includes/")
                || path.contains("/public/")
                || path.contains("/errors/")
                || path.endsWith("clientLogin.jsp")
                || path.endsWith("registerClient.jsp")
                || path.endsWith("adminLogin.jsp")
                || path.endsWith("AuthController")
                || path.endsWith("ClientController")) {
            chain.doFilter(req, res);
            return;
        }

        // Protect admin
        if (path.contains("/admin/")) {
            if (session == null || session.getAttribute("admin") == null) {
                response.sendRedirect(request.getContextPath() + "/errors/notAuthorized.jsp");
                return;
            }
        }

        // Protect client
        if (path.contains("/client/")) {
            if (session == null || session.getAttribute("client") == null) {
                response.sendRedirect(request.getContextPath() + "/errors/sessionError.jsp");
                return;
            }
        }

        chain.doFilter(req, res);
    }
}
