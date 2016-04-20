<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SearchEngine</title>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
	integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7"
	crossorigin="anonymous">
</head>
<body style="background-color:#BBDFD5;">

<nav class="navbar navbar-default" style="background-color:#7E619F;">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#"  style="color:white;">SearchEngine</a>
    </div>
    <ul class="nav navbar-nav">
      <li class="active"><a href="#" style="color:black;">Home</a></li> 
    </ul>
  </div>
</nav>

<div class="container" style="color:black;">
<form role="form" action="MyServlet">
  <div class="form-group">
    <label for="email"><b>ENTER SEARCH QUERY:</b></label>
    <input type="text" name="search" class="form-control" id="search">
  </div>
  <button type="submit" class="btn btn-default">Submit</button>
</form>
</div>

	<%@ page import="org.json.*"%>
	
	<%@ page import="java.util.*"%>

	<%
		String result = (String) request.getAttribute("content");
		result = result.replaceAll("\n","<br>");
	%>

<div class="container">
	<h1>NEWS</h1>
	<p><%=result %></p>
</div>

</body>
</html>