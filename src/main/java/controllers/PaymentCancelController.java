package controllers;

import dao.BookingDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/booking/paymentCancel")
public class PaymentCancelController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final BookingDao bookingDao = new BookingDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIdStr = request.getParameter("bookingId");

        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            bookingDao.updatePaymentStatus(bookingId, "CANCELLED", null);
        } catch (Exception ignored) {}

        response.sendRedirect(request.getContextPath() + "/booking/checkout?cancel=1");
    }
}
