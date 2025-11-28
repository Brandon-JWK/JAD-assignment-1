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

        <main class="admin-content">
            <div class="row">

                <!-- MAIN CONTENT -->
                <main class="col-md-10 ms-sm-auto px-4">

                    <!-- Dashboard-style header -->
                    <div class="admin-page-header d-flex justify-content-between 
                                flex-wrap flex-md-nowrap align-items-center 
                                pt-3 pb-2 mb-3 border-bottom">

                        <h1 class="h2">Service Categories</h1>

                        <a href="<%=request.getContextPath() %>/admin/categories/adminAddCategory.jsp" 
                           class="btn btn-success btn-lg">
                           + Add Category
                        </a>
                    </div>

                    <!-- Table -->
                    <div class="table-responsive">
                        <table class="table table-striped table-bordered align-middle">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Category Name</th>
                                    <th>Description</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>

                            <tbody>
                            <% for (Category c : categories) { %>
                                <tr>
                                    <td><%= c.getCategoryId() %></td>

                                    <td><%= c.getCategoryName() %></td>

                                    <td><%= c.getCategoryDesc() %></td>

                                    <td>
                                        <a href="adminEditCategory.jsp?categoryId=<%=c.getCategoryId()%>" 
                                           class="btn btn-warning btn-sm">
                                           Edit
                                        </a>

                                        <form action="<%= request.getContextPath() %>/CategoryController" 
                                              method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="deleteCategory">
                                            <input type="hidden" name="id" value="<%= c.getCategoryId() %>">

                                            <button type="submit" class="btn btn-danger btn-sm"
                                                    onclick="return confirm('Are you sure you want to delete this category?');">
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
