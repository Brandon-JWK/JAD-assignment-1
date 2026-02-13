<%@ page import="dao.ServiceDao, dao.CategoryDao, models.Service, models.Category, java.util.List" %>
<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/sidebar.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=3">

<%
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

<div class="page-wrapper d-flex flex-column">
    <div class="admin-layout d-flex flex-column flex-grow-1">

        <div class="row">

            <main class="col-md-10 ms-sm-auto px-4 admin-content">

                <h1 class="h2 mt-4 mb-3 border-bottom">Edit Service</h1>

                <div class="admin-form-card">

                    <form action="<%=request.getContextPath()%>/ServiceController"
      method="post"
      enctype="multipart/form-data">

                        <input type="hidden" name="action" value="updateService">
                        <input type="hidden" name="serviceId" value="<%= service.getServiceId() %>">

                        <!-- Service Name -->
                        <div class="form-group">
                            <label>Service Name</label>
                            <input type="text" name="serviceName" class="form-control"
                                   value="<%= service.getServiceName() %>" required placeholder=" ">
                        </div>

                        <!-- Description -->
                        <div class="form-group">
                            <label>Description</label>
                            <textarea name="serviceDesc" class="form-control" required placeholder=" ">
                                <%= service.getServiceDesc() %>
                            </textarea>
                        </div>

                        <!-- Price -->
                        <div class="form-group">
                            <label>Price</label>
                            <input type="number" step="0.01" name="price" class="form-control"
                                   value="<%= service.getPrice() %>" required placeholder=" ">
                        </div>

                        <!-- Category Dropdown -->
                        <div class="form-group">
                            <label>Category</label>
                            <select name="categoryId" class="form-control" required>
                                <% for (Category c : categories) { %>
                                    <option value="<%= c.getCategoryId() %>"
                                            <%= (c.getCategoryId() == service.getCategoryId()) ? "selected" : "" %>>
                                        <%= c.getCategoryName() %>
                                    </option>
                                <% } %>
                            </select>
                        </div>

                        <div class="form-group">
    <label>Current Image</label><br>
    <img src="<%= request.getContextPath() + "/" + service.getImagePath() %>"
         width="150"
         style="margin-bottom:10px;">
</div>

<div class="form-group">
    <label>Change Image (Optional)</label>
    <input type="file" name="imageFile" class="form-control" accept="image/*">
</div>

<!-- Keep old image path hidden -->
<input type="hidden" name="existingImagePath"
       value="<%= service.getImagePath() %>">


                        <div class="mt-4">
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                            <a href="adminListServices.jsp" class="btn btn-secondary ms-2">Cancel</a>
                        </div>

                    </form>

                </div>

            </main>
        </div>
    </div>
</div>

<%@ include file="../../includes/footer.jsp" %>
