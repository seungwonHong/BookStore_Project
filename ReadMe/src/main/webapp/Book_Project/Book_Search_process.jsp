<%@page import="part_5.dao.Book2"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@include file="dbconn.jsp"%>

<%
request.setCharacterEncoding("utf-8");

String keyword = request.getParameter("keyword");

ResultSet rs = null;
PreparedStatement pstmt = null;
List<Book2> searchResult = new ArrayList<>();

try{
	pstmt = conn.prepareStatement("select * from Book where b_name like ?");
	pstmt.setString(1, "%" + keyword + "%");
	rs = pstmt.executeQuery();
	
	while(rs.next()){
		Book2 book2 = new Book2();
		book2.setBookId(rs.getString("b_id"));
		book2.setName(rs.getString("b_name"));
		book2.setPublisher(rs.getString("b_publisher"));
		book2.setPrice(rs.getInt("b_price"));
		book2.setDescription(rs.getString("b_description"));
		book2.setAuthor(rs.getString("b_author"));
		searchResult.add(book2);
	}
	
	if(!searchResult.isEmpty()){
		session.setAttribute("SearchResult", searchResult);
		response.sendRedirect("Book_Search.jsp");
		
	}else{
		%>
		<script type="text/javascript">
				alert("존재하는 책이 없음");
				window.location.href = "Book_Search.jsp";
			</script>
		<%
	}
	
}catch(Exception exception){
	exception.printStackTrace();
	out.print("연결 오류 : " + exception.getMessage());
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