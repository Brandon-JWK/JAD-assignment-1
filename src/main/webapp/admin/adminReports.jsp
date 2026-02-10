<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="client-page">
  <div class="container mt-5" style="max-width: 1100px;">

    <h2 class="client-page-title">Admin Reports</h2>

    <div class="client-card mb-4">
      <h4 class="text-purple mb-3">Best Rated Services</h4>
      <table class="table client-table mb-0">
        <thead><tr><th>ID</th><th>Service</th><th>Avg Rating</th><th>Total Reviews</th></tr></thead>
        <tbody>
        <c:forEach var="r" items="${bestRated}">
          <tr>
            <td>${r.serviceId}</td>
            <td>${r.serviceName}</td>
            <td>${r.avgRating}</td>
            <td>${r.totalReviews}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>

    <div class="client-card mb-4">
      <h4 class="text-purple mb-3">Lowest Rated Services</h4>
      <table class="table client-table mb-0">
        <thead><tr><th>ID</th><th>Service</th><th>Avg Rating</th><th>Total Reviews</th></tr></thead>
        <tbody>
        <c:forEach var="r" items="${lowestRated}">
          <tr>
            <td>${r.serviceId}</td>
            <td>${r.serviceName}</td>
            <td>${r.avgRating}</td>
            <td>${r.totalReviews}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>

    <div class="client-card mb-4">
      <h4 class="text-purple mb-3">High Demand Services</h4>
      <table class="table client-table mb-0">
        <thead><tr><th>ID</th><th>Service</th><th>Times Booked</th></tr></thead>
        <tbody>
        <c:forEach var="r" items="${highDemand}">
          <tr>
            <td>${r.serviceId}</td>
            <td>${r.serviceName}</td>
            <td>${r.timesBooked}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>

    <div class="client-card mb-4">
      <h4 class="text-purple mb-3">Bookings by Month</h4>
      <table class="table client-table mb-0">
        <thead><tr><th>Month</th><th>Total Bookings</th><th>Revenue</th></tr></thead>
        <tbody>
        <c:forEach var="r" items="${bookingsByMonth}">
          <tr>
            <td>${r.month}</td>
            <td>${r.totalBookings}</td>
            <td>$${r.revenue}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>

    <div class="client-card">
      <h4 class="text-purple mb-3">Top Clients</h4>
      <table class="table client-table mb-0">
        <thead><tr><th>ID</th><th>Name</th><th>Email</th><th>Total Bookings</th><th>Total Value</th></tr></thead>
        <tbody>
        <c:forEach var="r" items="${topClients}">
          <tr>
            <td>${r.clientId}</td>
            <td>${r.fullName}</td>
            <td>${r.email}</td>
            <td>${r.totalBookings}</td>
            <td>$${r.totalValue}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>

  </div>
</div>

<%@ include file="../includes/footer.jsp" %>
