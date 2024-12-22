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
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
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
<div style="height: 60px;"></div>

<div style="flex-direction: row; display: flex;">
	<div style="flex-direction: column; width: 100px; height: calc(100vh - 60px - 30mm - 30mm);  display: flex; justify-content: center; position: fixed;">
		<p><a href="MyPost.jsp"><button style="border: none; background-color: rgba(128, 128, 128, 0.1); border-radius: 10px; height: 40px; width: 90px; box-shadow: 0 4px 9px rgba(0, 0, 0, 0.3); ">내 포스트</button></a></p>
		<p><a href="MyComment.jsp"><button style="border: none; background-color: rgba(128, 128, 128, 0.1); border-radius: 10px; height: 40px; width: 90px; box-shadow: 0 4px 9px rgba(0, 0, 0, 0.3);">내 댓글</button></a></p>
	</div>
	
	<div style="width: 170px;"></div>
	
	<div style="display: flex; flex-direction: column;">
		<span style="font-size: 60px; font-weight: bold;">My Comment<br></span>
		<div style="height: 30px;"></div>
	<%
	ResultSet rs = null;
	PreparedStatement pstmt = null;
	String commenter = (String)session.getAttribute("userid");
	
	try{
		pstmt = conn.prepareStatement("select comment_id, commenter, comment, comment_file from Comment where commenter=? order by comment_id desc");
		pstmt.setString(1, commenter);
		rs = pstmt.executeQuery();
		
		while(rs.next()){
			String comment = rs.getString("comment");
			int commentid = rs.getInt("comment_id");
			
			Blob comment_file = rs.getBlob("comment_file");
			
			if(comment_file != null){
				InputStream inputStream = comment_file.getBinaryStream();
				byte[] imageBytes = inputStream.readAllBytes();
		        String base64Image = Base64.getEncoder().encodeToString(imageBytes);
				%>
				<div style="background-color: rgba(217, 217, 217, 0.3); border-radius: 30px; padding: 20px; height: auto; width: 950px; display: inline-block; align-content: flex-start;">
		        	<div style="text-align: left;"> 
		        	<div style="display: flex; flex-direction: row; align-items: center; justify-content: space-between;">
						<h2><%=commenter %></h2>
						<a href="MyComment_delete.jsp?commentid=<%=commentid%>">
							<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="red" class="bi bi-trash" viewBox="0 0 16 16">
							  <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0z"/>
							  <path d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4zM2.5 3h11V2h-11z"/>
							</svg>
						</a>
						</div>
								<p><span style="font-size: 18px;"><%=comment %></span></p>
								<div style="height: 20px;"></div>
									<img src="data:image/jpeg;base64,<%=base64Image%>" style="width: 250px; height: 280px; border-radius: 15px; margin-left: 5px;">
								</div>
				</div>
				<div style="height: 20px;"></div>
				<%
				
			}else{
				%>
				<div style="background-color: rgba(217, 217, 217, 0.3); border-radius: 30px; padding: 20px; height: auto; width: 950px; display: inline-block; align-content: flex-start;">
		        	<div style="text-align: left;"> 
		        	<div style="display: flex; flex-direction: row; align-items: center; justify-content: space-between;">
						<h2><%=commenter %></h2>
						<a href="MyComment_delete.jsp?commentid=<%=commentid%>">
							<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="red" class="bi bi-trash" viewBox="0 0 16 16">
							  <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0z"/>
							  <path d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4zM2.5 3h11V2h-11z"/>
							</svg>
						</a>
						</div>
								<p><span style="font-size: 18px;"><%=comment %></span></p>
								</div>
				</div>
				<div style="height: 20px;"></div>
				<%
			}
			
		}
		
	}catch(Exception exception){
		exception.printStackTrace();
		System.out.print("연결 오류 : " + exception.getMessage());
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

</div>
</body>
</html>