package controllers;

import dao.BookingDao;
import dao.CartDao;
import models.Client;
import models.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

@WebServlet("/booking/checkout")
public class CheckoutController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final BigDecimal GST_RATE = new BigDecimal("0.09");

    private final CartDao cartDao = new CartDao();
    private final BookingDao bookingDao = new BookingDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("client") == null) {
            response.sendRedirect(request.getContextPath() + "/client/clientLogin.jsp");
            return;
        }

        Client client = (Client) session.getAttribute("client");
        int clientId = client.getClientId();

        // 1) Find pending booking id
        Integer pendingBookingId = cartDao.getPendingBookingId(clientId);
        if (pendingBookingId == null) {
            response.sendRedirect(request.getContextPath() + "/booking/viewCart.jsp");
            return;
        }

        // 2) Load cart items from DB
        List<Service> items = cartDao.getCartItems(clientId);
        if (items == null || items.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking/viewCart.jsp");
            return;
        }

        // 3) Compute subtotal
        BigDecimal subtotal = BigDecimal.ZERO;
        for (Service s : items) {
            subtotal = subtotal.add(BigDecimal.valueOf(s.getPrice()));
        }

        BigDecimal gst = subtotal.multiply(GST_RATE).setScale(2, RoundingMode.HALF_UP);
        BigDecimal total = subtotal.add(gst).setScale(2, RoundingMode.HALF_UP);

        request.setAttribute("bookingId", pendingBookingId);
        request.setAttribute("items", items);
        request.setAttribute("subtotal", subtotal.setScale(2, RoundingMode.HALF_UP));
        request.setAttribute("gst", gst);
        request.setAttribute("total", total);

        request.getRequestDispatcher("/booking/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("client") == null) {
            response.sendRedirect(request.getContextPath() + "/client/clientLogin.jsp");
            return;
        }

        Client client = (Client) session.getAttribute("client");
        int clientId = client.getClientId();

        Integer pendingBookingId = cartDao.getPendingBookingId(clientId);
        if (pendingBookingId == null) {
            response.sendRedirect(request.getContextPath() + "/booking/viewCart.jsp");
            return;
        }

        // schedule fields (optional)
        Date scheduledDate = null;
        Time scheduledTime = null;

        String dateStr = request.getParameter("scheduledDate");
        String timeStr = request.getParameter("scheduledTime");

        try {
            if (dateStr != null && !dateStr.isBlank()) scheduledDate = Date.valueOf(dateStr);
            if (timeStr != null && !timeStr.isBlank()) scheduledTime = Time.valueOf(timeStr + ":00");
        } catch (Exception ignored) {}

        String remarks = request.getParameter("remarks");

        try {
            // 1) Snapshot unit_price + quantity into booking_details (fixes your 0.00 issue)
            bookingDao.fillBookingDetailsPricing(pendingBookingId);

            // 2) Confirm the pending booking + store schedule/gst/remarks
            bookingDao.confirmBooking(pendingBookingId, scheduledDate, scheduledTime, GST_RATE.doubleValue(), remarks);

            response.sendRedirect(request.getContextPath() + "/booking/bookingSuccess.jsp?bookingId=" + pendingBookingId);

        } catch (Exception e) {
            throw new ServletException("Checkout failed: unable to confirm booking.", e);
        }
    }
}
