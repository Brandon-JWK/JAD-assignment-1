<%@ page import="dao.AdminFeedbackDao, java.util.*, models.Feedback" %>
<%@ page import="java.net.URLEncoder" %>

<%@ include file="../../includes/header.jsp" %>
<%@ include file="../../includes/navbar.jsp" %>
<%@ include file="../../includes/sidebar.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin.css?v=3">

<%
    AdminFeedbackDao feedbackDao = new AdminFeedbackDao();
    List<Feedback> allFeedback = feedbackDao.getAllFeedbackAdmin();

    // ---- RAW params ----
    String fltKeywordRaw = request.getParameter("keyword");
    String fltMinRatingParam = request.getParameter("minRating");
    String fltMaxRatingParam = request.getParameter("maxRating");

    // ---- FINAL filter values (so lambdas work) ----
    final String fltKeyword =
            (fltKeywordRaw == null || "null".equals(fltKeywordRaw) || fltKeywordRaw.trim().isEmpty())
                    ? null
                    : fltKeywordRaw.trim();

    Integer tmpMin = null;
    try { if (fltMinRatingParam != null && !fltMinRatingParam.isBlank()) tmpMin = Integer.parseInt(fltMinRatingParam); }
    catch(Exception e) {}
    final Integer fltMinRating = tmpMin;

    Integer tmpMax = null;
    try { if (fltMaxRatingParam != null && !fltMaxRatingParam.isBlank()) tmpMax = Integer.parseInt(fltMaxRatingParam); }
    catch(Exception e) {}
    final Integer fltMaxRating = tmpMax;

    // ---- Sorting ----
    String sortBy = request.getParameter("sortBy");
    String sortDir = request.getParameter("sortDir");
    if (sortBy == null || sortBy.isBlank()) sortBy = "createdAt";
    if (sortDir == null || sortDir.isBlank()) sortDir = "desc";
    sortDir = sortDir.equalsIgnoreCase("asc") ? "asc" : "desc";

    // ---- Pagination ----
    int currentPage = 1;
    int pageSize = 10;
    try { if (request.getParameter("page") != null) currentPage = Integer.parseInt(request.getParameter("page")); }
    catch(Exception e){ currentPage = 1; }
    int rowOffset = (currentPage - 1) * pageSize;

    // ---- Filter in memory ----
    List<Feedback> filtered = new ArrayList<>(allFeedback);

    if (fltKeyword != null) {
        final String k = fltKeyword.toLowerCase();
        filtered.removeIf(f -> {
            String clientNameText  = String.valueOf(f.getClientName()).toLowerCase();
            String serviceNameText = String.valueOf(f.getServiceName()).toLowerCase();
            String commentsText    = String.valueOf(f.getComments() == null ? "" : f.getComments()).toLowerCase();
            return !(clientNameText.contains(k) || serviceNameText.contains(k) || commentsText.contains(k));
        });
    }

    if (fltMinRating != null) filtered.removeIf(f -> f.getRating() < fltMinRating);
    if (fltMaxRating != null) filtered.removeIf(f -> f.getRating() > fltMaxRating);

    // ---- Sort ----
    final String _sortBy = sortBy;
    final String _sortDir = sortDir;

    Collections.sort(filtered, (a,b) -> {
        int cmp;
        if ("rating".equalsIgnoreCase(_sortBy)) {
            cmp = Integer.compare(a.getRating(), b.getRating());
        } else if ("client".equalsIgnoreCase(_sortBy)) {
            cmp = String.valueOf(a.getClientName()).compareToIgnoreCase(String.valueOf(b.getClientName()));
        } else if ("service".equalsIgnoreCase(_sortBy)) {
            cmp = String.valueOf(a.getServiceName()).compareToIgnoreCase(String.valueOf(b.getServiceName()));
        } else {
            cmp = String.valueOf(a.getCreatedAt()).compareToIgnoreCase(String.valueOf(b.getCreatedAt()));
        }
        return "desc".equalsIgnoreCase(_sortDir) ? -cmp : cmp;
    });

    // ---- Page slice ----
    int total = filtered.size();
    int totalPages = (int)Math.ceil((double)total / pageSize);

    int fromIndex = Math.min(rowOffset, total);
    int toIndex = Math.min(rowOffset + pageSize, total);
    List<Feedback> feedbackList = filtered.subList(fromIndex, toIndex);

    // ---- Link params ----
    String encKeyword = "";
    try { encKeyword = (fltKeyword == null) ? "" : URLEncoder.encode(fltKeyword, "UTF-8"); }
    catch(Exception e){ encKeyword = (fltKeyword == null) ? "" : fltKeyword; }

    String baseQs = "keyword=" + encKeyword
                  + "&minRating=" + (fltMinRatingParam == null ? "" : fltMinRatingParam)
                  + "&maxRating=" + (fltMaxRatingParam == null ? "" : fltMaxRatingParam)
                  + "&sortBy=" + sortBy
                  + "&sortDir=" + sortDir;

    String nextCreatedDir = ("createdAt".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
    String nextRatingDir  = ("rating".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
    String nextClientDir  = ("client".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
    String nextServiceDir = ("service".equals(sortBy) && "asc".equals(sortDir)) ? "desc" : "asc";
%>

<div class="page-wrapper d-flex flex-column">
    <div class="admin-layout d-flex flex-column flex-grow-1">
        <main class="admin-content">
            <div class="row">
                <main class="col-md-10 ms-sm-auto px-4">

                    <div class="admin-page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Manage Feedback</h1>
                        <a class="btn btn-outline-secondary" href="adminListFeedback.jsp">Reset</a>
                    </div>

                    <form class="row g-2 mb-3" method="get">
                        <input type="hidden" name="page" value="1"/>
                        <div class="col-md-4">
                            <input class="form-control" name="keyword" placeholder="Search client/service/comments..."
                                   value="<%= (fltKeyword != null) ? fltKeyword : "" %>">
                        </div>
                        <div class="col-md-2">
                            <input class="form-control" name="minRating" placeholder="Min rating"
                                   value="<%= (fltMinRatingParam != null) ? fltMinRatingParam : "" %>">
                        </div>
                        <div class="col-md-2">
                            <input class="form-control" name="maxRating" placeholder="Max rating"
                                   value="<%= (fltMaxRatingParam != null) ? fltMaxRatingParam : "" %>">
                        </div>
                        <div class="col-md-4">
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
                                        <th><a href="adminListFeedback.jsp?page=1&<%= baseQs %>&sortBy=client&sortDir=<%= nextClientDir %>">Client</a></th>
                                        <th><a href="adminListFeedback.jsp?page=1&<%= baseQs %>&sortBy=service&sortDir=<%= nextServiceDir %>">Service</a></th>
                                        <th><a href="adminListFeedback.jsp?page=1&<%= baseQs %>&sortBy=rating&sortDir=<%= nextRatingDir %>">Rating</a></th>
                                        <th>Comments</th>
                                        <th><a href="adminListFeedback.jsp?page=1&<%= baseQs %>&sortBy=createdAt&sortDir=<%= nextCreatedDir %>">Created At</a></th>
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
                                                <button type="submit" name="action" value="deleteFeedback" class="btn btn-sm btn-danger"
                                                        onclick="return confirm('Delete this feedback?')">Delete</button>
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
                                        <li class="page-item"><a class="page-link" href="adminListFeedback.jsp?page=<%= currentPage-1 %>&<%= baseQs %>">Previous</a></li>
                                    <% } %>
                                    <% for (int i=1; i<=totalPages; i++) { %>
                                        <li class="page-item <%= (i==currentPage ? "active" : "") %>">
                                            <a class="page-link" href="adminListFeedback.jsp?page=<%= i %>&<%= baseQs %>"><%= i %></a>
                                        </li>
                                    <% } %>
                                    <% if (currentPage < totalPages) { %>
                                        <li class="page-item"><a class="page-link" href="adminListFeedback.jsp?page=<%= currentPage+1 %>&<%= baseQs %>">Next</a></li>
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
