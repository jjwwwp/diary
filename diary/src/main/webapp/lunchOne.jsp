<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@page import = "java.net.*"%>
<%
	// 0. 로그인(인증) 분기
	// diary.login.my_session => 'OFF' => redirect("loginForm.jsp")
	
	String sql1 = "select my_session mySession from login";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	String mySession = null;
	if(rs1.next()) {
		mySession = rs1.getString("mySession");
	}
	// diary.login.my_session => 'OFF' => redirect("loginForm.jsp")
	if(mySession.equals("OFF")) {
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
		return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return사용
	}
	
%>	
<%
	String checkDate = request.getParameter("checkDate");
	if(checkDate == null){
		checkDate = "";
	}
	String ck = request.getParameter("ck");
	if(ck == null){
		ck = "";
	}
	
	String msg = "";
	if(ck.equals("T")){
		msg = "입력이 가능한 날짜입니다";
	}else if(ck.equals("F")){
		msg = "일기가 이미 존재하는 날짜입니다";
	}

	
	String sql2 = "select * from lunch where lunch_date = ?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,checkDate);
	rs2 = stmt2.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Song+Myung&display=swap" rel="stylesheet">	
<style>
	*{
		font-family: "Song Myung", serif;
	 }
	 body{
	 	text-align: center;
	 	background-image: url('/diary/img/spring.jpg');
		background-repeat:no-repeat;
		background-size: cover; 
		width: 100%;
	 }	
</style>
</head>
<body class="bg-success-subtle">
	<div class="container">
		<div class="row">
			<div class="col"></div>
				<div class="mt-5 col-7 bg-white border shadow p-3 mb-5 bg-body-tertiary rounded">
					
		<h1>점심투표</h1>
		<form method="post" action="/diary/addLunchAction.jsp">
			<div>
				날짜확인:<input type="date" name="checkDate" value="<%=checkDate%>">
				<button type="submit" class="btn btn-primary">날짜가능확인</button>  
			</div>	
			<div>
				<h6>checkDate:<%=checkDate%>&nbsp;&nbsp;&nbsp;</h6>
				<h6>ck:<%=ck%></h6>
			</div>
			<div><span>결과: <%=msg%></span></div>
		</form>	
		<hr>
		<form method="post" action="/diary/addLunchAction.jsp">	
			<div>
				날짜:
				<%
					if(ck.equals("T")){
				%>
				<input value="<%=checkDate%>" type="text" name="checkDate" readonly="readonly">  
				<%
					}else{
				%>
					<input value="" type="text" name="checkDate" readonly="readonly">
				<%
					}
				%>	
			</div>
			<div>
				<input type="radio" name="menu" value="한식">한식
				<input type="radio" name="menu" value="일식">일식
				<input type="radio" name="menu" value="중식">중식
				<input type="radio" name="menu" value="양식">양식
				<input type="radio" name="menu" value="기타">기타
			</div>		
					
</body>
</html>