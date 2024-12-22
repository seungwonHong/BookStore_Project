<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
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
request.setCharacterEncoding("utf-8");

// MultipartRequest 객체를 항상 생성
MultipartRequest multi = new MultipartRequest(request, "/Users/hongseungwon/Documents/05_files/file_upload_test", 20*1024*1024, "utf-8", new DefaultFileRenamePolicy());

String post = multi.getParameter("post");
String postname = multi.getParameter("post_name");
String poster = (String)session.getAttribute("userid");

// 파일 선택 여부 확인 
Enumeration<String> files = multi.getFileNames();
String file = files.hasMoreElements() ? files.nextElement() : null; 
String realfilename = (file != null) ? multi.getFilesystemName(file) : null; 
File uploadfile = (file != null) ? multi.getFile(file) : null;

PreparedStatement pstmt = null;
InputStream fileInputStream = null;

try{

    if(realfilename != null && !realfilename.isEmpty()){
        fileInputStream = new FileInputStream(uploadfile);

        pstmt = conn.prepareStatement("insert into Post(post, post_file, poster, post_name) values(?, ?, ?, ?)");
        pstmt.setString(1, post);
        pstmt.setBinaryStream(2, fileInputStream, (int)uploadfile.length()); 
        pstmt.setString(3, poster);
        pstmt.setString(4, postname);
    } else {
        pstmt = conn.prepareStatement("insert into Post(post, poster, post_name) values(?, ?, ?)");
        pstmt.setString(1, post);
        pstmt.setString(2, poster);
        pstmt.setString(3, postname);
    }

    pstmt.executeUpdate();
    response.sendRedirect("Community.jsp");

} catch(Exception exception){
    exception.printStackTrace();
    System.out.print("연결 오류 : " + exception.getMessage());
} finally {
    if (fileInputStream != null) {
        fileInputStream.close(); 
    }
    if (pstmt != null) {
        pstmt.close();
    }
    if (conn != null) {
        conn.close();
    }
}
%>
</body>
</html>