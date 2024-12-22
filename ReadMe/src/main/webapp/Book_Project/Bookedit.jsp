<%@page import="java.util.Base64"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<%@page import="part_5.dao.*"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>책 리스트 페이지</title>
</head>
<body>
<%
if(session != null && session.getAttribute("userid") != null && "admin".equals(session.getAttribute("userid"))){
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

<br><br>

<div style="background-image: url('/ReadMe/Book_Project/images/book_add.jpeg'); background-size: cover; border-radius: 30px; height: 10cm; padding: 30px;">
	<span style="font-size: 60px; font-weight: bold; color: #EDE9E9;">도서 편집<br></span>
		<span style="font-size: 25px; color: #EDE9E9;">BookEdit</span>
</div>

<div style="padding-bottom: 20px; padding-top: 20px; display: flex; flex-direction: row; flex-wrap: wrap;  width: 100%; margin: auto;" align="center">
			<jsp:useBean id="bookdao" class="part_5.dao.BookRepository2" scope="session"/>
				<%
				ResultSet rs = null;
				PreparedStatement pstmt = null;
				
				try{
					pstmt = conn.prepareStatement("select b_id, b_name, b_price, b_author, b_description, b_publisher, b_fileName from Book order by b_id");
					rs = pstmt.executeQuery();
					
					while(rs.next()){
						String rsname = rs.getString("b_name");
						String rsprice = rs.getString("b_price");
						String rsauthor = rs.getString("b_author");
						String rsdescription = rs.getString("b_description");
						String rspublisher = rs.getString("b_publisher");
						String rsbookID = rs.getString("b_id");
						
						Blob imageblob = rs.getBlob("b_fileName");
						InputStream inputStream = imageblob.getBinaryStream();
						byte[] imageBytes = inputStream.readAllBytes();
	                    String base64Image = Base64.getEncoder().encodeToString(imageBytes);
						
						%>
						<div style="flex-direction: column; padding-left: 20px; padding-right: 20px; flex: 0 0 calc(33.33% - 40px); margin: auto ; padding-bottom: 40px;">
							<img src="data:image/jpeg;base64,<%=base64Image%>" style="width: 150px; height: 200px;">  <%--사진 경로를 작성할 때 어떤 프로젝트인지 앞에 써야한다 --%>
							<h5><b><%=rsname%></b></h5>
							<p><%=rsauthor %></p>
							<p><%=rspublisher %> | <%=rsprice %></p>
							<p><%=rsdescription.substring(0, 60) %>...</p>
							<p> <a href="Bookedit_update.jsp?id=<%=rsbookID%>"><button type="button" style="background-color: lightsalmon; border-radius: 30px; border: none;">도서 수정</button></a>
						</div>
						<%
					}
					
				}catch(Exception e){
					e.getStackTrace();
					
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
				
			</div>
			<%@ include file="footer.jsp"%>
</div>
	<%
}else if(!"admin".equals(session.getAttribute("userid"))){
	%>
	<script type="text/javascript">
	alert("관리자만 접근 가능합니다");
	history.go(-1);
	</script>
	<%
}
else{
	session.setAttribute("bookListURL", request.getRequestURI());
	response.sendRedirect("LoginPage.jsp");
}
%>


			

</body>
</html>