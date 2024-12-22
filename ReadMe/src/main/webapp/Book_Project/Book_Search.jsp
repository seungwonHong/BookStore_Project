<%@page import="java.util.Base64"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<%@page import="part_5.dao.Book2"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
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


<div style="height: 100px;"></div>

<div align="center">
	<form action="Book_Search_process.jsp" method="post">
		<input type="text" name="keyword" placeholder="  책 이름으로 검색" style="box-shadow: none; width: 450px; border-radius: 20px; border: 1px solid black; height: 40px;">
		<input type="submit" value="검색" style="width: 60px; height: 40px; border: none; border-radius: 20px; background-color: lightsalmon">
	</form>
</div>

<div style="height: 100px;"></div>

<%--여기에 정보 받아와서 책 보여줌 --%>

<div style="padding-top: 30px; display: flex; flex-direction: row; flex-wrap: wrap;  width: 100%; margin: auto;" align="center">
<%
List<Book2> searchResult = (List<Book2>) session.getAttribute("SearchResult");

if(searchResult != null){
	for(Book2 book2 : searchResult){
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		
		try{
			pstmt = conn.prepareStatement("select b_fileName from Book where b_id=?");
			pstmt.setString(1, book2.getBookId());
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				Blob imageblob = rs.getBlob("b_fileName");
				InputStream inputStream = imageblob.getBinaryStream();
				byte[] imageBytes = inputStream.readAllBytes();
                String base64Image = Base64.getEncoder().encodeToString(imageBytes);
				
				%>
					<div style="flex-direction: column; padding-left: 20px; padding-right: 20px; flex: 0 0 calc(33.33% - 40px); margin: auto ; padding-bottom: 40px; ">
									<img src="data:image/jpeg;base64,<%=base64Image%>" style="width: 150px; height: 200px;"> <%--사진 경로를 작성할 때 어떤 프로젝트인지 앞에 써야한다 --%>
									<h5><b><%=book2.getName()%></b></h5>
									<p><%=book2.getAuthor() %></p>
									<p><%=book2.getPublisher() %> | <%=book2.getPrice() %></p>
									<p><%=book2.getDescription().substring(0, 60) %>...</p>
									<p> <a href="book_detail.jsp?id=<%=book2.getBookId()%>"><button type="button" style="background-color: lightsalmon; border-radius: 30px; border: none;">상세 정보</button></a>
								</div>
				<%
			}else{
				System.out.print("데이터베이스로부터 데이터 가져오기 실패");
			}
			
		}catch(Exception e){
			e.printStackTrace();
			System.out.print("연결 오류 : " + e.getMessage());
		}
		
	}
	
}else{
	System.out.print("검색 결과 없음");
}
%>
</div>

</div>
	<%
}else{
	session.setAttribute("bookSearchURL", request.getRequestURI());
	response.sendRedirect("LoginPage.jsp");
}
%>

</body>
</html>