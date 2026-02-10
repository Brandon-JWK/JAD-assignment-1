<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="client-page">
  <div class="container mt-5" style="max-width: 900px;">

    <h2 class="client-page-title">Booking Details</h2>

    <div class="client-card mb-3">
      <p><b>Booking ID:</b> ${b.bookingId}</p>
      <p><b>Status:</b> ${b.status}</p>
    </div>

    <div class="client-card">
      <c:if test="${empty l}">
        <p>No details found for this booking.</p>
      </c:if>

      <c:if test="${not empty l}">
        <table class="table client-table mb-0">
          <thead>
            <tr>
              <th>Service</th>
              <th>Quantity</th>
              <th>Unit Price</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="d" items="${l}">
              <tr>
                <td>${d.serviceName}</td>
                <td>${d.quantity}</td>
                <td>$${d.unitPrice}</td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </c:if>
    </div>

    <div class="mt-3">
      <a href="<c:url value='/ClientController?action=viewBookings'/>"
         class="btn btn-client-secondary w-100">
        Back to My Bookings
      </a>
    </div>

  </div>
</div>

<%@ include file="../includes/footer.jsp" %>
