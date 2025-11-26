<%@ page import="dao.ServiceDao, dao.CategoryDao, models.Service, models.Category, java.util.List" %>
<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/adminSessionCheck.jsp" %>
<%@ include file="../../includes/sidebar.jsp" %>
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=1">

<%
    // Get service ID from URL
    int serviceId = Integer.parseInt(request.getParameter("serviceId"));

    ServiceDao serviceDao = new ServiceDao();
    CategoryDao categoryDao = new CategoryDao();

    Service service = serviceDao.getServiceById(serviceId);
    List<Category> categories = categoryDao.getAllCategories();

    if (service == null) {
        out.println("<h3>Service not found!</h3>");
        return;
    }
%>

<div class="container-fluid">
    <div class="row">

        <!-- Sidebar -->
        <div class="col-md-2 d-none d-md-block bg-light sidebar vh-100">
            <%@ include file="../../includes/sidebar.jsp" %>
        </div>

        <!-- Main Content -->
        <main class="col-md-10 ms-sm-auto px-4">
            <div class="admin-content">

	            <h2 class="mt-4">Edit Service</h2>
	
	            <form action="<%= request.getContextPath() %>/ServiceController" method="post" class="mt-4">
	
	                <input type="hidden" name="action" value="updateService">
	                <input type="hidden" name="serviceId" value="<%= service.getServiceId() %>">
	
	                <!-- Service Name -->
	                <div class="mb-3">
	                    <label class="form-label">Service Name</label>
	                    <input type="text" 
	                           name="serviceName" 
	                           class="form-control" 
	                           value="<%= service.getServiceName() %>" 
	                           required>
	                </div>
	
	                <!-- Description -->
	                <div class="mb-3">
	                    <label class="form-label">Description</label>
	                    <textarea name="serviceDesc" 
	                              class="form-control" 
	                              rows="3" 
	                              required><%= service.getServiceDesc() %></textarea>
	                </div>
	
	                <!-- Price -->
	                <div class="mb-3">
	                    <label class="form-label">Price</label>
	                    <input type="number" 
	                           step="0.01" 
	                           name="price" 
	                           class="form-control" 
	                           value="<%= service.getPrice() %>" 
	                           required>
	                </div>
	
	                <!-- Category Dropdown -->
	                <div class="mb-3">
	                    <label class="form-label">Category</label>
	                    <select name="categoryId" class="form-control" required>
	                        <% for (Category c : categories) { %>
	                            <option value="<%= c.getCategoryId() %>"
	                                <%= (c.getCategoryId() == service.getCategoryId()) ? "selected" : "" %>>
	                                <%= c.getCategoryName() %>
	                            </option>
	                        <% } %>
	                    </select>
	                </div>
	
	                <!-- Image Path -->
	                <div class="mb-3">
	                    <label class="form-label">Image Path</label>
	                    <input type="text" 
	                           name="imagePath" 
	                           class="form-control" 
	                           value="<%= service.getImagePath() %>">
	                </div>
	
	                <!-- Buttons -->
	                <button type="submit" class="btn btn-primary">Save Changes</button>
	                <a href="adminListServices.jsp" class="btn btn-secondary">Cancel</a>
	
	            </form>
	         </div>
        </main>

    </div>
</div>

<%@ include file="../../includes/footer.jsp" %>
