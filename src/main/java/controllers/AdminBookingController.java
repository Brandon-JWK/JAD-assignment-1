package controllers;

import dao.AdminBookingDao;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/AdminBookingController")
public class AdminBookingController extends HttpServlet {

    private final AdminBookingDao dao = new AdminBookingDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String action = request.getParameter("action");
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));

        try {
            if ("updateStatus".equals(action)) {
                String status = request.getParameter("status");
                dao.updateBookingStatus(bookingId, status);
            } else if ("deleteBooking".equals(action)) {
                dao.deleteBooking(bookingId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/bookings/adminListBookings.jsp");
    }
}
