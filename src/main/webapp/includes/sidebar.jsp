<nav class="col-md-2 d-none d-md-block sidebar vh-100">
    <div class="sidebar-sticky p-3">
        <h5 class="sidebar-title">Admin Dashboard</h5>
        <ul class="nav flex-column mt-4">
            <li class="nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/admin/adminDashboard.jsp">Dashboard Home</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/admin/categories/adminListCategories.jsp">Manage Categories</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/admin/services/adminListServices.jsp">Manage Services</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/admin/clients/adminListClients.jsp">Manage Clients</a>
            </li>
            <li class="nav-item">
                <form action="<%=request.getContextPath() %>/AuthController" method="post">
                    <input type="hidden" name="action" value="logout">
                    <button class="btn btn-link nav-link logout-link">Logout</button>
                </form>
            </li>
        </ul>
    </div>
</nav>
