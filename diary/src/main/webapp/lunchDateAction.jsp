<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	//db연결
	Class.forName("org.mariadb.jdbc.Driver");
	//자원 초기화
	Connection con = null;
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

	//로그인 세션분기
		String loginMember = (String)(session.getAttribute("loginMember"));
		if(loginMember == null){
			String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 해주세요.","utf-8");
			response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
			return;
		}
	
	String checkDate = request.getParameter("checkDate");

	
	//결과가 있으면 -> 이미 이날짜에 일기가 있다 입력이 안됨 -> checkdate 보내기
	//결과가 없으면 -> 일기 입력 됨
	String checkDateSql = "select lunch_date lunchDate from lunch where lunch_date=?";
	PreparedStatement checkDateStmt = null;
	ResultSet checkDateRs = null;
	checkDateStmt = con.prepareStatement(checkDateSql);
	checkDateStmt.setString(1,checkDate);
	checkDateRs = checkDateStmt.executeQuery();
	
	if(checkDateRs.next()){
		//이날짜 일기 기록 불가능 - 커서내려서 읽어올 행이 있다 = 이미 일기를 쓴 날짜이다. 즉 ck =F  ck = F면 사용불가능
		response.sendRedirect("/diary/lunchOne.jsp?checkDate="+checkDate+"&ck=F");
	}else{
		//이날짜 일기 기록 가능 ck = T면 사용 가능
		response.sendRedirect("/diary/lunchOne.jsp?checkDate="+checkDate+"&ck=T");
	}

%>