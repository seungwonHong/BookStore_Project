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
String userid = request.getParameter("userid");

PreparedStatement pstmt = null;

try{
	pstmt = conn.prepareStatement("delete from User where user_id=?");
	pstmt.setString(1, userid);
	pstmt.executeUpdate();
	%>
	<script type="text/javascript">
			alert("회원 탈퇴 성공!");
			window.location.href = "LogoutPage.jsp";
		</script>
	<%
	
}catch(Exception exception){
	exception.printStackTrace();
	out.print("연결 오류 : " + exception.getMessage());
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