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

ResultSet rs = null;
PreparedStatement pstmt = null;

try{
	pstmt = conn.prepareStatement("select user_id, user_password from User where user_id=?");
	pstmt.setString(1, id);
	rs = pstmt.executeQuery();
	
	if(rs.next()){
		String rsid = rs.getString("user_id");
		String rspassword = rs.getString("user_password");
		
		if(id.equals(rsid) && password.equals(rspassword)){
			String booklisturl = (String)session.getAttribute("bookListURL");
			String addbookurl = (String)session.getAttribute("addbookURL");
			String carturl = (String)session.getAttribute("cartURL");
			String editProfileURL = (String)session.getAttribute("editProfileURL");
			String booksearchURL = (String)session.getAttribute("BookSearchURL");
			String communityURL = (String)session.getAttribute("CommunityURL");
			String MyPostURL = (String)session.getAttribute("MyPostURL");
			session.setAttribute("userid", id);
			session.setAttribute("userpassword", password);
			
			if(booklisturl != null){
				session.removeAttribute("bookListURL");
				response.sendRedirect(booklisturl);
			}else if(addbookurl != null){
				session.removeAttribute("bookListURL");
				response.sendRedirect(addbookurl);
			}else if(carturl != null){
				session.removeAttribute("cartURL");
				response.sendRedirect(carturl);
			}else if(editProfileURL != null){
				session.removeAttribute("editProfileURL");
				response.sendRedirect(editProfileURL);
			}
			else if(booksearchURL != null){
				session.removeAttribute("BookSearchURL");
				response.sendRedirect(booksearchURL);
				
			}else if(communityURL != null){
				session.removeAttribute("CommunityURL");
				response.sendRedirect(communityURL);
				
			}else if(MyPostURL != null){
				session.removeAttribute("MyPostURL");
				response.sendRedirect(MyPostURL);
			}
			else{
				response.sendRedirect("WelcomePage.jsp");
			}
			
		}else{
			response.sendRedirect("LoginPage.jsp?error=1");
		}
	}else{
		%>
		<script type="text/javascript">
			alert("회원가입이 되어있지 않은 상태입니다.");
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