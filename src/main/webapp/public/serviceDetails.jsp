<%@ page import="dao.ServiceDao, dao.FeedbackDao" %>
<%@ page import="models.Service, models.Feedback, models.Client" %>
<%@ page import="java.util.List" %>

<%
    int serviceId = Integer.parseInt(request.getParameter("serviceId"));

    ServiceDao serviceDao = new ServiceDao();
    FeedbackDao feedbackDao = new FeedbackDao();

    Service s = serviceDao.getServiceById(serviceId);
    List<Feedback> reviews = feedbackDao.getFeedbackByService(serviceId);

    Client logged = (Client) session.getAttribute("client");
%>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="client-page">

<div class="container mt-5" style="max-width: 1000px;">

    <div class="row g-4">

        <!-- ===========================
             SERVICE IMAGE
        ============================ -->
        <div class="col-md-5">
            <div class="client-card text-center">
                <img src="<%= request.getContextPath() + "/" + s.getImagePath() %>"
                     alt="<%= s.getServiceName() %>"
                     class="img-fluid rounded"
                     style="border-radius: 12px; max-height: 300px; object-fit: cover;">
            </div>
        </div>

        <!-- ===========================
             SERVICE DETAILS & ADD TO CART
        ============================ -->
        <div class="col-md-7">
            <div class="client-card h-100">

                <h2 class="client-page-title"><%= s.getServiceName() %></h2>

                <p class="text-muted">
                    <%= s.getServiceDesc() %>
                </p>

                <h4 class="fw-bold mt-3 text-purple">
                    Price: $<%= s.getPrice() %>
                </h4>

                <a href="<%= request.getContextPath() %>/CartController?action=add&serviceId=<%= s.getServiceId() %>"
                   class="btn btn-client-primary w-100 mt-4">
                    Add to Cart
                </a>

            </div>
        </div>

    </div>



    <!-- ======================================================
         REVIEWS SECTION
    ======================================================= -->

    <div class="client-card mt-5">

        <h3 class="client-page-title mb-3">Customer Reviews</h3>

        <% if (reviews.isEmpty()) { %>

            <p class="text-muted">No reviews yet for this service.</p>

        <% } else { %>

            <!-- Review list -->
            <ul class="list-group mb-4">

                <% for (Feedback fb : reviews) { %>
                    <li class="list-group-item py-3">

                        <div class="d-flex justify-content-between">
                            <strong>Rating: <%= fb.getRating() %>/5</strong>
                            <small class="text-muted"><%= fb.getCreatedAt() %></small>
                        </div>

                        <p class="mt-2 mb-0"><%= fb.getComments() %></p>

                    </li>
                <% } %>

            </ul>

        <% } %>


        <!-- ============================
             LEAVE A REVIEW (ONLY LOGGED IN)
        ============================= -->
        <% if (logged != null) { %>

            <h4 class="text-purple mt-4">Leave a Review</h4>

            <form action="<%= request.getContextPath() %>/FeedbackController" method="post" class="mt-3">

                <input type="hidden" name="action" value="add">
                <input type="hidden" name="clientId" value="<%= logged.getClientId() %>">
                <input type="hidden" name="serviceId" value="<%= serviceId %>">

                <!-- Rating -->
                <label class="form-label">Rating (1-5)</label>
                <select name="rating" class="form-select mb-3" required>
                    <option value="">Select rating</option>
                    <option value="1">1 - Very Poor</option>
                    <option value="2">2 - Poor</option>
                    <option value="3">3 - Okay</option>
                    <option value="4">4 - Good</option>
                    <option value="5">5 - Excellent</option>
                </select>

                <!-- Comments -->
                <label class="form-label">Your Review</label>
                <textarea name="comments" class="form-control mb-3" required></textarea>

                <button class="btn btn-client-primary w-100">Submit Review</button>

            </form>

        <% } else { %>

			<div class="client-card mt-4 text-center">
			
			    <p class="text-muted mb-3">You must be logged in to leave a review.</p>
			
			    <a href="<%= request.getContextPath() %>/client/clientLogin.jsp"
			       class="btn btn-client-primary w-100">
			        Login to Leave a Review
			    </a>
			
			</div>

        <% } %>

    </div>

</div>

</div>

<%@ include file="../includes/footer.jsp" %>
