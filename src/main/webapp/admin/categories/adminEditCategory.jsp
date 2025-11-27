<%@ page import="dao.CategoryDao, models.Category" %>
<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/adminSessionCheck.jsp" %>
<%@ include file="../../includes/sidebar.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=3">

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

<div class="page-wrapper d-flex flex-column">
    <div class="admin-layout d-flex flex-column flex-grow-1">

        <div class="row">

            <!-- Main Content -->
            <main class="col-md-10 ms-sm-auto px-4 admin-content">

                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Edit Category</h1>
                </div>

                <div class="admin-form-card">

                    <form action="<%= request.getContextPath() %>/CategoryController" method="post">

                        <input type="hidden" name="action" value="updateCategory">
                        <input type="hidden" name="id" value="<%= category.getCategoryId() %>">

                        <!-- Category Name -->
                        <div class="form-group">
                            <label>Category Name</label>
                            <input type="text" name="name" class="form-control"
                                   value="<%= category.getCategoryName() %>"
                                   required placeholder=" ">
                        </div>

                        <!-- Description -->
                        <div class="form-group">
                            <label>Description</label>
                            <textarea name="desc" class="form-control" placeholder=" " required><%= category.getCategoryDesc() %></textarea>
                        </div>

                        <!-- Buttons -->
                        <div class="mt-4">
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                            <a href="adminListCategories.jsp" class="btn btn-secondary ms-2">Cancel</a>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>
</div>

<%@ include file="../../includes/footer.jsp" %>
