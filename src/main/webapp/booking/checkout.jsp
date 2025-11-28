<%@ page import="dao.CartDao, models.Client, models.Service, java.util.*" %>

<%
    Client c = (Client) session.getAttribute("client");

    if (c == null) {
        response.sendRedirect(request.getContextPath() + "/client/clientLogin.jsp");
        return;
    }

    CartDao cartDao = new CartDao();
    List<Service> items = cartDao.getCartItems(c.getClientId());
%>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="client-page">
<div class="container mt-5" style="max-width: 800px;">

    <h2 class="client-page-title">Confirm Your Booking</h2>

    <div class="client-card">

        <% if (items.isEmpty()) { %>

            <p class="text-muted">Your cart is empty.</p>

        <% } else { %>

            <table class="table client-table mb-4">
                <thead>
                    <tr>
                        <th>Service</th>
                        <th>Description</th>
                        <th>Price</th>
                    </tr>
                </thead>

                <tbody>
                <% 
                    double total = 0;
                    for (Service s : items) {
                        total += s.getPrice();
                %>
                    <tr>
                        <td><%= s.getServiceName() %></td>
                        <td><%= s.getServiceDesc() %></td>
                        <td>$<%= s.getPrice() %></td>
                    </tr>
                <% } %>
                </tbody>

                <tfoot>
                    <tr>
                        <th colspan="2" class="text-end">Total:</th>
                        <th>$<%= total %></th>
                    </tr>
                </tfoot>
            </table>

            <form action="<%= request.getContextPath() %>/CheckoutController" method="post">
                <button class="btn btn-client-primary w-100">
                    Confirm Booking
                </button>
            </form>

        <% } %>

    </div>
</div>
</div>

<%@ include file="../includes/footer.jsp" %>
