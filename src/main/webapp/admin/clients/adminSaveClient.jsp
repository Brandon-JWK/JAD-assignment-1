<%@ page import="dao.ClientDao, models.Client" %>

<%
    String fullName = request.getParameter("fullName");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String emergencyContactName = request.getParameter("emergencyContactName");
    String emergencyContactPhone = request.getParameter("emergencyContactPhone");
    String medicalInfo = request.getParameter("medicalInfo");
    String password = request.getParameter("password");

    Client c = new Client(
        0,                  // clientId auto-generated
        fullName,
        email,
        password,
        phone,
        address,
        emergencyContactName,
        emergencyContactPhone,
        medicalInfo
    );

    ClientDao dao = new ClientDao();

    if (dao.register(c)) {
        response.sendRedirect("adminListClients.jsp");
    } else {
        request.setAttribute("error", "Failed to create client (email may already exist).");
        request.getRequestDispatcher("adminAddClient.jsp").forward(request, response);
    }
%>
