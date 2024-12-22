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
String commentid = request.getParameter("commentid");

PreparedStatement pstmt = null;

try{
	pstmt = conn.prepareStatement("delete from Comment where comment_id=?");
	pstmt.setString(1, commentid);
	pstmt.executeUpdate();
	response.sendRedirect("MyComment.jsp");
	
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