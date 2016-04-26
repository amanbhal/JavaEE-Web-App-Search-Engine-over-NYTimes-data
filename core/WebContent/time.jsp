<%@page import="com.resource.Document"%>
<%@page import="com.irwebapp.pkg.ProcessSearchResult"%>
<%@page import="com.irwebapp.pkg.MyServlet"%>
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
<title>Search Results</title>
</head>
<body>
	<nav class="navbar navbar-default" style="background-color:#7E619F;">
	<div class="container-fluid">
		<div class="navbar-header">
			<a class="navbar-brand" href="http://localhost:8080/IRwebApp/" style="color: white;">SearchEngine</a>
		</div>
		<ul class="nav navbar-nav">
			<li class="active"><a href="http://localhost:8080/IRwebApp/" style="color: black;">Home</a></li>
		</ul>
	</div>
	</nav>

	<div class="container" style="color: black;">
		<form role="form" action="MyServlet">
			<div class="form-group">
				<label for="email"><b>ENTER SEARCH QUERY:</b></label> <input
					type="text" name="search" class="form-control" id="search">
			</div>
			<button type="submit" class="btn btn-default">Submit</button>
		</form>
	</div>

	<%@ page import="org.json.*"%>
	<%@ page import="java.util.*"%>
	<%
		String content = (String) request.getAttribute("content");
		String search = (String) request.getAttribute("search");
		HashMap<String, Object> parsedContent = ProcessSearchResult.getContenForTimeTimeLine(content);
		String numOfResponse = (String)parsedContent.get("numOfResponse");
		String time = (String)parsedContent.get("respones_time_in_millisecond");
		Map<String, List<Document>> year_docidMap = (TreeMap<String, List<Document>>)parsedContent.get("year_docMap");
	%>
	<%
		session.setAttribute("data", year_docidMap);
	%>
	<div class="container">
		<div class="page-header">
			<h3 id="timeline"><span style="color:red;">Showing results for </span><%= search %></h3>
			<br>
			<h4 id="timeline"><%=numOfResponse%>
				results found in
				<%=time%>
				milliseconds
			</h4>
		</div>
		<ul class="timeline">
			<%
				int i=0;
		  		for (String year : year_docidMap.keySet()) {
		  			String url = "OpenFileServlet?year="+year+"&search="+search;
		  			List<Document> yearData = year_docidMap.get(year);
		  			String headline = yearData.get(0).getDocAsJSON().getJSONArray("headline").getString(0);
		  			String lead_para = yearData.get(0).getDocAsJSON().getJSONArray("lead_paragraph").getString(0);
			%>
			<%
				if(i%2==0) {
			%>
			<li><a id="dateLink" href=<%=url%>><div
						class="timeline-badge info"><%=year%></div></a>
				<div class="timeline-panel">
					<div class="timeline-heading">
						<h4 class="timeline-title"><%=year_docidMap.get(year).size()%>
							News Articles
						</h4>
						<!--<p><small class="text-muted"><i class="glyphicon glyphicon-time"></i> 11 hours ago via Twitter</small></p>-->
					</div>
					<div class="timeline-body">
						<p>
							Top Rated Article:
							<%
							String topArticle = lead_para;
						%>
						
						<p><%=topArticle%>
					</div>
				</div></li>
			<%
				} 
			else{
			%>
			<li class="timeline-inverted"><a id="dateLink" href=<%=url%>><div
						class="timeline-badge warning"><%=year%></div></a>
				<div class="timeline-panel">
					<div class="timeline-heading">
						<h4 class="timeline-title"><%=year_docidMap.get(year).size()%>
							News Articles
						</h4>
						<!--<p><small class="text-muted"><i class="glyphicon glyphicon-time"></i> 11 hours ago via Twitter</small></p>-->
					</div>
					<div class="timeline-body">
						<p>Top Article:
						<p><%=year_docidMap.get(year).get(0).getDocAsJSON().getJSONArray("lead_paragraph").getString(0)%>
					</div>
				</div></li>
			<%
				}
			%>
			<%
				i++;
													  		}
			%>
		</ul>
	</div>
</body>
</html>