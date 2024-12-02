<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시물 작성</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/skeleton/2.0.4/skeleton.min.css">
    <style>
        body {
            margin: 0;
            padding: 20px;
            font-family: Arial, sans-serif;
            overflow: hidden;
        }
        #navbar {
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #007bff;
            color: white;
            padding: 20px;
            margin-bottom: 20px;
        }
        #navbar button {
            background: none;
            border: none;
            color: white;
            font-size: 18px;
            cursor: pointer;
            margin: 0 15px;
        }
        #navbar button:hover {
            text-decoration: underline;
        }
        #navbar .auth-buttons {
            margin-left: auto;
        }
        .container {
            max-width: 1800px;
            margin: 0 auto;
        }
        .btn {
            background-color: #5A67D8;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #45B76F;
        }
        textarea {
            resize: none;
        }
    </style>
</head>
<body>
    <div id="navbar">
        <button onclick="location.href='home.jsp'">홈</button>
        <button onclick="location.href='board.jsp'">게시판</button>
        <button onclick="location.href='schedule.jsp'">시간표</button>
        <button onclick="location.href='food.jsp'">학식</button>
        <button onclick="location.href='chat.jsp'">대화</button>
        <div class="auth-buttons">
            <button onclick="location.href='login.jsp'">로그인</button>
            <button onclick="location.href='logout.jsp'">로그아웃</button>
        </div>
    </div>
    <div class="container">
        <h2 style="text-align: center; font-size: 24px;">게시물 작성</h2>
        <form id="postForm" action="content_create.jsp" method="POST">
            <div class="field">
                <label for="title">제목</label>
                <input type="text" id="title" name="title" required style="width: 100%;">
            </div>
            <div class="field">
                <label for="content">내용</label>
                <textarea id="content" name="content" rows="20" required style="width: 100%; height: 30%;"></textarea>
            </div>
            <div style="display: flex; align-items: center; gap: 10px; justify-content: flex-end;">
                <label for="terms">
                    <input type="checkbox" id="terms" name="terms">
                    익명
                </label>
                <br>
                <button type="submit" class="btn" style="background-color: #50C878; padding: 20px 40px; font-size: 20px;; text-align: center;; padding: 20px 40px; font-size: 20px; text-align: center; display: flex; align-items: center; justify-content: center;">글 올리기</button>
            </div>
        </form>
    </div>

<%@ page import="java.sql.*" %>
<%
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String userNickname = request.getParameter("terms") != null ? "익명" : "UserNickname";

        String url = "jdbc:mysql://localhost:3306/ws_db";
        String dbUser = "wsp";
        String dbPassword = "1234";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // JDBC 드라이버 로드
            Class.forName("com.mysql.cj.jdbc.Driver");
            // DB 연결
            conn = DriverManager.getConnection(url, dbUser, dbPassword);

            // SQL 쿼리 작성
            String sql = "INSERT INTO posts (title, content, user_id, user_nickname) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setString(2, content);
            pstmt.setString(3, "1");
            pstmt.setString(4, userNickname);

            // 쿼리 실행
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                out.println("<script>location.href='content_list.jsp';</script>");
            } else {
                out.println("<script>alert('게시글 작성에 실패했습니다.'); history.back();</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('오류가 발생했습니다: " + e.getMessage() + "'); history.back();</script>");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
</body>
</html>


