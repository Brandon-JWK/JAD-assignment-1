<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Caregiver, models.ServiceStatus, dao.CaregiverDao" %>
<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<%
    // Get caregiver from session (must cast)
    Caregiver cg = (Caregiver) session.getAttribute("caregiver");
    if (cg == null) {
        // If not logged in, redirect to login
        response.sendRedirect("caregiverLogin.jsp");
        return;
    }

    // Create DAO and get bookings for this caregiver
    CaregiverDao dao = new CaregiverDao(); // Uses DB.getConnection internally
    List<ServiceStatus> bookings = dao.getAssignedBookings(cg.getCaregiverId());
%>

<div class="container mt-5" style="max-width: 900px;">
    <h2>Welcome, <%= cg.getFullName() %></h2>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Booking ID</th>
                <th>Status</th>
                <th>Check-In</th>
                <th>Check-Out</th>
                <th>Notes</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <% for (ServiceStatus ss : bookings) { 
               boolean disabled = "Completed".equalsIgnoreCase(ss.getStatus()) 
                                  || "Cancelled".equalsIgnoreCase(ss.getStatus());
        %>
            <tr>
                <td><%= ss.getBookingId() %></td>
                <td><%= ss.getStatus() %></td>
                <td><%= ss.getCheckInTime() != null ? ss.getCheckInTime() : "-" %></td>
                <td><%= ss.getCheckOutTime() != null ? ss.getCheckOutTime() : "-" %></td>
                <td><%= ss.getCaregiverNotes() != null ? ss.getCaregiverNotes() : "" %></td>
                <td>
                    <!-- Check-In Form -->
                    <form action="<%=request.getContextPath()%>/CaregiverServiceController" method="get" style="display:inline;">
                        <input type="hidden" name="statusId" value="<%= ss.getStatusId() %>" />
                        <button type="submit" name="action" value="checkin" class="btn btn-success btn-sm" 
                                <%= disabled ? "disabled" : "" %>>Check-In</button>
                    </form>

                    <!-- Check-Out Form -->
                    <form action="<%=request.getContextPath()%>/CaregiverServiceController" method="get" style="display:inline;">
                        <input type="hidden" name="statusId" value="<%= ss.getStatusId() %>" />
                        <button type="submit" name="action" value="checkout" class="btn btn-warning btn-sm" 
                                <%= disabled ? "disabled" : "" %>>Check-Out</button>
                    </form>

                    <!-- Add Notes Form -->
                    <form action="<%=request.getContextPath()%>/CaregiverServiceController" method="get" style="display:inline;">
                        <input type="hidden" name="statusId" value="<%= ss.getStatusId() %>">
                        <input type="hidden" name="action" value="addnote">
                        <input type="text" name="notes" placeholder="Add note" 
                               <%= disabled ? "disabled" : "" %> >
                        <input type="submit" value="Save" class="btn btn-primary btn-sm" 
                               <%= disabled ? "disabled" : "" %>>
                    </form>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>

<%@ include file="../includes/footer.jsp" %>
