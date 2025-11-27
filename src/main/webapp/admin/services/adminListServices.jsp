<%@ page import="dao.ServiceDao, dao.CategoryDao, java.util.List, models.Service, models.Category" %>
<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/adminSessionCheck.jsp" %>
<%@ include file="../../includes/sidebar.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=3">

<%
    ServiceDao serviceDao = new ServiceDao();
    List<Service> services = serviceDao.getAllServices();
    CategoryDao categoryDao = new CategoryDao();
%>

<div class="page-wrapper d-flex flex-column">
	<div class="admin-layout d-flex flex-column flex-grow-1">

        <main class="admin-content">
            <div class="row">

                <!-- MAIN CONTENT -->
                <main class="col-md-10 ms-sm-auto px-4">

                    <!-- Dashboard-style header -->
                    <div class="admin-page-header d-flex justify-content-between 
                                flex-wrap flex-md-nowrap align-items-center 
                                pt-3 pb-2 mb-3 border-bottom">

                        <h1 class="h2">Services</h1>

                        <a href="<%=request.getContextPath() %>/admin/services/adminAddService.jsp" 
                           class="btn btn-primary btn-lg">+ Add Service</a>
                    </div>

                    <!-- Table -->
                    <div class="table-responsive">
                        <table class="table table-striped table-bordered align-middle">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Category</th>
                                    <th>Service Name</th>
                                    <th>Image</th>
                                    <th>Price</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>

                            <tbody>
                            <% for (Service s : services) { 
                                Category cat = categoryDao.getCategoryById(s.getCategoryId());
                            %>
                                <tr>
                                    <td><%= s.getServiceId() %></td>

                                    <td><%= (cat != null) ? cat.getCategoryName() : "N/A" %></td>

                                    <td><%= s.getServiceName() %></td>

                                    <td>
                                        <img src="<%= request.getContextPath() + "/" + s.getImagePath() %>"
                                             width="50" class="rounded"
                                             alt="<%= s.getServiceName() %>">
                                    </td>

                                    <td>$<%= s.getPrice() %></td>

                                    <td>
                                        <a href="adminEditService.jsp?serviceId=<%= s.getServiceId() %>" 
                                           class="btn btn-warning btn-sm">Edit</a>

                                        <form action="<%= request.getContextPath() %>/ServiceController"
                                              method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="deleteService">
                                            <input type="hidden" name="serviceId" value="<%= s.getServiceId() %>">

                                            <button type="submit"
                                                    class="btn btn-danger btn-sm"
                                                    onclick="return confirm('Are you sure you want to delete this service?');">
                                                Delete
                                            </button>
                                        </form>
                                    </td>
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

<%@ include file="../../includes/footer.jsp" %>
