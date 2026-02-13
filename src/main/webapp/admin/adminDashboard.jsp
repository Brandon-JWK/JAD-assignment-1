<%@ page import="dao.ServiceDao, dao.CategoryDao, dao.ClientDao" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="models.Service, models.Category" %>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=3">

<%
    ServiceDao serviceDao = new ServiceDao();
    CategoryDao categoryDao = new CategoryDao();
    ClientDao clientDao = new ClientDao();

    int totalServices = serviceDao.getAllServices().size();
    int totalCategories = categoryDao.getAllCategories().size();
    int totalClients = clientDao.getAllClients().size();

    // Pagination
    int currentpage = 1;
    int limit = 5;
    try {
        if (request.getParameter("page") != null) currentpage = Integer.parseInt(request.getParameter("page"));
    } catch (Exception e) { currentpage = 1; }
    int offset = (currentpage - 1) * limit;

    // Filters
    String keyword = request.getParameter("keyword");
    String categoryStr = request.getParameter("categoryId");

    if (keyword == null || keyword.equals("null") || keyword.trim().isEmpty()) keyword = null;
    if (categoryStr == null || categoryStr.equals("null") || categoryStr.trim().isEmpty()) categoryStr = null;
    Integer categoryId = (categoryStr != null) ? Integer.parseInt(categoryStr) : null;

    // Sorting
    String sortBy = request.getParameter("sortBy");
    String sortDir = request.getParameter("sortDir");
    if (sortBy == null || sortBy.equals("null") || sortBy.trim().isEmpty()) sortBy = "serviceName";
    if (sortDir == null || sortDir.equals("null") || sortDir.trim().isEmpty()) sortDir = "asc";
    sortDir = sortDir.equalsIgnoreCase("desc") ? "desc" : "asc";

    // Category map (for display + sorting)
    List<Category> categories = categoryDao.getAllCategories();
    Map<Integer, String> categoryNameMap = new HashMap<>();
    for (Category c : categories) categoryNameMap.put(c.getCategoryId(), c.getCategoryName());

    // Load ALL filtered results (big limit) so sorting works across pages
    List<Service> allFiltered = serviceDao.searchFilterPaginate(keyword, categoryId, 0, 1000000);

    // Sort in-memory
    final String _sortBy = sortBy;
    final String _sortDir = sortDir;
    Collections.sort(allFiltered, (a, b) -> {
        int cmp = 0;
        if ("category".equalsIgnoreCase(_sortBy)) {
            String ca = categoryNameMap.getOrDefault(a.getCategoryId(), "");
            String cb = categoryNameMap.getOrDefault(b.getCategoryId(), "");
            cmp = ca.compareToIgnoreCase(cb);
        } else {
            // serviceName default
            String sa = (a.getServiceName() == null) ? "" : a.getServiceName();
            String sb = (b.getServiceName() == null) ? "" : b.getServiceName();
            cmp = sa.compareToIgnoreCase(sb);
        }
        return "desc".equalsIgnoreCase(_sortDir) ? -cmp : cmp;
    });

    int totalServicesFiltered = allFiltered.size();
    int totalPages = (int) Math.ceil((double) totalServicesFiltered / limit);

    int fromIndex = Math.min(offset, totalServicesFiltered);
    int toIndex = Math.min(offset + limit, totalServicesFiltered);
    List<Service> serviceList = allFiltered.subList(fromIndex, toIndex);

    // Build safe query string for links
    String encKeyword = "";
    try { encKeyword = (keyword == null) ? "" : URLEncoder.encode(keyword, "UTF-8"); }
    catch (Exception e) { encKeyword = (keyword == null) ? "" : keyword; }

    String baseQs = "keyword=" + encKeyword
                  + "&categoryId=" + (categoryId == null ? "" : categoryId)
                  + "&sortBy=" + sortBy
                  + "&sortDir=" + sortDir;

    String nextNameDir = ("serviceName".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
    String nextCatDir  = ("category".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
%>

<div class="page-wrapper d-flex flex-column">
    <div class="admin-layout d-flex flex-column flex-grow-1">

        <main class="admin-content">
            <div class="row">
                <%@ include file="../includes/sidebar.jsp" %>
                <main class="col-md-10 ms-sm-auto px-4">

                    <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-4 border-bottom">
                        <h1 class="h2">Dashboard Overview</h1>

                        <a href="<%= request.getContextPath() %>/AdminController?action=reports"
                           class="btn btn-primary">
                            View Reports
                        </a>
                    </div>

                    <div class="row g-3 mb-4">

                        <div class="col-md-4">
                            <div class="card dashboard-card p-4 text-center shadow-sm">
                                <h5 class="mb-2">Total Services</h5>
                                <h2 class="dashboard-value text-primary"><%= totalServices %></h2>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="card dashboard-card p-4 text-center shadow-sm">
                                <h5 class="mb-2">Total Categories</h5>
                                <h2 class="dashboard-value text-success"><%= totalCategories %></h2>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="card dashboard-card p-4 text-center shadow-sm">
                                <h5 class="mb-2">Total Clients</h5>
                                <h2 class="dashboard-value text-danger"><%= totalClients %></h2>
                            </div>
                        </div>

                        <div class="table-responsive card shadow-sm p-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <h4 class="mb-3">Recent Services</h4>
                                <a class="btn btn-outline-secondary btn-sm" href="adminDashboard.jsp">Reset</a>
                            </div>

                            <form method="get" action="adminDashboard.jsp" class="d-flex gap-3 mb-3">
                                <input type="hidden" name="page" value="1"/>
                                <input type="hidden" name="sortBy" value="<%= sortBy %>"/>
                                <input type="hidden" name="sortDir" value="<%= sortDir %>"/>

                                <input type="text"
                                       name="keyword"
                                       class="form-control"
                                       placeholder="Search services..."
                                       style="max-width: 250px"
                                       value="<%= (keyword != null) ? keyword : "" %>">

                                <select name="categoryId" class="form-select" style="max-width: 250px;">
                                    <option value="">All Categories</option>
                                    <%
                                        String selectedCat = request.getParameter("categoryId");
                                        for (Category c : categories) {
                                    %>
                                    <option value="<%= c.getCategoryId() %>"
                                        <%= (selectedCat != null && selectedCat.equals(String.valueOf(c.getCategoryId()))) ? "selected" : "" %>>
                                        <%= c.getCategoryName() %>
                                    </option>
                                    <% } %>
                                </select>

                                <button type="submit" class="btn btn-primary">Filter</button>
                            </form>

                            <table class="table table-striped table-bordered align-middle">
                                <thead>
                                    <tr>
                                        <th>
                                            <a href="adminDashboard.jsp?page=1&keyword=<%= encKeyword %>&categoryId=<%= (categoryId==null?"":categoryId) %>&sortBy=serviceName&sortDir=<%= nextNameDir %>">
                                                Service Name
                                            </a>
                                        </th>
                                        <th>
                                            <a href="adminDashboard.jsp?page=1&keyword=<%= encKeyword %>&categoryId=<%= (categoryId==null?"":categoryId) %>&sortBy=category&sortDir=<%= nextCatDir %>">
                                                Category
                                            </a>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Service s : serviceList) { %>
                                    <tr>
                                        <td><%= s.getServiceName() %></td>
                                        <td><%= categoryNameMap.getOrDefault(s.getCategoryId(), "N/A") %></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>


	                        <div class="d-flex justify-content-center p-3 pt-2">
	                            <nav aria-label="Page navigation" class="mb-0">
	                                <ul class="pagination mb-0">
	                                    <% if (currentpage > 1) { %>
	                                        <li class="page-item">
	                                            <a class="page-link" href="adminDashboard.jsp?page=<%= currentpage - 1 %>&<%= baseQs %>">Previous</a>
	                                        </li>
	                                    <% } %>
	
	                                    <% for (int i = 1; i <= totalPages; i++) { %>
	                                        <li class="page-item <%= (i == currentpage ? "active" : "") %>">
	                                            <a class="page-link" href="adminDashboard.jsp?page=<%= i %>&<%= baseQs %>"><%= i %></a>
	                                        </li>
	                                    <% } %>
	
	                                    <% if (currentpage < totalPages) { %>
	                                        <li class="page-item">
	                                            <a class="page-link" href="adminDashboard.jsp?page=<%= currentpage + 1 %>&<%= baseQs %>">Next</a>
	                                        </li>
	                                    <% } %>
                                	</ul>
                                </nav>
                             </div>
                        </div>

                        <div class="card p-4 shadow-sm mb-4">
                            <h4 class="mb-4">Service Analytics</h4>
                            <canvas id="serviceChart"></canvas>
                        </div>

                        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

                        <script>
                            const ctx = document.getElementById('serviceChart').getContext('2d');

                            const dataSets = [
                                <%
                                for (Category c : categoryDao.getAllCategories()) {
                                    int count = serviceDao.getServicesByCategory(c.getCategoryId()).size();
                                %>
                                {
                                    label: "<%= c.getCategoryName() %>",
                                    data: [<%= count %>],
                                    backgroundColor: "#" + ("000000" + Math.floor(Math.random()*16777215).toString(16)).slice(-6)
                                },
                                <% } %>
                            ];

                            new Chart(ctx, {
                                type: 'bar',
                                data: {
                                    labels: ["Services"],
                                    datasets: dataSets
                                },
                                options: {
                                    responsive: true,
                                    plugins: {
                                        legend: { display: true }
                                    }
                                }
                            });
                        </script>

                    </div>
                </main>
            </div>

        </main>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
