<%@ page import="dao.ClientDao, models.Client" %>
<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/adminSessionCheck.jsp" %>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));
    ClientDao dao = new ClientDao();
    Client c = dao.getClientById(id);
%>

<div class="container-fluid">
    <div class="row">

        <!-- Sidebar -->
        <div class="col-md-2 d-none d-md-block bg-light sidebar vh-100">
            <%@ include file="../../includes/sidebar.jsp" %>
        </div>

        <!-- Main Content -->
        <div class="col-md-10">
            <div class="admin-content">
                <h2>Edit Client</h2>

                <form action="adminUpdateClient.jsp" method="post">

                    <input type="hidden" name="id" value="<%= c.getClientId() %>">

                    <div class="mb-3">
                        <label>Full Name</label>
                        <input type="text" name="full_name" class="form-control" value="<%= c.getFullName() %>">
                    </div>

                    <div class="mb-3">
                        <label>Email</label>
                        <input type="email" name="email" class="form-control" value="<%= c.getEmail() %>">
                    </div>

                    <div class="mb-3">
                        <label>Phone</label>
                        <input type="text" name="phone" class="form-control" value="<%= c.getPhone() %>">
                    </div>

                    <div class="mb-3">
                        <label>Address</label>
                        <input type="text" name="address" class="form-control" value="<%= c.getAddress() %>">
                    </div>

                    <button type="submit" class="btn btn-success">Update</button>
                    <a href="adminListClients.jsp" class="btn btn-secondary">Cancel</a>
                </form>
            </div>
        </div>

    </div> <!-- row -->
</div> <!-- container-fluid -->

<%@ include file="../../includes/footer.jsp" %>
