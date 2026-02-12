package controllers;

import dao.ServiceStatusDao;
import models.Client;
import models.ServiceStatus;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ClientServiceStatusController")
public class ClientServiceStatusController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Client client = (session != null) ? (Client) session.getAttribute("client") : null;

        if (client == null) {
            response.sendRedirect(request.getContextPath() + "/client/clientLogin.jsp");
            return;
        }

        try {
            // ✅ No more ServletContext connection
            ServiceStatusDao dao = new ServiceStatusDao();
            List<ServiceStatus> statuses = dao.getStatusesByClientId(client.getClientId());

            request.setAttribute("statuses", statuses);
            request.getRequestDispatcher("/client/clientServiceStatus.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Failed to fetch service statuses.", e);
        }
    }
}
