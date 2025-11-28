package controllers;

import dao.CartDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import models.Client;

@WebServlet("/CheckoutController")
public class CheckoutController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Client client = (session != null) ? (Client) session.getAttribute("client") : null;

        if (client == null) {
            response.sendRedirect(request.getContextPath() + "/client/clientLogin.jsp");
            return;
        }

        CartDao dao = new CartDao();
        Integer bookingId = dao.getPendingBookingId(client.getClientId());

        if (bookingId == null) {
            response.sendRedirect(request.getContextPath() + "/booking/viewCart.jsp");
            return;
        }

        // Mark the booking as confirmed
        dao.confirmBooking(bookingId);

        // Redirect to a confirmation page
        response.sendRedirect(request.getContextPath() + "/booking/bookingSuccess.jsp");
    }
}
