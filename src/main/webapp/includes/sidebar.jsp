<!-- Sidebar Toggle Button (for small screens) -->
<button class="admin-sidebar-toggle d-md-none">
    <span class="hamburger-icon">&#9776;</span>
</button>

<!-- Screen-Dim Overlay -->
<div id="sidebarOverlay" class="sidebar-overlay d-md-none"></div>

<!-- SIDEBAR -->
<nav class="sidebar col-md-2 vh-100" id="adminSidebar">
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
        </ul>
    </div>
</nav>
