<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="client-page">
  <div class="container mt-5" style="max-width: 900px;">

    <h2 class="client-page-title">Checkout Summary</h2>

    <div class="client-card mb-3">
      <p>Subtotal (No GST): <b>$${subtotal}</b></p>
      <p>GST (9%): <b>$${gst}</b></p>
      <p class="mb-0">Total (With GST): <b>$${total}</b></p>
    </div>

    <div class="client-card">
      <form method="post" action="<c:url value='/booking/checkout'/>">

        <div class="row g-3">
          <div class="col-md-6">
            <label class="form-label">Scheduled Date</label>
            <input type="date" name="scheduledDate" class="form-control"/>
          </div>

          <div class="col-md-6">
            <label class="form-label">Scheduled Time</label>
            <input type="time" name="scheduledTime" class="form-control"/>
          </div>

          <div class="col-12">
            <label class="form-label">Remarks</label>
            <input type="text" name="remarks" maxlength="255" class="form-control"/>
          </div>

          <div class="col-12">
            <button type="submit" class="btn btn-client-primary w-100">
              Confirm Booking
            </button>
          </div>
        </div>

      </form>

      <div class="mt-3">
        <a href="<c:url value='/booking/viewCart.jsp'/>" class="btn btn-client-secondary w-100">
          Back to Cart
        </a>
      </div>
    </div>

  </div>
</div>

<%@ include file="../includes/footer.jsp" %>
