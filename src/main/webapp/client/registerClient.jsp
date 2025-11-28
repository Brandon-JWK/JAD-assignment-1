<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="client-page">

	<div class="container mt-5" style="max-width: 600px;">
	
	    <div class="client-card">
	
	        <h2 class="client-page-title">Create Client Account</h2>
	
	        <form action="<%=request.getContextPath() %>/ClientController" method="post">
	            <input type="hidden" name="action" value="register">
	
	            <div class="mb-3">
	                <label class="form-label">Full Name</label>
	                <input type="text" name="fullName" class="form-control" required>
	            </div>
	
	            <div class="mb-3">
	                <label class="form-label">Email</label>
	                <input type="email" name="email" class="form-control" required>
	            </div>
	
	            <div class="mb-3">
	                <label class="form-label">Password</label>
	                <input type="password" name="password" class="form-control" required>
	            </div>
	
	            <div class="mb-3">
	                <label class="form-label">Phone Number</label>
	                <input type="text" name="phone" class="form-control">
	            </div>
	
	            <div class="mb-3">
	                <label class="form-label">Address</label>
	                <textarea name="address" class="form-control" rows="3"></textarea>
	            </div>
	
	            <% if (request.getAttribute("error") != null) { %>
	                <p class="text-danger small"><%= request.getAttribute("error") %></p>
	            <% } %>
	
	            <button class="btn btn-client-primary w-100">Register</button>
	        </form>
	
	    </div>
	</div>
</div>

<%@ include file="../includes/footer.jsp" %>
