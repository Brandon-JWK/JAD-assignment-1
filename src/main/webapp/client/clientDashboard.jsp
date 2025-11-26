<%-- <%@ page import="models.Client" %>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<%
    Client c = (Client) session.getAttribute("client");

    if (c == null) {
        response.sendRedirect("clientLogin.jsp");
        return;
    }
%>

<div class="container mt-4">
    <h2>Client Dashboard</h2>
    <p>Welcome, <strong><%= c.getFullName() %></strong>!</p>

    <div class="list-group mt-4" style="max-width: 400px;">
        <a href="clientProfile.jsp" class="list-group-item list-group-item-action">
            View Profile
        </a>

        <a href="clientEditProfile.jsp" class="list-group-item list-group-item-action">
            Edit Profile
        </a>

        <a href="clientDeleteAccount.jsp" class="list-group-item list-group-item-action text-danger">
            Delete Account
        </a>
        <a href="booking/viewCart.jsp" class="list-group-item list-group-item-action btn btn-primary mt-2 text-center">
            View Bookings / Cart
        </a>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>  --%>

<%@ page import="models.Client, dao.CartDao" %>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<%
    Client c = (Client) session.getAttribute("client");

    if (c == null) {
        response.sendRedirect("clientLogin.jsp");
        return;
    }

    // Get the number of services in the cart
    CartDao cartDao = new CartDao();
    int cartCount = cartDao.getCartItems(c.getClientId()).size();
%>

<div class="container mt-4">
    <h2>Client Dashboard</h2>
    <p>Welcome, <strong><%= c.getFullName() %></strong>!</p>

    <div class="list-group mt-4" style="max-width: 400px;">
        <a href="clientProfile.jsp" class="list-group-item list-group-item-action">
            View Profile
        </a>

        <a href="clientEditProfile.jsp" class="list-group-item list-group-item-action">
            Edit Profile
        </a>

        <a href="clientDeleteAccount.jsp" class="list-group-item list-group-item-action text-danger">
            Delete Account
        </a>

        <!-- Dynamic View Cart / Bookings button -->
        <a href="<%= request.getContextPath() %>/booking/viewCart.jsp" class="list-group-item list-group-item-action btn btn-primary mt-2 text-center">
            View Bookings (<%= cartCount %>)
        </a>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>