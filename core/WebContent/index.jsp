<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
<title>SearchEngine</title>
</head>
<body>
<nav class="navbar navbar-default" style="background-color:#7E619F;">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="http://localhost:8080/IRwebApp/"  style="color:white;">SearchEngine</a>
    </div>
    <ul class="nav navbar-nav">
      <li class="active"><a href="http://localhost:8080/IRwebApp/" style="color:black;">Home</a></li> 
    </ul>
  </div>
</nav>
<br><br><br><br><br><br><br><br><br>
<div class="container" style="color:black;">
<form role="form" action="MyServlet">
  <div class="form-group">
    <label for="email"><b>ENTER SEARCH QUERY:</b></label>
    <input type="text" name="search" class="form-control" id="search">
  </div>
  <button type="submit" class="btn btn-default">Submit</button>
</form>
</div>


</body>
</html>