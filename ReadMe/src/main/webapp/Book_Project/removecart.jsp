<%@page import="java.util.Arrays"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="part_5.dao.Book2"%>
<%@page import="java.util.ArrayList"%>
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
String removebook = request.getParameter("bookId");
String userid = (String)session.getAttribute("userid");

PreparedStatement pstmt = null;
ResultSet rs = null;

try{
	pstmt = conn.prepareStatement("select book_cart from User where user_id=?");
	pstmt.setString(1, userid);
	rs = pstmt.executeQuery();
	
	// 받은 bookId와 같은 bookId가 있는지 대조하기 위하여 book_cart의 내용을 갖고 오기 성공함
	if(rs.next()){
		String bookCart = rs.getString("book_cart");
		String[] bookArray = bookCart.split(","); // 배열로 분리
		ArrayList<String> bookIdList = new ArrayList<>(Arrays.asList(bookArray)); // ArrayList로 변환
		
		bookIdList.removeIf(bookIdindividual -> bookIdindividual.equals(removebook));
		
		String updatedBookCart;
		
		// book_cart를 다 지워서 안에가 빈 공간이 될 경우
		if(bookIdList.isEmpty()){
			updatedBookCart = null;
			
			pstmt = conn.prepareStatement("update User set book_cart=? where user_id=?");
			pstmt.setNull(1, java.sql.Types.VARCHAR); // book_cart를 null로 업데이트한다
			pstmt.setString(2, userid);
			pstmt.executeUpdate();
			
			pstmt = conn.prepareStatement("update Book set base_quantity=? where b_id=?");
			pstmt.setInt(1, 1);
			pstmt.setString(2, removebook);
			pstmt.executeUpdate();
			
			response.sendRedirect("cart.jsp");
			
		}else{ // book_cart의 내용을 지웠지만 안에 내용이 뭐라도 남아있는 경우
			updatedBookCart = String.join(",", bookIdList) + ","; // 리스트 요소 사이사이에 ,를 넣고 맨 뒤에도 ,를 넣는다
			
			pstmt = conn.prepareStatement("update User set book_cart=? where user_id=?");
			pstmt.setString(1, updatedBookCart);
			pstmt.setString(2, userid);
			pstmt.executeUpdate();
			
			pstmt = conn.prepareStatement("update Book set base_quantity=? where b_id=?");
			pstmt.setInt(1, 1);
			pstmt.setString(2, removebook);
			pstmt.executeUpdate();
			
			response.sendRedirect("cart.jsp");
		}
		
		
	}else{ // 받은 bookId와 같은 bookId가 있는지 대조하기 위하여 book_cart의 내용을 갖고 오기 실패함
		out.print("받은 bookId와 같은 bookId가 있는지 대조하기 위하여 book_cart의 내용을 갖고 오기 실패");
	}
	
}catch(Exception exception){
	
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