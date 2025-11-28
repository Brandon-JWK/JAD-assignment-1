<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="client-page">
<div class="container mt-5" style="max-width: 700px;">

    <div class="client-card text-center">
        <h2 class="client-page-title">Booking Confirmed!</h2>

        <p class="text-muted mb-4">
            Thank you. Your booking has been successfully confirmed.
        </p>

        <a href="<%= request.getContextPath() %>/client/clientDashboard.jsp"
           class="btn btn-client-primary w-100">
           Return to Dashboard
        </a>
    </div>

</div>
</div>

<%@ include file="../includes/footer.jsp" %>
