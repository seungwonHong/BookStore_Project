<%@page import="java.util.Base64"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.util.List"%>
<%@page import="part_5.dao.*"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>웰컴 페이지</title>
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

<div style="padding: 30px;">
	<span style="font-size: 60px; font-weight: bold;">ReadMe<br></span>
		<span style="font-size: 50px; color: gray; font-weight: bold;">최고의 책을 구입하는 가장 좋은 방법</span>
</div>

<div style="padding-top: 200px; padding-left: 30px;">
	<span style="font-size: 40px; font-weight: bold;">Best Selling.</span>
		<span style="font-size: 30px; font-weight: bold; color: gray;">가장 '핫'한 책</span>
</div>

<div style="padding-top: 30px; padding-left: 30px; flex-direction: row; display: flex;">
		<%
		ResultSet rs1 = null;
		PreparedStatement pstmt1 = null;
		String b_id = "ISBN1234";
		
		try{
			pstmt1 = conn.prepareStatement("select b_fileName, b_name, b_price, b_author, b_description, b_publisher from Book where b_id=?");
			pstmt1.setString(1, b_id);
			rs1 = pstmt1.executeQuery();
			
			if(rs1.next()){
				String bookname = rs1.getString("b_name");
				String bookprice = rs1.getString("b_price");
				String publisher = rs1.getString("b_publisher");
				String author = rs1.getString("b_author");
				String description = rs1.getString("b_description");
				
				Blob imageblob = rs1.getBlob("b_fileName");
				InputStream inputStream = imageblob.getBinaryStream();
				byte[] imageBytes = inputStream.readAllBytes();
                String base64Image = Base64.getEncoder().encodeToString(imageBytes);
				
				%>
				<img src="/ReadMe/Book_Project/images/ISBN1234.jpeg"  style="width: 250px; height: 350px; margin-right: 100px;">
				
				<div style="flex-direction: column; padding-right: 300px;">
				<h3><%=bookname %></h3>
				<p> <%=publisher %> </p>
				<p> <%=author %> </p>
				<p> <%=bookprice %>원 </p>
				<p> <%=description %> </p>
				</div>
				<%
				
			}else{
				System.out.print("정보 가져오기 실패");
			}
			
		}catch(Exception exception){
			exception.printStackTrace();
			System.out.print("연결 오류 : " + exception.getMessage());
		}finally{
			if(rs1 != null){
				rs1.close();
			}
			if(pstmt1 != null){
				pstmt1.close();
			}
		}
		%>
</div>

<div style="height: 60px;"></div>

<div style="flex-direction: column; padding: 30px;">
	<div align="right">
		<a href="BookList.jsp" style="color: black; text-decoration: none;"><span>+ more</span></a>
	</div>
		
		<div style="padding-top: 30px; padding-left: 30px; flex-direction: row; display: flex; overflow-x: auto; margin: auto;" align="center">
			<%
			ResultSet rs = null;
			PreparedStatement pstmt = null;
			
			try{
				pstmt = conn.prepareStatement("select b_name, b_fileName from Book order by b_id");
				rs = pstmt.executeQuery();
				
				while(rs.next()){
					String bookname = rs.getString("b_name");
					
					Blob imageblob = rs.getBlob("b_fileName");
					InputStream inputStream = imageblob.getBinaryStream();
					byte[] imageBytes = inputStream.readAllBytes();
                    String base64Image = Base64.getEncoder().encodeToString(imageBytes);
					
					%>
					<div style="flex-direction: column; align-content: center; margin-left: 20px; margin-right: 40px;" align="center">
						<img src="data:image/jpeg;base64,<%=base64Image%>" style="width: 150px; height: 200px;">
						<div style="height: 10px;"></div>
						<h6><b><%=bookname%></b></h6>
					</div>
					<%
					
				}
				
			}catch(Exception exception){
				exception.printStackTrace();
				out.print("데이터베이스 접근 실패 : " +  exception.getMessage());
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

</div>

			
<%@ include file="footer.jsp"%>
</div>
</body>
</html>