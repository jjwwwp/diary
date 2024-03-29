<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.*"%>
<% 
	String loginMember = (String)(session.getAttribute("loginMember"));
	if(loginMember == null) {
	String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
	response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
	return;
	}

	String diaryDate = request.getParameter("diaryDate");

	String sql = "select diary_date, title,weather,content from diary where diary_date=?";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	
	rs = stmt.executeQuery();
	
	if(rs.next()) {
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
<!-- bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>	
<!-- font -->	
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Song+Myung&display=swap" rel="stylesheet">
<style>
	*{
		font-family: "Song Myung", serif;
	 }
	 body{
	 	text-align:center;
	 	background-image:url('/diary/img/spring.jpg');
	 	background-size: cover;
		background-repeat:no-repeat;
		width: 100%;
	 }
	 table{
	 	border:1px solid #FFD6FD;
		border-radius:5px;
	 }	
		
</style>
</head>
<body class="bg-success-subtle">
<div class="container">
<div class="row justify-content-center">
	<div class="row"></div>
	<div class="mt-5 col-7 bg-white border shadow p-3 mb-5 bg-body-tertiary rounded">
		<h1>게시글 수정</h1>
		<form method="post" action="./updateDiaryAction.jsp">
			<table>
				<tr>
					<th>날짜:</th>
					<td><input type="text" class="form-control" name="diaryDate"
						value="<%=rs.getString("diary_date")%>">
					</td>
				</tr>
				<tr>
					<th>제목:</th>
					<td><input type="text" class="form-control" name="title"
						value="<%=rs.getString("title")%>">
					</td>	
				</tr>
				<tr>
					<th>날씨:</th>
					<td><input type="text" class="form-control" name="weather"
						value="<%=rs.getString("weather")%>">
					</td>	
				</tr>
				<tr>
					<th>내용:</th>
					<td><input type="text" class="form-control" name="content"
						value="<%=rs.getString("content")%>">
				</tr>
			</table>
			
			<button type="submit">입력</button>
			<div class="col"></div>
	<%
	}
	%>	
</body>
</html>