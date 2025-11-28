<%@ page import="dao.ServiceDao, java.util.List, models.Service" %>

<%
    int categoryId = Integer.parseInt(request.getParameter("categoryId"));
    ServiceDao dao = new ServiceDao();
    List<Service> list = dao.getServicesByCategory(categoryId);
%>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="client-page">

<div class="container mt-5">

    <h2 class="client-page-title">Services in this Category</h2>

    <div class="row g-4 mt-3">

        <% for (Service s : list) { %>

            <div class="col-md-4">
                <div class="client-card h-100">

                    <h4 class="text-purple mb-2"><%= s.getServiceName() %></h4>

                    <p class="text-muted">
                        <%= s.getServiceDesc() %>
                    </p>

                    <p class="fw-bold mt-2">
                        Price: $<%= s.getPrice() %>
                    </p>

                    <a href="serviceDetails.jsp?serviceId=<%= s.getServiceId() %>"
                       class="btn btn-client-primary w-100 mt-2">
                       View Details
                    </a>

                </div>
            </div>

        <% } %>

    </div>

</div>

</div>

<%@ include file="../includes/footer.jsp" %>
