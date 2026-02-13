package controllers;

import dao.BookingDao;
import dao.CartDao;
import dao.PromotionDao;
import models.Client;
import models.Promotion;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;

@WebServlet("/booking/applyPromo")
public class ApplyPromoController extends HttpServlet {

    private final CartDao cartDao = new CartDao();
    private final BookingDao bookingDao = new BookingDao();
    private final PromotionDao promoDao = new PromotionDao();

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

        String code = request.getParameter("promoCode");
        if (code != null) code = code.trim().toUpperCase();

        // Clear if empty
        if (code == null || code.isBlank()) {
            session.removeAttribute("promoCode");
            session.removeAttribute("promoError");
            response.sendRedirect(request.getContextPath() + "/booking/checkout");
            return;
        }

        // Keep whatever user typed (so it stays in the input box)
        session.setAttribute("promoCode", code);

        try {
            Integer bookingId = cartDao.getPendingBookingId(clientId);
            if (bookingId == null) {
                session.setAttribute("promoError", "No active cart/booking found.");
                response.sendRedirect(request.getContextPath() + "/booking/viewCart.jsp");
                return;
            }

            // Ensure pricing snapshot exists
            bookingDao.fillBookingDetailsPricing(bookingId);
            BigDecimal subtotal = bookingDao.calculateSubtotal(bookingId);

            // IMPORTANT: This method must exist (see section 4 below)
            Promotion p = promoDao.getPromoByCode(code);

            if (p == null) {
                session.setAttribute("promoError", "Promo code '" + code + "' does not exist.");
                response.sendRedirect(request.getContextPath() + "/booking/checkout");
                return;
            }

            // inactive
            if (!p.isActive()) {
                session.setAttribute("promoError", "Promo code '" + code + "' is not active.");
                response.sendRedirect(request.getContextPath() + "/booking/checkout");
                return;
            }

            LocalDate today = LocalDate.now();
            LocalDate start = p.getStartDate().toLocalDate();
            LocalDate end = p.getEndDate().toLocalDate();

            // expired / not started
            if (today.isBefore(start)) {
                session.setAttribute("promoError",
                        "Promo code '" + code + "' is not available yet (starts " + start + ").");
                response.sendRedirect(request.getContextPath() + "/booking/checkout");
                return;
            }
            if (today.isAfter(end)) {
                session.setAttribute("promoError",
                        "Promo code '" + code + "' has expired (ended " + end + ").");
                response.sendRedirect(request.getContextPath() + "/booking/checkout");
                return;
            }

            // min spend not met
            BigDecimal min = BigDecimal.valueOf(p.getMinSubtotal()).setScale(2, RoundingMode.HALF_UP);
            if (subtotal.compareTo(min) < 0) {
                BigDecimal shortfall = min.subtract(subtotal).setScale(2, RoundingMode.HALF_UP);
                session.setAttribute("promoError",
                        "Minimum spend not met. Spend $" + shortfall + " more to use '" + code + "'.");
                response.sendRedirect(request.getContextPath() + "/booking/checkout");
                return;
            }

            // ✅ valid promo
            session.removeAttribute("promoError");
            response.sendRedirect(request.getContextPath() + "/booking/checkout");

        } catch (Exception e) {
            session.setAttribute("promoError", "Unable to apply promo right now.");
            response.sendRedirect(request.getContextPath() + "/booking/checkout");
        }
    }
}
