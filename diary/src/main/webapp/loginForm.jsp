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
	if(mySession.equals("ON")){
		response.sendRedirect("/diary/diary.jsp");
		//자원반납
		
		return; //코드진행을 종료시키는 문법 ex) 메서드 끝낼때 return사용
	}
	rs1.close();
	stmt1.close();
	conn.close();
	
	//1.요청값 분석
	String errMsg = request.getParameter("errMsg");
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
		
	<h1>로그인</h1>
	
	<form method="post" action="/diary/loginAction.jsp">
	<div>
		<div>memberId:<div>
		<input type="text" name="memberId">
		<div>memberPw:</div>
		<input type="password" name="memberPw">
	</div><br>
		<button type="submit" class="btn btn-primary">로그인</button>

	 </form><br>
	    <%
			if(errMsg !=  null){
		%>
			<%=errMsg%>
		<%
			}
		%>	
		
	
</body>
</html>