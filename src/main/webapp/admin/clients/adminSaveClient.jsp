<%@ page import="dao.ClientDao, models.Client" %>

<%
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String password = request.getParameter("password");

    Client c = new Client(
        0,
        fullName,
        email,
        password,
        phone,
        address
    );

    ClientDao dao = new ClientDao();

    if (dao.register(c)) {
        response.sendRedirect("adminListClients.jsp");
    } else {
        request.setAttribute("error", "Failed to create client (email may already exist).");
        request.getRequestDispatcher("adminAddClient.jsp").forward(request, response);
    }
%>
