<nav class="navbar navbar-expand-lg navbar-light bg-light px-3">

  <a class="navbar-brand" href="/ST0510-JAD-Assignment1/public/home.jsp">
    Silver Care
  </a>

  <ul class="navbar-nav ms-auto">

    <!-- PUBLIC -->
    <li class="nav-item">
      <a class="nav-link" href="/ST0510-JAD-Assignment1/public/serviceCategories.jsp">Services</a>
    </li>

    <!-- CLIENT LOGGED IN -->
    <%
      Object client = session.getAttribute("client");
      if (client != null) {
    %>
      <li class="nav-item">
        <a class="nav-link" href="/ST0510-JAD-Assignment1/client/clientDashboard.jsp">Dashboard</a>
      </li>
      <li class="nav-item">
        <form action="/ST0510-JAD-Assignment1/AuthController" method="post">
          <input type="hidden" name="action" value="logout">
          <button class="btn btn-danger btn-sm">Logout</button>
        </form>
      </li>
    <% } else { %>
      <!-- NOT LOGGED IN -->
      <li class="nav-item">
        <a class="nav-link" href="/ST0510-JAD-Assignment1/client/clientLogin.jsp">Login</a>
      </li>
    <% } %>

    <!-- ADMIN -->
    <%
      Object admin = session.getAttribute("admin");
      if (admin != null) {
    %>
      <li class="nav-item">
        <a class="nav-link" href="/ST0510-JAD-Assignment1/admin/adminDashboard.jsp">Admin</a>
      </li>
    <% } %>

  </ul>
</nav>
