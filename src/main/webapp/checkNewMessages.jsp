<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<%
    // 응답 형식을 텍스트로 설정
    response.setContentType("text/plain");
    
    // 데이터베이스 연결 변수들
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // 요청 파라미터로부터 사용자 ID를 가져옴
    String destUserId = request.getParameter("dest_user_id");
    String sourceUserId = "1";  // 현재 사용자의 ID가 1이라고 가정
    
    try {
        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ws_db", "wsp", "1234");
        
        // 마지막으로 확인한 메시지 이후에 새로운 메시지가 있는지 확인하는 SQL 쿼리
        String sql = "SELECT source_user_id, dest_user_id, source_user_nickname, content FROM chat " +
                     "WHERE dest_user_id = ? AND source_user_id = ? AND seen = 0";
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, sourceUserId);
        pstmt.setString(2, destUserId);
        
        rs = pstmt.executeQuery();

        // 새로운 메시지가 있다면 반환
        if (rs.next()) {
            String messageContent = rs.getString("content");
            
            // 응답으로 메시지 반환
            out.print(messageContent);
            
            // 메시지를 확인 상태로 업데이트
            String updateSql = "UPDATE chat SET seen = 1 WHERE source_user_id = ? AND dest_user_id = ? AND seen = 0";
            PreparedStatement updatePstmt = conn.prepareStatement(updateSql);
            updatePstmt.setString(1, destUserId);
            updatePstmt.setString(2, sourceUserId);
            updatePstmt.executeUpdate();
            updatePstmt.close();
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException se) {
            se.printStackTrace();
        }
    }
%>
