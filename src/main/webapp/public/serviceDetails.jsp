<%@ page import="dao.ServiceDao, models.Service" %>

<%
    int serviceId = Integer.parseInt(request.getParameter("serviceId"));
    ServiceDao dao = new ServiceDao();
    Service s = dao.getServiceById(serviceId);
%>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="client-page">

<div class="container mt-5" style="max-width: 900px;">

    <div class="row g-4">

        <!-- Image -->
        <div class="col-md-5">
            <div class="client-card text-center">

                <img src="<%= request.getContextPath() + "/" + s.getImagePath() %>"
                     alt="<%= s.getServiceName() %>"
                     class="img-fluid rounded"
                     style="border-radius: 12px; max-height: 280px; object-fit: cover;">
            </div>
        </div>

        <!-- Details -->
        <div class="col-md-7">

            <div class="client-card h-100">

                <h2 class="client-page-title"><%= s.getServiceName() %></h2>

                <p class="text-muted">
                    <%= s.getServiceDesc() %>
                </p>

                <h4 class="fw-bold mt-3 text-purple">
                    Price: $<%= s.getPrice() %>
                </h4>

                <a href="<%= request.getContextPath() %>/CartController?action=add&serviceId=<%= s.getServiceId() %>"
                   class="btn btn-client-primary w-100 mt-4">
                    Add to Cart
                </a>

            </div>

        </div>

    </div>

</div>

</div>

<%@ include file="../includes/footer.jsp" %>
