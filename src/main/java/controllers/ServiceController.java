package controllers;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.ServiceDao;
import models.Service;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.File;
import jakarta.servlet.http.Part;

@WebServlet("/ServiceController")
@MultipartConfig
public class ServiceController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        ServiceDao dao = new ServiceDao();

        if ("addService".equals(action)) {

            String serviceName = request.getParameter("serviceName");
            String serviceDesc = request.getParameter("serviceDesc");
            double price = Double.parseDouble(request.getParameter("price"));
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));

            // Handle image upload
            Part filePart = request.getPart("imageFile");
            String fileName = filePart.getSubmittedFileName();

            String uploadPath = getServletContext().getRealPath("") + "images";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            filePart.write(uploadPath + File.separator + fileName);

            String imagePath = "images/" + fileName;

            Service s = new Service(
                0,
                serviceName,
                serviceDesc,
                price,
                categoryId,
                imagePath
            );

            dao.addService(s);

            response.sendRedirect("admin/services/adminListServices.jsp");
        }


        if ("updateService".equals(action)) {
            Service s = new Service(
                Integer.parseInt(request.getParameter("serviceId")),
                request.getParameter("serviceName"),
                request.getParameter("serviceDesc"),
                Double.parseDouble(request.getParameter("price")),
                Integer.parseInt(request.getParameter("categoryId")),
                request.getParameter("imagePath")
            );
            dao.updateService(s);
            response.sendRedirect("admin/services/adminListServices.jsp");
        }

        if ("deleteService".equals(action)) {
            int id = Integer.parseInt(request.getParameter("serviceId"));
            dao.deleteService(id);
            response.sendRedirect("admin/services/adminListServices.jsp");
        }
    }
}


