package controllers;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.AdminDao;
import dao.ClientDao;
import models.Client;

@WebServlet("/AuthController")
public class AuthController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // CLIENT LOGIN
        if ("clientLogin".equals(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            ClientDao dao = new ClientDao();
            Client c = dao.login(email, password);

            if (c != null) {
                HttpSession session = request.getSession();
                session.setAttribute("client", c);
                response.sendRedirect("client/clientDashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid login!");
                request.getRequestDispatcher("client/clientLogin.jsp").forward(request, response);
            }
        }

        // ADMIN LOGIN
        if ("adminLogin".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            AdminDao dao = new AdminDao();
            boolean valid = dao.validateLogin(username, password);

            if (valid) {
                HttpSession session = request.getSession();
                session.setAttribute("admin", username);
                response.sendRedirect("admin/adminDashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid login!");
                request.getRequestDispatcher("admin/adminLogin.jsp").forward(request, response);
            }
        }

        // LOGOUT
        if ("logout".equals(action)) {
            request.getSession().invalidate();
            response.sendRedirect("public/home.jsp");
        }
    }
}