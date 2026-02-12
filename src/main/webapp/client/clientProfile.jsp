<%@ page import="models.Client" %>

<%@ include file="../includes/header.jsp" %>
<%@ include file="../includes/navbar.jsp" %>

<div class="client-page">

	<%
	    Client c = (Client) session.getAttribute("client");
	    if (c == null) {
	        response.sendRedirect("clientLogin.jsp");
	        return;
	    }
	%>
	
	<div class="container mt-5" style="max-width: 650px;">
	
	    <h2 class="client-page-title">Your Profile</h2>
	
	    <div class="client-card">
	
	        <table class="table client-table mb-4">
	            <tr>
	                <th>Name</th>
	                <td><%= c.getFullName() %></td>
	            </tr>
	            <tr>
	                <th>Email</th>
	                <td><%= c.getEmail() %></td>
	            </tr>
	            <tr>
	                <th>Phone</th>
	                <td><%= c.getPhone() %></td>
	            </tr>
	            <tr>
	                <th>Address</th>
	                <td><%= c.getAddress() %></td>
	            </tr>
	            <tr>
    <th>Emergency Contact Name</th>
    <td><%= c.getEmergencyContactName() != null ? c.getEmergencyContactName() : "-" %></td>
</tr>
<tr>
    <th>Emergency Contact Phone</th>
    <td><%= c.getEmergencyContactPhone() != null ? c.getEmergencyContactPhone() : "-" %></td>
</tr>
<tr>
    <th>Medical Information</th>
    <td><%= c.getMedicalInfo() != null ? c.getMedicalInfo() : "-" %></td>
</tr>
	            
	        </table>
	
	        <a href="clientEditProfile.jsp" class="btn btn-client-primary w-100">
	            Edit Profile
	        </a>
	    </div>
	</div>
</div>
<%@ include file="../includes/footer.jsp" %>
