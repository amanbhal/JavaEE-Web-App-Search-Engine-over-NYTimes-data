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
		System.out.println(result);
		JSONObject jo = new JSONObject(result);
		JSONArray arr = jo.getJSONObject("response").getJSONArray("docs");
		ArrayList<String> links = new ArrayList<String>();
		for (int i = 0; i < arr.length(); i++) {
			JSONObject data = arr.getJSONObject(i);
			links.add(data.get("headline").toString());
		}
	%>
	<br>
	<div class="container">
	<table class="table table-hover">
		<thead>
			<tr>
				<th>RESULT LINKS</th>
			</tr>
		</thead>
		<%
			for (int i = 0; i < links.size(); i++) {
		%>
		<tbody>
			<tr>
				<%
					String res = "OpenFileServlet?filename="
								+ links.get(i).substring(2, links.get(i).length() - 2).replaceAll(" ", "%20");
					String[] displayArray = links.get(i).split("/");
					String display = displayArray[displayArray.length-1];
					display = display.replace(".txt","");
					display = display.substring(0,display.length()-2);
				%>
				<td><a href=<%=res %>><b><%=display %></a></td>

			</tr>
		</tbody>
		<%
			}
		%>
	</table>
	</div>

</body>
</html>