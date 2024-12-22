<%@page import="part_5.dao.*"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>책 리스트 페이지</title>
</head>
<body>
<div style="padding: 15mm;">
<%@ include file="header.jsp" %>

<%
    // 세션에서 userid를 가져옵니다.
    String userid = (String)session.getAttribute("userid");
%>
<div>
    <a href="BookList.jsp" style="text-decoration: none; color: black; margin-right: 20px;">도서 목록</a>
    
    <% if ("admin".equals(userid)) { %> 
        <!-- admin인 경우에만 도서 등록과 편집 표시 -->
        <a href="addBook.jsp" style="text-decoration: none; color: black; margin-right: 20px;">도서 등록</a>
        <a href="Bookedit.jsp" style="text-decoration: none; color: black; margin-right: 20px;">도서 편집</a>
    <% } %>
    
    <a href="Book_Search.jsp" style="text-decoration: none; color: black; margin-right: 20px;">도서 검색</a>
    <a href="Community.jsp" style="text-decoration: none; color: black; margin-right: 20px;">커뮤니티</a>
    <a href="MyPost.jsp" style="text-decoration: none; color: black; margin-right: 20px;">게시글</a>
</div>

<br><br>

<div style="background-color: lightgray; border-radius: 30px; height: 10cm; padding: 30px;">
	<span style="font-size: 60px; font-weight: bold;">로그인<br></span>
		<span style="font-size: 25px;">Login</span>
</div>

<div align="center" style="flex-direction: column; padding-top: 60px;">
	<span style="font-size: 30px;">Please sign in</span>
	
	<div style="height: 15px;"></div>
	
		<form action="Login_process.jsp" method="post">
			<p> <input type="text" name="id" placeholder="ID" size="40" style="border-radius: 5px; border: 1px solid black; outline: none;"> </p>
			<p> <input type="password" name="password" placeholder="Password" size="40" style="border-radius: 5px; outline: none; border: 1px solid black;"> </p>
			<%
			String error = request.getParameter("error");
		
			if(error != null){
			%>
			<div style="display: inline-block; width: 400px; height: 20px;" align="left">
			<p style="color: red; font-size: 11px;"> 입력하신 정보가 옳지 않습니다.<br> 다시 확인해 주세요. </p>
			</div>
			<%
			}
			%>
			<p> <input type="submit" value="로그인" style="border-radius: 10px; border: none; background-color: lightsalmon"> </p>
		</form>
		
</div>
			

</div>
</body>
</html>