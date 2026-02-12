<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/adminLogin.jsp"); // redirect to login if not logged in
        return;
    }
%>
