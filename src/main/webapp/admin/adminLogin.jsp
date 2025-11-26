<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="../includes/header.jsp" %>

<div class="container mt-5" style="max-width: 400px;">
    <h2 class="text-center mb-4">Admin Login</h2>

    <form action="<c:url value='/AuthController' />" method="post">
        <!-- Hidden input to tell AuthController this is an admin login -->
        <input type="hidden" name="action" value="adminLogin" />

        <div class="mb-3">
            <label for="username" class="form-label">Username</label>
            <input type="text" class="form-control" id="username" name="username" required />
        </div>

        <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input type="password" class="form-control" id="password" name="password" required />
        </div>

        <button type="submit" class="btn btn-primary w-100">Login</button>
    </form>

    <!-- Show error message if login fails -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger mt-3">${error}</div>
    </c:if>
</div>

<%@ include file="../includes/footer.jsp" %>
