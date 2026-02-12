<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>
<html>
<head>
    <title>Caregiver Login</title>

    <!-- Bootstrap CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f4f6f9;
        }
        .login-container {
            max-width: 400px;
            margin: 80px auto;
            padding: 30px;
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .login-title {
            text-align: center;
            margin-bottom: 25px;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="login-container">

        <h3 class="login-title">Caregiver Login</h3>

        <!-- Error Message -->
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="alert alert-danger text-center">
                <%= error %>
            </div>
        <%
            }
        %>

        <!-- Login Form -->
        <form action="<%=request.getContextPath()%>/CaregiverController" method="post">

            <input type="hidden" name="action" value="login"/>

            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" required/>
            </div>

            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="password" name="password" class="form-control" required/>
            </div>

            <div class="d-grid">
                <button type="submit" class="btn btn-primary">
                    Login
                </button>
            </div>

        </form>

        <hr>

        <div class="text-center">
            <a href="<%=request.getContextPath()%>/index.jsp">
                Back to Home
            </a>
        </div>

    </div>
</div>
<%@ include file="../includes/footer.jsp" %>
</body>
</html>
