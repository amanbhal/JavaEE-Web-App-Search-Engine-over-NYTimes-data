<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<link rel="stylesheet" type="text/css" href="css/timelineStyle.css">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Search Results</title>
	<script type="text/javascript" src="javascript/timeline.js" ></script>
</head>
<body>
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
		JSONObject jo = new JSONObject(result);
		String time = jo.getJSONObject("responseHeader").get("QTime").toString();
		JSONArray arr = jo.getJSONObject("response").getJSONArray("docs");
		Map<String, List<String>> year_docidMap = new TreeMap<String, List<String>>(Collections.reverseOrder());
		for (int i = 0; i < arr.length(); i++) {
			String year = arr.getJSONObject(i).getJSONArray("date").getString(0).substring(0, 4);
			String docid = arr.getJSONObject(i).getString("lead_paragraph");
			// System.out.println("Year :" + year + " Doc ID :" + docid);
			List<String> list = null;
			if (year_docidMap.containsKey(year)) {
				list = year_docidMap.get(year);
			} else {
				list = new ArrayList<String>();
			}
			list.add(docid);
			year_docidMap.put(year, list);
		}
		
		String numOfResponse = jo.getJSONObject("response").get("numFound").toString();
	%>
	<%	session.setAttribute("data", year_docidMap);
	%>
	<div class="container">
  <div class="page-header">
    <h4 id="timeline"><%= numOfResponse %> results found in <%= time %> miliseconds</h4>
  </div>
  <ul class="timeline">
  	<%	int i=0;
  		for (String year : year_docidMap.keySet()) {
  			String url = "OpenFileServlet?year="+year;
  	%>
  	<%if(i%2==0) { 	%>
    <li>
      <div class="timeline-badge info"><a id="dateLink" href=<%=url %>><%= year %></a></div>
      <div class="timeline-panel">
        <div class="timeline-heading">
          <h4 class="timeline-title"><%= year_docidMap.get(year).size() %> News Articles</h4>
          <!--<p><small class="text-muted"><i class="glyphicon glyphicon-time"></i> 11 hours ago via Twitter</small></p>-->
        </div>
        <div class="timeline-body">
          <p>Top Article:
          <p><%= year_docidMap.get(year).get(0) %>
        </div>
      </div>
    </li>
    <%} 
    else{ %>
    <li class="timeline-inverted">
      <div class="timeline-badge warning"><a id="dateLink" href=<%=url %>><%= year %></a></div>
      <div class="timeline-panel">
        <div class="timeline-heading">
          <h4 class="timeline-title"><%= year_docidMap.get(year).size() %> News Articles</h4>
          <!--<p><small class="text-muted"><i class="glyphicon glyphicon-time"></i> 11 hours ago via Twitter</small></p>-->
        </div>
        <div class="timeline-body">
          <p>Top Article:
          <p><%= year_docidMap.get(year).get(0) %>
        </div>
      </div>
    </li>
    <%} %>
    <%
    	i++;
  		} %>
  </ul>
</div>
</body>
</html>