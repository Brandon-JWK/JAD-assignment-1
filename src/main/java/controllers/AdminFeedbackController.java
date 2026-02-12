package controllers;

import dao.AdminFeedbackDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/AdminFeedbackController")
public class AdminFeedbackController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        AdminFeedbackDao dao = new AdminFeedbackDao();

        if ("deleteFeedback".equals(action)) {
            int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
            dao.deleteFeedback(feedbackId);
        }

        response.sendRedirect(request.getContextPath() + "/admin/feedback/adminListFeedback.jsp");
    }
}
