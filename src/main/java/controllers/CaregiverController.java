package controllers;

import dao.CaregiverDao;
import models.Caregiver;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/CaregiverController")
public class CaregiverController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("login".equals(action)) {

            String email = request.getParameter("email");
            String password = request.getParameter("password");

            CaregiverDao dao = new CaregiverDao();
            Caregiver caregiver = dao.login(email, password);

            if (caregiver != null) {

                request.getSession().setAttribute("caregiver", caregiver);
                response.sendRedirect(request.getContextPath() + "/caregiver/caregiverDashboard.jsp");

            } else {

                request.setAttribute("error", "Invalid email or password");
                request.getRequestDispatcher("/caregiver/caregiverLogin.jsp")
                       .forward(request, response);
            }
        }
    }
}
