<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.logging.*" %>
<%
    // 로거 설정
    Logger logger = Logger.getLogger("ChatLogger");

    // 입력 파라미터 검증
    String sourceUserId = request.getParameter("source_user_id");
    String destUserId = request.getParameter("dest_user_id");
    String content = request.getParameter("content");

    if (sourceUserId == null || sourceUserId.isEmpty() ||
        destUserId == null || destUserId.isEmpty() ||
        content == null || content.isEmpty()) {
        logger.warning("Invalid input detected. Source User ID or Destination User ID or Content is missing.");
        // out.println("Invalid input detected. Please check your data.");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ws_db", "wsp", "1234");
        conn.setAutoCommit(false);  // 트랜잭션 시작

        String source_nickname = "";
        String dest_nickname = "";

        // 출발지 유저 닉네임 조회
        String sql = "SELECT nickname FROM users WHERE user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, sourceUserId);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            source_nickname = rs.getString("nickname");
        }
        rs.close();
        pstmt.close();

        // 목적지 유저 닉네임 조회
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, destUserId);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            dest_nickname = rs.getString("nickname");
        }
        rs.close();
        pstmt.close();

        // 채팅 메시지 저장
        sql = "INSERT INTO chat (source_user_id, source_user_nickname, dest_user_id, dest_user_nickname, content) VALUES (?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, sourceUserId);
        pstmt.setString(2, source_nickname);
        pstmt.setString(3, destUserId);
        pstmt.setString(4, dest_nickname);
        pstmt.setString(5, content);

        int rowsAffected = pstmt.executeUpdate();
        if (rowsAffected > 0) {
            conn.commit();  // 커밋
            logger.info("Message successfully stored for Source User ID: " + sourceUserId + " and Destination User ID: " + destUserId);
            //out.println("Message successfully stored.");
        } else {
            conn.rollback();  // 롤백
            logger.warning("No rows affected. Rolling back transaction.");
            out.println("Failed to store message, please try again.");
        }
    } catch (Exception e) {
        if (conn != null) {
            try {
                conn.rollback();  // 오류 시 롤백
                logger.severe("Exception occurred, rolling back transaction: " + e.getMessage());
            } catch (SQLException se) {
                se.printStackTrace();
                logger.severe("SQLException during rollback: " + se.getMessage());
            }
        }
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException se) {
            se.printStackTrace();
            logger.severe("SQLException during resource cleanup: " + se.getMessage());
        }
    }
%>
