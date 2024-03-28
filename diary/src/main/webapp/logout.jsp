<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@page import="java.net.*"%>
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
	if(mySession.equals("OFF")){
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
		//자원반납
		
		return; //코드진행을 종료시키는 문법 ex) 메서드 끝낼때 return사용
	}
	//현재값이 OFF아니고 ON이다 -> OFF변경후 loginForm으로 리다이렉트
	String sql2 = "update login set my_session='off',off_date=now()";
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	int row = stmt2.executeUpdate();
	System.out.println(row + "<--row");
	
	response.sendRedirect("/diary/loginForm.jsp");
	
	
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
	
</body>
</html>