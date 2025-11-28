<%@ page import="dao.CategoryDao, java.util.List, models.Category" %>

<%
    CategoryDao dao = new CategoryDao();
    List<Category> list = dao.getAllCategories();
%>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="client-page">

<div class="container mt-5">

    <h2 class="client-page-title">Service Categories</h2>

    <div class="row g-4 mt-3">

        <% for (Category c : list) { %>
            <div class="col-md-4">
                <div class="client-card h-100">

                    <h4 class="text-purple"><%= c.getCategoryName() %></h4>
                    <p class="text-muted"><%= c.getCategoryDesc() %></p>

                    <a class="btn btn-client-primary w-100 mt-3"
                       href="serviceByCategory.jsp?categoryId=<%= c.getCategoryId() %>">
                       View Services
                    </a>
                </div>
            </div>
        <% } %>

    </div>

</div>

</div>

<%@ include file="../includes/footer.jsp" %>
