package controllers;

import dao.FeedbackDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import models.Feedback;

@WebServlet("/FeedbackController")
public class FeedbackController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            int clientId = Integer.parseInt(request.getParameter("clientId"));
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comments = request.getParameter("comments");

            Feedback fb = new Feedback();
            fb.setClientId(clientId);
            fb.setServiceId(serviceId);
            fb.setRating(rating);
            fb.setComments(comments);

            FeedbackDao dao = new FeedbackDao();
            dao.addFeedback(fb);

            response.sendRedirect(request.getContextPath() + "/public/serviceDetails.jsp?serviceId=" + serviceId);
            return;
        }
    }
}
