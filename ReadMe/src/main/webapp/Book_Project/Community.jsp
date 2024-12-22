<%@page import="java.util.Base64"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
if(session != null && session.getAttribute("userid") != null){
	%>
	<div style="padding: 15mm;">
<%@ include file="header.jsp" %>
	
<%
    // 세션에서 userid를 가져옵니다.
    String userid = (String)session.getAttribute("userid");
%>
<div>
    <a href="BookList.jsp" style="text-decoration: none; color: black; margin-right: 20px;">도서 목록</a>
    
    <% if ("admin".equals(userid)) { %> 
        <!-- admin인 경우에만 도서 등록과 편집 표시 -->
        <a href="addBook.jsp" style="text-decoration: none; color: black; margin-right: 20px;">도서 등록</a>
        <a href="Bookedit.jsp" style="text-decoration: none; color: black; margin-right: 20px;">도서 편집</a>
    <% } %>
    
    <a href="Book_Search.jsp" style="text-decoration: none; color: black; margin-right: 20px;">도서 검색</a>
    <a href="Community.jsp" style="text-decoration: none; color: black; margin-right: 20px;">커뮤니티</a>
    <a href="MyPost.jsp" style="text-decoration: none; color: black; margin-right: 20px;">게시글</a>
</div>

<div style="height: 80px;"></div>

<%--게시글 보여주기 --%>
<%
ResultSet rs = null;
PreparedStatement pstmt = null;

try{
	pstmt = conn.prepareStatement("select post_id, poster, post, post_name, post_file from Post order by post_id desc");
	rs = pstmt.executeQuery();
	
	while(rs.next()){
		int post_id = rs.getInt("post_id");
		String poster = rs.getString("poster");
		String post = rs.getString("post");
		String post_name = rs.getString("post_name");
		
		Blob post_file = rs.getBlob("post_file");
        
      	if(post_file != null){
      		InputStream inputStream = post_file.getBinaryStream();
    		byte[] imageBytes = inputStream.readAllBytes();
            String base64Image = Base64.getEncoder().encodeToString(imageBytes);
      		 %>
             <div style="background-color: rgba(217, 217, 217, 0.3); border-radius: 30px; padding: 20px; height: auto;">
     			<form action="Post_Detail.jsp" method="post">
     				<input type="hidden" value="<%=post_id %>" name="postid">
     				<p><input type="submit" value="<%=post_name%>" style="border: none; font-size: 40px; font-weight: bold; background-color: transparent; cursor: pointer;"></p>
     			</form>
     			
     				<p><span style="font-size: 25px; margin-left: 5px;"><%=poster %></span></p>
     					<p><span style="font-size: 18px; margin-left: 5px;"><%=post %></span></p>
     						<div align="center">
     							<img src="data:image/jpeg;base64,<%=base64Image%>" style="max-width: 80%; max-height: 500px; border-radius: 15px; margin-left: 5px; object-fit: contain;">
     						</div>
     						
     		</div>
     		
     		<div style="height: 30px;"></div>
             <%
      	}else{
      		%>
            <div style="background-color: rgba(217, 217, 217, 0.3); border-radius: 30px; padding: 20px; height: auto; ">
    			<form action="Post_Detail.jsp" method="post">
    				<input type="hidden" value="<%=post_id %>" name="postid">
    				<p><input type="submit" value="<%=post_name%>" style="border: none; font-size: 40px; font-weight: bold; background-color: transparent; cursor: pointer;"></p>
    			</form>
    			
    				<p><span style="font-size: 25px; margin-left: 5px;"><%=poster %></span></p>
    					<p><span style="font-size: 18px; margin-left: 5px;"><%=post %></span></p>
    		</div>
    		
    		<div style="height: 30px;"></div>
            <%
      	}
	}
	
}catch(Exception e){
	e.printStackTrace();
	System.out.print("연결 오류 : " + e.getMessage());
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


<a href="Write.jsp">
<button type="button" style="background-color: lightsalmon; border-radius: 30px; border: none; position: fixed; bottom: 30px; right: 40px; box-shadow: 0px 3px 9px rgba(0, 0, 0, 0.6); height: 50px; display: flex; align-items: center; width: 110px; align-content: center;">
<div style="width: 5px;"></div>
<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-pencil" viewBox="0 0 16 16">
  <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325"/>
</svg>
<div style="width: 10px;"></div>
<span style="font-size: 18px; font-weight: bold;">글쓰기</span>
</button>
</a>

</div>
	<%
}else{
	session.setAttribute("CommunityURL", request.getRequestURI());
	response.sendRedirect("LoginPage.jsp");
}
%>
</body>
</html>