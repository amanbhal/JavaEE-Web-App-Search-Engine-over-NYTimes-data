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
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
  <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Search Results</title>
	<script src="js/openTimeline.js" type="text/javascript"></script>
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
		List<Document> yearData = year_docidMap.get(yr);
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
			int maxIteration = 0;
			if(yearData.size()<10)
				maxIteration = yearData.size();
			else
				maxIteration = 10;
			for(int j=0; j<maxIteration; j++){ 
				String headline = yearData.get(j).getDocAsJSON().getJSONArray("headline").getString(0);
				String lead_para = yearData.get(j).getDocAsJSON().getJSONArray("lead_paragraph").getString(0);
				Document passData = yearData.get(j);
				String docID = yearData.get(j).getDocAsJSON().getString("id");
				HashMap<String,Integer> userRatings = ProcessSearchResult.getDocumentRating(docID);
				int star5 = userRatings.get("five_star");
				int star4 = userRatings.get("four_star");
				int star3 = userRatings.get("three_star");
				int star2 = userRatings.get("two_star");
				int star1 = userRatings.get("one_star");
				int totalUsers = star5+star4+star3+star2+star1;
				double rating = (double)(star5*5+star4*4+star3*3+star2*2+star1*1)/(totalUsers);
				headline = headline.replaceAll("'","");
				//headline = headline.replaceAll("??","");
				lead_para = lead_para.replaceAll("'","");
				//lead_para = lead_para.replaceAll("??","");
				String author = "";
				if(!(yearData.get(j).getDocAsJSON().getJSONArray("author").length()==0)){
					author = yearData.get(j).getDocAsJSON().getJSONArray("author").getString(0);
				}
				String date = yearData.get(j).getDocAsJSON().getJSONArray("date").getString(0);
				date = date.substring(0, 10);
		%>
		<div class="article parentNode">
			<i class="fa fa-newspaper-o fa-lg fa-pull-left fa-border" aria-hidden="true"></i>
			
			<h4 style="margin-bottom:20px;"><a href="javascript:show('<%= headline %>','<%= lead_para %>','<%= star5%>','<%= star4%>','<%= star3%>','<%= star2%>','<%= star1%>','<%=docID%>','<%= date %>','<%= author %>')"><%=headline%></a></h4>
			
			<!--<h4 style="margin-bottom:20px;"><a onclick="show('<%= headline %>','<%= lead_para %>')"; href="#myModal" data-toggle="modal"><%=headline%></a></h4>-->
			<!--<i class="fa fa-paragraph fa-pull-left fa-border" aria-hidden="true"></i>
			<p style="margin-bottom:20px;"><%=lead_para %></p>-->
			<i class="fa fa-star fa-pull-left fa-border" aria-hidden="true"></i>
			<%if(Double.isNaN(rating)) {%>
				<p>Rating: 0 by 0 Users
			<%} 
			else {%>
				<p>Rating: <%= rating %> by <%= totalUsers %> Users
			<%} %>
		</div>
		<br>
		<hr style="width:60%; border-top:2px solid #eee; margin-left:15px;" align="left" size="3px">
		<br>
		<%
			}
		%>
	</div>
	
	<div id="childNode">
		<div id="insideChild" class="container">
			<i class="fa fa-newspaper-o fa-lg fa-pull-left fa-border" aria-hidden="true"></i>
			<h4 style="margin-bottom:20px;"><a id="headline"></a></h4>
			<div id="leadparaDiv">
				<i class="fa fa-paragraph fa-pull-left fa-border" aria-hidden="true"></i>
				<p id="leadpara" style="margin-bottom:20px;"></p>
			</div>
			<div id="showAuthor" style="visibility:hidden;">
				<i class="fa fa-user fa-pull-left fa-border" aria-hidden="true"></i>
				<p id="author">Written By: </p> 
			</div>
			<div>
				<i class="fa fa-calendar fa-pull-left fa-border" aria-hidden="true"></i>
				<p id="date">Dated: </p>
			</div>
			<i class="fa fa-star fa-pull-left fa-border" aria-hidden="true"></i>
			<p>User Ratings:</p>
			<table style="margin-left:75px;">
				<tr>
					<td></td>
					<td><div id="stars-5" data-rating="5"><input type="hidden" name="rating"/></div></td>
					<td id="5_star_user"></td>
				</tr>
				<tr>
					<td></td>
					<td><div id="stars-4" data-rating="4"><input type="hidden" name="rating"/></div></td>
					<td id="4_star_user"></td>
				</tr>
				<tr>
					<td></td>
					<td><div id="stars-3" data-rating="3"><input type="hidden" name="rating"/></div></td>
					<td id="3_star_user"></td>
				</tr>
				<tr>
					<td></td>
					<td><div id="stars-2" data-rating="2"><input type="hidden" name="rating"/></div></td>
					<td id="2_star_user"></td>
				</tr>
				<tr>
					<td></td>
					<td><div id="stars-1" data-rating="1"><input type="hidden" name="rating"/></div></td>
					<td id="1_star_user"></td>
				</tr>
			</table>
				
			<br>
			<p>Provide Rating:</p>
			<div class="container" style="margin-left:75px;">
		    <div class="row lead">
		        <div id="stars" class="starrr"></div>
		        <div id="docID" style="visibility:hidden;"></div>
			</div>
			<button style="position:absolute; left:45%;" class="btn btn-danger" onclick="hide()">Close</button>
			<br>
		</div>
	</div>
</body>
</html>