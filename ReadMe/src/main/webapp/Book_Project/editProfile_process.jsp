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

String name = request.getParameter("name");
String id = request.getParameter("id");
String password = request.getParameter("password");
String email = request.getParameter("email");

ResultSet rs = null;
PreparedStatement pstmt = null;

try{
	pstmt = conn.prepareStatement("select user_id, user_password, email, name from User where user_id=?");
	pstmt.setString(1, id);
	rs = pstmt.executeQuery();
	
	if(rs.next()){
		pstmt = conn.prepareStatement("update User set user_id=?, user_password=?, email=?, name=? where user_id=?");
		pstmt.setString(1, id);
		pstmt.setString(2, password);
		pstmt.setString(3, email);
		pstmt.setString(4, name);
		pstmt.setString(5, id);
		pstmt.executeUpdate();
		
		%>
		<script type="text/javascript">
				alert("회원정보가 수정됨");
				window.location.href = "editProfile.jsp";
			</script>
		<%
		
	}else{
		%>
		<script type="text/javascript">
				alert("일치하는 id가 없음");
				history.go(-1);
			</script>
		<%
	}
	
}catch(Exception exception){
	exception.getStackTrace();
	out.print("연결 오류");
}finally{
	if(rs != null){
		rs.close();
	}
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