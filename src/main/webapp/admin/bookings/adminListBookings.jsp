<%@ page import="dao.AdminBookingDao, java.util.List, models.Booking" %>
<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/sidebar.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=3">

<div class="page-wrapper d-flex flex-column">
    <div class="admin-layout d-flex flex-column flex-grow-1">

        <main class="admin-content">
            <div class="row">

                <!-- MAIN CONTENT -->
                <main class="col-md-10 ms-sm-auto px-4">

                    <!-- Page Header -->
                    <div class="admin-page-header d-flex justify-content-between 
                                flex-wrap flex-md-nowrap align-items-center 
                                pt-3 pb-2 mb-3 border-bottom">

                        <h1 class="h2">Manage Bookings</h1>
                    </div>

                    <%
                        AdminBookingDao dao = new AdminBookingDao();
                        List<Booking> bookings = dao.getAllBookingsAdmin();
                    %>

                    <div class="table-responsive">
                        <table class="table table-striped table-bordered align-middle">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Client</th>
                                    <th>Status</th>
                                    <th>Scheduled Date</th>
                                    <th>Scheduled Time</th>
                                    <th>GST</th>
                                    <th>Remarks</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Booking b : bookings) { %>
                                    <tr>
                                        <td><%= b.getBookingId() %></td>
                                        <td><%= b.getClientName() %></td>
                                        <td><%= b.getStatus() %></td>
                                        <td><%= b.getScheduledDate() != null ? b.getScheduledDate() : "-" %></td>
                                        <td><%= b.getScheduledTime() != null ? b.getScheduledTime() : "-" %></td>
                                        <td>$<%= b.getGstRate() %></td>
                                        <td><%= b.getRemarks() != null ? b.getRemarks() : "-" %></td>
                                        <td>
                                            <!-- Update Status Form -->
                                            <form action="<%=request.getContextPath()%>/AdminBookingController" method="post" style="display:inline;">
                                                <input type="hidden" name="bookingId" value="<%=b.getBookingId()%>"/>
                                                <select name="status" class="form-select form-select-sm d-inline w-auto">
                                                    <option value="Pending" <%= "Pending".equals(b.getStatus()) ? "selected" : "" %>>Pending</option>
                                                    <option value="Confirmed" <%= "Confirmed".equals(b.getStatus()) ? "selected" : "" %>>Confirmed</option>
                                                    <option value="Completed" <%= "Completed".equals(b.getStatus()) ? "selected" : "" %>>Completed</option>
                                                    <option value="Cancelled" <%= "Cancelled".equals(b.getStatus()) ? "selected" : "" %>>Cancelled</option>
                                                </select>
                                                <button type="submit" name="action" value="updateStatus" class="btn btn-sm btn-primary ms-1">Update</button>
                                            </form>

                                            <!-- Delete Form -->
                                            <form action="<%=request.getContextPath()%>/AdminBookingController" method="post" style="display:inline;">
                                                <input type="hidden" name="bookingId" value="<%=b.getBookingId()%>"/>
                                                <button type="submit" name="action" value="deleteBooking" class="btn btn-sm btn-danger ms-1" onclick="return confirm('Delete this booking?')">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                </main>

            </div>
        </main>

    </div>
</div>

<%@ include file="../../includes/footer.jsp" %>