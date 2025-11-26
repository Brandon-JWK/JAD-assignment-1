<%@ page import="dao.CategoryDao, java.util.List, models.Category" %>
<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/adminSessionCheck.jsp" %>
<%@ include file="../../includes/sidebar.jsp" %>
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=1">

<%
    CategoryDao dao = new CategoryDao();
    List<Category> categories = dao.getAllCategories();
%>
<div class="container-fluid">
    <div class="row">

        <%@ include file="../../includes/sidebar.jsp" %>

        <div class="col-md-9">
            <div class="admin-content">
                <h2>Add New Service</h2>
                <form action="<%=request.getContextPath()%>/ServiceController" method="post">
                    <input type="hidden" name="action" value="addService"/>

                    <div class="mb-3">
                        <label for="name" class="form-label">Service Name</label>
                        <input type="text" class="form-control" id="name" name="serviceName" required>
                    </div>

                    <div class="mb-3">
                        <label for="category" class="form-label">Category</label>
                        <select class="form-select" id="category" name="categoryId" required>
                            <% for (Category c : categories) { %>
                                <option value="<%= c.getCategoryId() %>"><%= c.getCategoryName() %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="desc" class="form-label">Description</label>
                        <textarea class="form-control" id="desc" name="serviceDesc" required></textarea>
                    </div>

                    <div class="mb-3">
                        <label for="price" class="form-label">Price</label>
                        <input type="number" step="0.01" class="form-control" id="price" name="price" required>
                    </div>

                    <div class="mb-3">
                        <label for="image" class="form-label">Image Path</label>
                        <input type="text" class="form-control" id="image" name="imagePath" required>
                    </div>

                    <button type="submit" class="btn btn-primary">Add Service</button>
                </form>
            </div>
        </div><!-- col-md-9 -->

    </div><!-- row -->
</div><!-- container-fluid -->

<%@ include file="../../includes/footer.jsp" %>
