<%@ page import="dao.ClientDao, models.Client, java.util.*" %>
<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/adminSessionCheck.jsp" %>
<%@ include file="../../includes/sidebar.jsp" %>
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=3">

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    ClientDao dao = new ClientDao();
    List<Client> clients = dao.getAllClients();
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
		
		                <h1 class="h2">All Clients</h1>
		            </div>
		
		            <div class="table-responsive">
		                <table class="table table-striped table-bordered align-middle">
		                    <thead>
		                        <tr>
		                            <th>ID</th>
		                            <th>Full Name</th>
		                            <th>Email</th>
		                            <th>Phone</th>
		                            <th>Address</th>
		                            <th>Actions</th>
		                        </tr>
		                    </thead>
		
		                    <tbody>
		                    <% for(Client c : clients) { %>
		                        <tr>
		                            <td><%= c.getClientId() %></td>
		
		                            <td class="client-name">
		                                <%= c.getFullName() %>
		                            </td>
		
		                            <td class="client-email">
		                                <%= c.getEmail() %>
		                            </td>
		
		                            <td class="client-phone">
		                                <%= c.getPhone() %>
		                            </td>
		
		                            <td class="client-address">
		                                <%= c.getAddress() %>
		                            </td>
		
		                            <td>
		                                <a href="adminEditClient.jsp?id=<%= c.getClientId() %>" 
		                                   class="btn btn-warning btn-sm">Edit</a>
		
		                                <form action="<%=request.getContextPath()%>/AdminController"
		                                      method="post" style="display:inline;">
		                                      
		                                    <input type="hidden" name="action" value="deleteClient">
		                                    <input type="hidden" name="clientId" value="<%= c.getClientId() %>">
		
		                                    <button type="submit"
		                                            class="btn btn-danger btn-sm"
		                                            onclick="return confirm('Are you sure you want to delete this client?');">
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
