<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="client-page">

	<div class="container mt-5" style="max-width: 450px;">
	
	    <div class="client-card">
	        <h2 class="client-page-title">Client Login</h2>
	
	        <form action="<%=request.getContextPath() %>/AuthController" method="post">
	            <input type="hidden" name="action" value="clientLogin">
	
	            <div class="mb-3">
	                <label class="form-label">Email</label>
	                <input type="email" name="email" class="form-control" required>
	            </div>
	
	            <div class="mb-3">
	                <label class="form-label">Password</label>
	                <input type="password" name="password" class="form-control" required>
	            </div>
	
	            <% if (request.getAttribute("error") != null) { %>
	                <p class="text-danger small"><%= request.getAttribute("error") %></p>
	            <% } %>
	
	            <button class="btn btn-client-primary w-100">Login</button>
	        </form>
	
	        <p class="mt-3 text-center text-muted">
	            New here?
	            <a href="registerClient.jsp" class="text-purple fw-bold">Register now</a>
	        </p>
	    </div>
	</div>
</div>

<%@ include file="../includes/footer.jsp" %>
