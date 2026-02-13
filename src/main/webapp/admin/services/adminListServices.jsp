<%@ page import="dao.ServiceDao, dao.CategoryDao, java.util.*, models.Service, models.Category" %>
<%@ page import="java.net.URLEncoder" %>

<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/sidebar.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=3">

<%
    ServiceDao serviceDao = new ServiceDao();
    CategoryDao categoryDao = new CategoryDao();

    // Filters
    String keyword = request.getParameter("keyword");
    String categoryStr = request.getParameter("categoryId");
    if (keyword == null || keyword.equals("null") || keyword.trim().isEmpty()) keyword = null;
    if (categoryStr == null || categoryStr.equals("null") || categoryStr.trim().isEmpty()) categoryStr = null;
    Integer categoryId = (categoryStr != null) ? Integer.parseInt(categoryStr) : null;

    // Sorting
    String sortBy = request.getParameter("sortBy");
    String sortDir = request.getParameter("sortDir");
    if (sortBy == null || sortBy.trim().isEmpty()) sortBy = "id";
    if (sortDir == null || sortDir.trim().isEmpty()) sortDir = "asc";
    sortDir = sortDir.equalsIgnoreCase("desc") ? "desc" : "asc";

    // Pagination
    int currentPage = 1;
    int pageSize = 4;
    try {
        if (request.getParameter("page") != null) currentPage = Integer.parseInt(request.getParameter("page"));
    } catch (Exception e) { currentPage = 1; }
    int offset = (currentPage - 1) * pageSize;

    // Category map
    List<Category> allCategories = categoryDao.getAllCategories();
    Map<Integer, String> categoryNameMap = new HashMap<>();
    for (Category c : allCategories) categoryNameMap.put(c.getCategoryId(), c.getCategoryName());

    // Load ALL filtered for sorting across pages
    List<Service> allFiltered = serviceDao.searchFilterPaginate(keyword, categoryId, 0, 1000000);

    final String _sortBy = sortBy;
    final String _sortDir = sortDir;

    Collections.sort(allFiltered, (a, b) -> {
        int cmp = 0;

        if ("name".equalsIgnoreCase(_sortBy)) {
            String sa = (a.getServiceName() == null) ? "" : a.getServiceName();
            String sb = (b.getServiceName() == null) ? "" : b.getServiceName();
            cmp = sa.compareToIgnoreCase(sb);

        } else if ("price".equalsIgnoreCase(_sortBy)) {
            cmp = Double.compare(a.getPrice(), b.getPrice());

        } else if ("category".equalsIgnoreCase(_sortBy)) {
            String ca = categoryNameMap.getOrDefault(a.getCategoryId(), "");
            String cb = categoryNameMap.getOrDefault(b.getCategoryId(), "");
            cmp = ca.compareToIgnoreCase(cb);

        } else {
            cmp = Integer.compare(a.getServiceId(), b.getServiceId());
        }

        return "desc".equalsIgnoreCase(_sortDir) ? -cmp : cmp;
    });

    int total = allFiltered.size();
    int totalPages = (int) Math.ceil((double) total / pageSize);

    int fromIndex = Math.min(offset, total);
    int toIndex = Math.min(offset + pageSize, total);
    List<Service> services = allFiltered.subList(fromIndex, toIndex);

    // Link params
    String encKeyword = "";
    try { encKeyword = (keyword == null) ? "" : URLEncoder.encode(keyword, "UTF-8"); }
    catch (Exception e) { encKeyword = (keyword == null) ? "" : keyword; }

    String baseQs = "keyword=" + encKeyword
                  + "&categoryId=" + (categoryId == null ? "" : categoryId)
                  + "&sortBy=" + sortBy
                  + "&sortDir=" + sortDir;

    String nextIdDir    = ("id".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
    String nextCatDir   = ("category".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
    String nextNameDir  = ("name".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
    String nextPriceDir = ("price".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
%>

<div class="page-wrapper d-flex flex-column">
    <div class="admin-layout d-flex flex-column flex-grow-1">

        <main class="admin-content">
            <div class="row">

                <main class="col-md-10 ms-sm-auto px-4">

                    <div class="admin-page-header d-flex justify-content-between
                                flex-wrap flex-md-nowrap align-items-center
                                pt-3 pb-2 mb-3 border-bottom">

                        <h1 class="h2">Services</h1>

                        <div class="d-flex gap-2">
                            <a href="adminListServices.jsp" class="btn btn-outline-secondary btn-lg">Reset</a>
                            <a href="<%=request.getContextPath() %>/admin/services/adminAddService.jsp"
                               class="btn btn-primary btn-lg">+ Add Service</a>
                        </div>
                    </div>

                    <form method="get" class="d-flex gap-2 mb-3">
                        <input type="hidden" name="page" value="1"/>
                        <input class="form-control" style="max-width:260px"
                               name="keyword" placeholder="Search service name..."
                               value="<%= (keyword != null) ? keyword : "" %>"/>

                        <select class="form-select" style="max-width:260px" name="categoryId">
                            <option value="">All Categories</option>
                            <%
                                for (Category c : allCategories) {
                                    String sel = (categoryId != null && categoryId == c.getCategoryId()) ? "selected" : "";
                            %>
                            <option value="<%= c.getCategoryId() %>" <%= sel %>><%= c.getCategoryName() %></option>
                            <% } %>
                        </select>

                        <button class="btn btn-primary" type="submit">Filter</button>
                    </form>

                    <!-- TABLE + PAGINATION (same box) -->
                    <div class="card shadow-sm mb-3">
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th><a href="adminListServices.jsp?page=1&keyword=<%= encKeyword %>&categoryId=<%= (categoryId==null?"":categoryId) %>&sortBy=id&sortDir=<%= nextIdDir %>">ID</a></th>
                                        <th><a href="adminListServices.jsp?page=1&keyword=<%= encKeyword %>&categoryId=<%= (categoryId==null?"":categoryId) %>&sortBy=category&sortDir=<%= nextCatDir %>">Category</a></th>
                                        <th><a href="adminListServices.jsp?page=1&keyword=<%= encKeyword %>&categoryId=<%= (categoryId==null?"":categoryId) %>&sortBy=name&sortDir=<%= nextNameDir %>">Service Name</a></th>
                                        <th>Image</th>
                                        <th><a href="adminListServices.jsp?page=1&keyword=<%= encKeyword %>&categoryId=<%= (categoryId==null?"":categoryId) %>&sortBy=price&sortDir=<%= nextPriceDir %>">Price</a></th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>

                                <tbody>
                                <% for (Service s : services) { %>
                                    <tr>
                                        <td><%= s.getServiceId() %></td>
                                        <td><%= categoryNameMap.getOrDefault(s.getCategoryId(), "N/A") %></td>
                                        <td><%= s.getServiceName() %></td>
                                        <td>
                                            <img src="<%= request.getContextPath() + "/" + s.getImagePath() %>"
                                                 width="50" class="rounded"
                                                 alt="<%= s.getServiceName() %>">
                                        </td>
                                        <td>$<%= s.getPrice() %></td>
                                        <td>
                                            <a href="adminEditService.jsp?serviceId=<%= s.getServiceId() %>"
                                               class="btn btn-warning btn-sm">Edit</a>

                                            <form action="<%= request.getContextPath() %>/ServiceController"
                                                  method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="deleteService">
                                                <input type="hidden" name="serviceId" value="<%= s.getServiceId() %>">
                                                <button type="submit"
                                                        class="btn btn-danger btn-sm"
                                                        onclick="return confirm('Are you sure you want to delete this service?');">
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
                                            <a class="page-link" href="adminListServices.jsp?page=<%= currentPage-1 %>&<%= baseQs %>">Previous</a>
                                        </li>
                                    <% } %>

                                    <% for (int i=1; i<=totalPages; i++) { %>
                                        <li class="page-item <%= (i==currentPage ? "active" : "") %>">
                                            <a class="page-link" href="adminListServices.jsp?page=<%= i %>&<%= baseQs %>"><%= i %></a>
                                        </li>
                                    <% } %>

                                    <% if (currentPage < totalPages) { %>
                                        <li class="page-item">
                                            <a class="page-link" href="adminListServices.jsp?page=<%= currentPage+1 %>&<%= baseQs %>">Next</a>
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
