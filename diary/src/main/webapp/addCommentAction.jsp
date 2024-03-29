<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	String diaryDate = request.getParameter("diaryDate");
	String memo = request.getParameter("memo");
	String createDate = request.getParameter("createDate");
	System.out.println(diaryDate+"<--diaryDate");
	System.out.println(memo+"<--memo");
	System.out.println(createDate+"<--createDate");
	
	String sql = "insert into comment(diary_date,memo,update_date,create_date)VALUES(?,?,now(),now())";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,diaryDate);
	stmt.setString(2,memo);
	stmt.setString(3,createDate);
	rs = stmt.executeQuery();
	
	response.sendRedirect("/diary/diaryOne.jsp?diaryDate="+diaryDate);
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