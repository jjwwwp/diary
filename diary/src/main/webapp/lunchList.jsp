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
%>	
<%
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 5; //페이지당 출력되는 글 개수
	
	int startRow = (currentPage-1)*rowPerPage; 
	
	
	String searchWord = ""; //null이 될수없음
	if(request.getParameter("searchWord") != null){
		searchWord = request.getParameter("searchWord");
	}	

	String sql2 = "select lunch_date, menu from lunch where menu like ? order by lunch_date desc limit ?,?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,"%"+searchWord+"%");
	stmt2.setInt(2,startRow);
	stmt2.setInt(3,rowPerPage);
	rs2 = stmt2.executeQuery();
	
	String sql3 = "select count(*) cnt from lunch where menu like ?";
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
	
	String sql4 = "select menu, count(*) cnt from lunch group by menu";
	PreparedStatement stmt4 = null;
	ResultSet rs4 = null;
	stmt4 = conn.prepareStatement(sql4);
	rs4 = stmt4.executeQuery();
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
	  table{
	 	border:1px solid #FFD6FD;
		border-radius:5px;
		text-align: center;
	 }	
</style>	
</head>
<body class="bg-success-subtle">
	<div class="container">
		<div class="row">
			<div class="col"></div>
				<div class="mt-5 col-7 bg-white border shadow p-3 mb-5 bg-body-tertiary rounded">
				<h1 class="text-center">점심</h1>
				
					<%
					double maxHeight = 500;
					double totalCnt = 0; 
					while(rs4.next()) {
						totalCnt = totalCnt + rs4.getInt("cnt");
					}
					
					rs4.beforeFirst();
					%>
					
					<div>
						전체 투표수 : <%=(int)totalCnt%>
					</div>
						<div style="text-align: center">
						<table border="1" style="width: 400px;">
							<tr>
							<%	
								String[] c = {"#FF0000", "#FF5E00", "#FFE400", "#1DDB16", "#0054FF"};
								int i = 0;
								while(rs4.next()) {
									int h = (int)(maxHeight * (rs4.getInt("cnt")/totalCnt));
							%>
							<td style="vertical-align: bottom;">
								<div style="height: <%=h%>px; 
											background-color:<%=c[i]%>;
											text-align: center">
									<%=rs4.getInt("cnt")%>
								</div>
							</td>
							<%		
									i = i+1;
								}
							%>
							</tr>
							<tr>
							<%
								// 커스의 위치를 다시 처음으로
								rs4.beforeFirst();
											
								while(rs4.next()) {
							%>
									<td><%=rs4.getString("menu")%></td>
							<%		
								}
							%>
						</tr>
					</table>
					</div>
				
				<table class="table">
					<tr>
						<td>날짜</td>
						<td>내용</td>
					</tr>
					  <% 
						while(rs2.next()){
					  %>
					<tr>
						<td><%=rs2.getString("lunch_date")%></td>
						<td><%=rs2.getString("menu")%></td>
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
							<a class ="page-link" href="./lunchList.jsp?currentPage=1"> << </a>
						</li>
						<li class="page-item">
							<a class ="page-link" href="./lunchList.jsp?currentPage=<%=currentPage-1%>&searchWord=<%=searchWord%>">이전</a>
						</li>
					<%		
						} else{
					%>
						<li class="page-item disabled">
							<a class ="page-link" href="./lunchList.jsp?currentPage=1"> << </a>
						<li class="page-item disabled">
							<a class ="page-link" href="./lunchList.jsp?currentPage=<%=currentPage-1%>">이전</a>
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
							<a class ="page-link" href="./lunchList.jsp?currentPage=<%=currentPage+1%>">다음</a>
						</li>
						<li class="page-item">
							<a class ="page-link" href="./lunchList.jsp?currentPage=<%=lastPage%>"> >> </a>
						</li>
						
					<%		
						}
					%>
					</ul>
					</nav>
					</div>
					</div>
					</div>
					
			
</body>
</html>