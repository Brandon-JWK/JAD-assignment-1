<%@ page import="models.Client" %>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="client-page">

	<%
	    Client c = (Client) session.getAttribute("client");
	    if (c == null) {
	        response.sendRedirect("clientLogin.jsp");
	        return;
	    }
	%>
	
	<div class="container mt-5" style="max-width: 600px;">
	
	    <div class="client-card">
	        <h2 class="client-page-title text-danger">Delete Account</h2>
	
	        <p class="text-muted">
	            Are you sure you want to permanently delete your account?
	            This action cannot be undone.
	        </p>
	
	        <form action="<%=request.getContextPath() %>/ClientController" method="post">
	            <input type="hidden" name="action" value="deleteClient">
	            <input type="hidden" name="clientId" value="<%= c.getClientId() %>">
	
	            <button class="btn btn-client-danger w-100 mb-2">
	                Yes, Delete My Account
	            </button>
	
	            <a href="clientDashboard.jsp" class="btn btn-secondary w-100">
	                Cancel
	            </a>
	        </form>
	    </div>
	</div>
</div>

<%@ include file="../includes/footer.jsp" %>
