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
request.setCharacterEncoding("utf-8");

String comment = request.getParameter("comment");
String commenter = (String)session.getAttribute("userid");
int postid = Integer.parseInt(request.getParameter("postid"));

PreparedStatement pstmt = null;

try{
	pstmt = conn.prepareStatement("insert into Comment(commenter, comment, post_id) values(?, ?, ?)");
	pstmt.setString(1, commenter);
	pstmt.setString(2, comment);
	pstmt.setInt(3, postid);
	pstmt.executeUpdate();
	response.sendRedirect("Post_Detail.jsp?postid=" + postid);
	
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