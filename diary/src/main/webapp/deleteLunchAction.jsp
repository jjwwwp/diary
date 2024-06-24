<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");

	//투표기록 삭제하기
	String lunchDate = request.getParameter("lunchDate");
	System.out.println(lunchDate);
	String sql = "delete from lunch where lunch_date=?";
	PreparedStatement stmt = null;
	Connection conn = null;
	conn =  DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,lunchDate);
	System.out.println(stmt);
	int row = stmt.executeUpdate();
	
	
	System.out.println(row +"<-투표글 개수 row");
	
	if(row == 1){ 
		response.sendRedirect("./lunchOne.jsp");
		System.out.println("삭제성공");
	}else{
		response.sendRedirect("./lunchOne.jsp?lunchDate="+lunchDate);
		System.out.println("삭제실패");
	}
	
	conn.close();
	stmt.close();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
</head>
<body>
	
</body>
</html>