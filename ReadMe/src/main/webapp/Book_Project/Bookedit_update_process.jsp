<%@page import="java.sql.Types"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 정보 수정</title>
</head>
<body>
<%@include file="dbconn.jsp" %>

<%
request.setCharacterEncoding("utf-8");

// 파일 업로드 처리
MultipartRequest multi = new MultipartRequest(
    request,
    "/Users/hongseungwon/Documents/05_files/file_upload_test",
    5 * 1024 * 1024,  // 최대 5MB 파일 업로드
    "utf-8",
    new DefaultFileRenamePolicy()
);

// 폼 데이터 수집
String bookId = multi.getParameter("bookId");
String bookName = multi.getParameter("bookName");
String bookPrice = multi.getParameter("bookPrice");
String author = multi.getParameter("author");
String publisher = multi.getParameter("publisher");
String releaseDate = multi.getParameter("releaseDate");
String description = multi.getParameter("description");
String category = multi.getParameter("category");
String unitsInStockstr = multi.getParameter("unitsInStock");
String condition = multi.getParameter("condition");

// 재고 수량 파싱 및 예외 처리
int unitsInStock = 0;
try {
    unitsInStock = Integer.parseInt(unitsInStockstr);
} catch (NumberFormatException e) {
    out.print("재고 수량이 잘못된 형식입니다.");
    return;
}

// 파일 업로드 처리 및 예외 방지
File uploadfile = null;
Enumeration<String> files = multi.getFileNames();
if (files.hasMoreElements()) {
    String file = files.nextElement();
    uploadfile = multi.getFile(file);
}

ResultSet rs = null;
PreparedStatement pstmt = null;
InputStream fileInputStream = null;

try {
    // 트랜잭션 시작
    conn.setAutoCommit(false); 

    // 기존 도서 정보 확인
    pstmt = conn.prepareStatement("select * from Book where b_id=?");
    pstmt.setString(1, bookId);
    rs = pstmt.executeQuery();
    
    if (rs.next()) {
        // 파일이 존재하면 InputStream 생성
        if (uploadfile != null) {
            fileInputStream = new FileInputStream(uploadfile);
        }

        // 업데이트 SQL (파일이 있는 경우와 없는 경우 조건 처리)
        if (uploadfile != null) {
            pstmt = conn.prepareStatement(
                "update Book set b_name=?, b_price=?, b_author=?, b_description=?, b_publisher=?, b_category=?, b_unitsInStock=?, b_releaseDate=?, b_condition=?, b_fileName=? where b_id=?"
            );
            pstmt.setBinaryStream(10, fileInputStream, (int) uploadfile.length());
        } else {
            pstmt = conn.prepareStatement(
                "update Book set b_name=?, b_price=?, b_author=?, b_description=?, b_publisher=?, b_category=?, b_unitsInStock=?, b_releaseDate=?, b_condition=? where b_id=?"
            );
        }
        
        // 데이터 설정
        pstmt.setString(1, bookName);
        pstmt.setString(2, bookPrice);
        pstmt.setString(3, author);
        pstmt.setString(4, description);
        pstmt.setString(5, publisher);
        pstmt.setString(6, category);
        pstmt.setInt(7, unitsInStock);
        pstmt.setString(8, releaseDate);
        pstmt.setString(9, condition);
        pstmt.setString(10, bookId);  // 조건문 - 어떤 도서를 수정할지 지정

        // 업데이트 실행
        pstmt.executeUpdate();
        conn.commit();  // 커밋
%>
        <script type="text/javascript">
            alert("수정 완료");
            window.location.href = "Bookedit.jsp";
        </script>
<%
    } else {
        out.print("도서 정보를 찾을 수 없습니다.");
    }
} catch(Exception e) {
    conn.rollback();  // 실패 시 롤백
    e.printStackTrace();
    out.print("연결 오류: " + e.getMessage());
} finally {
    // 자원 해제 (ResultSet, PreparedStatement, InputStream, Connection 순)
    if (rs != null) rs.close();
    if (pstmt != null) pstmt.close();
    if (fileInputStream != null) fileInputStream.close();
    if (conn != null) conn.close();
}
%>
</body>
</html>