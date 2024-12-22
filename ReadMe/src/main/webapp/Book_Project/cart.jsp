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
<title>쇼핑 카트</title>
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

<br><br>

<%
String bookId = request.getParameter("bookId");

// 장바구니에 담기 버튼을 눌렀을 때의 경우
if(bookId != null){
	// 비밀번호로 조회해서 갖고오기
	ResultSet rs1 = null;
	ResultSet rs2 = null;
	ResultSet rs3 = null;
	ResultSet rs4 = null;
	ResultSet rs5 = null;
	ResultSet rs6 = null;
	ResultSet rs7 = null;
	
	ResultSet rs2_2 = null;
	ResultSet rs3_2 = null;
	ResultSet rs4_2 = null;
	ResultSet rs5_2 = null;
	ResultSet rs6_2 = null;
	ResultSet rs7_2 = null;
	
	PreparedStatement pstmt = null;
	
	try{
		// 데이터베이스에서 정보 갖고오기
		pstmt = conn.prepareStatement("select book_cart from User where user_id=?");
		pstmt.setString(1, userid);
		rs1 = pstmt.executeQuery();
		
		// 데이터베이스에서 book_cart의 내용을 가져올 때의 경우
		if(rs1.next()){
			String bookcart = rs1.getString("book_cart");
			
			// book_cart에서 가져온 값이 null값인 경우
			if(bookcart == null){
				String insertbook = bookId + ",";
				pstmt = conn.prepareStatement("update User set book_cart=? where user_id=?");
				pstmt.setString(1, insertbook);
				pstmt.setString(2, userid);
				pstmt.executeUpdate();
				
				pstmt = conn.prepareStatement("select book_cart from User where user_id=?");
				pstmt.setString(1, userid);
				rs2 = pstmt.executeQuery();
				
				// 최종적으로 추가가 완료된 book_cart의 값을 가져오는데 성공한 경우
				if(rs2.next()){
					String[] bookcartfinal = rs2.getString("book_cart").split(",");
					pstmt = conn.prepareStatement("update User set total=? where user_id=?");
					pstmt.setInt(1, 0);
					pstmt.setString(2, userid);
					pstmt.executeUpdate();
					
					// book_cart의 최종 저장 단계에서 한개씩 가져와서 total에 누적시키고 total을	db에 업데이트 시키기
					for(String bookcartindividual : bookcartfinal){
						pstmt = conn.prepareStatement("select b_price, base_quantity from Book where b_id=?");
						pstmt.setString(1, bookcartindividual);
						rs3 = pstmt.executeQuery();
						
						// 개별적으로 가져온 book_cart의 bookId를 Book 테이블의 가격과 수량을 가져오는데 성공한 경우
						if(rs3.next()){
							int bookprice = rs3.getInt("b_price");
							int basequantity = rs3.getInt("base_quantity");
							
							// total에 누적시키기 위하여 total을 가져온다
							pstmt = conn.prepareStatement("select total from User where user_id=?");
							pstmt.setString(1, userid);
							rs4 = pstmt.executeQuery();
							
							// total db에서 가져오기 성공
							if(rs4.next()){
								int total = rs4.getInt("total");
								total += bookprice * basequantity;
								
								pstmt = conn.prepareStatement("update User set total=? where user_id=?");
								pstmt.setInt(1, total);
								pstmt.setString(2, userid);
								pstmt.executeUpdate();
								
							}else{ // total db에서 가져오기 실패
								out.print("total을 db에서 가져오기 실패");
							}
							
						}else{ // 개별적으로 가져온 book_cart의 bookId를 Book 테이블의 가격과 수량을 가져오는데 성공한 경우
							out.print("Book 테이블에서 가격과 수량을 가져오는데 실패");
						}
					}// for문 밖
					// 업데이트 된 total 가져오기
					pstmt = conn.prepareStatement("select total from User where user_id=?");
					pstmt.setString(1, userid);
					rs5 = pstmt.executeQuery();
					
					// 업데이트 된 total 가져오기 성공
					if(rs5.next()){
						int totalupdate = rs5.getInt("total");
						
						// 맨 위에 한번만 출력하는 장바구니 총액
						%>
						<div style="flex-direction: column; padding: 30px;">
								<div align="center" style="flex-direction: column;">
									<p><span style="font-size: 40px; font-weight: bold;">장바구니 총액 : ₩<%=totalupdate%> </span></p>
									<p><span>모든 주문에 무료 배송 서비스가 제공됩니다.</span></p>
									<a href="javascript:void(0);" onclick="
									    alert('결제가 완료되었습니다');
									    location.href='pay_process.jsp';">
									    <button style="width: 300px; height: 40px; border-radius: 10px; border: none; background-color: lightsalmon">결제</button>
									</a>
									
									<div style="height: 20px;">
												
											</div>
											
											<div>
												<a href="pay.jsp">주문 내역 확인 -></a>
											</div>
											<div style="margin-top: 80px; border-bottom: 1px solid lightgray;"></div>
								</div>
									</div>
						<%
						// book_cart에서 값을 하나씩 가져와서 Book 테이블에 일치하는 b_id의 정보를 불러와서 책 정보를 표시하는 부분
						pstmt = conn.prepareStatement("select book_cart from User where user_id=?");
						pstmt.setString(1, userid);
						rs6 = pstmt.executeQuery();
						
						// 웹페이지에 카트를 출력하기 위하여 book_cart의 값을 가져오는데 성공한 경우
						if(rs6.next()){
							String[] bookcartwebpage = rs6.getString("book_cart").split(","); 
							
							// 웹페이지에 카트를 출력하기 위하여 book_cart의 값을 가져오는데 for문을 사용
							for(String bookcartindividualwebpage : bookcartwebpage){
								pstmt = conn.prepareStatement("select base_quantity, b_id, b_name, b_price, b_author, b_publisher, b_fileName from Book where b_id=?");
								pstmt.setString(1, bookcartindividualwebpage);
								rs7 = pstmt.executeQuery();
								
								// 웹페이지에 카트를 출력하기 위하여 book_cart의 값을 가져오는데 성공한 후 Book 테이블의 값을 가져오는데 성공한 경우
								if(rs7.next()){
									int rsbasequantity = rs7.getInt("base_quantity");
									String rsid = rs7.getString("b_id");
									String rsname = rs7.getString("b_name");
									int rsprice = rs7.getInt("b_price");
									String rsauthor = rs7.getString("b_author");
									String rspublisher = rs7.getString("b_publisher");
									
									Blob imageblob = rs7.getBlob("b_fileName");
									InputStream inputStream = imageblob.getBinaryStream();
									byte[] imageBytes = inputStream.readAllBytes();
				                    String base64Image = Base64.getEncoder().encodeToString(imageBytes);
									
									%>
									<div style="flex-direction: column; padding: 10px;">
								<div style="flex-direction: row; padding: 30px; display: flex; margin-top: 80px; width: 1200px; height: 450px;">
										<img src="data:image/jpeg;base64,<%=base64Image%>" style="width: 200px; height: 300px; margin-right: 50px;">
											<div style="flex-direction: column; ">
											<p><span style="font-size: 30px; font-weight: bold;"><%=rsname %></span></p>
											<p><span style="font-size: 20px; font-weight: bold;"><%=rsid %></span></p>
											<p><span style="font-size: 15px;"><%=rspublisher %></span></p>		
											<p><span style="font-size: 15px;"><%=rsauthor %></span></p>
												</div>
												
												<div style="margin-left: auto; padding: 5px;">
													<form action="updatecart.jsp" method="post">
														<input type="hidden" name="bookId" value="<%=rsid%>">
														<input type="number" name="quantity" min="1" value="<%=rsbasequantity %>" style="width: 90px; height: 60px; border : 1px solid black; padding: 5px; box-sizing: border-box; border-radius: 10px;" placeholder="수량" oninput="this.form.submit()">
															</form>
													</div>
												
												<div style="flex-direction: column; margin-left: auto; text-align: right;">
												<p><span style="font-size: 30px; font-weight: bold; ">₩<%=rsprice * rsbasequantity %></span></p>
													<a href="removecart.jsp?bookId=<%=rsid %>" style="text-decoration: none;">삭제</a>
													</div>
										</div>
										<div style="margin-top: 80px; border-bottom: 1px solid lightgray;"></div>
							</div>
									<%
									
								}else{ // 웹페이지에 카트를 출력하기 위하여 book_cart의 값을 가져오는데 성공한 후 Book 테이블의 값을 가져오는데 실패한 경우
									out.print("// 웹페이지에 카트를 출력하기 위하여 book_cart의 값을 가져오는데 성공한 후 Book 테이블의 값을 가져오는데 실패함");
								}
								
							}// 웹페이지에 카트를 출력하기 위하여 book_cart의 값을 가져오는데 for문을 사용 종료 (for문 밖)
							
						}else{ // 웹페이지에 카트를 출력하기 위하여 book_cart의 값을 가져오는데 실패한 경우
							out.print("웹페이지에 카트를 출력하기 위하여 book_cart 값 가져오기 실패");
						}
						
					}else{ // 업데이트 된 total 가져오기 실패
						out.print("업데이트 된 total 가져오기 실패");
					}
					
				}else{// 최종적으로 추가가 완료된 book_cart의 값을 가져오는데 실패한 경우
					out.print("업데이트 완료된 book_cart 가져오기 실패");
				}
				
				
				// book_cart에서 가져온 값이 null이 아닌 경우
			}else{ 
				if (bookcart.contains(bookId + ",")) {
				    // 이미 book_cart에 해당 책이 있는 경우
				    out.print("책이 이미 장바구니에 추가되어 있습니다.");
				} else {
				    // 중복되지 않는 경우 새 책 추가
				    String insertbooknotnull = bookcart + bookId + ",";
				    pstmt = conn.prepareStatement("update User set book_cart=? where user_id=?");
				    pstmt.setString(1, insertbooknotnull);
				    pstmt.setString(2, userid);
				    pstmt.executeUpdate();
				}
				
				pstmt = conn.prepareStatement("select book_cart from User where user_id=?");
				pstmt.setString(1, userid);
				rs2_2 = pstmt.executeQuery();
				
				// book_cart에서 가져온 값이 null이 아닐 때 값을 추가한 후 최종적인 값을 가져오는데 성공한 경우
				if(rs2_2.next()){
					String[] bookcartfinal = rs2_2.getString("book_cart").split(",");
					pstmt = conn.prepareStatement("update User set total=? where user_id=?");
					pstmt.setInt(1, 0);
					pstmt.setString(2, userid);
					pstmt.executeUpdate(); // ***********************************************
					
					// book_cart의 최종 저장 단계에서 한개씩 가져와서 total에 누적시키고 total을	db에 업데이트 시키기
					for(String bookcartindividual : bookcartfinal){
						pstmt = conn.prepareStatement("select b_price, base_quantity from Book where b_id=?");
						pstmt.setString(1, bookcartindividual);
						rs3_2 = pstmt.executeQuery();
						
						// Book에서 가격과 기본 수량을 가져오는데 성공한 경우
						if(rs3_2.next()){
							int bookprice = rs3_2.getInt("b_price");
							int basequantity = rs3_2.getInt("base_quantity");
							
							// total 값에 누적시키기 위하여 total 값을 가져온다
							pstmt = conn.prepareStatement("select total from User where user_id=?");
							pstmt.setString(1, userid);
							rs4_2 = pstmt.executeQuery();
							
							// total을 데이터베이스에서 가져오는데 성공한 경우
							if(rs4_2.next()){
								int total = rs4_2.getInt("total");
								total += bookprice * basequantity;
								
								pstmt = conn.prepareStatement("update User set total=? where user_id=?");
								pstmt.setInt(1, total);
								pstmt.setString(2, userid);
								pstmt.executeUpdate();
								
							}else{ // total을 데이터베이스에서 가져오는데 실패한 경우
								out.print("total을 데이터베이스에서 가져오는데 실패함");
							}
							
						}else{ // Book에서 가격과 기본 수량을 가져오는데 실패한 경우
							out.print(" Book에서 가격과 기본 수량을 가져오는데 실패");
						}
						
					}// for문 밖
					// 업데이트 된 total 가져오기
					pstmt = conn.prepareStatement("select total from User where user_id=?");
					pstmt.setString(1, userid);
					rs5_2 = pstmt.executeQuery();
					
					// total을 최종적으로 업데이트 시킨 후 장바구니 총액을 웹페이지에 표시하기 위해 값을 가져오는데 성공한 경우
					if(rs5_2.next()){
						int totalupdate = rs5_2.getInt("total");
						
						// 맨 위에 한번만 출력하는 장바구니 총액
						%>
						<div style="flex-direction: column; padding: 30px;">
								<div align="center" style="flex-direction: column;">
									<p><span style="font-size: 40px; font-weight: bold;">장바구니 총액 : ₩<%=totalupdate%> </span></p>
									<p><span>모든 주문에 무료 배송 서비스가 제공됩니다.</span></p>
									<a href="javascript:void(0);" onclick="
									    alert('결제가 완료되었습니다');
									    location.href='pay_process.jsp';">
									    <button style="width: 300px; height: 40px; border-radius: 10px; border: none; background-color: lightsalmon">결제</button>
									</a>
									
									<div style="height: 20px;">
												
											</div>
											
											<div>
												<a href="pay.jsp">주문 내역 확인 -></a>
											</div>
											<div style="margin-top: 80px; border-bottom: 1px solid lightgray;"></div>
								</div>
									</div>
						<%
						
						// book_cart에서 값을 하나씩 가져와서 Book 테이블에 일치하는 b_id의 정보를 불러와서 책 정보를 표시하는 부분
						pstmt = conn.prepareStatement("select book_cart from User where user_id=?");
						pstmt.setString(1, userid);
						rs6_2 = pstmt.executeQuery();
						
						// 웹페이지에 책 정보를 나타내기 위하여 북카트에서 책을 가져오는데 성공한 경우
						if(rs6_2.next()){
							String[] bookcartwebpage = rs6_2.getString("book_cart").split(",");
							
							for(String bookcartindividualwebpage : bookcartwebpage){
								pstmt = conn.prepareStatement("select base_quantity, b_id, b_name, b_price, b_author, b_publisher, b_fileName from Book where b_id=?");
								pstmt.setString(1, bookcartindividualwebpage);
								rs7_2 = pstmt.executeQuery();
								
								// 책의 정보를 웹페이지에 띄우기 위하여 Book에서 책의 정보들을 가져오는데 성공한 경우
								if(rs7_2.next()){
									int rsbasequantity = rs7_2.getInt("base_quantity");
									String rsid = rs7_2.getString("b_id");
									String rsname = rs7_2.getString("b_name");
									int rsprice = rs7_2.getInt("b_price");
									String rsauthor = rs7_2.getString("b_author");
									String rspublisher = rs7_2.getString("b_publisher");
									
									Blob imageblob = rs7_2.getBlob("b_fileName");
									InputStream inputStream = imageblob.getBinaryStream();
									byte[] imageBytes = inputStream.readAllBytes();
				                    String base64Image = Base64.getEncoder().encodeToString(imageBytes);
									
									%>
									<div style="flex-direction: column; padding: 10px;">
								<div style="flex-direction: row; padding: 30px; display: flex; margin-top: 80px; width: 1200px; height: 450px;">
										<img src="data:image/jpeg;base64,<%=base64Image%>" style="width: 200px; height: 300px; margin-right: 50px;">
											<div style="flex-direction: column; ">
											<p><span style="font-size: 30px; font-weight: bold;"><%=rsname %></span></p>
											<p><span style="font-size: 20px; font-weight: bold;"><%=rsid %></span></p>
											<p><span style="font-size: 15px;"><%=rspublisher %></span></p>		
											<p><span style="font-size: 15px;"><%=rsauthor %></span></p>
												</div>
												
												<div style="margin-left: auto; padding: 5px;">
													<form action="updatecart.jsp" method="post">
														<input type="hidden" name="bookId" value="<%=rsid%>">
														<input type="number" name="quantity" min="1" value="<%=rsbasequantity %>" style="width: 90px; height: 60px; border : 1px solid black; padding: 5px; box-sizing: border-box; border-radius: 10px;" placeholder="수량" oninput="this.form.submit()">
															</form>
													</div>
												
												<div style="flex-direction: column; margin-left: auto; text-align: right;">
												<p><span style="font-size: 30px; font-weight: bold; ">₩<%=rsprice * rsbasequantity %></span></p>
													<a href="removecart.jsp?bookId=<%=rsid %>" style="text-decoration: none;">삭제</a>
													</div>
										</div>
										<div style="margin-top: 80px; border-bottom: 1px solid lightgray;"></div>
							</div>
									<%
									
								}else{ // 책의 정보를 웹페이지에 띄우기 위하여 Book에서 책의 정보들을 가져오는데 실패한 경우
									out.print("// 책의 정보를 웹페이지에 띄우기 위하여 Book에서 책의 정보들을 가져오는데 실패함");
								}
								
							}
							
						}else{ // 웹페이지에 책 정보를 나타내기 위하여 북카트에서 책을 가져오는데 실패한 경우
							out.print("웹페이지에 책 정보를 나타내기 위하여 북카트에서 책을 가져오는데 실패");
						}
						
					}else{ // total을 최종적으로 업데이트 시킨 후 장바구니 총액을 웹페이지에 표시하기 위해 값을 가져오는데 실패한 경우
						out.print("total을 최종적으로 업데이트 시킨 후 장바구니 총액을 웹페이지에 표시하기 위해 값을 가져오는데 실패");
					}
					
				}else{ // book_cart에서 가져온 값이 null이 아닐 때 값을 추가한 후 최종적인 값을 가져오는데 실패한 경우
					out.print("book_cart에서 가져온 값이 null이 아닐 때 값을 추가한 후 최종적인 값을 가져오는데 실패함");
				}
				
			}
			
			
		}else{ // 데이터베이스에서 정보를 가져오는 데에 실패한 경우 (rs1 실패)
			out.print("book_cart의 내용 가져오기 실패");
		}
		
	}catch(Exception exception){
		exception.printStackTrace();
		out.print("데이터베이스 접근 실패 : " +  exception.getMessage());
	}finally{
		if(rs1 != null){
			rs1.close();
		}
		if(rs2 != null){
			rs1.close();
		}
		if(rs3 != null){
			rs1.close();
		}
		if(rs4 != null){
			rs1.close();
		}
		if(rs5 != null){
			rs1.close();
		}
		if(rs6 != null){
			rs1.close();
		}
		if(rs7 != null){
			rs1.close();
		}
		if(rs2_2 != null){
			rs1.close();
		}
		if(rs3_2 != null){
			rs1.close();
		}
		if(rs4_2 != null){
			rs1.close();
		}
		if(rs5_2 != null){
			rs1.close();
		}
		if(rs6_2 != null){
			rs1.close();
		}
		if(rs7_2 != null){
			rs1.close();
		}
		if(conn != null){
			conn.close();
		}
		if(pstmt != null){
			pstmt.close();
		}
	}
	
	session.removeAttribute("booksession");
	
	
	// 장바구니 담기 버튼을 누르지 않고 바로 카트로 이동한 경우
}else{
	ResultSet rs1 = null;
	ResultSet rs2 = null;
	ResultSet rs3 = null;
	ResultSet rs4 = null;
	ResultSet rs5 = null;
	
	PreparedStatement pstmt = null;
	
	try{
		// user_id 기반으로 book_cart 내용 갖고오기
		pstmt = conn.prepareStatement("select book_cart from User where user_id=?");
		pstmt.setString(1, userid);
		rs1 = pstmt.executeQuery();
		
		// book_cart 내용 갖고 오기 성공
		if(rs1.next()){
			String bookcart = rs1.getString("book_cart");
			if(bookcart == null){
				
				%>
				<div align="center">
						<span style="font-size: 40px; font-weight: bold;">장바구니가 비었습니다</span>
						
						<div style="height: 20px;">
												
											</div>
											
											<div>
												<a href="pay.jsp">주문 내역 확인 -></a>
											</div>
					</div>
				<%
				
			}else{
				String[] bookcartwebpage = rs1.getString("book_cart").split(",");
				
				// bookcartwebpage에 내용이 있는 경우
				if(bookcartwebpage != null){
					pstmt = conn.prepareStatement("update User set total=? where user_id=?");
					pstmt.setInt(1, 0);
					pstmt.setString(2, userid);
					pstmt.executeUpdate();
					
					for(String bookcartindividual : bookcartwebpage){
						pstmt = conn.prepareStatement("select b_price, base_quantity from Book where b_id=?");
						pstmt.setString(1, bookcartindividual);
						rs2 = pstmt.executeQuery();
						
						// total을 업데이트 하기 위해 Book으로부터 기본 수량과 가격 정보를 가져오는데 성공한 경우
						if(rs2.next()){
							int bookprice = rs2.getInt("b_price");
							int basequantity = rs2.getInt("base_quantity");
							
							pstmt = conn.prepareStatement("select total from User where user_id=?");
							pstmt.setString(1, userid);
							rs3 = pstmt.executeQuery();
							
							// total을 업데이트 하기 위하여 total의 정보를 가져오기 성공
							if(rs3.next()){
								int total = rs3.getInt("total");
								total += bookprice * basequantity;
								
								pstmt = conn.prepareStatement("update User set total=? where user_id=?");
								pstmt.setInt(1, total);
								pstmt.setString(2, userid);
								pstmt.executeUpdate();
								
							}else{ // total을 업데이트 하기 위하여 total의 정보를 가져오기 실패
								out.print("total을 업데이트 하기 위하여 total의 정보를 가져오기 실패");
							}
							
						}else{ // total을 업데이트 하기 위해 Book으로부터 기본 수량과 가격 정보를 가져오는데 실패한 경우
							out.print("total을 업데이트 하기 위해 Book으로부터 기본 수량과 가격 정보를 가져오는데 실패");
						}
					}// for문 밖
					
					pstmt = conn.prepareStatement("select total from User where user_id=?");
					pstmt.setString(1, userid);
					rs4 = pstmt.executeQuery();
					
					// 장바구니 총액을 표시하기 위해 total을 가져오는데 성공
					if(rs4.next()){
						int total = rs4.getInt("total");
						
						// 장바구니 총액을 화면의 맨 위에 한번만 표시
						%>
						<div style="flex-direction: column; padding: 30px;">
										<div align="center" style="flex-direction: column;">
											<p><span style="font-size: 40px; font-weight: bold;">장바구니 총액 : ₩<%=total%> </span></p>
											<p><span>모든 주문에 무료 배송 서비스가 제공됩니다.</span></p>
											<a href="javascript:void(0);" onclick="
											    alert('결제가 완료되었습니다');
											    location.href='pay_process.jsp';">
											    <button style="width: 300px; height: 40px; border-radius: 10px; border: none; background-color: lightsalmon">결제</button>
											</a>
											
											<div style="height: 20px;">
												
											</div>
											
											<div>
												<a href="pay.jsp">주문 내역 확인 -></a>
											</div>
													<div style="margin-top: 80px; border-bottom: 1px solid lightgray;"></div>
										</div>
											</div>
						<%
						
						for(String bookcartindividualwebpage : bookcartwebpage){
							pstmt = conn.prepareStatement("select base_quantity, b_id, b_name, b_price, b_author, b_publisher, b_fileName from Book where b_id=?");
							pstmt.setString(1, bookcartindividualwebpage);
							rs5 = pstmt.executeQuery();
							
							// 하나씩 가져온 bookId를 가지고 Book 테이블에서 정보를 가져오는데 성공한 경우
							if(rs5.next()){
								int rsbasequantity = rs5.getInt("base_quantity");
								String rsid = rs5.getString("b_id");
								String rsname = rs5.getString("b_name");
								int rsprice = rs5.getInt("b_price");
								String rsauthor = rs5.getString("b_author");
								String rspublisher = rs5.getString("b_publisher");
								
								Blob imageblob = rs5.getBlob("b_fileName");
								InputStream inputStream = imageblob.getBinaryStream();
								byte[] imageBytes = inputStream.readAllBytes();
			                    String base64Image = Base64.getEncoder().encodeToString(imageBytes);
								
								%>
								<div style="flex-direction: column; padding: 10px;">
										<div style="flex-direction: row; padding: 30px; display: flex; margin-top: 80px; width: 1200px; height: 450px;">
												<img src="data:image/jpeg;base64,<%=base64Image%>" style="width: 200px; height: 300px; margin-right: 50px;">
													<div style="flex-direction: column; ">
													<p><span style="font-size: 30px; font-weight: bold;"><%=rsname %></span></p>
													<p><span style="font-size: 20px; font-weight: bold;"><%=rsid %></span></p>
													<p><span style="font-size: 15px;"><%=rspublisher %></span></p>		
													<p><span style="font-size: 15px;"><%=rsauthor %></span></p>
														</div>
														
														<div style="margin-left: auto; padding: 5px;">
															<form action="updatecart.jsp" method="post">
																<input type="hidden" name="bookId" value="<%=rsid%>">
																<input type="number" name="quantity" min="1" value="<%=rsbasequantity %>" style="width: 90px; height: 60px; border : 1px solid black; padding: 5px; box-sizing: border-box; border-radius: 10px;" placeholder="수량" oninput="this.form.submit()">
																	</form>
															</div>
														
														<div style="flex-direction: column; margin-left: auto; text-align: right;">
														<p><span style="font-size: 30px; font-weight: bold; ">₩<%=rsprice * rsbasequantity %></span></p>
															<a href="removecart.jsp?bookId=<%=rsid %>" style="text-decoration: none;">삭제</a>
															</div>
												</div>
												<div style="margin-top: 80px; border-bottom: 1px solid lightgray;"></div>
									</div>
								<%
								
							}else{ // 하나씩 가져온 bookId를 가지고 Book 테이블에서 정보를 가져오는데 실패한 경우
								out.print("하나씩 가져온 bookId를 가지고 Book 테이블에서 정보를 가져오는데 실패함");
							}
							
						}
						
					}else{ // 장바구니 총액을 표시하기 위해 total을 가져오는데 실패
						out.print("장바구니 총액을 표시하기 위해 total을 가져오는데 실패");
					}
					
					// bookcartwebpage에 내용이 없는 경우
				}else{
					%>
					<div align="center">
							<span style="font-size: 40px; font-weight: bold;">장바구니가 비었습니다</span>
						</div>
					<%
				}
			}
			
			
			
		}else{ // book_cart 내용 갖고 오기 실패
			out.print("book_cart 내용 갖고 오기 실패");
		}
		
	}catch(Exception exception){
		exception.printStackTrace();
		out.print("데이터베이스 접근 실패 : " +  exception.getMessage());
		
	}finally{
		if(rs1 != null){
			rs1.close();
		}
		if(rs2 != null){
			rs1.close();
		}
		if(rs3 != null){
			rs1.close();
		}
		if(rs4 != null){
			rs1.close();
		}
		if(rs5 != null){
			rs1.close();
		}
		if(conn != null){
			conn.close();
		}
		if(pstmt != null){
			pstmt.close();
		}
	}
	
}
%>		

</div>
	<%
	
	
	// 로그인을 하지 않았을 때의 경우
}else{
	session.setAttribute("cartURL", request.getRequestURI());
	response.sendRedirect("LoginPage.jsp");
}
%>
</body>
</html>