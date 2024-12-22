<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@include file="dbconn.jsp" %>
		<%
		if(session != null && session.getAttribute("userid") != null){
			ResultSet rs = null;
			PreparedStatement pstmt = null;
			String userid = (String)session.getAttribute("userid");
			
			try{
				pstmt = conn.prepareStatement("select name from User where user_id=?");
				pstmt.setString(1, userid);
				rs = pstmt.executeQuery();
				
				if(rs.next()){
					String name = rs.getString("name");
					
					%>
					<div style="position: absolute; right: 180px; margin-left: auto; height: 35px; display: flex; align-items: center">
						<span style="align-items: center; display: flex;"><a><%=name %>님</a></span>
						
						<div style="width: 20px;"></div>
						
						<a href="editProfile.jsp">
							<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="black" class="bi bi-person" viewBox="0 0 16 16">
							  <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
							</svg>
						</a>
					</div>
					
					<header style=" margin-bottom: 5px; display: flex; flex-direction: row; align-items: center;">
			<a href="./WelcomePage.jsp" class="d-flex align-items-center text-decoration-none" style="color: black;">
			<span class="fs-4" style="margin-right: auto; font-family: Georgia, serif; font-weight: bold;">ReadMe</span>
				</a>
				
				<div style="margin-bottom: 38px; ">
				<a href="cart.jsp" style="text-decoration: none; color: black; position: absolute; right: 140px; ">
					<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-cart2" viewBox="0 0 16 16">
		 				 <path d="M0 2.5A.5.5 0 0 1 .5 2H2a.5.5 0 0 1 .485.379L2.89 4H14.5a.5.5 0 0 1 .485.621l-1.5 6A.5.5 0 0 1 13 11H4a.5.5 0 0 1-.485-.379L1.61 3H.5a.5.5 0 0 1-.5-.5M3.14 5l1.25 5h8.22l1.25-5zM5 13a1 1 0 1 0 0 2 1 1 0 0 0 0-2m-2 1a2 2 0 1 1 4 0 2 2 0 0 1-4 0m9-1a1 1 0 1 0 0 2 1 1 0 0 0 0-2m-2 1a2 2 0 1 1 4 0 2 2 0 0 1-4 0"/>
							</svg>
				</a>
				</div>
				
					
					<div style="position: absolute; right: 70px; margin-left: auto;">
						<span><a href="LogoutPage.jsp" style="text-decoration: none; color: black;">로그아웃</a></span>
					</div>
					</header>
					<hr style="margin-top: 0px;">
					<%
					
				}else{
					out.print("User 테이블에서 사용자 이름 데이터 가져오기 실패");
				}
				
			}catch(Exception e){
				e.printStackTrace();
				out.print("데이터베이스 접근 실패 : " +  e.getMessage());
			}finally{
				
			}
			
		}else{
			%>
			<header class="border-bottom" style=" margin-bottom: 5px; display: flex; flex-direction: row; align-items: center;">
	<a href="./WelcomePage.jsp" class="d-flex align-items-center text-decoration-none" style="color: black;">
	<span class="fs-4" style="margin-right: auto; font-family: Georgia, serif; font-weight: bold;">ReadMe</span>
		</a>
		
		<div style="margin-bottom: 38px; ">
		<a href="cart.jsp" style="text-decoration: none; color: black; position: absolute; right: 200px; ">
			<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-cart2" viewBox="0 0 16 16">
 				 <path d="M0 2.5A.5.5 0 0 1 .5 2H2a.5.5 0 0 1 .485.379L2.89 4H14.5a.5.5 0 0 1 .485.621l-1.5 6A.5.5 0 0 1 13 11H4a.5.5 0 0 1-.485-.379L1.61 3H.5a.5.5 0 0 1-.5-.5M3.14 5l1.25 5h8.22l1.25-5zM5 13a1 1 0 1 0 0 2 1 1 0 0 0 0-2m-2 1a2 2 0 1 1 4 0 2 2 0 0 1-4 0m9-1a1 1 0 1 0 0 2 1 1 0 0 0 0-2m-2 1a2 2 0 1 1 4 0 2 2 0 0 1-4 0"/>
					</svg>
		</a>
		</div>
			
			<div style="position: absolute; right: 70px; margin-left: auto;">
				<span><a href="LoginPage.jsp" style="text-decoration: none; color: black;">로그인</a> | <a href="Signup.jsp" style="text-decoration: none; color: black;">회원가입</a></span>
			</div>
			
			</header>
			<%
		}
		%>
		
	

</body>
</html>