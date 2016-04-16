<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/timelineStyle.css">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
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
		String numOfResponse = jo.getJSONObject("response").get("numFound").toString();
		ArrayList<String> links = new ArrayList<String>();
		ArrayList<String> dates = new ArrayList<String>();
		for (int i = 0; i < arr.length(); i++) {
			JSONObject data = arr.getJSONObject(i);
			links.add(data.get("headline").toString());
			dates.add(data.get("date").toString());
		}
	%>
	<div class="container">
  <div class="page-header">
    <h3 id="timeline"><%= numOfResponse %> results found in <%= time %> miliseconds</h3>
  </div>
  <ul class="timeline">
  	<%for (int i=0;i<links.size();i++) {
  		String display = links.get(i);
  		String dispDate = dates.get(i);
  		display = display.substring(2,display.length()-2);
  		dispDate = dispDate.substring(2, dispDate.length()-2);
  		String year = dispDate.substring(0,4);
  	%>
  	<%if(i%2==0) {%>
    <li>
      <div class="timeline-badge info"><%= year %></div>
      <div class="timeline-panel">
        <div class="timeline-heading">
          <h4 class="timeline-title">Mussum ipsum cacilds</h4>
          <p><small class="text-muted"><i class="glyphicon glyphicon-time"></i> 11 hours ago via Twitter</small></p>
        </div>
        <div class="timeline-body">
          <p><%= display %>
        </div>
      </div>
    </li>
    <%} 
    else{ %>
    <li class="timeline-inverted">
      <div class="timeline-badge warning"><%= year %></div>
      <div class="timeline-panel">
        <div class="timeline-heading">
          <h4 class="timeline-title">Mussum ipsum cacilds</h4>
          <p><small class="text-muted"><i class="glyphicon glyphicon-time"></i> 11 hours ago via Twitter</small></p>
        </div>
        <div class="timeline-body">
          <p><%= display %>
        </div>
      </div>
    </li>
    <%} %>
    <%} %>
  </ul>
</div>
</body>
</html>