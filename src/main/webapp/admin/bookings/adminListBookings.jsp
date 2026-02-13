<%@ page import="dao.AdminBookingDao, models.Booking" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>

<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/sidebar.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=3">

<%
    AdminBookingDao bookingDao = new AdminBookingDao();
    List<Booking> allBookings = bookingDao.getAllBookingsAdmin();

    // ---- RAW params ----
    String fltKeywordRaw = request.getParameter("keyword");
    String fltStatusRaw = request.getParameter("status");
    String fltDateFromParam = request.getParameter("dateFrom");
    String fltDateToParam = request.getParameter("dateTo");

    // ---- FINAL filter values (so lambdas work) ----
    final String fltKeyword =
            (fltKeywordRaw == null || "null".equals(fltKeywordRaw) || fltKeywordRaw.trim().isEmpty())
                    ? null
                    : fltKeywordRaw.trim();

    final String fltStatus =
            (fltStatusRaw == null || "null".equals(fltStatusRaw) || fltStatusRaw.trim().isEmpty())
                    ? null
                    : fltStatusRaw.trim();

    java.sql.Date tmpFrom = null;
    try { if (fltDateFromParam != null && !fltDateFromParam.isBlank()) tmpFrom = java.sql.Date.valueOf(fltDateFromParam); }
    catch(Exception e) {}
    final java.sql.Date fltFromDate = tmpFrom;

    java.sql.Date tmpTo = null;
    try { if (fltDateToParam != null && !fltDateToParam.isBlank()) tmpTo = java.sql.Date.valueOf(fltDateToParam); }
    catch(Exception e) {}
    final java.sql.Date fltToDate = tmpTo;

    // ---- Sorting ----
    String sortBy = request.getParameter("sortBy");
    String sortDir = request.getParameter("sortDir");
    if (sortBy == null || sortBy.isBlank()) sortBy = "scheduledDate";
    if (sortDir == null || sortDir.isBlank()) sortDir = "desc";
    sortDir = sortDir.equalsIgnoreCase("asc") ? "asc" : "desc";

    // ---- Pagination ----
    int currentPage = 1;
    int pageSize = 10;
    try { if (request.getParameter("page") != null) currentPage = Integer.parseInt(request.getParameter("page")); }
    catch(Exception e){ currentPage = 1; }
    int rowOffset = (currentPage - 1) * pageSize;

    // ---- Filter in memory ----
    List<Booking> filtered = new ArrayList<>(allBookings);

    if (fltKeyword != null) {
        final String k = fltKeyword.toLowerCase();
        filtered.removeIf(b -> {
            String clientNameText = String.valueOf(b.getClientName()).toLowerCase();
            String remarksText = String.valueOf(b.getRemarks() == null ? "" : b.getRemarks()).toLowerCase();
            return !(clientNameText.contains(k) || remarksText.contains(k));
        });
    }

    if (fltStatus != null) {
        filtered.removeIf(b -> b.getStatus() == null || !b.getStatus().equalsIgnoreCase(fltStatus));
    }

    if (fltFromDate != null) {
        filtered.removeIf(b -> b.getScheduledDate() == null || b.getScheduledDate().before(fltFromDate));
    }

    if (fltToDate != null) {
        filtered.removeIf(b -> b.getScheduledDate() == null || b.getScheduledDate().after(fltToDate));
    }

    // ---- Sort ----
    final String _sortBy = sortBy;
    final String _sortDir = sortDir;

    Collections.sort(filtered, (a, b) -> {
        int cmp = 0;

        if ("clientName".equalsIgnoreCase(_sortBy)) {
            cmp = String.valueOf(a.getClientName()).compareToIgnoreCase(String.valueOf(b.getClientName()));
        } else if ("status".equalsIgnoreCase(_sortBy)) {
            cmp = String.valueOf(a.getStatus()).compareToIgnoreCase(String.valueOf(b.getStatus()));
        } else if ("scheduledTime".equalsIgnoreCase(_sortBy)) {
            if (a.getScheduledTime() == null && b.getScheduledTime() == null) cmp = 0;
            else if (a.getScheduledTime() == null) cmp = -1;
            else if (b.getScheduledTime() == null) cmp = 1;
            else cmp = a.getScheduledTime().compareTo(b.getScheduledTime());
        } else {
            if (a.getScheduledDate() == null && b.getScheduledDate() == null) cmp = 0;
            else if (a.getScheduledDate() == null) cmp = -1;
            else if (b.getScheduledDate() == null) cmp = 1;
            else cmp = a.getScheduledDate().compareTo(b.getScheduledDate());
        }

        return "desc".equalsIgnoreCase(_sortDir) ? -cmp : cmp;
    });

    // ---- Page slice ----
    int total = filtered.size();
    int totalPages = (int)Math.ceil((double)total / pageSize);

    int fromIndex = Math.min(rowOffset, total);
    int toIndex = Math.min(rowOffset + pageSize, total);
    List<Booking> bookings = filtered.subList(fromIndex, toIndex);

    // ---- Link params ----
    String encKeyword = "";
    try { encKeyword = (fltKeyword == null) ? "" : URLEncoder.encode(fltKeyword, "UTF-8"); }
    catch(Exception e){ encKeyword = (fltKeyword == null) ? "" : fltKeyword; }

    String baseQs = "keyword=" + encKeyword
                  + "&status=" + (fltStatus == null ? "" : fltStatus)
                  + "&dateFrom=" + (fltDateFromParam == null ? "" : fltDateFromParam)
                  + "&dateTo=" + (fltDateToParam == null ? "" : fltDateToParam)
                  + "&sortBy=" + sortBy
                  + "&sortDir=" + sortDir;

    String nextClientDir = ("clientName".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
    String nextStatusDir = ("status".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
    String nextDateDir   = ("scheduledDate".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
    String nextTimeDir   = ("scheduledTime".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
%>

<div class="page-wrapper d-flex flex-column">
    <div class="admin-layout d-flex flex-column flex-grow-1">

        <main class="admin-content">
            <div class="row">
                <main class="col-md-10 ms-sm-auto px-4">

                    <div class="admin-page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Manage Bookings</h1>
                        <a class="btn btn-outline-secondary" href="adminListBookings.jsp">Reset</a>
                    </div>

                    <form method="get" class="row g-2 mb-3">
                        <input type="hidden" name="page" value="1"/>

                        <div class="col-md-3">
                            <input class="form-control" name="keyword" placeholder="Search client / remarks..."
                                   value="<%= (fltKeyword != null) ? fltKeyword : "" %>">
                        </div>

                        <div class="col-md-2">
                            <select class="form-select" name="status">
                                <option value="">All Status</option>
                                <option value="Confirmed" <%= "Confirmed".equalsIgnoreCase(fltStatus) ? "selected":"" %>>Confirmed</option>
                                <option value="Completed" <%= "Completed".equalsIgnoreCase(fltStatus) ? "selected":"" %>>Completed</option>
                                <option value="Cancelled" <%= "Cancelled".equalsIgnoreCase(fltStatus) ? "selected":"" %>>Cancelled</option>
                            </select>
                        </div>

                        <div class="col-md-2">
                            <input type="date" class="form-control" name="dateFrom" value="<%= (fltDateFromParam != null) ? fltDateFromParam : "" %>">
                        </div>
                        <div class="col-md-2">
                            <input type="date" class="form-control" name="dateTo" value="<%= (fltDateToParam != null) ? fltDateToParam : "" %>">
                        </div>

                        <div class="col-md-3">
                            <button class="btn btn-primary" type="submit">Filter</button>
                        </div>
                    </form>

                    <!-- TABLE + PAGINATION (same box) -->
                    <div class="card shadow-sm mb-3">
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th><a href="adminListBookings.jsp?page=1&<%= baseQs %>&sortBy=clientName&sortDir=<%= nextClientDir %>">Client</a></th>
                                        <th><a href="adminListBookings.jsp?page=1&<%= baseQs %>&sortBy=status&sortDir=<%= nextStatusDir %>">Status</a></th>
                                        <th><a href="adminListBookings.jsp?page=1&<%= baseQs %>&sortBy=scheduledDate&sortDir=<%= nextDateDir %>">Scheduled Date</a></th>
                                        <th><a href="adminListBookings.jsp?page=1&<%= baseQs %>&sortBy=scheduledTime&sortDir=<%= nextTimeDir %>">Scheduled Time</a></th>
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
                                            <form action="<%=request.getContextPath()%>/AdminBookingController" method="post" style="display:inline;">
                                                <input type="hidden" name="bookingId" value="<%=b.getBookingId()%>"/>
                                                <select name="status" class="form-select form-select-sm d-inline w-auto">
                                                    <option value="Completed" <%= "Completed".equals(b.getStatus()) ? "selected" : "" %>>Completed</option>
                                                    <option value="Cancelled" <%= "Cancelled".equals(b.getStatus()) ? "selected" : "" %>>Cancelled</option>
                                                </select>
                                                <button type="submit" name="action" value="updateStatus" class="btn btn-sm btn-primary ms-1">Update</button>
                                            </form>

                                            <form action="<%=request.getContextPath()%>/AdminBookingController" method="post" style="display:inline;">
                                                <input type="hidden" name="bookingId" value="<%=b.getBookingId()%>"/>
                                                <button type="submit" name="action" value="deleteBooking" class="btn btn-sm btn-danger ms-1"
                                                        onclick="return confirm('Delete this booking?')">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>

                        <div class="d-flex justify-content-center p-3 pt-2">
                            <nav aria-label="Page navigation" class="mb-0">
                                <ul class="pagination mb-0">
                                    <% if (currentPage > 1) { %>
                                        <li class="page-item">
                                            <a class="page-link" href="adminListBookings.jsp?page=<%= currentPage-1 %>&<%= baseQs %>">Previous</a>
                                        </li>
                                    <% } %>

                                    <% for (int i=1; i<=totalPages; i++) { %>
                                        <li class="page-item <%= (i==currentPage ? "active" : "") %>">
                                            <a class="page-link" href="adminListBookings.jsp?page=<%= i %>&<%= baseQs %>"><%= i %></a>
                                        </li>
                                    <% } %>

                                    <% if (currentPage < totalPages) { %>
                                        <li class="page-item">
                                            <a class="page-link" href="adminListBookings.jsp?page=<%= currentPage+1 %>&<%= baseQs %>">Next</a>
                                        </li>
                                    <% } %>
                                </ul>
                            </nav>
                        </div>
                    </div>

                </main>
            </div>
        </main>
    </div>
</div>

<%@ include file="../../includes/footer.jsp" %>
