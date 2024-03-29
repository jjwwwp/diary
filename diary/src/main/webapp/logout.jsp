<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.net.*"%>
<%
	//session.removeAttribute("loginMember");
	//System.out.println(session.getId() +"<--session.invalidate()호출전");
	//System.out.println(session.getId() +"<--session.invalidate()호출후");
	session.invalidate(); //세션공간 초기화(포멧)

	response.sendRedirect("/diary/loginForm.jsp");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	
</body>
</html>