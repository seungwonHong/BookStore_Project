<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
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
String userId = (String) session.getAttribute("userid");

PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    // 북카트의 내용을 가져오기
    pstmt = conn.prepareStatement("SELECT book_cart FROM User WHERE user_id = ?");
    pstmt.setString(1, userId);
    rs = pstmt.executeQuery();
    
    if (rs.next()) {
        String book_cart = rs.getString("book_cart");
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        
        try {
            // book_order에 기존 값이 있으면 추가하고 없으면 그대로 추가
            pstmt2 = conn.prepareStatement(
                "UPDATE User SET book_order = CONCAT(IFNULL(book_order, ''), ?) WHERE user_id = ?"
            );
            pstmt2.setString(1, book_cart); // 기존 값에 ','로 구분하여 추가
            pstmt2.setString(2, userId);
            pstmt2.executeUpdate();

            // book_cart 정보 초기화
            pstmt3 = conn.prepareStatement("UPDATE User SET book_cart = NULL WHERE user_id = ?");
            pstmt3.setString(1, userId);
            pstmt3.executeUpdate();

            // 업데이트와 삭제가 성공적으로 끝났으면 pay.jsp로 이동
            response.sendRedirect("pay.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("데이터베이스 조작 실패(업데이트)");
        } finally {
            if (pstmt2 != null) {
                pstmt2.close();
            }
            if (pstmt3 != null) {
                pstmt3.close();
            }
        }
    } else {
        out.print("카트 정보 가져오기 실패");
    }
} catch (Exception e) {
    e.printStackTrace();
    out.print("데이터베이스 조작 실패");
} finally {
    if (pstmt != null) {
        pstmt.close();
    }
    if (rs != null) {
        rs.close();
    }
}
%>
</body>
</html>