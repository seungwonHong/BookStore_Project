<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
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
String postid = request.getParameter("postid");
System.out.println("Post ID to delete: " + postid);  // postid 값 확인

PreparedStatement pstmt = null;

try{
	pstmt = conn.prepareStatement("delete from Post where post_id=?");
	pstmt.setString(1, postid);
	pstmt.executeUpdate();
	response.sendRedirect("MyPost.jsp");
	
}catch(Exception exception){
	exception.printStackTrace();
	System.out.print("연결 오류 : " + exception.getMessage());
}finally{
	if(conn != null){
		conn.close();
	}
	if(pstmt != null){
		pstmt.close();
	}
}
%>
</body>
</html>