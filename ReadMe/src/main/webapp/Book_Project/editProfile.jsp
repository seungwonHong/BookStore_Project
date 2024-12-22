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
if(session != null && session.getAttribute("userid") != null){
	
	String userid = (String)session.getAttribute("userid");
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try{
		pstmt = conn.prepareStatement("select user_id, user_password, email, name from User where user_id=?");
		pstmt.setString(1, userid);
		rs = pstmt.executeQuery();
		
		if(rs.next()){
			String rsid = rs.getString("user_id");
			String rspassword = rs.getString("user_password");
			String rsemail = rs.getString("email");
			String rsname = rs.getString("name");
			
			if(rsname == null){
				rsname = "";
			}
			if(rsemail == null){
				rsemail = "";
			}
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

<div style="height: 50px;"></div>

<div style="display: flex; justify-content: center; align-items: center; height: 100vh;">
    <div style="width: 500px; height: 650px; border-radius: 50px; border: 1px solid black;">
    	<div style="flex-direction: column; padding: 30px;">
    		<h3 style="border-bottom: 1px solid lightgray; margin-bottom: 20px; padding-bottom: 10px;">내 정보</h3>
    		<form action="editProfile_process.jsp" method="post">
    			<p>이름</p>
    			<input type="text" name="name" style="box-shadow: none; width: 300px; border-radius: 5px; border: 1px solid black;" value="<%=rsname%>"><br><br>
    			<p>아이디</p>
    			<input type="text" name="id" style="box-shadow: none; width: 300px; border-radius: 5px; border: 1px solid black;" value="<%=rsid%>"><br><br>
    			<p>비밀번호</p>
    			<input type="text" name="password" style="box-shadow: none; width: 300px; border-radius: 5px; border: 1px solid black;" value="<%=rspassword%>"><br><br>
    			<p>이메일</p>
    			<input type="email" name="email" style="box-shadow: none; width: 300px; border-radius: 5px; border: 1px solid black;" value="<%=rsemail%>"><br><br>
    			
    			<div style="height: 50px;"></div>
    			
    			<div style="flex-direction: row; justify-content: center; align-items: center;" align="center">
    				<p><input type="submit" value="수정" style="width: 350px; height: 40px; border: none; border-radius: 10px; background-color: lightsalmon"></p>
    			</div>
    		</form>
    		
    		<div style="flex-direction: row; justify-content: center; align-items: center;" align="center">
    			<form action="delete_profile.jsp" method="post">
    				<input type="hidden" value="<%=rsid%>" name="userid">
    					<p><input type="submit" value="탈퇴" style="width: 350px; height: 40px; border: 1.5px solid lightsalmon; border-radius: 10px; background-color: transparent; color: lightsalmon; "></p>
    			</form>
    			</div>
    	</div>
    </div>
</div>

<div>
	
</div>
<%
	if("admin".equals(userid)){
		PreparedStatement adminPstmt = null;
		ResultSet adminRS = null;
		
		try{
			adminPstmt = conn.prepareStatement("select user_id, email, name from User where user_id != ?");
			adminPstmt.setString(1, userid);
			adminRS = adminPstmt.executeQuery();
			%>
			<span style="font-size: 40px; font-weight: bold;">회원 정보 관리</span>
				<table style="width: 100%; margin-top: 30px;">
					<thead>
						<tr>
							<th>아이디</th>
							<th>이름</th>
							<th>이메일</th>
						</tr>
					</thead>
			<tbody>
			<%
			while(adminRS.next()){
				String otherUserId = adminRS.getString("user_id");
				String otherUsername = adminRS.getString("name");
				String otherUserEmail = adminRS.getString("email") != null ? adminRS.getString("email") : "-";
				%>
					<tr>
						<td style="padding-top: 20px;"><%=otherUserId %></td>
						<td style="padding-top: 20px;"><%=otherUsername %></td>
						<td style="padding-top: 20px;"><%=otherUserEmail %></td>
						<td>
							<form action="delete_profile_byadmin.jsp" onsubmit="return confirmDelete();">
								<input type="hidden" name="userId" value="<%=otherUserId%>" >
								<button style="background: #FA3232; color: white; border-radius: 5px; border: none; width: 80px;">
									삭제
							</button>
							</form>
						</td>
					</tr>
				<%
			}
			%>
			</tbody>
					</table>
			<%
		}catch(Exception e){
			out.print("관리자 전용 정보 조회 기능 오류");
		}
	}
%>
</div>
			<%
			
		}else{
			out.print("문제 발생");
		}
		
	}catch(Exception e){
		e.getStackTrace();
		out.print("연결오류");
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
}else{
	session.setAttribute("editProfileURL", request.getRequestURI());
	response.sendRedirect("LoginPage.jsp");
}
%>

<script>
    // 삭제 재확인 함수
    function confirmDelete() {
        return confirm("정말로 이 계정을 삭제하시겠습니까?");
    }
</script>
</body>
</html>