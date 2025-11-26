package controllers;

import dao.CartDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import models.Client;

@WebServlet("/CartController")
public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Get logged-in client
        Client client = (session != null) ? (Client) session.getAttribute("client") : null;

        if (client == null) {
            // Not logged in → redirect
            response.sendRedirect(request.getContextPath() + "/client/clientLogin.jsp");
            return;
        }

        int clientId = client.getClientId();
        String action = request.getParameter("action");
        int serviceId = request.getParameter("serviceId") != null ? Integer.parseInt(request.getParameter("serviceId")) : 0;

        CartDao dao = new CartDao();

        switch (action) {
            case "add":
                dao.addToCart(clientId, serviceId);
                response.sendRedirect(request.getContextPath() + "/booking/viewCart.jsp");
                break;
            case "remove":
                dao.removeFromCart(clientId, serviceId);
                response.sendRedirect(request.getContextPath() + "/booking/viewCart.jsp");
                break;
            case "clear":
                dao.clearCart(clientId);
                response.sendRedirect(request.getContextPath() + "/booking/viewCart.jsp");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/booking/viewCart.jsp");
        }
    }
}