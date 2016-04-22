<%@page import="com.resource.Document"%>
<%@page import="com.irwebapp.pkg.ProcessSearchResult"%>
<%@page import="com.irwebapp.pkg.MyServlet"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<link rel="stylesheet" type="text/css" href="css/openTimeline.css">
	<link rel="stylesheet"
		href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
		integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7"
		crossorigin="anonymous">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.1/css/font-awesome.min.css">
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Search Results</title>
</head>
<body>
	<nav class="navbar navbar-default" style="background-color:#7E619F;">
	<div class="container-fluid">
		<div class="navbar-header">
			<a class="navbar-brand" href="#" style="color: white;">SearchEngine</a>
		</div>
		<ul class="nav navbar-nav">
			<li class="active"><a href="#" style="color: black;">Home</a></li>
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
	<br>
	<br>

	<%@ page import="org.json.*"%>
	<%@ page import="java.util.*"%>
	<%
		String content = (String) request.getAttribute("content");
		String search = (String) request.getAttribute("search");
		String yr = (String) request.getAttribute("year");
		HashMap<String, Object> parsedContent = ProcessSearchResult.getContenForTimeTimeLine(content);
		String numOfResponse = (String)parsedContent.get("numOfResponse");
		String time = (String)parsedContent.get("respones_time_in_millisecond");
		Map<String, List<Document>> year_docidMap = (TreeMap<String, List<Document>>)parsedContent.get("year_docMap");
		Map<String, List<Document>> map = (TreeMap<String, List<Document>>) session.getAttribute("data");
		List<Document> yearData = map.get(yr);
	%>
	<%
		session.setAttribute("data", year_docidMap);
	%>
	<div class="container" id="leftTimeline">
		<div id="innerTimeline">
			<div class="page-header">
				<!--<h3 id="timeline"><span style="color:red;">TIMELINE</span></h3>-->
				<br>
			</div>
			<ul class="timeline">
				<%
					int i=0;
			  		for (String year : year_docidMap.keySet()) {
			  			String url = "OpenFileServlet?year="+year+"&search="+search;
				%>
				<%
					if(i%2==0) {
				%>
				<li><a id="dateLink" href=<%=url%>><div
							class="timeline-badge info"><%=year%></div></a>
					<div class="timeline-panel">
						<div class="timeline-heading">
							<p class="timeline-title"><%=year_docidMap.get(year).size()%>
							News Articles
							</p>
							<!--<p><small class="text-muted"><i class="glyphicon glyphicon-time"></i> 11 hours ago via Twitter</small></p>-->
						</div>
						<div class="timeline-body">
							
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
							<p class="timeline-title"><%=year_docidMap.get(year).size()%>
							News Articles	
							</p>
							<!--<p><small class="text-muted"><i class="glyphicon glyphicon-time"></i> 11 hours ago via Twitter</small></p>-->
						</div>
						<div class="timeline-body">
							
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
	</div>
	<div id="searchResult">
		<h3>Showing results for <span style="color:red;"><%= search %></span> based on year <span style="color:red;"><%= yr %></span></h3>
		<br>
		<hr style="width:60%; border-top:2px solid #eee; margin-left:15px;" align="left" size="3px">
		<%
			for(int j=0; j<10; j++){ 
				String headline = yearData.get(j).getDocAsJSON().getJSONArray("headline").getString(0);
				String lead_para = yearData.get(j).getDocAsJSON().getJSONArray("lead_paragraph").getString(0);
				Document passData = yearData.get(j);
		%>
		<div class="article parentNode">
			<i class="fa fa-newspaper-o fa-lg fa-pull-left fa-border" aria-hidden="true"></i>
			<h4 style="margin-bottom:20px;"><a href="javascript:show('<%= headline %>')"><%=headline%></a></h4>
			<i class="fa fa-paragraph fa-pull-left fa-border" aria-hidden="true"></i>
			<p style="margin-bottom:20px;"><%=lead_para %></p>
			<i class="fa fa-star fa-pull-left fa-border" aria-hidden="true"></i>
			<p>Rating:
		</div>
		<br>
		<hr style="width:60%; border-top:2px solid #eee; margin-left:15px;" align="left" size="3px">
		<br>
		<%
			}
		%>
	</div>
		<div id="childNode">
			<div id="insideChild">
				
				<a href="javascript:hide()"> Close </a>
			</div>
		</div>
		<script type="text/javascript">
			function show(headline){
				document.getElementById("childNode").style.visibility = "visible";
				var div = document.getElementById("insideChild");
				var p = document.createElement("P");
				var headlineText = document.createTextNode(headline);
				p.appendChild(headlineText);
				div.appendChild(p);
			}
			function hide() {
				document.getElementById("childNode").style.visibility = "hidden";
			}
		</script>
	
</body>
</html>