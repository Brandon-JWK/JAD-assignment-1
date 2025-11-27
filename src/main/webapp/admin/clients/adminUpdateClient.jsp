<%@ page import="dao.ClientDao, models.Client" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");

    Client c = new Client(id, fullName, email, null, phone, address);
    ClientDao dao = new ClientDao();

    if (dao.update(c)) {
        response.sendRedirect("adminListClients.jsp");
    } else {
        out.println("Error updating client.");
    }
%>