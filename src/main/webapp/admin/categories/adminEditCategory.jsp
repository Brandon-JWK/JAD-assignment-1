<%@ page import="dao.CategoryDao, models.Category" %>
<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/adminSessionCheck.jsp" %>

<%
    String idStr = request.getParameter("categoryId");
    int id = Integer.parseInt(idStr);

    CategoryDao dao = new CategoryDao();
    Category category = dao.getCategoryById(id);

    if (category == null) {
        out.println("<h3>Category not found!</h3>");
        return;
    }
%>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 d-none d-md-block bg-light sidebar vh-100">
            <%@ include file="../../includes/sidebar.jsp" %>
        </div>

        <main class="col-md-10 ms-sm-auto px-4">
        	<div class="admin-content">
	            <h2 class="mt-4">Edit Category</h2>
	
	            <form action="<%= request.getContextPath() %>/CategoryController" method="post" class="mt-4">
	
	                <!-- MUST MATCH CONTROLLER -->
	                <input type="hidden" name="action" value="updateCategory">
	                <input type="hidden" name="id" value="<%= category.getCategoryId() %>">
	
	                <div class="mb-3">
	                    <label class="form-label">Category Name</label>
	                    <input type="text" name="name" class="form-control"
	                           value="<%= category.getCategoryName() %>" required>
	                </div>
	
	                <div class="mb-3">
	                    <label class="form-label">Description</label>
	                    <textarea name="desc" class="form-control" required><%= category.getCategoryDesc() %></textarea>
	                </div>
	
	                <button type="submit" class="btn btn-primary">Save Changes</button>
	                <a href="adminListCategories.jsp" class="btn btn-secondary">Cancel</a>
	            </form>
	         </div>
        </main>
    </div>
</div>

<%@ include file="../../includes/footer.jsp" %>
