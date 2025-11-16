package controllers;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.CategoryDao;
import models.Category;

@WebServlet("/CategoryController")
public class CategoryController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        CategoryDao dao = new CategoryDao();

        if ("addCategory".equals(action)) {
            Category c = new Category(
                0,
                request.getParameter("name"),
                request.getParameter("desc")
            );
            dao.addCategory(c);
            response.sendRedirect("admin/categories/adminListCategories.jsp");
        }

        if ("updateCategory".equals(action)) {
            Category c = new Category(
                Integer.parseInt(request.getParameter("id")),
                request.getParameter("name"),
                request.getParameter("desc")
            );

            dao.updateCategory(c);
            response.sendRedirect("admin/categories/adminListCategories.jsp");
        }

        if ("deleteCategory".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteCategory(id);
            response.sendRedirect("admin/categories/adminListCategories.jsp");
        }
    }
}