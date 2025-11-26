<%@ page import="dao.CartDao, models.Service, models.Client, java.util.*" %>

<%
    Client loggedInClient = (Client) session.getAttribute("client");

    if (loggedInClient == null) {
        response.sendRedirect(request.getContextPath() + "/client/clientLogin.jsp");
        return;
    }

    int clientId = loggedInClient.getClientId();
    CartDao dao = new CartDao();
    List<Service> cart = dao.getCartItems(clientId);
%>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="container mt-4">

    <h2>Your Bookings</h2>

    <%
        if (cart.isEmpty()) {
    %>
        <p>You have no bookings.</p>
    <%
        } else {
    %>

    <table class="table table-bordered">
        <tr>
            <th>Service</th>
            <th>Description</th>
            <th>Price</th>
            <th>Action</th>
        </tr>

        <%
            double total = 0;
            for (Service s : cart) {
                total += s.getPrice();
        %>

        <tr>
            <td><%= s.getServiceName() %></td>
            <td><%= s.getServiceDesc() %></td>
            <td>$<%= s.getPrice() %></td>
            <td>
                <a href="<%= request.getContextPath() %>/CartController?action=remove&serviceId=<%= s.getServiceId() %>" 
                   class="btn btn-danger btn-sm">Remove</a>
            </td>
        </tr>

        <% } %>

        <tr>
            <th colspan="2">Total</th>
            <th colspan="2">$<%= total %></th>
        </tr>
    </table>

    <a href="#" class="btn btn-success">Confirm Booking</a>

    <%
        }
    %>

</div>

<%@ include file="../includes/footer.jsp" %>