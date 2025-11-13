//package controllers;
//
//import java.io.IOException;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//
//import dao.UserDao;
//import util.DB;
//
//@WebServlet(name="UserController", urlPatterns= {"/users"})
//public class UserController extends HttpServlet {
//	private static final long serialVersionUID = 1L;
//
//	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//		String loginId = req.getParameter("loginId");
//        String password = req.getParameter("password");
//        
//        try {
//            UserDao userDao = new UserDao();
//            boolean isValid = userDao.getUser(loginId, password); // returns true if user exists
//
//            if (isValid) {
//                // Pass the loginId as a request attribute to verifyUser.jsp
//                req.setAttribute("loginid", loginId);
//                req.getRequestDispatcher("pract2/verifyUser.jsp").forward(req, resp);
//            } else {
//                // Redirect with error
//                resp.sendRedirect("pract2/login.jsp?errCode=invalidLogin");
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            resp.sendRedirect("pract2/login.jsp?errCode=serverError");
//        }	
//     }
//}
//

