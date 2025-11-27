<%@ page import="dao.CategoryDao, java.util.List, models.Category" %>
<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/adminSessionCheck.jsp" %>
<%@ include file="../../includes/sidebar.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=3">

<div class="page-wrapper d-flex flex-column">
    <div class="admin-layout d-flex flex-column flex-grow-1">

        <div class="row">

            <!-- Main Content -->
            <main class="col-md-10 ms-sm-auto px-4 admin-content">

                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Add New Category</h1>
                </div>

                <div class="admin-form-card">

                    <form action="<%=request.getContextPath()%>/CategoryController" method="post">
                        <input type="hidden" name="action" value="addCategory"/>

                        <!-- Category Name -->
                        <div class="form-group">
                            <label>Category Name</label>
                            <input type="text" name="name" class="form-control" required placeholder=" ">
                        </div>

                        <!-- Description -->
                        <div class="form-group">
                            <label>Description</label>
                            <input type="text" name="desc" class="form-control" placeholder=" ">
                        </div>

                        <!-- Submit Buttons -->
                        <div class="mt-4">
                            <button type="submit" class="btn btn-primary">Add Category</button>
                            <a href="adminListCategories.jsp" class="btn btn-secondary ms-2">Cancel</a>
                        </div>

                    </form>

                </div>

            </main>
        </div>

    </div>
</div>

<%@ include file="../../includes/footer.jsp" %>
