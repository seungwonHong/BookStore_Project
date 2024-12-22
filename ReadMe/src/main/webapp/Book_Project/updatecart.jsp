<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
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
String bookId = request.getParameter("bookId");
String quantity = request.getParameter("quantity");

ResultSet rs = null;
PreparedStatement pstmt = null;

try{
	if(quantity == null || quantity.isEmpty()){
		%>
		<script type="text/javascript">
			alert("수량을 작성해주세요");
			history.go(-1);
		</script>
		<%
	}else{
		int quantityInt = Integer.parseInt(quantity);
		
		if(quantityInt > 0){
			pstmt = conn.prepareStatement("update Book set base_quantity=? where b_id=?");
			pstmt.setInt(1, quantityInt);
			pstmt.setString(2, bookId);
			pstmt.executeUpdate();
			response.sendRedirect("cart.jsp");
		}else{
			%>
			<script type="text/javascript">
			alert("정보가 올바르지 않습니다");
			history.go(-1);
		</script>
			<%
		}
		
	}
}catch(Exception exception){
	exception.getStackTrace();
	out.print("연결 오류2");
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