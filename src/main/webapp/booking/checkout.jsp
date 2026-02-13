<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="client-page">
  <div class="container mt-5" style="max-width: 900px;">

    <h2 class="client-page-title">Checkout Summary</h2>

    <div class="client-card mb-3">
      <p>Subtotal (No GST): <b>$${subtotal}</b></p>
      <p>Discount: <b>-$${discount}</b></p>
      <p>GST (9%): <b>$${gst}</b></p>
      <p class="mb-0">Total (With GST): <b>$${total}</b></p>
    </div>

	<div class="client-card mb-3">
	  <form method="post" action="<c:url value='/booking/applyPromo'/>" class="d-flex gap-2">
	    <input type="text" name="promoCode"
	       value="${sessionScope.promoCode}"
	       class="form-control"
	       placeholder="Enter promo code (e.g. SAVE10)" maxlength="30"/>
	    <button class="btn btn-client-secondary" type="submit">Apply</button>
	  </form>
	</div>
	
	<!-- Flash error (shown once) -->
	<c:if test="${not empty promoError}">
	  <div class="alert alert-danger mt-2 mb-0">
	    ${promoError}
	  </div>
	</c:if>
	
	<!-- Success (promo applied) -->
	<c:if test="${not empty promo}">
	  <div class="alert alert-success mt-2 mb-0">
	    Promo Applied: <b>${promo.promoCode}</b> ${promo.title}
	  </div>
	</c:if>

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
		    <!-- Pay later / confirm only -->
		    <button type="submit"
		        class="btn btn-client-primary w-100"
			    formaction="<c:url value='/booking/checkout'/>">
			  Confirm Booking (Pay Later)
			</button>
		  </div>
			
		  <div class="col-12">
			<!-- Stripe pay -->
			<button type="submit"
			        class="btn btn-success w-100"
			        formaction="<c:url value='/booking/payStripe'/>">
			  Pay with Stripe (Card)
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
