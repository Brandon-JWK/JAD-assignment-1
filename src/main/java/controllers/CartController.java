package controllers;

import dao.CartDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import models.Client;

@WebServlet("/CartController")
public class CartController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Client client = (session != null) ? (Client) session.getAttribute("client") : null;

        if (client == null) {
            response.sendRedirect(request.getContextPath() + "/client/clientLogin.jsp");
            return;
        }

        int clientId = client.getClientId();
        String action = request.getParameter("action");
        String serviceIdParam = request.getParameter("serviceId");
        String detailIdParam = request.getParameter("detailId"); // FIXED

        CartDao dao = new CartDao();

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/booking/viewCart.jsp");
            return;
        }

        switch (action) {

            case "add":
                if (serviceIdParam != null) {
                    int serviceId = Integer.parseInt(serviceIdParam);
                    dao.addToCart(clientId, serviceId);
                }
                break;

            case "remove":
                if (detailIdParam != null) {        // FIXED
                    int detailId = Integer.parseInt(detailIdParam);
                    dao.removeFromCart(detailId);   // FIXED
                }
                break;

            case "clear":
                dao.clearCart(clientId);
                break;

            default:
                break;
        }

        response.sendRedirect(request.getContextPath() + "/booking/viewCart.jsp");
    }
}
