<%@page import="java.util.Base64"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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

	<div style="height: 100px;"></div>
	
	<span style="font-size: 50px; font-weight: bold;">주문하신 책.</span>
	
	<div style="height: 50px;"></div>
	
	<%
	String userId = (String) session.getAttribute("userid");
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try{
		pstmt = conn.prepareStatement("select book_order from User where user_id=?");
		pstmt.setString(1, userId);
		rs = pstmt.executeQuery();
		
		if(rs.next()){
			String book_order = rs.getString("book_order");
			
			if(book_order == null || book_order.isEmpty()){ // 아직 주문한 목록이 없을 경우
				%>
				<div style="display: flex; flex-direction: column; " align="center">
					<div>
						<span style="font-size: 35px; font-weight: bold;">아직 주문하신 책이 없습니다.</span>
					</div>
					
					<div>
						<a href="BookList.jsp">주문하러 가기 -></a>
					</div>
				</div>
				<%
				
			}else{ // 주문한 내역이 있을 경우
				String[] bookList = book_order.split(",");
			
			%>
			<div style="display: flex; flex-direction: row; flex-wrap: wrap; width: 100%; align-items: stretch; width: 100%; justify-content: flex-start;" align="center">
			<%
			for(String book : bookList){
				PreparedStatement pstmt2 = null;
				ResultSet rs2 = null;
				try{
					pstmt2 = conn.prepareStatement("select b_name, b_author, b_fileName from Book where b_id=?");
					pstmt2.setString(1, book);
					rs2 = pstmt2.executeQuery();
					
					if(rs2.next()){
						String book_name = rs2.getString("b_name");
						String book_author = rs2.getString("b_author");
						Blob imageblob = rs2.getBlob("b_fileName");
						InputStream inputStream = imageblob.getBinaryStream();
						byte[] imageBytes = inputStream.readAllBytes();
	                    String base64Image = Base64.getEncoder().encodeToString(imageBytes);
						
						%>
							<div style="border: 1px solid gray; border-radius: 30px; padding: 10px; margin: 30px; flex-direction: column; flex:  0 0 calc(33.33% - 40px); margin: auto; margin-bottom: 30px;" align="center">
								 <a href="book_detail.jsp?id=<%=book%>">
							        <img src="data:image/jpeg;base64,<%=base64Image%>" style="width: 300px; height: 400px;">
							    </a>
								<p style="font-size: 15px;"><%=book_name %> - <%=book_author %></p>
								<div style="border: 0.5px solid gray;"></div>
								<p style="font-size: 30px; font-weight: bold; margin-bottom: 0px;">주문 완료됨</p>
							</div>
						
						<%
						
					}else{
						
					}
					
				}catch(Exception exception){
					exception.printStackTrace();
					out.print("책 데이터베이스 연결 실패");
				}finally{
					if(pstmt2 != null){
						pstmt2.close();
					}
					if(rs2 != null){
						rs2.close();
					}
				}// finally 종
			}// for 종료
			%>
			</div>
			<%
			}
			
		}else{
			out.print("데이터베이스 값 가져오기 실패");
		}
		
	}catch(Exception exception){
		exception.printStackTrace();
		out.print("유저 데이터베이스 연결 실패");
	}finally{
		if(pstmt != null){
			pstmt.close();
		}
		if(rs != null){
			rs.close();
		}
		if(conn != null){
			conn.close();
		}
	}
	%>
</div>
</body>
</html>