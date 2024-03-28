<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@page import="java.net.URLEncoder"%>
<%
	//0.로그인(인증) 분기
	//diary(db이름).login(테이블이름).mysession db설정 => 'OFF' => redirect("loginForm.jsp")
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
	//diary.login.my_session => 'OFF' => redirect("loginForm.jsp")
	if(mySession.equals("OFF")){
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);

		return; //코드진행을 종료시키는 문법 ex) 메서드 끝낼때 return사용
	}
	
	String checkDate = request.getParameter("checkDate");
	
	String sql2 = "select diary_date diaryDate from diary where diary_date=?";
	//결과가 있으면 이미 날짜에 일기가 있다 -> 입력X
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,checkDate);
	rs2 = stmt2.executeQuery();
	if(rs2.next()){
		//이날짜 일기 기록 불가능(이미존재)
		response.sendRedirect("/diary/addDiaryForm.jsp?checkDate="+checkDate+"&ck=F");
	}else{
		//이 날짜 일기 기록 가능
		response.sendRedirect("/diary/addDiaryForm.jsp?checkDate="+checkDate+"&ck=T");
	}
	
	
	//1.요청값 분석
	String errMsg = request.getParameter("errMsg");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	<div>
		<%
			if(errMsg !=  null){
		%>
			<%=errMsg%>
		<%
			}
		%>	
	</div>
	<h1>로그인</h1>
	<form method="post" action="/diary/loginAction.jsp">
		<div>memberId: <input type="text" name="memberId"></div>
		<div>memberPw: <input type="password" name="memberPw"></div>
		<div><button type="submit">로그인</button></div>
	</form>
</body>
</html>