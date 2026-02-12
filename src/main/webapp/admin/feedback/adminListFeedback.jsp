<%@ page import="dao.AdminFeedbackDao, java.util.List, models.Feedback" %>
<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/sidebar.jsp" %>

<div class="page-wrapper d-flex flex-column">
    <div class="admin-layout d-flex flex-column flex-grow-1">
        <main class="admin-content">
            <div class="row">
                <main class="col-md-10 ms-sm-auto px-4">
                    <div class="admin-page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Manage Feedback</h1>
                    </div>

                    <%
                        AdminFeedbackDao dao = new AdminFeedbackDao();
                        List<Feedback> feedbackList = dao.getAllFeedbackAdmin();
                    %>

                    <div class="table-responsive">
                        <table class="table table-striped table-bordered align-middle">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Client</th>
                                    <th>Service</th>
                                    <th>Rating</th>
                                    <th>Comments</th>
                                    <th>Created At</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Feedback f : feedbackList) { %>
                                    <tr>
                                        <td><%= f.getFeedbackId() %></td>
                                        <td><%= f.getClientName() %></td>
                                        <td><%= f.getServiceName() %></td>
                                        <td><%= f.getRating() %> / 5</td>
                                        <td><%= f.getComments() != null ? f.getComments() : "-" %></td>
                                        <td><%= f.getCreatedAt() %></td>
                                        <td>
                                            <form action="<%=request.getContextPath()%>/AdminFeedbackController" method="post" style="display:inline;">
                                                <input type="hidden" name="feedbackId" value="<%= f.getFeedbackId() %>"/>
                                                <button type="submit" name="action" value="deleteFeedback" class="btn btn-sm btn-danger" onclick="return confirm('Delete this feedback?')">Delete</button>
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