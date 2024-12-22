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
String bookId = request.getParameter("id");

PreparedStatement pstmt = null;

try{
	pstmt = conn.prepareStatement("delete from Book where b_id = ?");
	pstmt.setString(1, bookId);
	int rowsDeleted = pstmt.executeUpdate();
	if(rowsDeleted > 0){
		response.sendRedirect("BookList.jsp");
	}else{
		out.print("데이터베이스에서 책 삭제 에러");
	}
	
}catch(Exception exception){
	exception.printStackTrace();
	out.print("db 에러");
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