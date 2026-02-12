<%@ page import="dao.ClientDao, models.Client, java.util.*" %>
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

    // --- Filter logic ---
    String areaCode = request.getParameter("areaCode"); // e.g., first 3 digits
    String careKeyword = request.getParameter("careKeyword"); // search medical info

    List<Client> clients = dao.getAllClients();

    if (areaCode != null && !areaCode.isBlank()) {
        clients.removeIf(c -> c.getAddress() == null || !c.getAddress().startsWith(areaCode));
    }

    if (careKeyword != null && !careKeyword.isBlank()) {
        String keywordLower = careKeyword.toLowerCase();
        clients.removeIf(c -> c.getMedicalInfo() == null || !c.getMedicalInfo().toLowerCase().contains(keywordLower));
    }
%>

<div class="page-wrapper d-flex flex-column">
    <div class="admin-layout d-flex flex-column flex-grow-1">
        <main class="admin-content">

            <div class="row">
                <main class="col-md-10 ms-sm-auto px-4">

                    <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">All Clients</h1>
                        <a href="adminAddClient.jsp" class="btn btn-success btn-lg">+ Add Client</a>
                    </div>

                    <!-- Filter Form -->
                    <form class="mb-3" method="get">
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
                                <button type="submit" class="btn btn-primary">Filter</button>
                                <a href="adminListClients.jsp" class="btn btn-secondary">Reset</a>
                            </div>
                        </div>
                    </form>

                    <div class="table-responsive">
                        <table class="table table-striped table-bordered align-middle">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Full Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Address</th>
                                    <th>Emergency Contact</th>
                                    <th>Medical Info</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Client c : clients) { %>
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

                </main>
            </div>
        </main>
    </div>
</div>

<%@ include file="../../includes/footer.jsp" %>
