package controllers;

import dao.CaregiverDao;
import models.Caregiver;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/CaregiverServiceController")
public class CaregiverServiceController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Caregiver caregiver = (session != null) ? (Caregiver) session.getAttribute("caregiver") : null;

        if (caregiver == null) {
            response.sendRedirect("caregiverLogin.jsp");
            return;
        }

        // Use default DAO constructor (handles connection internally)
        CaregiverDao dao = new CaregiverDao();

        String action = request.getParameter("action");
        String statusIdParam = request.getParameter("statusId");
        if (action != null && statusIdParam != null) {
            int statusId = Integer.parseInt(statusIdParam);
            switch (action) {
                case "checkin":
				try {
					dao.checkIn(statusId);
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                    break;
                case "checkout":
				try {
					dao.checkOut(statusId);
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                    break;
                case "addnote":
                    String notes = request.getParameter("notes");
                    dao.addNotes(statusId, notes);
                    break;
            }
        }

        // After action or if no action, show dashboard
        request.getRequestDispatcher("/caregiver/caregiverDashboard.jsp").forward(request, response);
    }
}
