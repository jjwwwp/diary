<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	String sql1 = "select my_session mySession from login";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	
	String mySession = null;
	if(rs1.next());{
		mySession = rs1.getString("mySession"); //rs1.getString(1): select from login 테이블로 부터 my_session값 불러옴	
	}
	if(mySession.equals("OFF")){
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요","utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
		return; //코드진행을 종료시키는 문법 ex) 메서드 끝낼때 return사용
	}
		

	String diaryDate = request.getParameter("diaryDate");
	System.out.println(diaryDate +"<--diaryDate"); 
	
	
	String sql2 = "select diary_date, feeling,title,weather,content,update_date,create_date from diary where diary_date=?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;

	//쿼리
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,diaryDate);
	rs2 = stmt2.executeQuery();
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
	<div class="mt-5 col-7 bg-white border shadow p-3 mb-5 bg-body-tertiary rounded">
		<div>
			<a href="/diary/diary.jsp">다이어리/</a>
			<a href="/diary/diaryList.jsp">게시판</a>
		</div>
		<h1>내용</h1>
	
	<%
		if(rs2.next()){
	%>
		<div style="display: flex; justify-content: center;">
			<table class="table">
				<tr>
					<td>날짜:</td>
					<td><%=rs2.getString("diary_date")%></td>
				</tr>
				<tr>
					<td>기분:</td>
					<td><%=rs2.getString("feeling")%></td>
				</tr>
				<tr>
					<td>제목:</td>
					<td><%=rs2.getString("title")%></td>
				</tr>
				<tr>
					<td>날씨:</td>
					<td><%=rs2.getString("weather")%></td>
				</tr>
				<tr>
					<td>내용:</td>
					<td><%=rs2.getString("content")%></td>
				</tr>
			</table>
		</div>
	<%
		}
	%>
		<div>
			<a href="/diary/updateDiaryForm.jsp?diaryDate=<%=diaryDate%>">
				<button type="submit" class="btn btn-outline-primary">수정</button>
			</a>
			
			<a href="/diary/deleteDiaryAction.jsp?diaryDate=<%=diaryDate%>">
				<button type="submit" class="btn btn-outline-primary">삭제</button>
			</a>
		</div>
	</div>
</body>
</html>