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
	if(rs1.next()){
		mySession = rs1.getString("mySession"); //rs1.getString(1): select from login 테이블로 부터 my_session값 불러옴	
	}
	if(mySession.equals("ON")){
		response.sendRedirect("/diary/diary.jsp");
		return;
	}
	//1.요청값 분석
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	String sql2 = "select member_id memberId from member where member_id=? and member_pw=?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,memberId);
	stmt2.setString(2,memberPw);
	rs2 = stmt2.executeQuery();
	
	if(rs2.next()){
		//로그인 성공
		System.out.println("로그인성공");
		//diary.login.my_session -> "ON" 변경
		String sql3 = "update login set my_session = 'ON',on_date = now()";
		PreparedStatement stmt3 = conn.prepareStatement(sql3);
		int row = stmt3.executeUpdate();
		System.out.println(row+"<--row");
		response.sendRedirect("/diary/diary.jsp");
		
	} else{
		//로그인 실패
		System.out.println("로그인실패");
		String errMsg = URLEncoder.encode("아이디와 비밀번호를 확인 해주세요","utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
	}
	
	
	conn.close();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
		
	<h1>로그인</h1>
</body>
</html>