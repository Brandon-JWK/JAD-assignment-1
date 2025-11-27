<nav class="navbar navbar-expand-lg custom-navbar px-4">

  <!-- Brand -->
  <a class="navbar-brand fw-bold" href="<%=request.getContextPath() %>/public/home.jsp">
    Silver Care
  </a>

  <!-- Right Links -->
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

  </ul>
</nav>
