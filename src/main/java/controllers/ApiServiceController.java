package controllers;

import dao.ServiceDao;
import models.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/services")
public class ApiServiceController extends HttpServlet {

    private final ServiceDao serviceDao = new ServiceDao();

    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoryIdStr = request.getParameter("categoryId");
        if (categoryIdStr == null || categoryIdStr.isBlank()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\":\"categoryId is required\"}");
            return;
        }

        try {
            int categoryId = Integer.parseInt(categoryIdStr);

            // Must exist in your ServiceDao
            List<Service> services = serviceDao.getServicesByCategory(categoryId);

            StringBuilder json = new StringBuilder();
            json.append("[");

            for (int i = 0; i < services.size(); i++) {
                Service s = services.get(i);

                // IMPORTANT: adjust these getters to match your Service.java exactly
                int serviceId = s.getServiceId();
                String serviceName = s.getServiceName();
                double price = s.getPrice();
                String imagePath = null;

                // If your Service model uses a different image getter, change here
                // e.g. s.getImage(), s.getImageUrl(), s.getServiceImage(), etc.
                try {
                    imagePath = s.getImagePath();
                } catch (Exception ignored) {
                    imagePath = "";
                }

                json.append("{")
                        .append("\"serviceId\":").append(serviceId).append(",")
                        .append("\"serviceName\":\"").append(esc(serviceName)).append("\",")
                        .append("\"price\":").append(price).append(",")
                        .append("\"imagePath\":\"").append(esc(imagePath)).append("\"")
                        .append("}");

                if (i < services.size() - 1) json.append(",");
            }

            json.append("]");

            response.setStatus(HttpServletResponse.SC_OK);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json.toString());

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\":\"categoryId must be an integer\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"error\":\"Failed to fetch services\"}");
        }
    }
}
