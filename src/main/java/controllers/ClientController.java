package controllers;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.ClientDao;
import dao.BookingDao;
import models.Booking;
import models.Client;

@WebServlet("/ClientController")
public class ClientController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================
    // GET actions
    // =========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/client/clientDashboard.jsp");
            return;
        }

        switch (action) {
            case "viewBookings":
                viewBookings(request, response);
                break;

            case "viewBookingDetails":
                viewBookingDetails(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/client/clientDashboard.jsp");
                break;
        }
    }

    private void viewBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Client client = (session != null) ? (Client) session.getAttribute("client") : null;

        if (client == null) {
            response.sendRedirect(request.getContextPath() + "/client/clientLogin.jsp");
            return;
        }

        try {
            BookingDao bookingDao = new BookingDao();
            request.setAttribute("bookings", bookingDao.getBookingsByClientId(client.getClientId()));
            request.getRequestDispatcher("/client/clientBookings.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Failed to load booking history.", e);
        }
    }

    private void viewBookingDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Client client = (session != null) ? (Client) session.getAttribute("client") : null;

        if (client == null) {
            response.sendRedirect(request.getContextPath() + "/client/clientLogin.jsp");
            return;
        }

        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null || bookingIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/ClientController?action=viewBookings");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);

            BookingDao bookingDao = new BookingDao();
            Booking booking = bookingDao.getBookingByBookingId(bookingId);
            request.setAttribute("b", booking);

            var details = bookingDao.getBookingDetailsWithServiceName(bookingId);
            request.setAttribute("l", details);

            request.getRequestDispatcher("/client/clientBookingDetails.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Failed to load booking details.", e);
        }
    }

    // =========================
    // POST actions
    // =========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        ClientDao dao = new ClientDao();

        switch (action) {
            // =========================
            // REGISTER
            // =========================
            case "register":
                Client c = new Client(
                        0,
                        request.getParameter("fullName"),
                        request.getParameter("email"),
                        request.getParameter("password"),
                        request.getParameter("phone"),
                        request.getParameter("address")
                );

                if (dao.register(c)) {
                    response.sendRedirect("client/registerSuccess.jsp");
                } else {
                    request.setAttribute("error", "Registration failed");
                    request.getRequestDispatcher("client/registerClient.jsp").forward(request, response);
                }
                break;

            // =========================
            // UPDATE PROFILE
            // =========================
            case "updateProfile":
                int id = Integer.parseInt(request.getParameter("clientId"));

                Client updateClient = new Client(
                        id,
                        request.getParameter("fullName"),
                        request.getParameter("email"),
                        "",
                        request.getParameter("phone"),
                        request.getParameter("address")
                );

                if (dao.update(updateClient)) {
                    Client freshClient = dao.getClientById(updateClient.getClientId());
                    request.getSession().setAttribute("client", freshClient);
                    response.sendRedirect("client/clientProfile.jsp?success=1");
                } else {
                    request.setAttribute("error", "Update failed");
                    request.getRequestDispatcher("client/editClientProfile.jsp").forward(request, response);
                }
                break;

            // =========================
            // DELETE CLIENT ACCOUNT
            // =========================
            case "deleteClient":
                int delId = Integer.parseInt(request.getParameter("clientId"));
                dao.delete(delId);
                request.getSession().invalidate();
                response.sendRedirect("public/index.jsp");
                break;

            // =========================
            // PAY CONFIRMED BOOKING
            // =========================
            case "payBooking":
                String bookingIdStr = request.getParameter("bookingId");
                if (bookingIdStr != null) {
                    try {
                        int bookingId = Integer.parseInt(bookingIdStr);
                        BookingDao bookingDao = new BookingDao();
                        Booking booking = bookingDao.getBookingByBookingId(bookingId);

                        if (booking != null && ("PENDING".equalsIgnoreCase(booking.getStatus())
                                || "CONFIRMED".equalsIgnoreCase(booking.getStatus()))) {

                            // Option 1: Redirect to Stripe controller
                            response.sendRedirect(request.getContextPath() + "/booking/payStripe?bookingId=" + bookingId);

                            // Option 2: Or, if you have a JSP payment page:
                            // request.setAttribute("booking", booking);
                            // request.getRequestDispatcher("/client/paymentPage.jsp").forward(request, response);

                        } else {
                            request.setAttribute("error", "Booking already paid or invalid.");
                            request.getRequestDispatcher("/client/clientBookings.jsp").forward(request, response);
                        }
                    } catch (Exception e) {
                        throw new ServletException("Payment initiation failed.", e);
                    }
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/client/clientDashboard.jsp");
                break;
        }
    }
}
