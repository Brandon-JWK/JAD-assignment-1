<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="client-page">
  <div class="container mt-5" style="max-width: 1000px;">

    <h2 class="client-page-title">My Bookings / Care Schedule</h2>

    <c:if test="${empty bookings}">
      <div class="client-card text-center">
        <h4 class="text-purple mb-2">No bookings found</h4>
        <p class="text-muted mb-4">You have not confirmed any bookings yet.</p>
        <a href="<c:url value='/public/serviceCategories.jsp'/>" class="btn btn-client-primary w-100">
          Browse Services
        </a>
      </div>
    </c:if>

    <c:if test="${not empty bookings}">
      <div class="client-card">
        <table class="table client-table mb-0">
          <thead>
            <tr>
              <th>Booking ID</th>
              <th>Status</th>
              <th>Created At</th>
              <th>Scheduled Date</th>
              <th>Scheduled Time</th>
              <th>Remarks</th>
              <th style="width: 120px;">Action</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="b" items="${bookings}">
              <tr>
                <td>${b.bookingId}</td>
                <td>${b.status}</td>
                <td>${b.createdAt}</td>
				<td><c:out value="${b.scheduledDate}" default="-" /></td>
				<td><c:out value="${b.scheduledTime}" default="-" /></td>
				<td><c:out value="${b.remarks}" default="-" /></td>

                <td>
                  <a class="btn btn-client-secondary btn-sm w-100"
                     href="<c:url value='/ClientController?action=viewBookingDetails&bookingId=${b.bookingId}'/>">
                    Details
                  </a>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </c:if>

    <div class="mt-3">
      <a href="<c:url value='/client/clientDashboard.jsp'/>" class="btn btn-client-secondary w-100">
        Back to Dashboard
      </a>
    </div>

  </div>
</div>

<%@ include file="../includes/footer.jsp" %>
