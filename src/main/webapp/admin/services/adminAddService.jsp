<%@ page import="dao.CategoryDao, java.util.List, models.Category" %>
<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/sidebar.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=3">

<%
    CategoryDao dao = new CategoryDao();
    List<Category> categories = dao.getAllCategories();
%>

<div class="page-wrapper d-flex flex-column">
    <div class="admin-layout d-flex flex-column flex-grow-1">

        <div class="row">
        
            <main class="col-md-10 ms-sm-auto px-4 admin-content">

                <h1 class="h2 pt-3 pb-2 mb-3 border-bottom">Add New Service</h1>

                <div class="admin-form-card">
                    <form action="<%=request.getContextPath()%>/ServiceController" method="post">
                        <input type="hidden" name="action" value="addService"/>

                        <!-- Service Name -->
                        <div class="form-group">
                            <label>Service Name</label>
                            <input type="text" name="serviceName" class="form-control" required placeholder=" ">
                        </div>

                        <!-- Category -->
                        <div class="form-group">
                        	<label>Category</label>
                            <select name="categoryId" class="form-control" required>
                                <option disabled selected value="">Select Category</option>
                                <% for (Category c : categories) { %>
                                    <option value="<%= c.getCategoryId() %>"><%= c.getCategoryName() %></option>
                                <% } %>
                            </select>
                        </div>

                        <!-- Description -->
                        <div class="form-group">
                            <label>Description</label>
                            <textarea name="serviceDesc" class="form-control" required placeholder=" "></textarea>
                        </div>

                        <!-- Price -->
                        <div class="form-group">
                            <label>Price</label>
                            <input type="number" step="0.01" name="price" class="form-control" required placeholder=" ">
                        </div>

                        <!-- Image Path -->
                        <div class="form-group">
                            <label>Image Path</label>
                            <input type="text" name="imagePath" class="form-control" required placeholder=" ">
                        </div>

                        <!-- Buttons -->
                        <div class="mt-4">
                            <button type="submit" class="btn btn-primary">Add Service</button>
                            <a href="adminListServices.jsp" class="btn btn-secondary ms-2">Cancel</a>
                        </div>

                    </form>
                </div>

            </main>
        </div>
    </div>
</div>

<%@ include file="../../includes/footer.jsp" %>
