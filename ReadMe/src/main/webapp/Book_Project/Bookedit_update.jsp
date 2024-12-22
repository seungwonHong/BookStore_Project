<%@page import="java.util.Base64"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.io.InputStream"%>
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

<div style="background-image: url('/ReadMe/Book_Project/images/book_add.jpeg'); background-size: cover; border-radius: 30px; height: 10cm; padding: 30px;">
	<span style="font-size: 60px; font-weight: bold; color: #EDE9E9;">정보 수정<br></span>
		<span style="font-size: 25px; color: #EDE9E9;">Update Information</span>
</div>

<div style="padding-bottom: 30px; padding-top: 30px; display: flex; flex-direction: row; padding-right: 30px; padding-left: 30px;">
			<jsp:useBean id="bookdao" class="part_5.dao.BookRepository2" scope="session"/>
				<%
				String id = request.getParameter("id"); // url에 담아서 넘어온 bookId를 받아온다
				Book2 book2 = bookdao.getBookById(id); // getBookId 함수에 매개변수로 id를 넣어서 같은 id가 들어있는 객체를 판별한다
				
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
						<img src="data:image/jpeg;base64,<%=base64Image%>" style="width: 350px; height: 450px; margin-right: 100px;">
				
				<div style="flex-direction: column; ">
				
				<form action="Bookedit_update_process.jsp" method="post" enctype="multipart/form-data">
						<div>
					<p><label style="display: inline-block; width: 200px;">도서 코드</label>
						 <input type="text" name="bookId" value="<%=rsid%>"></p>
						 </div>
						 
					<div>
					<p><label style="display: inline-block; width: 200px;">도서명</label> 
					<input type="text" name="bookName" value="<%=rsname%>"></p>
					</div>
					
					
					<div>
					<p><label style="display: inline-block; width: 200px;">가격</label> 
					<input type="text" name="bookPrice" value="<%=rsprice%>"></p>
					</div>
					
					<div>
					<p><label style="display: inline-block; width: 200px;">저자</label> 
					<input type="text" name="author" value="<%=rsauthor%>"></p>
					</div>
					
					<div>
					<p><label style="display: inline-block; width: 200px;">출판사</label> 
					<input type="text" name="publisher" value="<%=rspublisher%>"></p>
					</div>
					
					<div>
					<p><label style="display: inline-block; width: 200px;">출판일</label> 
					<input type="text" name="releaseDate" value="<%=rsreleaseDate%>"></p>
					</div>
					
					<div>
					<p><label style="display: inline-block; width: 200px; vertical-align: top;">상세 설명</label> 
					<textarea rows="2" cols="30" placeholder="상세 정보를 입력하세요" name="description"><%=rsdescription %></textarea>
					</div>
					
					<div>
					<p><label style="display: inline-block; width: 200px;">분류</label> 
					<input type="text" name="category" value="<%=rscategory%>"></p>
					</div>
					
					<div>
					<p><label style="display: inline-block; width: 200px;">재고수량</label> 
					<input type="text" name="unitsInStock" value="<%=rsunitsInStock%>"></p>
					</div>
					
					<div>
					<p><label style="display: inline-block; width: 200px;">상태</label> 
					<input type="radio" name="condition" value="New">새 도서
					<input type="radio" name="condition" value="Old">중고 도서
					<input type="radio" name="condition" value="EBook">E-Book
					</div>
					
					<div>
					<p><label style="display: inline-block; width: 200px;">이미지</label> 
					<input type="file" name="BookImage"></p>
					</div>
					
					<input type="hidden" name="filename" value="<%=base64Image%>">
					
					<input type="submit" value="수정" style="border-radius: 10px; border: none; background-color: lightsalmon">
					
					</form>
								</div>
						<%
					}else{
						out.print("도서 정보 확인 불가");
					}
					
				}catch(Exception exception){
					exception.getStackTrace();
					out.print("연결 불가");
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
</body>
</html>