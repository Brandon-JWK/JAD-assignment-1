<nav class="navbar navbar-expand-lg custom-navbar px-4">

  <!-- Brand -->
  <a class="navbar-brand fw-bold" href="<%=request.getContextPath() %>/public/home.jsp">
    Silver Care
  </a>

  <!-- Right Links -->
  <ul class="navbar-nav ms-auto align-items-center">

    <!-- PUBLIC -->
    <li class="nav-item">
      <a class="nav-link" href="<%=request.getContextPath() %>/public/serviceCategories.jsp">Services</a>
    </li>

    <!-- CLIENT LOGGED IN -->
    <%
      Object client = session.getAttribute("client");
      if (client != null) {
    %>
      <li class="nav-item">
        <a class="nav-link" href="<%=request.getContextPath() %>/client/clientDashboard.jsp">Dashboard</a>
      </li>

      <!-- CLEANER logout styling -->
      <li class="nav-item">
        <form action="<%=request.getContextPath() %>/AuthController" method="post" class="d-inline">
          <input type="hidden" name="action" value="logout">
          <button class="btn btn-outline-danger btn-sm ms-2">Logout</button>
        </form>
      </li>
    <% } else { %>

      <!-- NOT LOGGED IN -->
      <li class="nav-item">
        <a class="nav-link" href="<%=request.getContextPath() %>/client/clientLogin.jsp">Login</a>
      </li>

    <% } %>

    <!-- ADMIN -->
    <%
      Object admin = session.getAttribute("admin");
      if (admin != null) {
    %>
      <li class="nav-item">
        <a class="nav-link admin-link" href="<%=request.getContextPath() %>/admin/adminDashboard.jsp">Admin</a>
      </li>
    <% } %>

  </ul>
</nav>
