<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	//로그인(인증) 분기
	//diary(db이름).login(테이블이름).mysession db설정 => 'OFF' => redirect("loginForm.jsp")
	
/* 	String sql1 = "select my_session mySession from login";
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
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요","utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
		//자원반납
		rs1.close();
		stmt1.close();
		conn.close();
		return; //코드진행을 종료시키는 문법 ex) 메서드 끝낼때 return사용
	} */
%>
<%
	String loginMember = (String)(session.getAttribute("loginMember"));
	if(loginMember == null) {
	String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
	response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
	return;
	}
%>
<%	
	
	//출력 리스트
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 5; //페이지당 출력되는 글 개수
	/* 
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("rowPerPage"));
	} */
	int startRow = (currentPage-1)*rowPerPage; // 1-0,2-10,3-20,4-30...
	
	//페이징
	String searchWord = ""; //null이 될수없음
	if(request.getParameter("searchWord") != null){
		searchWord = request.getParameter("searchWord");
	}
	/* "select diary_date diaryDate, title 
	from diary 
	where title like ? 
	order by diary_date desc 
	limit ?,?" 
	*/
	String sql2 = "select diary_date diaryDate, title from diary where title like ? order by diary_date desc limit ?,?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,"%"+searchWord+"%");
	stmt2.setInt(2,startRow);
	stmt2.setInt(3,rowPerPage);
	rs2 = stmt2.executeQuery();
	
	String sql3 = "select count(*) cnt from diary where title like ?";
	PreparedStatement stmt3 = null;
	ResultSet rs3 = null;
	stmt3 = conn.prepareStatement(sql3);
	stmt3.setString(1,"%"+searchWord+"%");
	rs3 = stmt3.executeQuery();
	int totalRow = 0;
	if(rs3.next()){
		totalRow = rs3.getInt("cnt");
	}
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage !=0){
		lastPage = lastPage +1;
	}
	
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
	 table{
	 	border:1px solid #FFD6FD;
		border-radius:5px;
		text-align: center;
		width:300px;
	 }	
		
</style>
</head>

<body class="bg-success-subtle">
<div class="container">
		<div class="row justify-content-center">
			<div class="mt-5 col-7 bg-white border shadow p-3 mb-5 bg-body-tertiary rounded">
				<div>
					<a href="/diary/diary.jsp">메인화면/</a>
					<a href="/diary/addDiaryForm.jsp">다이어리/</a>
					<a href="/diary/lunchOne.jsp">점심투표/</a>
					<a href="/diary/statsLunch.jsp">점심투표결과</a>
				</div>
				<h1 class="text-center">목록</h1>
				
					<table style="margin-left: auto; margin-right: auto;">
							<tr>
								<th>날짜</th>
								<th>제목</th>
							</tr>
							<%
								while(rs2.next()){
							%>
								<tr>
									<td><a href='/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>'>
										<%=rs2.getString("diaryDate")%>
										</a>
									</td>
									<td><%=rs2.getString("title")%></td>
									
								</tr>
							<%
								}
							%>	
					
					</table>
				
	<nav aria-label="Page navigation example">
  	<ul class="pagination justify-content-center">
  	
	<%
		if(currentPage > 1){
	%>
		<li class="page-item">
			<a class ="page-link" href="./diaryList.jsp?currentPage=1"> << </a>
		</li>
		<li class="page-item">
			<a class ="page-link" href="./diaryList.jsp?currentPage=<%=currentPage-1%>&searchWord=<%=searchWord%>">이전</a>
		</li>
	<%		
		} else{
	%>
		<li class="page-item disabled">
			<a class ="page-link" href="./diaryList.jsp?currentPage=1"> << </a>
		<li class="page-item disabled">
			<a class ="page-link" href="./diaryList.jsp?currentPage=<%=currentPage-1%>">이전</a>
		</li>
	<%
		}
	%>
		&nbsp;
		<div>
			<span class="btn btn-outline-secondary">
					<%=currentPage%> 
			</span>
		</div>
		&nbsp;
	<%		
		
		if(currentPage < lastPage) {
	%>
		<li class="page-item">
			<a class ="page-link" href="./diaryList.jsp?currentPage=<%=currentPage+1%>">다음</a>
		</li>
		<li class="page-item">
			<a class ="page-link" href="./diaryList.jsp?currentPage=<%=lastPage%>">>></a>
		</li>
		
	<%		
		}
	%>
	</ul>
	</nav>
		
	<form method="get" action="./diaryList.jsp?searchWord=<%=request.getParameter(searchWord)%>">
		<div>
			제목검색:
			<input type="text" name="searchWord" value="<%=searchWord%>">
			<button type="submit">검색</button>
		</div>
	</form>
</body>
</html>