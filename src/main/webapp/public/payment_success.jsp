<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="client-page">
  <div class="container mt-5" style="max-width: 800px;">
    <div class="client-card text-center">
      <h2>Payment Successful ✅</h2>
      <p>Your booking is paid and confirmed.</p>

      <p><b>Booking ID:</b> ${bookingId}</p>

      <a class="btn btn-client-primary w-100 mt-3"
         href="<c:url value='/client/clientDashboard.jsp'/>">
        Go to Dashboard
      </a>
    </div>
  </div>
</div>

<%@ include file="../includes/footer.jsp" %>
