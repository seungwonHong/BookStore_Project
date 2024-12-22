<%@page import="java.sql.PreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@include file="dbconn.jsp" %>

<%
String userId = request.getParameter("userId");

if(userId != null){
	PreparedStatement pstmt = null;
	try{
		pstmt = conn.prepareStatement("delete from User where user_id = ?");
		pstmt.setString(1, userId);
		int result = pstmt.executeUpdate();
		
		if(result > 0){
			response.sendRedirect("editProfile.jsp");
		}else{
			out.print("삭제할 사용자를 찾지 못함");
		}
		
	}catch(Exception e){
		e.printStackTrace();
		out.print("삭제 오류");
	}
}
%>
</body>
</html>