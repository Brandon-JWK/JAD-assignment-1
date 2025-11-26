<%@ page import="dao.CategoryDao, java.util.List, models.Category" %>
<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/adminSessionCheck.jsp" %>

<div class="container-fluid">
    <div class="row">
        <%@ include file="../../includes/sidebar.jsp" %>
        <main class="col-md-10 ms-sm-auto px-4 mt-5">
        	<div class="admin-content">
	            <h2>Add New Category</h2>
	            <form action="<%=request.getContextPath()%>/CategoryController" method="post">
	                <input type="hidden" name="action" value="addCategory"/>
	                <div class="mb-3">
	                    <label for="name" class="form-label">Category Name</label>
	                    <input type="text" class="form-control" id="name" name="name" required>
	                    <label for="desc" class="form-label">Description:</label>
	                    <input type="text" class="form-control" id="desc" name="desc">
	                </div>
	                <button type="submit" class="btn btn-primary">Add Category</button>
	            </form>
	         </div>
        </main>
    </div>
</div>

<%@ include file="../../includes/footer.jsp" %>
