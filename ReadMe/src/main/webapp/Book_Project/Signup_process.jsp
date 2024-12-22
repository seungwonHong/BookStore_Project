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

String id = request.getParameter("id");
String password = request.getParameter("password");
String name = request.getParameter("name");

ResultSet rs = null;
PreparedStatement pstmt = null;

try{
	pstmt = conn.prepareStatement("select user_id from User where user_id=?");
	pstmt.setString(1, id);
	rs = pstmt.executeQuery();
	
	if(rs.next()){
			%>
			<script type="text/javascript">
				alert("중복되는 아이디가 존재합니다");
				history.go(-1);
			</script>
			<%
		
	}else{
		if(password.length() < 4){
			%>
			<script type="text/javascript">
				alert("비밀번호는 4자리 이상으로 작성하세요");
				history.go(-1);
			</script>
			<%
		}else if(name == null && name.isEmpty()){
			%>
			<script type="text/javascript">
				alert("이름을 작성해 주세요");
				history.go(-1);
			</script>
			<%
		}
		else{
			pstmt = conn.prepareStatement("insert into User(user_id, user_password, total, name) values(?, ?, ?, ?)");
			pstmt.setString(1, id);
			pstmt.setString(2, password);
			pstmt.setInt(3, 0);
			pstmt.setString(4, name);
			pstmt.executeUpdate();
			%>
			<script type="text/javascript">
				alert("회원가입에 성공하였습니다");
				window.location.href = "LoginPage.jsp";
			</script>
			<%
		}
	}
	
}catch(Exception exception){
	exception.getStackTrace();
	out.print("오류 발생");
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