<%@ page import="models.ServiceStatus, java.util.List" %>
<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="container mt-5">
    <h2>Real-time Service Status</h2>
    
    <div id="status-list">
        <%
            List<ServiceStatus> statuses = (List<ServiceStatus>) request.getAttribute("statuses");
            if (statuses != null && !statuses.isEmpty()) {
                for (ServiceStatus ss : statuses) {
        %>
        <div class="card mb-3">
            <div class="card-body">
                <p><strong>Booking ID:</strong> <%= ss.getBookingId() %></p>
                <p><strong>Status:</strong> <%= ss.getStatus() %></p>
                <p><strong>Check-in:</strong> <%= ss.getCheckInTime() != null ? ss.getCheckInTime() : "Not yet" %></p>
                <p><strong>Check-out:</strong> <%= ss.getCheckOutTime() != null ? ss.getCheckOutTime() : "Not yet" %></p>
                <p><strong>Notes:</strong> <%= ss.getCaregiverNotes() != null ? ss.getCaregiverNotes() : "-" %></p>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <p>No services scheduled yet.</p>
        <%
            }
        %>
    </div>
</div>

<script>
    // Polling every 10 seconds for real-time update
    setInterval(function() {
        fetch(`<%= request.getContextPath() %>/ClientServiceStatusController`)
            .then(response => response.text())
            .then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, "text/html");
                const statusList = doc.getElementById("status-list");
                document.getElementById("status-list").innerHTML = statusList.innerHTML;
            });
    }, 10000);
</script>

<%@ include file="../includes/footer.jsp" %>
