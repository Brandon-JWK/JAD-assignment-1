<%@ page import="dao.ClientDao, models.Client" %>
<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/sidebar.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=3">

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }
%>

<div class="page-wrapper d-flex flex-column">
    <div class="admin-layout d-flex flex-column flex-grow-1">

        <div class="row">

            <!-- Main Content -->
            <main class="col-md-10 ms-sm-auto px-4 admin-content">

                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Add New Client</h1>
                </div>

                <!-- Modern Form Card -->
                <div class="admin-form-card">

                    <form action="adminSaveClient.jsp" method="post">

                        <!-- Full Name -->
                        <div class="form-group">
                        	<label>Full Name</label>
                            <input type="text" name="full_name" class="form-control" required placeholder=" ">
                        </div>

                        <!-- Email -->
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" class="form-control" required placeholder=" ">
                        </div>

                        <!-- Phone -->
                        <div class="form-group">
                        	<label>Phone Number</label>
                            <input type="text" name="phone" class="form-control" placeholder=" ">
                        </div>

                        <!-- Address -->
                        <div class="form-group">
                         	<label>Address</label>
                            <input type="text" name="address" class="form-control" placeholder=" ">
                        </div>

                        <!-- Password -->
                        <div class="form-group">
                        	<label>Password</label>
                            <input type="password" name="password" class="form-control" required placeholder=" ">
                        </div>

                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger mt-2">
                                <%= request.getAttribute("error") %>
                            </div>
                        <% } %>

                        <!-- Buttons -->
                        <div class="mt-4">
                            <button type="submit" class="btn btn-primary">Add Client</button>
                            <a href="adminListClients.jsp" class="btn btn-secondary ms-2">Cancel</a>
                        </div>

                    </form>

                </div>
            </main>
        </div>

    </div>
</div>

<%@ include file="../../includes/footer.jsp" %>
