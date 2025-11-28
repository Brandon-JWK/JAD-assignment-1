<nav class="navbar navbar-expand-lg custom-navbar px-4">

  <!-- Brand -->
  <a class="navbar-brand fw-bold" href="<%=request.getContextPath() %>/public/index.jsp">
    Silver Care
  </a>
  <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
          data-bs-target="#clientNav" aria-controls="clientNav"
          aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
  </button>
  <!-- Right Links -->
  <div class="collapse navbar-collapse" id="clientNav">
	 <ul class="navbar-nav ms-auto align-items-center">
	
	    <!-- PUBLIC (ALWAYS SHOW) -->
	    <li class="nav-item">
	      <a class="nav-link" href="<%=request.getContextPath() %>/public/serviceCategories.jsp">
	        Services
	      </a>
	    </li>
	
	    <%
	        Object client = session.getAttribute("client");
	        Object admin  = session.getAttribute("admin");
	    %>
	
	    <!-- CLIENT: login or dashboard -->
	    <li class="nav-item">
	      <% if (client != null) { %>
	        <a class="nav-link" href="<%=request.getContextPath() %>/client/clientDashboard.jsp">
	          Client Dashboard
	        </a>
	      <% } else { %>
	        <a class="nav-link" href="<%=request.getContextPath() %>/client/clientLogin.jsp">
	          Client Login
	        </a>
	      <% } %>
	    </li>
	
	    <!-- ADMIN: login or dashboard -->
	    <li class="nav-item">
	      <% if (admin != null) { %>
	        <a class="nav-link admin-link" href="<%=request.getContextPath() %>/admin/adminDashboard.jsp">
	          Admin Dashboard
	        </a>
	      <% } else { %>
	        <a class="nav-link admin-link" href="<%=request.getContextPath() %>/admin/adminLogin.jsp">
	          Admin Login
	        </a>
	      <% } %>
	    </li>
	    
		<li class="nav-item">
		    <form action="<%=request.getContextPath() %>/AuthController" method="post">
		        <input type="hidden" name="action" value="logout">
		        <button class="btn nav-link text-danger fw-bold" style="padding: 8px 14px;">Logout</button>
		    </form>
		</li>
	  </ul>
   </div>
</nav>
