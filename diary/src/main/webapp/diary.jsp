<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.*"%>
<%@ page import = "java.util.*" %>
<%
	//로그인(인증) 분기
	
	// 0. 로그인(인증) 분기
	String loginMember = (String)(session.getAttribute("loginMember"));
	if(loginMember == null) {
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
		return;
	}
	
	
%>
<%

Class.forName("org.mariadb.jdbc.Driver");
Connection conn = null;
conn = DriverManager.getConnection(
		"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

// 달력 API
String targetYear = request.getParameter("targetYear");
String targetMonth = request.getParameter("targetMonth");

Calendar target = Calendar.getInstance();

if(targetYear != null && targetMonth != null) {
	target.set(Calendar.YEAR, Integer.parseInt(targetYear));
	target.set(Calendar.MONTH, Integer.parseInt(targetMonth)); 
}

target.set(Calendar.DATE, 1);

// 달력 타이틀로 출력할 변수
int tYear = target.get(Calendar.YEAR);
int tMonth = target.get(Calendar.MONTH);

int yoNum = target.get(Calendar.DAY_OF_WEEK); // 일:1, 월:2, .....토:7
System.out.println(yoNum); 
// 시작공백의 개수 : 일요일 공백이 없고, 월요일은 1칸, 화요일은 2칸,....yoNum - 1이 공백의 개수
int startBlank = yoNum - 1;
int lastDate = target.getActualMaximum(Calendar.DATE); // target달의 마지막 날짜 반환
System.out.println(lastDate + " <-- lastDate");
int countDiv = startBlank + lastDate;

// DB에서 tYear와 tMonth에 해당되는 diary목록 추출
String sql2 = "select diary_date diaryDate, day(diary_date) day, feeling, left(title,5) title from diary where year(diary_date)=? and month(diary_date)=?";
PreparedStatement stmt2 = null;
ResultSet rs2 = null;
stmt2 = conn.prepareStatement(sql2);
stmt2.setInt(1, tYear);
stmt2.setInt(2, tMonth+1);
System.out.println(stmt2);

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
	 	text-align:center;
	 	background-image:url('/diary/img/spring.jpg');
	 	background-size: cover;
		background-repeat:no-repeat;
		width: 100%;
		
	 }
	 	.yo{
			float:left;
			width:60px; height:20px;
			border:1px solid #FFD6FD;
			border-radius:5px;
			margin:5px;
			text-align:center;
			font-style:oblique;
		}
		.cell{
			float:left;			
			border:1px solid #000000;
			border-radius:5px;
			width:70px; height:70px;
			text-align:center;
			font-weight: bold;
			font-style: inherit;
			font-size: 20px;
		}
		
		.sun{
		 	clear:both;
		 	color: #FF0000;
		}
		.sat{
			color: #0000FF;
		}
		
</style>
</head>
<body class="bg-success-subtle">
	<div class="container">
		<div class="row justify-content-center">
				<div class="mt-5 col-7 bg-white border shadow p-3 mb-5 bg-body-tertiary rounded">
				<div>
					<a href="/diary/diary.jsp">다이어리/</a>
					<a href="/diary/diaryList.jsp">게시판/</a>
					<a href="/diary/lunchOne.jsp">점심</a>
				</div>
					<h1>일기장</h1>
					
					<button class="btn btn-outline-primary"><a href="/diary/logout.jsp">로그아웃</a></button>	
					<button class="btn btn-outline-primary"><a href="/diary/addDiaryForm.jsp">글쓰기</a></button>
						
						<div class="container">
							<div class="row">
								<div class="col">
									<h1><%=tYear%>년
										<%=tMonth+1%>월
							</h1>
						</div>
	
			<div>
				<a href="./diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth-1%>">이전달</a>	
				<a href="./diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth+1%>">다음달</a>
			</div>	
		</div>
	
		<hr>
		
	 	<div class="yo sun">SUN</div>
        <div class="yo">MON</div>
        <div class="yo">TUE</div>
        <div class="yo">WED</div>
        <div class="yo">THU</div>
        <div class="yo">FRI</div>
        <div class="yo sat">SAT</div>
	
		
	<%
		for(int i=1; i<=countDiv; i=i+1){
			
			if(i%7==1){
	%>
		<div class="cell sun">
	<%
			}else if(i%7==0){
	%>	
		<div class="cell sat">
	<%
		}else{
	%>	
		<div class="cell">
	<% 			
	}
		if(i-startBlank > 0){
	%> 
		<%=i-startBlank%><br>
	<% 			
		//현재날짜(i-startBlank)의 일기가 rs2목록에 있는지 비교
		while(rs2.next()){
			//날짜에 일기가 존재한다
			if(rs2.getInt("day")==(i-startBlank)){
	%>
			<div style="font-size: 12px;">
				<span><%=rs2.getString("feeling")%></span>
				<a href='/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>'>
					<%=rs2.getString("title")%>...
				</a>
			</div>
	<% 
					break;
				}
			}
			rs2.beforeFirst(); // ResultSet의 커스 위치를 처음으로...
			//여기까지 진행되면 1일날의 데이터가 있는지 검색한것
		}else{
	%>
		&nbsp; 
	<%
		}
	%>			
		
		</div>
	<%
		}
	%>		

	</div>	
</div>
	</div>
</body>
</html>