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
	
	String lunchDate = request.getParameter("lunchDate");
	String menu = request.getParameter("menu");
	
	System.out.println(lunchDate);
	System.out.println(menu);
	
	String sql2 = "insert into lunch(lunch_date, menu, create_date, update_date)VALUES(?, ?, now(), now())";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,lunchDate);
	stmt2.setString(2,menu);
	System.out.println(stmt2);
	
	int row = stmt2.executeUpdate();
	if(row==1){
		System.out.println("입력성공");
	}else{
		System.out.println("입력실패");
	}
	response.sendRedirect("/diary/statsLunch.jsp");
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