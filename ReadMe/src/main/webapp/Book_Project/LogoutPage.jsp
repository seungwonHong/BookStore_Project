<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
session.invalidate(); // 세션의 모든 데이터 삭제
response.sendRedirect("WelcomePage.jsp");
%>
</body>
</html>