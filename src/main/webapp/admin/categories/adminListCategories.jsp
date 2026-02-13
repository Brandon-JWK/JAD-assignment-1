<%@ page import="dao.CategoryDao, java.util.*, models.Category" %>
<%@ page import="java.net.URLEncoder" %>

<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/sidebar.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=3">

<%
    CategoryDao dao = new CategoryDao();
    List<Category> categories = dao.getAllCategories();

    // Filter
    String keyword = request.getParameter("keyword");
    if (keyword == null || keyword.equals("null") || keyword.trim().isEmpty()) keyword = null;

    // Sorting
    String sortBy = request.getParameter("sortBy");
    String sortDir = request.getParameter("sortDir");
    if (sortBy == null || sortBy.isBlank()) sortBy = "id";
    if (sortDir == null || sortDir.isBlank()) sortDir = "asc";
    sortDir = sortDir.equalsIgnoreCase("desc") ? "desc" : "asc";

    // Filter list
    List<Category> filtered = new ArrayList<>(categories);
    if (keyword != null) {
        String k = keyword.toLowerCase();
        filtered.removeIf(c -> {
            String nameText = String.valueOf(c.getCategoryName()).toLowerCase();
            String descText = String.valueOf(c.getCategoryDesc() == null ? "" : c.getCategoryDesc()).toLowerCase();
            return !(nameText.contains(k) || descText.contains(k));
        });
    }

    // Sort list
    final String _sortBy = sortBy;
    final String _sortDir = sortDir;

    Collections.sort(filtered, (a,b) -> {
        int cmp = 0;
        if ("name".equalsIgnoreCase(_sortBy)) {
            cmp = String.valueOf(a.getCategoryName()).compareToIgnoreCase(String.valueOf(b.getCategoryName()));
        } else {
            cmp = Integer.compare(a.getCategoryId(), b.getCategoryId());
        }
        return "desc".equalsIgnoreCase(_sortDir) ? -cmp : cmp;
    });

    // Pagination
    int currentPage = 1;
    int pageSize = 4;
    try { if (request.getParameter("page") != null) currentPage = Integer.parseInt(request.getParameter("page")); }
    catch(Exception e){ currentPage = 1; }
    int rowOffset = (currentPage - 1) * pageSize;

    int total = filtered.size();
    int totalPages = (int)Math.ceil((double)total / pageSize);

    int fromIndex = Math.min(rowOffset, total);
    int toIndex = Math.min(rowOffset + pageSize, total);
    List<Category> paged = filtered.subList(fromIndex, toIndex);

    // Links
    String encKeyword = "";
    try { encKeyword = (keyword == null) ? "" : URLEncoder.encode(keyword, "UTF-8"); }
    catch(Exception e){ encKeyword = (keyword == null) ? "" : keyword; }

    String baseQs = "keyword=" + encKeyword + "&sortBy=" + sortBy + "&sortDir=" + sortDir;

    String nextIdDir   = ("id".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
    String nextNameDir = ("name".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
%>

<div class="page-wrapper d-flex flex-column">
    <div class="admin-layout d-flex flex-column flex-grow-1">

        <main class="admin-content">
            <div class="row">

                <main class="col-md-10 ms-sm-auto px-4">

                    <div class="admin-page-header d-flex justify-content-between
                                flex-wrap flex-md-nowrap align-items-center
                                pt-3 pb-2 mb-3 border-bottom">

                        <h1 class="h2">Categories</h1>

                        <div class="d-flex gap-2">
                            <a href="adminListCategories.jsp" class="btn btn-outline-secondary btn-lg">Reset</a>
                            <a href="<%=request.getContextPath() %>/admin/categories/adminAddCategory.jsp"
                               class="btn btn-success btn-lg">+ Add Category</a>
                        </div>
                    </div>

                    <form class="d-flex gap-2 mb-3" method="get">
                        <input type="hidden" name="page" value="1"/>
                        <input class="form-control" style="max-width:320px"
                               name="keyword" placeholder="Search name/description..."
                               value="<%= (keyword != null) ? keyword : "" %>"/>
                        <button class="btn btn-primary" type="submit">Filter</button>
                    </form>

                    <!-- TABLE + PAGINATION (same box) -->
                    <div class="card shadow-sm mb-3">
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th><a href="adminListCategories.jsp?page=1&keyword=<%= encKeyword %>&sortBy=id&sortDir=<%= nextIdDir %>">ID</a></th>
                                        <th><a href="adminListCategories.jsp?page=1&keyword=<%= encKeyword %>&sortBy=name&sortDir=<%= nextNameDir %>">Category Name</a></th>
                                        <th>Description</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>

                                <tbody>
                                <% for (Category c : paged) { %>
                                    <tr>
                                        <td><%= c.getCategoryId() %></td>
                                        <td><span class="category-name"><%= c.getCategoryName() %></span></td>
                                        <td><%= c.getCategoryDesc() %></td>
                                        <td>
                                            <a href="adminEditCategory.jsp?categoryId=<%=c.getCategoryId()%>"
                                               class="btn btn-warning btn-sm">Edit</a>

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

                        <div class="d-flex justify-content-center p-3 pt-2">
                            <nav aria-label="Page navigation" class="mb-0">
                                <ul class="pagination mb-0">
                                    <% if (currentPage > 1) { %>
                                        <li class="page-item">
                                            <a class="page-link" href="adminListCategories.jsp?page=<%= currentPage-1 %>&<%= baseQs %>">Previous</a>
                                        </li>
                                    <% } %>

                                    <% for (int i=1; i<=totalPages; i++) { %>
                                        <li class="page-item <%= (i==currentPage ? "active" : "") %>">
                                            <a class="page-link" href="adminListCategories.jsp?page=<%= i %>&<%= baseQs %>"><%= i %></a>
                                        </li>
                                    <% } %>

                                    <% if (currentPage < totalPages) { %>
                                        <li class="page-item">
                                            <a class="page-link" href="adminListCategories.jsp?page=<%= currentPage+1 %>&<%= baseQs %>">Next</a>
                                        </li>
                                    <% } %>
                                </ul>
                            </nav>
                        </div>
                    </div>

                </main>
            </div>
        </main>

    </div>
</div>

<%@ include file="../../includes/footer.jsp" %>
