<%@ page import="dao.ClientDao, models.Client" %>
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

    int id = Integer.parseInt(request.getParameter("id"));
    ClientDao dao = new ClientDao();
    Client c = dao.getClientById(id);
%>

<div class="page-wrapper d-flex flex-column">
    <div class="admin-layout d-flex flex-column flex-grow-1">
        <div class="row">

            <!-- Main -->
            <main class="col-md-10 ms-sm-auto px-4 admin-content">

                <h1 class="h2 mt-3 mb-3 border-bottom pb-2">Edit Client</h1>

                <div class="admin-form-card">

                    <form action="adminUpdateClient.jsp" method="post">

                        <input type="hidden" name="id" value="<%= c.getClientId() %>">

                        <div class="form-group">
                        	<label>Full Name</label>
                            <input type="text" name="full_name" class="form-control" value="<%= c.getFullName() %>" required placeholder=" ">
                        </div>

                        <div class="form-group">
                        	<label>Email</label>
                            <input type="email" name="email" class="form-control" value="<%= c.getEmail() %>" required placeholder=" ">
                        </div>

                        <div class="form-group">
                        	<label>Phone</label>
                            <input type="text" name="phone" class="form-control" value="<%= c.getPhone() %>" placeholder=" ">
                        </div>

                        <div class="form-group">
                            <label>Address</label>
                            <input type="text" name="address" class="form-control" value="<%= c.getAddress() %>" placeholder=" ">
                        </div>

                        <div class="mt-4">
                            <button type="submit" class="btn btn-primary">Update Client</button>
                            <a href="adminListClients.jsp" class="btn btn-secondary ms-2">Cancel</a>
                        </div>

                    </form>

                </div>

            </main>
        </div>
    </div>
</div>

<%@ include file="../../includes/footer.jsp" %>
