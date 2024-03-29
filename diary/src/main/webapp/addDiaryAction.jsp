<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@page import = "java.net.*"%>
<%
	
	String diaryDate = request.getParameter("diaryDate");
	String feeling = request.getParameter("feeling");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	
	System.out.println(diaryDate);
	System.out.println(title);
	System.out.println(weather);
	System.out.println(content);
	
	String sql1 = "INSERT INTO `diary`.`diary` (`diary_date`,`feeling`, `title`, `weather`, `content`, `update_date`, `create_date`) VALUES (?, ?, ?, ?, ?, NOW(), NOW())";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1,diaryDate);
	stmt1.setString(2,feeling);
	stmt1.setString(3,title);
	stmt1.setString(4,weather);
	stmt1.setString(5,content);
	rs1 = stmt1.executeQuery();
	System.out.println(stmt1);
	
	response.sendRedirect("/diary/diary.jsp");


%>
