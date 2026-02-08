<%@ page import="dao.ServiceDao, dao.CategoryDao, dao.ClientDao" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Service, models.Category" %>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>
<%@ include file="../includes/sidebar.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=3">

<%
    ServiceDao serviceDao = new ServiceDao();
    CategoryDao categoryDao = new CategoryDao();
    ClientDao clientDao = new ClientDao();

    int totalServices = serviceDao.getAllServices().size();
    int totalCategories = categoryDao.getAllCategories().size();
    int totalClients = clientDao.getAllClients().size();

 	// PAGINATION SETUP
    int currentpage = 1;
    int limit = 5; // services per page

    if (request.getParameter("page") != null) {
        currentpage = Integer.parseInt(request.getParameter("page"));
    }

    int offset = (currentpage - 1) * limit;

    // FILTER VARIABLES
    String keyword = request.getParameter("keyword");
	String categoryStr = request.getParameter("categoryId");
	
	// Fix pagination issue: some URLs send "null" as string
	if (keyword == null || keyword.equals("null") || keyword.trim().isEmpty()) {
	    keyword = null;
	}
	
	if (categoryStr == null || categoryStr.equals("null") || categoryStr.trim().isEmpty()) {
	    categoryStr = null;
	}
	
	Integer categoryId = (categoryStr != null) ? Integer.parseInt(categoryStr) : null;


    // TOTAL COUNT
    int totalServicesFiltered = serviceDao.countServices(keyword, categoryId);
    int totalPages = (int) Math.ceil((double) totalServicesFiltered / limit);

    // LOAD RESULTS
    List<Service> serviceList = serviceDao.searchFilterPaginate(keyword, categoryId, offset, limit);
%>

<div class="page-wrapper d-flex flex-column">
    <div class="admin-layout d-flex flex-column flex-grow-1">

        <!-- Main Content Area -->
        <main class="admin-content">

            <div class="row">
                <main class="col-md-10 ms-sm-auto px-4">

                    <!-- PAGE TITLE -->
                    <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-4 border-bottom">
                        <h1 class="h2">Dashboard Overview</h1>
                    </div>

                    <!-- DASHBOARD METRICS -->
                    <div class="row g-3 mb-4">

                        <!-- Total Services -->
                        <div class="col-md-4">
                            <div class="card dashboard-card p-4 text-center shadow-sm">
                                <h5 class="mb-2">Total Services</h5>
                                <h2 class="dashboard-value text-primary"><%= totalServices %></h2>
                            </div>
                        </div>

                        <!-- Total Categories -->
                        <div class="col-md-4">
                            <div class="card dashboard-card p-4 text-center shadow-sm">
                                <h5 class="mb-2">Total Categories</h5>
                                <h2 class="dashboard-value text-success"><%= totalCategories %></h2>
                            </div>
                        </div>

                        <!-- Total Clients -->
                        <div class="col-md-4">
                            <div class="card dashboard-card p-4 text-center shadow-sm">
                                <h5 class="mb-2">Total Clients</h5>
                                <h2 class="dashboard-value text-danger"><%= totalClients %></h2>
                            </div>
                        </div>
                        
                        <!-- TABLE SECTION -->
	                    <div class="table-responsive card shadow-sm p-3">
	                        <h4 class="mb-3">Recent Services</h4>
	                        <!-- FILTER FORM -->
							<form method="get" action="adminDashboard.jsp" class="d-flex gap-3 mb-3">
							
							    <!-- SEARCH BAR -->
							    <input type="text" 
							           name="keyword" 
							           class="form-control" 
							           placeholder="Search services..." 
							           style="max-width: 250px"
							           value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
							
							    <!-- CATEGORY FILTER (existing) -->
							    <select name="categoryId" class="form-select" style="max-width: 250px;">
							        <option value="">All Categories</option>
							        <% 
							            List<Category> categories = categoryDao.getAllCategories();
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
	                                    <th>Service Name</th>
	                                    <th>Category</th>
	                                </tr>
	                            </thead>
	                            <tbody>
	                                <% for (Service s : serviceList) { 
	                                    Category cat = categoryDao.getCategoryById(s.getCategoryId());
	                                %>
	                                    <tr>
	                                        <td><%= s.getServiceName() %></td>
	                                        <td><%= cat != null ? cat.getCategoryName() : "N/A" %></td>
	                                    </tr>
	                                <% } %>
	                            </tbody>
	                        </table>
	                        <nav aria-label="Page navigation">
							    <ul class="pagination">
							        <% if (currentpage > 1) { %>
							            <li class="page-item">
							                <a class="page-link"
							                   href="adminDashboard.jsp?page=<%= currentpage - 1 %>&keyword=<%= keyword %>&categoryId=<%= categoryStr %>">
							                   Previous
							                </a>
							            </li>
							        <% } %>
							
							        <% for (int i = 1; i <= totalPages; i++) { %>
							            <li class="page-item <%= (i == currentpage ? "active" : "") %>">
							                <a class="page-link"
							                   href="adminDashboard.jsp?page=<%= i %>&keyword=<%= keyword %>&categoryId=<%= categoryStr %>">
							                   <%= i %>
							                </a>
							            </li>
							        <% } %>
							
							        <% if (currentpage < totalPages) { %>
							            <li class="page-item">
							                <a class="page-link"
							                   href="adminDashboard.jsp?page=<%= currentpage + 1 %>&keyword=<%= keyword %>&categoryId=<%= categoryStr %>">
							                   Next
							                </a>
							            </li>
							        <% } %>
							    </ul>
							</nav>
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
							        backgroundColor: "#" + Math.floor(Math.random()*16777215).toString(16)
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
