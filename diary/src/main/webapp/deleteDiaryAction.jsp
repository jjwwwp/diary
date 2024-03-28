<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	String diaryDate = request.getParameter("diaryDate");
	System.out.println(diaryDate +"<--diaryDate delete"); 
	
	String sql1 = "delete from diary.diary where diary_date=? ";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1,diaryDate);
	
	
 	int row = stmt1.executeUpdate();
 	if(row==1){
 		System.out.println("삭제성공");
 	}
	response.sendRedirect("./diary.jsp");
	
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