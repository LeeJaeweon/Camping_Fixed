<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.URL" %> 

<%
String strHtml="";
String strLine="";
try{
	String strUrl="http://localhost:8081/Project/bbsUpload/xxe.xml";
	BufferedReader br=new BufferedReader(
				new InputStreamReader((new URL(strUrl)).openConnection().getInputStream()));

	while((strLine=br.readLine())!=null){
		strHtml+=strLine;
	}
	br.close();
}catch(Exception e){
}
%>       
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>XML PARSING</title>
</head>
<body>
<%= strHtml %>
</body>
</html>