package controllers;

import dao.BookingDao;
import dao.CartDao;
import models.Client;
import models.Service;
import dao.PromotionDao;
import models.Promotion;
import models.PriceSummary;
import util.PricingUtil;

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
    private final PromotionDao promoDao = new PromotionDao();

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
        
        String promoError = (String) session.getAttribute("promoError");
        if (promoError != null) {
            request.setAttribute("promoError", promoError);
            session.removeAttribute("promoError");
        }

        // 1) Find pending booking id
        Integer pendingBookingId = cartDao.getPendingBookingId(clientId);
        if (pendingBookingId == null) {
            response.sendRedirect(request.getContextPath() + "/booking/viewCart.jsp");
            return;
        }

        // 2) Load cart items from DB (for display)
        List<Service> items = cartDao.getCartItems(clientId);
        if (items == null || items.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking/viewCart.jsp");
            return;
        }

        try {
            // Ensure booking_details has correct quantity + unit_price (fixes any 0.00)
            bookingDao.fillBookingDetailsPricing(pendingBookingId);

            // 3) Compute subtotal from booking_details (more accurate than summing items)
            BigDecimal bookingSubtotal = bookingDao.calculateSubtotal(pendingBookingId);

            // 4) Promo validation (from session)
            String promoCode = (String) session.getAttribute("promoCode");
            Promotion appliedPromo = null;

            if (promoCode != null && !promoCode.isBlank()) {
                appliedPromo = promoDao.getValidPromoByCode(promoCode, bookingSubtotal.doubleValue());
                if (appliedPromo == null) {
                    session.removeAttribute("promoCode"); // invalid/expired
                }
            }

            if (appliedPromo == null) {
                session.removeAttribute("promoCode");
            }

            // 5) Compute final breakdown
            PriceSummary summary = PricingUtil.compute(bookingSubtotal, GST_RATE, appliedPromo);

            // 6) Pass to JSP
            request.setAttribute("bookingId", pendingBookingId);
            request.setAttribute("items", items);

            request.setAttribute("subtotal", summary.getSubtotal());
            request.setAttribute("discount", summary.getDiscount());
            request.setAttribute("gst", summary.getGst());
            request.setAttribute("total", summary.getTotal());
            request.setAttribute("promo", summary.getPromo());

            request.getRequestDispatcher("/booking/checkout.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Failed to load checkout summary.", e);
        }
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
            // 1) Snapshot pricing in booking_details
            bookingDao.fillBookingDetailsPricing(pendingBookingId);

            // 2) Confirm booking (your existing logic)
            bookingDao.confirmBooking(
                    pendingBookingId,
                    scheduledDate,
                    scheduledTime,
                    GST_RATE.doubleValue(),
                    remarks
            );

            // 3) Compute subtotal from booking_details (more accurate than items list)
            BigDecimal bookingSubtotal = bookingDao.calculateSubtotal(pendingBookingId);

            // 4) Validate promo (if any)
            String promoCode = (String) session.getAttribute("promoCode");
            Promotion appliedPromo = null;

            if (promoCode != null && !promoCode.isBlank()) {
                appliedPromo = promoDao.getValidPromoByCode(promoCode, bookingSubtotal.doubleValue());
                if (appliedPromo == null) {
                    session.removeAttribute("promoCode"); // invalid/expired
                }
            }

            // 5) Compute final amounts (subtotal - discount + GST)
            PriceSummary summary = PricingUtil.compute(bookingSubtotal, GST_RATE, appliedPromo);

            // 6) SAVE to booking table (this is the “advanced feature” audit trail)
            bookingDao.updateBookingAmountsAndPromo(
                    pendingBookingId,
                    (appliedPromo != null ? appliedPromo.getPromoId() : null),
                    summary.getSubtotal(),
                    summary.getDiscount(),
                    summary.getGst(),
                    summary.getTotal()
            );

            // Optional: clear promo after checkout confirm
            // session.removeAttribute("promoCode");

            response.sendRedirect(request.getContextPath()
                    + "/booking/bookingSuccess.jsp?bookingId=" + pendingBookingId);

        } catch (Exception e) {
            throw new ServletException("Checkout failed: unable to confirm booking.", e);
        }
    }
}
