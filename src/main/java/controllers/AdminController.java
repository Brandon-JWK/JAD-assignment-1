package controllers;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.AdminDao;
import dao.ReportDao;

@WebServlet("/AdminController")
public class AdminController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // GET: Admin Reports
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/admin/adminDashboard.jsp");
            return;
        }

        switch (action) {
            case "reports":
                showReports(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/admin/adminDashboard.jsp");
                break;
        }
    }

    private void showReports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            ReportDao reportDao = new ReportDao();

            request.setAttribute("bestRated", reportDao.getServiceRatings(true, 5));
            request.setAttribute("lowestRated", reportDao.getServiceRatings(false, 5));
            request.setAttribute("highDemand", reportDao.getHighDemandServices(5));
            request.setAttribute("bookingsByMonth", reportDao.getBookingsByMonth());
            request.setAttribute("topClients", reportDao.getTopClients(5));

            request.getRequestDispatcher("/admin/adminReports.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Failed to load admin reports.", e);
        }
    }

    // POST: Existing delete client logic
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        AdminDao dao = new AdminDao();

        if ("deleteClient".equals(action)) {
            int id = Integer.parseInt(request.getParameter("clientId"));
            dao.deleteClient(id);
            response.sendRedirect(request.getContextPath() + "/admin/clients/adminListClients.jsp");
        }
    }
}
