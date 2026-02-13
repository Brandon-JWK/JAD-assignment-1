<%@ page import="dao.ClientDao, models.Client, java.util.*" %>
<%@ page import="java.net.URLEncoder" %>

<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/sidebar.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=3">

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    ClientDao dao = new ClientDao();

    // Filters
    String areaCode = request.getParameter("areaCode");
    String careKeyword = request.getParameter("careKeyword");

    List<Client> clients = dao.getAllClients();

    if (areaCode != null && !areaCode.isBlank()) {
        clients.removeIf(c -> c.getAddress() == null || !c.getAddress().startsWith(areaCode));
    }

    if (careKeyword != null && !careKeyword.isBlank()) {
        String keywordLower = careKeyword.toLowerCase();
        clients.removeIf(c -> c.getMedicalInfo() == null || !c.getMedicalInfo().toLowerCase().contains(keywordLower));
    }

    // Sorting
    String sortBy = request.getParameter("sortBy");
    String sortDir = request.getParameter("sortDir");
    if (sortBy == null || sortBy.isBlank()) sortBy = "id";
    if (sortDir == null || sortDir.isBlank()) sortDir = "asc";
    sortDir = sortDir.equalsIgnoreCase("desc") ? "desc" : "asc";

    final String _sortBy = sortBy;
    final String _sortDir = sortDir;

    Collections.sort(clients, (a,b) -> {
        int cmp = 0;
        if ("name".equalsIgnoreCase(_sortBy)) {
            cmp = String.valueOf(a.getFullName()).compareToIgnoreCase(String.valueOf(b.getFullName()));
        } else if ("email".equalsIgnoreCase(_sortBy)) {
            cmp = String.valueOf(a.getEmail()).compareToIgnoreCase(String.valueOf(b.getEmail()));
        } else if ("phone".equalsIgnoreCase(_sortBy)) {
            cmp = String.valueOf(a.getPhone()).compareToIgnoreCase(String.valueOf(b.getPhone()));
        } else if ("address".equalsIgnoreCase(_sortBy)) {
            cmp = String.valueOf(a.getAddress()).compareToIgnoreCase(String.valueOf(b.getAddress()));
        } else {
            cmp = Integer.compare(a.getClientId(), b.getClientId());
        }
        return "desc".equalsIgnoreCase(_sortDir) ? -cmp : cmp;
    });

    // Pagination
    int currentPage = 1;
    int pageSize = 4;
    try { if (request.getParameter("page") != null) currentPage = Integer.parseInt(request.getParameter("page")); }
    catch(Exception e){ currentPage = 1; }
    int rowOffset = (currentPage - 1) * pageSize;

    int total = clients.size();
    int totalPages = (int)Math.ceil((double)total / pageSize);

    int fromIndex = Math.min(rowOffset, total);
    int toIndex = Math.min(rowOffset + pageSize, total);
    List<Client> pagedClients = clients.subList(fromIndex, toIndex);

    // Link params
    String encArea = "";
    String encCare = "";
    try { encArea = (areaCode == null) ? "" : URLEncoder.encode(areaCode, "UTF-8"); } catch(Exception e){}
    try { encCare = (careKeyword == null) ? "" : URLEncoder.encode(careKeyword, "UTF-8"); } catch(Exception e){}

    String baseQs = "areaCode=" + encArea
                  + "&careKeyword=" + encCare
                  + "&sortBy=" + sortBy
                  + "&sortDir=" + sortDir;

    String nextIdDir      = ("id".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
    String nextNameDir    = ("name".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
    String nextEmailDir   = ("email".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
    String nextPhoneDir   = ("phone".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
    String nextAddressDir = ("address".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
%>

<div class="page-wrapper d-flex flex-column">
    <div class="admin-layout d-flex flex-column flex-grow-1">
        <main class="admin-content">
            <div class="row">
                <main class="col-md-10 ms-sm-auto px-4">

                    <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">All Clients</h1>
                        <div class="d-flex gap-2">
                            <a href="adminListClients.jsp" class="btn btn-outline-secondary btn-lg">Reset</a>
                            <a href="adminAddClient.jsp" class="btn btn-success btn-lg">+ Add Client</a>
                        </div>
                    </div>

                    <form class="mb-3" method="get">
                        <input type="hidden" name="page" value="1"/>
                        <div class="row g-2">
                            <div class="col-md-3">
                                <input type="text" name="areaCode"
                                       value="<%= request.getParameter("areaCode") != null ? request.getParameter("areaCode") : "" %>"
                                       class="form-control" placeholder="Filter by Area Code">
                            </div>
                            <div class="col-md-3">
                                <input type="text" name="careKeyword"
                                       value="<%= request.getParameter("careKeyword") != null ? request.getParameter("careKeyword") : "" %>"
                                       class="form-control" placeholder="Filter by Care Needs">
                            </div>
                            <div class="col-md-2">
                                <select class="form-select" name="sortBy">
                                    <option value="id" <%= "id".equals(sortBy) ? "selected":"" %>>Sort: ID</option>
                                    <option value="name" <%= "name".equals(sortBy) ? "selected":"" %>>Sort: Name</option>
                                    <option value="email" <%= "email".equals(sortBy) ? "selected":"" %>>Sort: Email</option>
                                    <option value="phone" <%= "phone".equals(sortBy) ? "selected":"" %>>Sort: Phone</option>
                                    <option value="address" <%= "address".equals(sortBy) ? "selected":"" %>>Sort: Address</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select class="form-select" name="sortDir">
                                    <option value="asc" <%= "asc".equals(sortDir) ? "selected":"" %>>Asc</option>
                                    <option value="desc" <%= "desc".equals(sortDir) ? "selected":"" %>>Desc</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary">Apply</button>
                            </div>
                        </div>
                    </form>

                    <!-- TABLE + PAGINATION (same box) -->
                    <div class="card shadow-sm mb-3">
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th><a href="adminListClients.jsp?page=1&areaCode=<%= encArea %>&careKeyword=<%= encCare %>&sortBy=id&sortDir=<%= nextIdDir %>">ID</a></th>
                                        <th><a href="adminListClients.jsp?page=1&areaCode=<%= encArea %>&careKeyword=<%= encCare %>&sortBy=name&sortDir=<%= nextNameDir %>">Full Name</a></th>
                                        <th><a href="adminListClients.jsp?page=1&areaCode=<%= encArea %>&careKeyword=<%= encCare %>&sortBy=email&sortDir=<%= nextEmailDir %>">Email</a></th>
                                        <th><a href="adminListClients.jsp?page=1&areaCode=<%= encArea %>&careKeyword=<%= encCare %>&sortBy=phone&sortDir=<%= nextPhoneDir %>">Phone</a></th>
                                        <th><a href="adminListClients.jsp?page=1&areaCode=<%= encArea %>&careKeyword=<%= encCare %>&sortBy=address&sortDir=<%= nextAddressDir %>">Address</a></th>
                                        <th>Emergency Contact</th>
                                        <th>Medical Info</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for(Client c : pagedClients) { %>
                                    <tr>
                                        <td><%= c.getClientId() %></td>
                                        <td><%= c.getFullName() %></td>
                                        <td><%= c.getEmail() %></td>
                                        <td><%= c.getPhone() %></td>
                                        <td><%= c.getAddress() %></td>
                                        <td>
                                            <%= c.getEmergencyContactName() != null ? c.getEmergencyContactName() : "-" %><br>
                                            <%= c.getEmergencyContactPhone() != null ? c.getEmergencyContactPhone() : "-" %>
                                        </td>
                                        <td><%= c.getMedicalInfo() != null ? c.getMedicalInfo() : "-" %></td>
                                        <td>
                                            <a href="adminEditClient.jsp?id=<%= c.getClientId() %>" class="btn btn-warning btn-sm">Edit</a>
                                            <form action="<%=request.getContextPath()%>/AdminController" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="deleteClient">
                                                <input type="hidden" name="clientId" value="<%= c.getClientId() %>">
                                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?');">Delete</button>
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
                                        <li class="page-item"><a class="page-link" href="adminListClients.jsp?page=<%= currentPage-1 %>&<%= baseQs %>">Previous</a></li>
                                    <% } %>

                                    <% for (int i=1; i<=totalPages; i++) { %>
                                        <li class="page-item <%= (i==currentPage ? "active" : "") %>">
                                            <a class="page-link" href="adminListClients.jsp?page=<%= i %>&<%= baseQs %>"><%= i %></a>
                                        </li>
                                    <% } %>

                                    <% if (currentPage < totalPages) { %>
                                        <li class="page-item"><a class="page-link" href="adminListClients.jsp?page=<%= currentPage+1 %>&<%= baseQs %>">Next</a></li>
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
