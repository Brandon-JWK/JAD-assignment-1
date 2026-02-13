package controllers;

import com.stripe.Stripe;
import com.stripe.model.checkout.Session;
import com.stripe.param.checkout.SessionCreateParams;

import dao.BookingDao;
import dao.CartDao;
import dao.PromotionDao;
import models.Client;
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

@WebServlet("/booking/payStripe")
public class StripePayController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final BigDecimal GST_RATE = new BigDecimal("0.09");

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

        Integer bookingId = cartDao.getPendingBookingId(clientId);
        if (bookingId == null) {
            response.sendRedirect(request.getContextPath() + "/booking/viewCart.jsp");
            return;
        }

        // Read schedule + remarks (same fields as your checkout form)
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
            // 1) Ensure booking_details have correct quantity/unit_price
            bookingDao.fillBookingDetailsPricing(bookingId);

            // 2) Confirm booking (assign caregiver, set schedule, insert service_status)
            // IMPORTANT: Only do this ONCE via Stripe button (avoid double-confirm).
            bookingDao.confirmBooking(bookingId, scheduledDate, scheduledTime, GST_RATE.doubleValue(), remarks);

            // 3) Compute totals from booking_details
            BigDecimal bookingSubtotal = bookingDao.calculateSubtotal(bookingId);

            // 4) Promo from session (optional)
            String promoCode = (String) session.getAttribute("promoCode");
            Promotion appliedPromo = null;
            if (promoCode != null && !promoCode.isBlank()) {
                appliedPromo = promoDao.getValidPromoByCode(promoCode, bookingSubtotal.doubleValue());
                if (appliedPromo == null) session.removeAttribute("promoCode");
            }

            PriceSummary summary = PricingUtil.compute(bookingSubtotal, GST_RATE, appliedPromo);

            // 5) Save promo + breakdown to booking table
            bookingDao.updateBookingAmountsAndPromo(
                    bookingId,
                    (appliedPromo != null ? appliedPromo.getPromoId() : null),
                    summary.getSubtotal(),
                    summary.getDiscount(),
                    summary.getGst(),
                    summary.getTotal()
            );

            // 6) Create Stripe Checkout Session
            Stripe.apiKey = System.getenv("STRIPE_SECRET_KEY");
            if (Stripe.apiKey == null || Stripe.apiKey.isBlank()) {
                throw new ServletException("STRIPE_SECRET_KEY not found in environment variables.");
            }

            long amountCents = summary.getTotal()
                    .multiply(new BigDecimal("100"))
                    .setScale(0, RoundingMode.HALF_UP)
                    .longValueExact();

            String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
                    + request.getContextPath();

            SessionCreateParams params = SessionCreateParams.builder()
                    .setMode(SessionCreateParams.Mode.PAYMENT)
                    .setSuccessUrl(baseUrl + "/booking/paymentSuccess?session_id={CHECKOUT_SESSION_ID}")
                    .setCancelUrl(baseUrl + "/booking/paymentCancel?bookingId=" + bookingId)
                    .addLineItem(
                            SessionCreateParams.LineItem.builder()
                                    .setQuantity(1L)
                                    .setPriceData(
                                            SessionCreateParams.LineItem.PriceData.builder()
                                                    .setCurrency("sgd")
                                                    .setUnitAmount(amountCents)
                                                    .setProductData(
                                                            SessionCreateParams.LineItem.PriceData.ProductData.builder()
                                                                    .setName("Silver Care Booking #" + bookingId)
                                                                    .build()
                                                    )
                                                    .build()
                                    )
                                    .build()
                    )
                    .putMetadata("bookingId", String.valueOf(bookingId))
                    .putMetadata("clientId", String.valueOf(clientId))
                    .build();

            Session stripeSession = Session.create(params);

            // 7) Record payment status + txn
            bookingDao.updatePaymentStatus(bookingId, "PENDING", stripeSession.getId());
            bookingDao.insertPaymentTxn(bookingId, "STRIPE", stripeSession.getId(), summary.getTotal(), "SGD", "PENDING");

            // 8) Redirect to Stripe hosted checkout
            response.sendRedirect(stripeSession.getUrl());

        } catch (Exception e) {
            throw new ServletException("Stripe payment failed.", e);
        }
    }
}
