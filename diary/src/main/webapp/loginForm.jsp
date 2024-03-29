<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* //0.로그인(인증) 분기
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
	} */
	
	//0-1 로그인(인증)분기 session사용으로 변경
	//로그인 성공시 세션에 loginMember라는 변수를 만들고 값으로 로그인 아이디를 저장
	String loginMember = (String)(session.getAttribute("loginMember"));
	//사용되는 sessionAPI
	//session.getAttribute():변수이름으로 변수값을 반환하는 메서드
	//session.getAttribute()는 찾는 변수가 없으면 null값을 반환한다
	//null이면 로그아웃상태이고, null이 아니면 로그인 상태
	System.out.println(loginMember+"<--loginMember");
	
	//loginForm페이지는 로그아웃 상태에서만 출력되는 페이지
	if(loginMember != null){
		response.sendRedirect("/diary/diary.jsp");
		return;
	}
	
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