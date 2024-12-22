<%@page import="part_5.dao.*"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
      <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인 페이지</title>
</head>
<body>
<%
if(session != null && session.getAttribute("userid") != null && "admin".equals(session.getAttribute("userid"))){
	%>
	<fmt:setLocale value="${param.language}"/> <%--el을 사용해야지 오류가 뜨지 않는다 --%> <%--url에서 language를 받아서 설정한다 --%>
<fmt:bundle basename="Bundle.bookmarket"> <%--url에서 받은 것을 기반으로 어떤 파일을 선택해야 할지 자동으로 선택한다 --%>
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

<div style="background-image: url('/ReadMe/Book_Project/images/book_add.jpeg'); background-size: cover; border-radius: 30px; height: 10cm; padding: 30px; margin-bottom: 20px;">
	<span style="font-size: 60px; font-weight: bold; color: #EDE9E9;"><fmt:message key="title"/><br></span>
		<span style="font-size: 25px; color: #EDE9E9;">Book Addition</span>
</div>

<div>
<form action="process_addBook.jsp" method="post" enctype="multipart/form-data">

<div align="right">
	<a href="?language=ko" style="text-decoration: none;">Korean</a> | <a href="?language=en" style="text-decoration: none;">English</a>
</div>

<div>
<p><label style="display: inline-block; width: 200px;"><fmt:message key="bookId"/></label>
	 <input type="text" name="bookId" style="box-shadow: none; width: 250px; border-radius: 5px; border: 1px solid black;"></p>
	 </div>
	 
<div>
<p><label style="display: inline-block; width: 200px;"><fmt:message key="name"/></label> 
<input type="text" name="bookName" style="box-shadow: none; width: 250px; border-radius: 5px; border: 1px solid black;"></p>
</div>


<div>
<p><label style="display: inline-block; width: 200px;"><fmt:message key="unitPrice"/></label> 
<input type="text" name="bookPrice" style="box-shadow: none; width: 250px; border-radius: 5px; border: 1px solid black;"></p>
</div>

<div>
<p><label style="display: inline-block; width: 200px;"><fmt:message key="author"/></label> 
<input type="text" name="author" style="box-shadow: none; width: 250px; border-radius: 5px; border: 1px solid black;"></p>
</div>

<div>
<p><label style="display: inline-block; width: 200px;"><fmt:message key="publisher"/></label> 
<input type="text" name="publisher" style="box-shadow: none; width: 250px; border-radius: 5px; border: 1px solid black;"></p>
</div>

<div>
<p><label style="display: inline-block; width: 200px;"><fmt:message key="releaseDate"/></label> 
<input type="text" name="releaseDate" style="box-shadow: none; width: 250px; border-radius: 5px; border: 1px solid black;"></p>
</div>

<div>
<p><label style="display: inline-block; width: 200px; vertical-align: top;"><fmt:message key="description"/></label> 
<textarea rows="2" cols="30" placeholder="상세 정보를 입력하세요" name="description" style="box-shadow: none; width: 250px; border-radius: 5px; border: 1px solid black;"></textarea>
</div>

<div>
<p><label style="display: inline-block; width: 200px;"><fmt:message key="category"/></label> 
<input type="text" name="category" style="box-shadow: none; width: 250px; border-radius: 5px; border: 1px solid black;"></p>
</div>

<div>
<p><label style="display: inline-block; width: 200px;"><fmt:message key="unitsInStock"/></label> 
<input type="text" name="unitsInStock" style="box-shadow: none; width: 250px; border-radius: 5px; border: 1px solid black;"></p>
</div>

<div>
<p><label style="display: inline-block; width: 200px;"><fmt:message key="condition"/></label> 
<input type="radio" name="condition" value="New"><fmt:message key="condition_New"/>
<input type="radio" name="condition" value="Old"><fmt:message key="condition_Old"/>
<input type="radio" name="condition" value="EBook"><fmt:message key="condition_Ebook"/>
</div>

<div>
<p><label style="display: inline-block; width: 200px;"><fmt:message key="bookImage"/></label> 
<input type="file" name="BookImage"></p>
</div>

<input type="submit" value="<fmt:message key="button"/>" style="border-radius: 10px; border: none; background-color: lightsalmon">

</form>
</div>
			
<%@ include file="footer.jsp"%>
</div>
</fmt:bundle>
	<%
}else if(!"admin".equals(session.getAttribute("userid"))){
	%>
	<script type="text/javascript">
	alert("관리자만 접근 가능합니다");
	history.go(-1);
	</script>
	<%
}
else{
	session.setAttribute("addbookURL", request.getRequestURI());
	response.sendRedirect("LoginPage.jsp");
}
%>


</body>
</html>