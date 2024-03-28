<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@page import="java.net.*"%>
<%
	//0.로그인(인증) 분기
	//diary(db이름).login(테이블이름).mysession db설정 => 'ON' => redirect("diary.jsp")
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
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
		//자원반납
		
		return; //코드진행을 종료시키는 문법 ex) 메서드 끝낼때 return사용
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
	
	
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>addDiaryForm</title>
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
	
	<h1>일기쓰기</h1>
	
	<form method="post" action="/diary/checkDateAction.jsp">
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
	<form method="post" action="/diary/addDiaryAction.jsp">	
		<div>
			날짜:
			<%
				if(ck.equals("T")){
			%>
			<input value="<%=checkDate%>" type="text" name="diaryDate" readonly="readonly">  
			<%
				}else{
			%>
				<input value="" type="text" name="diaryDate" readonly="readonly">
			<%
				}
			%>	
		</div>
		<div>
			기분:
			<input type="radio" name="feeling" value="&#128512;">&#128512;
			<input type="radio" name="feeling" value="&#128545;">&#128545;
			<input type="radio" name="feeling" value="&#128567;">&#128567;
			<input type="radio" name="feeling" value="&#128561;">&#128561;
			<input type="radio" name="feeling" value="&#128565;">&#128565;
			<input type="radio" name="feeling" value="&#128564;">&#128564;
		</div>
		<div>
			제목:<input type="text" name="title">  
		</div>
		<div>
			<select name="weather">
				<option value="맑음">맑음</option>
				<option value="흐림">흐림</option>
				<option value="비">비</option>
				<option value="눈">눈</option>
			</select>  
		</div>
		<div class="mt-3 fs-4"></div>
		<form method="post" action="./addDiaryAction.jsp">
		<div>
			<textarea rows="7" cols="50" name="content"></textarea>	
		</div>
		<div class="d-grid">
			<button type="submit" class="btn btn-primary">입력</button>
		</div>
		</form>
		
		<div>
			<div class="col"></div>
		</div>
		
	</form>
	</div>
	</div>
	</div>
</body>
</html>