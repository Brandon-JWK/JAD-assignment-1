package controllers;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.ClientDao;

@WebServlet("/AdminController")
public class AdminController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        ClientDao dao = new ClientDao();

        if ("deleteClient".equals(action)) {
            int id = Integer.parseInt(request.getParameter("clientId"));
            dao.delete(id);
            response.sendRedirect("admin/clients/adminListClients.jsp");
        }
    }
}