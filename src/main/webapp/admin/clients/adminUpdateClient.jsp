<%@ page import="dao.ClientDao, models.Client" %>

<%
    // Get all form parameters
    int id = Integer.parseInt(request.getParameter("id"));
    String fullName = request.getParameter("fullName");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String emergencyContactName = request.getParameter("emergencyContactName");
    String emergencyContactPhone = request.getParameter("emergencyContactPhone");
    String medicalInfo = request.getParameter("medicalInfo");

    // Create Client object
    Client c = new Client(
        id,
        fullName,
        email,
        null, // Password unchanged for admin edit
        phone,
        address,
        emergencyContactName,
        emergencyContactPhone,
        medicalInfo
    );

    ClientDao dao = new ClientDao();

    // Update client in database
    if (dao.update(c)) {
        response.sendRedirect("adminListClients.jsp");
    } else {
        out.println("<p style='color:red;'>Error updating client. Please try again.</p>");
    }
%>
