<!DOCTYPE html>
<html>
<head>
    <title>Silver Care</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/includes.css?v=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/client.css?v=1">
    <%
	  models.Promotion activePromo = (models.Promotion) request.getAttribute("activePromo");
	  String primary = (activePromo != null && activePromo.getThemePrimary() != null) ? activePromo.getThemePrimary() : "#2c6bed";
	  String accent  = (activePromo != null && activePromo.getThemeAccent()  != null) ? activePromo.getThemeAccent()  : "#ffb020";
	%>
	<style>
	:root{
	  --brandPrimary: <%= primary %>;
	  --brandAccent: <%= accent %>;
	}
	</style>
</head>
