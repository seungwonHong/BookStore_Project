<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="part_5.dao.Book2"%>
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
<jsp:useBean id="bookdao" class="part_5.dao.BookRepository2" scope="session"/>

<%
request.setCharacterEncoding("utf-8");
MultipartRequest multi = new MultipartRequest(request, "/Users/hongseungwon/Documents/05_files/file_upload_test", 5*1024*1024, "utf-8", new DefaultFileRenamePolicy());

String bookId = multi.getParameter("bookId");
String bookName = multi.getParameter("bookName");
String bookPrice = multi.getParameter("bookPrice");
String author = multi.getParameter("author");
String publisher = multi.getParameter("publisher");
String releaseDate = multi.getParameter("releaseDate");
String description = multi.getParameter("description");
String category = multi.getParameter("category");
String unitsInStock = multi.getParameter("unitsInStock");
String condition = multi.getParameter("condition");

Enumeration<String> files = multi.getFileNames(); // 파일 지정 파라미터 이름 받아오기
String file = files.nextElement(); // 파일명 받아오기
String realfilename = multi.getFilesystemName(file); // 실제 시스템 파일명 받아오기
File uploadfile = multi.getFile(file);

if(bookId == null || bookId.isEmpty()){
	%>
	<script type="text/javascript">
	alert("도서코드가 작성되지 않았습니다");
	history.go(-1);
	</script>
	<%
}else if(bookName == null || bookName.isEmpty()){
	%>
	<script type="text/javascript">
	alert("도서명이 작성되지 않았습니다");
	history.go(-1);
	</script>
	<%
}else if(bookPrice == null || bookPrice.isEmpty()){
	%>
	<script type="text/javascript">
	alert("책 가격이 기입되지 않았습니다");
	history.go(-1);
	</script>
	<%
}else if(!bookPrice.matches("[0-9]+")){
	%>
	<script type="text/javascript">
	alert("책 가격은 숫자만 입력 가능합니다");
	history.go(-1);
	</script>
	<%
}else if(author == null || author.isEmpty()){
	%>
	<script type="text/javascript">
	alert("작가 정보가 작성되지 않았습니다");
	history.go(-1);
	</script>
	<%
}else if(publisher == null || publisher.isEmpty()){
	%>
	<script type="text/javascript">
	alert("출판사 정보가 기입되지 않았습니다");
	history.go(-1);
	</script>
	<%
}else if(releaseDate == null || releaseDate.isEmpty()){
	%>
	<script type="text/javascript">
	alert("출판일이 기입되지 않았습니다");
	history.go(-1);
	</script>
	<%
}else if(description == null || description.isEmpty()){
	%>
	<script type="text/javascript">
	alert("상세정보가 기입되지 않았습니다");
	history.go(-1);
	</script>
	<%
}else if(category == null || category.isEmpty()){
	%>
	<script type="text/javascript">
	alert("분류 정보가 기입되지 않았습니다");
	history.go(-1);
	</script>
	<%
}else if(unitsInStock == null || unitsInStock.isEmpty()){
	%>
	<script type="text/javascript">
	alert("재고수가 기입되지 않았습니다");
	history.go(-1);
	</script>
	<%
}else if(!unitsInStock.matches("[0-9]+")){
	%>
	<script type="text/javascript">
	alert("재고수는 숫자로만 작성되어야 합니다");
	history.go(-1);
	</script>
	<%
}else if(condition == null || condition.isEmpty()){
	%>
	<script type="text/javascript">
	alert("상태를 선택하지 않았습니다");
	history.go(-1);
	</script>
	<%
}else if(realfilename == null || realfilename.isEmpty()){
	%>
	<script type="text/javascript">
	alert("이미지가 선택되지 않았습니다");
	history.go(-1);
	</script>
	<%
}else{
	PreparedStatement pstmt = null;
	InputStream fileInputStream = null;
	
	try{
		fileInputStream = new FileInputStream(uploadfile);
		
		pstmt = conn.prepareStatement("insert into Book(b_id, b_name, b_price, b_author, b_description, b_publisher, b_category, b_unitsInStock, b_releaseDate, b_condition, b_fileName, base_quantity) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
		pstmt.setString(1, bookId);
		pstmt.setString(2, bookName);
		pstmt.setString(3, bookPrice);
		pstmt.setString(4, author);
		pstmt.setString(5, description);
		pstmt.setString(6, publisher);
		pstmt.setString(7, category);
		pstmt.setString(8, unitsInStock);
		pstmt.setString(9, releaseDate);
		pstmt.setString(10, condition);
		pstmt.setBinaryStream(11, fileInputStream, (int)uploadfile.length()); 
		pstmt.setInt(12, 1);
		pstmt.executeUpdate();
		
		%>
		<script type="text/javascript">
				alert("도서가 추가되었습니다");
				window.location.href = "addBook.jsp";
			</script>
		<%
		
	}catch(Exception exception){
		exception.getStackTrace();
		out.print("연결 오류");
	}finally{
		if(conn != null){
			conn.close();
		}
		if(pstmt != null){
			pstmt.close();
		}
		if(fileInputStream != null){
			fileInputStream.close();
		}
	}
}
%>
</body>
</html>