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

<div class="client-page">

	<div class="container mt-5" style="max-width: 900px;">
	
	    <h2 class="client-page-title">Your Bookings</h2>
	
	    <% if (cart.isEmpty()) { %>
	
	        <div class="client-card text-center">
	            <h4 class="text-purple mb-2">Your cart is empty</h4>
	            <p class="text-muted mb-4">
	                You haven't added any services yet.
	            </p>
	
	            <a href="<%= request.getContextPath() %>/public/serviceCategories.jsp"
	               class="btn btn-client-primary w-100">
	                Browse Services
	            </a>
	        </div>
	
	    <% } else { %>
	
	        <div class="client-card">
	
	            <table class="table client-table mb-4">
	                <thead>
	                    <tr>
	                        <th>Service</th>
	                        <th>Description</th>
	                        <th>Price</th>
	                        <th style="width: 110px;">Action</th>
	                    </tr>
	                </thead>
	
	                <tbody>
	                <%
	                    double total = 0;
	                    for (Service s : cart) {
	                        total += s.getPrice();
	                %>
	                    <tr>
	                        <td><%= s.getServiceName() %></td>
	                        <td style="max-width: 300px;"><%= s.getServiceDesc() %></td>
	                        <td>$<%= s.getPrice() %></td>
	                        <td>
	                            <a href="<%= request.getContextPath() %>/CartController?action=remove&serviceId=<%= s.getServiceId() %>"
	                               class="btn btn-client-danger btn-sm w-100">
	                                Remove
	                            </a>
	                        </td>
	                    </tr>
	                <% } %>
	                </tbody>
	
	                <tfoot>
	                    <tr>
	                        <th colspan="2" class="text-end">Total:</th>
	                        <th colspan="2">$<%= total %></th>
	                    </tr>
	                </tfoot>
	            </table>
	
	            <a href="<%= request.getContextPath() %>/booking/checkout.jsp"
	               class="btn btn-client-primary w-100">
	                Confirm Booking
	            </a>
	
	        </div>
	
	    <% } %>
	
	</div>

</div>

<%@ include file="../includes/footer.jsp" %>
