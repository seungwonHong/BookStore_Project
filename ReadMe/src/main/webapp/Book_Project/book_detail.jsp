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
<title>책 정보 페이지</title>
</head>
<body>
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

<div style="background-image: url('/ReadMe/Book_Project/images/book.jpeg'); background-size: cover; border-radius: 30px; height: 10cm; padding: 30px;">
	<span style="font-size: 60px; font-weight: bold;">도서정보<br></span>
		<span style="font-size: 25px;">BookInfo</span>
</div>

<div style="padding-bottom: 30px; padding-top: 30px; display: flex; flex-direction: row; padding-right: 30px; padding-left: 30px; ">
				<%
				String id = request.getParameter("id"); // url에 담아서 넘어온 bookId를 받아온다
				
				ResultSet rs = null;
				PreparedStatement pstmt = null;
				
				try{
					pstmt = conn.prepareStatement("select b_id, b_name, b_price, b_author, b_description, b_publisher, b_category, b_unitsInStock, b_releaseDate, b_condition, b_fileName from Book where b_id=?");
					pstmt.setString(1, id);
					rs = pstmt.executeQuery();
					
					if(rs.next()){
						String rsid = rs.getString("b_id");
						String rsname = rs.getString("b_name");
						String rsprice = rs.getString("b_price");
						String rsauthor = rs.getString("b_author");
						String rsdescription = rs.getString("b_description");
						String rspublisher = rs.getString("b_publisher");
						String rscategory = rs.getString("b_category");
						String rsunitsInStock = rs.getString("b_unitsInStock");
						String rsreleaseDate = rs.getString("b_releaseDate");
						String rscondition = rs.getString("b_condition");
						
						Blob imageblob = rs.getBlob("b_fileName");
						InputStream inputStream = imageblob.getBinaryStream();
						byte[] imageBytes = inputStream.readAllBytes();
	                    String base64Image = Base64.getEncoder().encodeToString(imageBytes);
						%>
						<img src="data:image/jpeg;base64,<%=base64Image%>" style="width: 250px; height: 350px; margin-right: 100px;">
				
						<div style="flex-direction: column;">
							<h3><%=rsname %></h3>
							<p><%=rsdescription %></p>
							<p><b>도서코드 : </b><b><span><%=rsid %></span></b></p>
							<p><b>저자 : </b> <%=rsauthor %></p>
							<p><b>출판사 : </b> <%=rspublisher %></p>
							<p><b>출판일 : </b> <%=rsreleaseDate%></p>
							<p><b>분류 : </b> <%=rscategory %></p>
							<p><b>재고 수 : </b> <%=rsunitsInStock %></p>
							<span style="font-size: 20px;"><%=rsprice %>원</span> <br><br>
				
				<div style="flex-direction: row; display: flex; ">
				<form action="cart.jsp" method="post">
  					<input type="hidden" name="bookId" value="<%= rsid %>" />
  						<input type="submit" style="border-radius: 30px; border: 1.5px solid lightsalmon; background: none; color: lightsalmon;" value="장바구니에 담기"/>
					</form>
					
					<div style="width: 20px;"></div>

				<a href="BookList.jsp"><button type="button" style="border-radius: 30px; border: none; background-color: lightsalmon;">도서 목록</button></a>
				
				<div style="width: 20px;"></div>
				
				<% if ("admin".equals(userid)) { %>
        <!-- admin인 경우에만 도서 삭제 버튼 표시 -->
			        <a href="javascript:void(0);" onclick="confirmDelete('<%= rsid %>');">
			            <button type="button" style="border-radius: 30px; border: none; background-color: #E23232;">도서 삭제</button>
			        </a>
			    <% } %>
				</div>
				
<script>
    function confirmDelete(bookId) {
        // confirm 창 표시
        if (confirm("도서를 삭제하시겠습니까?")) {
            // 확인을 누르면 Book_Delete.jsp로 이동
            window.location.href = "Book_Delete.jsp?id=" + bookId;
        }
    }
</script>
				</div>
			</div>
						
						<%
					}else{
						out.print("데이터베이스와 일치하지 않음");
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
			
				
			
<%@ include file="footer.jsp"%>
</div>
</body>
</html>