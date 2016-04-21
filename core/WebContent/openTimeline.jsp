<%@page import="com.resource.Document"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/timelineStyle.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
	integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7"
	crossorigin="anonymous">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>News Articles</title>
</head>
<body>
	<%@ page import="org.json.*"%>
	<%@ page import="java.util.*"%>
	<%
		String year = (String) request.getAttribute("year"); 
		Map<String, List<Document>> year_docidMap = (TreeMap<String, List<Document>>) session.getAttribute("data");
		List<Document> yearData= year_docidMap.get(year);
	%>

	<%
		for(int i=0; i<yearData.size(); i++){ 
			String headline = yearData.get(i).getDocAsJSON().getJSONArray("headline").getString(0);
	%>
	<div class="container">
		<p><%=headline%>
	</div>
	<br>
	<br>
	<%
		}
	%>
</body>
</html>