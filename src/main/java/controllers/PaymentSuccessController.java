package controllers;

import com.stripe.Stripe;
import com.stripe.model.checkout.Session;

import dao.BookingDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/booking/paymentSuccess")
public class PaymentSuccessController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final BookingDao bookingDao = new BookingDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sessionId = request.getParameter("session_id");
        if (sessionId == null || sessionId.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/public/index.jsp");
            return;
        }

        try {
            Stripe.apiKey = System.getenv("STRIPE_SECRET_KEY");
            if (Stripe.apiKey == null || Stripe.apiKey.isBlank()) {
                throw new ServletException("STRIPE_SECRET_KEY not found in environment variables.");
            }

            Session s = Session.retrieve(sessionId);

            String bookingIdStr = (s.getMetadata() != null) ? s.getMetadata().get("bookingId") : null;
            if (bookingIdStr == null) {
                throw new ServletException("BookingId not found in Stripe session metadata.");
            }

            int bookingId = Integer.parseInt(bookingIdStr);

            // Stripe returns "paid" when successful
            if ("paid".equalsIgnoreCase(s.getPaymentStatus())) {
                bookingDao.updatePaymentStatus(bookingId, "PAID", sessionId);
                bookingDao.updatePaymentTxnStatusByRef(sessionId, "PAID");

                // Optional: clear promo
                HttpSession httpSession = request.getSession(false);
                if (httpSession != null) httpSession.removeAttribute("promoCode");

                request.setAttribute("bookingId", bookingId);
                request.getRequestDispatcher("/booking/payment_success.jsp").forward(request, response);
                return;
            }

            bookingDao.updatePaymentStatus(bookingId, "FAILED", sessionId);
            bookingDao.updatePaymentTxnStatusByRef(sessionId, "FAILED");

            response.sendRedirect(request.getContextPath() + "/booking/bookingSuccess.jsp?bookingId=" + bookingId);
            return;

        } catch (Exception e) {
            throw new ServletException("Payment verification failed.", e);
        }
    }
}
