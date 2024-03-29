<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@page import="java.net.*"%>
<%
	
	// 0. 로그인(인증) 분기
	String loginMember = (String)(session.getAttribute("loginMember"));
	System.out.println(loginMember + " <-loginMember");
	// loginForm페이지는 로그아웃상태에서만 출력되는 페이지
	if(loginMember != null) {
		response.sendRedirect("/diary/diary.jsp");
		return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return사용
	}
	
	// loginMember가 null 이다 -> session공간에 loginMember변수를 생성...

	// 1. 요청값 분석 -> 로그인 성공 -> session에 loginMember변수를 생성
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	String sql2 = "select member_id memberId from member where member_id=? and member_pw=?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 =	conn.prepareStatement(sql2);
	stmt2.setString(1, memberId);
	stmt2.setString(2, memberPw);
	rs2 = stmt2.executeQuery();
	
	if(rs2.next()) {
		// 로그인 성공
		System.out.println("로그인 성공");
		/*
		String sql3 = "update login set my_session = 'ON', on_date = NOW() where my_session='OFF'";
		PreparedStatement stmt3 = conn.prepareStatement(sql3);
		int row = stmt3.executeUpdate();
		System.out.println(row+ " <-- row");
		*/
		// 로그인 성공시 DB값 설정 -> session변수 설정
		session.setAttribute("loginMember", rs2.getString("memberId"));
		
		response.sendRedirect("/diary/diary.jsp");
		
	} else {
		// 로그인 실패
		System.out.println("로그인 실패");
		String errMsg = URLEncoder.encode("아이디와 비밀번호를 확인 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
	}

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