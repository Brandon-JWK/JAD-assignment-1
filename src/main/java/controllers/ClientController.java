package controllers;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.ClientDao;
import models.Client;

@WebServlet("/ClientController")
public class ClientController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        ClientDao dao = new ClientDao();

        // REGISTER
        if ("register".equals(action)) {
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
        }

        // UPDATE PROFILE
        if ("updateProfile".equals(action)) {
            int id = Integer.parseInt(request.getParameter("clientId"));

            Client c = new Client(
                id,
                request.getParameter("fullName"),
                request.getParameter("email"),
                "",
                request.getParameter("phone"),
                request.getParameter("address")
            );

            if (dao.update(c)) {
                response.sendRedirect("client/clientProfile.jsp");
            } else {
                request.setAttribute("error", "Update failed");
                request.getRequestDispatcher("client/clientEditProfile.jsp").forward(request, response);
            }
        }

        // DELETE CLIENT ACCOUNT
        if ("deleteClient".equals(action)) {
            int id = Integer.parseInt(request.getParameter("clientId"));
            dao.delete(id);
            request.getSession().invalidate();
            response.sendRedirect("public/home.jsp");
        }
    }
}