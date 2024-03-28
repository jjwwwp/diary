<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	String diaryDate = request.getParameter("diaryDate");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	
	System.out.println(diaryDate + "<--diaryDate");
	System.out.println(title + "<--title");
	System.out.println(weather + "<--weather");
	System.out.println(content + "<--content");
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	String sql = "update diary set title=?, weather=?, content=?, update_date= now() where diary_date=? ";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	stmt.setString(1,title);
	stmt.setString(2,weather);
	stmt.setString(3,content);
	stmt.setString(4,diaryDate);
	
	System.out.println(stmt);
	int row = stmt.executeUpdate();
	System.out.println(row);
	if(row==1){
		response.sendRedirect("./diaryOne.jsp?diaryDate="+diaryDate);
	} else{
		response.sendRedirect("./updateDiaryForm.jsp");
	}
	
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