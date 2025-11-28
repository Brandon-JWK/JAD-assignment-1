<%@ page import="models.Client, dao.CartDao" %>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="client-page">

	<%
	    Client c = (Client) session.getAttribute("client");
	
	    if (c == null) {
	        response.sendRedirect("clientLogin.jsp");
	        return;
	    }
	
	    // Get number of items in cart
	    CartDao cartDao = new CartDao();
	    int cartCount = cartDao.getCartItems(c.getClientId()).size();
	%>
	
	<div class="container mt-5" style="max-width: 700px;">
	
	    <h2 class="client-page-title">Your Dashboard</h2>
	    <p class="text-muted mb-4">Welcome back, <strong><%= c.getFullName() %></strong>!</p>
	
	    <div class="client-card">
	
	        <h4 class="mb-3 text-purple">Quick Actions</h4>
	
	        <div class="list-group">
	
	            <a href="clientProfile.jsp"
	               class="list-group-item list-group-item-action py-3">
	                View Profile
	            </a>
	
	            <a href="clientEditProfile.jsp"
	               class="list-group-item list-group-item-action py-3">
	                Edit Profile
	            </a>
	
	            <a href="clientDeleteAccount.jsp"
	               class="list-group-item list-group-item-action py-3 text-danger fw-bold">
	                Delete Account
	            </a>
	
	        </div>
	
	        <a href="<%= request.getContextPath() %>/booking/viewCart.jsp"
	           class="btn btn-client-primary w-100 mt-4">
	            View Bookings (<%= cartCount %>)
	        </a>
	    </div>
	</div>
</div>

<%@ include file="../includes/footer.jsp" %>
