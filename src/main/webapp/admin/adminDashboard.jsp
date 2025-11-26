<%@ page import="dao.ServiceDao, dao.CategoryDao, dao.ClientDao" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Service, models.Category" %>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>
<%@ include file="../includes/adminSessionCheck.jsp" %>
<%@ include file="../includes/sidebar.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=3">

<%
    ServiceDao serviceDao = new ServiceDao();
    CategoryDao categoryDao = new CategoryDao();
    ClientDao clientDao = new ClientDao();

    int totalServices = serviceDao.getAllServices().size();
    int totalCategories = categoryDao.getAllCategories().size();
    int totalClients = clientDao.getAllClients().size();

    List<Service> serviceList = serviceDao.getAllServices();
%>

<div class="page-wrapper d-flex flex-column">
    <div class="admin-layout d-flex flex-column flex-grow-1">

        <!-- Main Content Area -->
        <main class="admin-content">

            <div class="row">
                <main class="col-md-10 ms-sm-auto px-4">

                    <!-- PAGE TITLE -->
                    <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-4 border-bottom">
                        <h1 class="h2">Dashboard Overview</h1>
                    </div>

                    <!-- DASHBOARD METRICS -->
                    <div class="row g-3 mb-4">

                        <!-- Total Services -->
                        <div class="col-md-4">
                            <div class="card dashboard-card p-4 text-center shadow-sm">
                                <h5 class="mb-2">Total Services</h5>
                                <h2 class="dashboard-value text-primary"><%= totalServices %></h2>
                            </div>
                        </div>

                        <!-- Total Categories -->
                        <div class="col-md-4">
                            <div class="card dashboard-card p-4 text-center shadow-sm">
                                <h5 class="mb-2">Total Categories</h5>
                                <h2 class="dashboard-value text-success"><%= totalCategories %></h2>
                            </div>
                        </div>

                        <!-- Total Clients -->
                        <div class="col-md-4">
                            <div class="card dashboard-card p-4 text-center shadow-sm">
                                <h5 class="mb-2">Total Clients</h5>
                                <h2 class="dashboard-value text-danger"><%= totalClients %></h2>
                            </div>
                        </div>

                    </div>

                    <!-- TABLE SECTION -->
                    <div class="table-responsive card shadow-sm p-3">
                        <h4 class="mb-3">Recent Services</h4>
                        <table class="table table-striped table-bordered align-middle">
                            <thead>
                                <tr>
                                    <th>Service Name</th>
                                    <th>Category</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Service s : serviceList) { 
                                    Category cat = categoryDao.getCategoryById(s.getCategoryId());
                                %>
                                    <tr>
                                        <td><%= s.getServiceName() %></td>
                                        <td><%= cat != null ? cat.getCategoryName() : "N/A" %></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                </main>
            </div>

        </main>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
