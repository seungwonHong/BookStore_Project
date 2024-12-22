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

<div style="height: 80px;"></div>

<%
int postid = Integer.parseInt(request.getParameter("postid"));
System.out.print(postid);

ResultSet rs = null;
ResultSet rs2 = null;
ResultSet rs3 = null;
PreparedStatement pstmt = null;

try{
	pstmt = conn.prepareStatement("select post_id, post, post_file, poster, post_name from Post where post_id=?");
	pstmt.setInt(1, postid);
	rs = pstmt.executeQuery();
	
	if(rs.next()){
		String post = rs.getString("post");
		String poster = rs.getString("poster");
		String post_name = rs.getString("post_name");
		int post_id = rs.getInt("post_id");
		
		Blob post_file = rs.getBlob("post_file");
		
		if(post_file != null){
			InputStream inputStream = post_file.getBinaryStream();
			byte[] imageBytes = inputStream.readAllBytes();
	        String base64Image = Base64.getEncoder().encodeToString(imageBytes);
	        
	        %>
	        <div align="center">
		        <div style="background-color: rgba(217, 217, 217, 0.3); border-radius: 30px; padding: 20px; height: auto;  width: 950px; display: inline-block; align-content: flex-start;">
		        	<div style="text-align: left;"> 
						<h1><%=post_name %></h1>
							<p><span style="margin-left: 5px; font-size: 20px;"><%=poster %></span></p>
								<p><span style="font-size: 18px; margin-left: 5px;"><%=post %></span></p>
								<div style="height: 30px;"></div>
									<div align="center">
					     							<img src="data:image/jpeg;base64,<%=base64Image%>" style="max-width: 100%; max-height: 700px; border-radius: 15px; margin-left: 5px; object-fit: contain;">
					     						</div>
								</div>
				</div>
				
				<div style="height: 30px;"></div>
				
				<form action="Comment_process.jsp" method="post" style="display: flex; align-items: center; margin: 0 auto; width: 620px; margin-bottom: 30px;">
					<textarea rows="2" cols="30" placeholder=" 댓글을 남겨보세요" name="comment" style="box-shadow: none; width: 550px; border-radius: 10px; border: 1px solid black;"></textarea>
					<div style="width: 20px;"></div>
					<input type="hidden" name="postid" value="<%=postid%>">
					<input type="submit" value="등록" style="width: 60px; height: 40px; border: none; border-radius: 10px; background-color: lightsalmon">
				</form>
				
				
				<%
				pstmt = conn.prepareStatement("select commenter, comment, comment_file from Comment where post_id=? order by comment_id desc");
				pstmt.setInt(1, postid);
				rs2 = pstmt.executeQuery();
				
				while(rs2.next()){
					String commenter = rs2.getString("commenter");
					String comment = rs2.getString("comment");
					
					Blob post_file2 = rs2.getBlob("comment_file");
					
			        
			        if(post_file2 != null){
			        	InputStream inputStream2 = post_file2.getBinaryStream();
						byte[] imageBytes2 = inputStream2.readAllBytes();
				        String base64Image2 = Base64.getEncoder().encodeToString(imageBytes2);
			        	%>
				        <%--댓글 보여주기 --%>
				        <div style="height: 30px;"></div>
				        <div align="center">
			        <div style="background-color: rgba(217, 217, 217, 0.3); border-radius: 30px; padding: 10px; height: auto;  width: 750px; display: inline-block; align-content: flex-start;">
			        	<div style="text-align: left;"> 
								<p><span style="margin-left: 5px; font-size: 23px;"><%=commenter %></span></p>
									<p><span style="font-size: 15px; margin-left: 5px;"><%=comment %></span></p>
									<div style="height: 20px;"></div>
										<div align="center">
					     							<img src="data:image/jpeg;base64,<%=base64Image2%>" style="max-width: 100%; max-height: 700px; border-radius: 15px; margin-left: 5px; object-fit: contain;">
					     						</div>
									</div>
							</div>
					</div>
					
					
				        <%
			        }else{
			        	%>
				        <%--댓글 보여주기 --%>
				        <div style="height: 30px;"></div>
				        <div align="center">
			        <div style="background-color: rgba(217, 217, 217, 0.3); border-radius: 30px; padding: 10px; height: auto;  width: 750px; display: inline-block; align-content: flex-start;">
			        	<div style="text-align: left;"> 
								<p><span style="margin-left: 5px; font-size: 23px;"><%=commenter %></span></p>
									<p><span style="font-size: 15px; margin-left: 5px;"><%=comment %></span></p>
									</div>
							</div>
					</div>
					
					<div style="height: 30px;"></div>
				        <%
			        }
			        
				}
				
		}else{
			 %>
		        <div align="center">
			        <div style="background-color: rgba(217, 217, 217, 0.3); border-radius: 30px; padding: 20px; height: auto;  width: 950px; display: inline-block; align-content: flex-start;">
			        	<div style="text-align: left;"> 
							<h1><%=post_name %></h1>
								<p><span style="margin-left: 5px; font-size: 20px;"><%=poster %></span></p>
									<p><span style="font-size: 18px; margin-left: 5px;"><%=post %></span></p>
									<div style="height: 30px;"></div>
									</div>
					</div>
					
					<div style="height: 30px;"></div>
					
					<form action="Comment_process.jsp" method="post" style="display: flex; align-items: center; margin: 0 auto; width: 620px; margin-bottom: 30px;">
					<textarea rows="2" cols="30" placeholder=" 댓글을 남겨보세요" name="comment" style="box-shadow: none; width: 550px; border-radius: 10px; border: 1px solid black;"></textarea>
					<div style="width: 20px;"></div>
					<input type="hidden" name="postid" value="<%=postid%>">
					<input type="submit" value="등록" style="width: 60px; height: 40px; border: none; border-radius: 10px; background-color: lightsalmon">
				</form>
					
					<%
					pstmt = conn.prepareStatement("select commenter, comment, comment_file from Comment where post_id=? order by comment_id desc");
					pstmt.setInt(1, postid);
					rs3 = pstmt.executeQuery();
					
					while(rs3.next()){
						String commenter = rs3.getString("commenter");
						String comment = rs3.getString("comment");
						
						Blob post_file2 = rs3.getBlob("comment_file");
				        
				        if(post_file2 != null){
				        	InputStream inputStream2 = post_file.getBinaryStream();
							byte[] imageBytes2 = inputStream2.readAllBytes();
					        String base64Image2 = Base64.getEncoder().encodeToString(imageBytes2);
				        	 %>
						        <%--댓글 보여주기 --%>
						        <div style="height: 30px;"></div>
						        <div align="center">
					        <div style="background-color: rgba(217, 217, 217, 0.3); border-radius: 30px; padding: 10px; height: auto;  width: 750px; display: inline-block; align-content: flex-start;">
					        	<div style="text-align: left;"> 
										<p><span style="margin-left: 5px; font-size: 23px;"><%=commenter %></span></p>
											<p><span style="font-size: 15px; margin-left: 5px;"><%=comment %></span></p>
											<div style="height: 20px;"></div>
												<div align="center">
					     							<img src="data:image/jpeg;base64,<%=base64Image2%>" style="max-width: 100%; max-height: 700px; border-radius: 15px; margin-left: 5px; object-fit: contain;">
					     						</div>
											</div>
									</div>
							</div>
							
							<div style="height: 30px;"></div>
						        <%
				        }else{
				        	%>
					        <%--댓글 보여주기 --%>
					        <div style="height: 30px;"></div>
					        <div align="center">
				        <div style="background-color: rgba(217, 217, 217, 0.3); border-radius: 30px; padding: 10px; height: auto;  width: 750px; display: inline-block; align-content: flex-start;">
				        	<div style="text-align: left;"> 
									<p><span style="margin-left: 5px; font-size: 23px;"><%=commenter %></span></p>
										<p><span style="font-size: 15px; margin-left: 5px;"><%=comment %></span></p>
										</div>
								</div>
						</div>
						
						<div style="height: 30px;"></div>
					        <%
				        }
				       
					}
		}
        
        
			%>
			
		</div>
        <%
		
	}else{
		System.out.print("데이터 베이스 연결 오류");
	}
	
}catch(Exception exception){
	exception.printStackTrace();
	System.out.print("연결 오류 : " + exception.getMessage());
}finally{
	if(rs != null){
		rs.close();
	}
	if(rs2 != null){
		rs.close();
	}
	if(rs3 != null){
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
</body>
</html>