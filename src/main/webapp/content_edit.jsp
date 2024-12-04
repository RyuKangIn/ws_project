<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시물 수정</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/skeleton/2.0.4/skeleton.min.css">
    <style>
        body {
            margin: 0;
            padding: 20px;
            font-family: Arial, sans-serif;
            overflow: hidden;
        }
         #navbar {
        	width: 100%;
            position: fixed;
            top: 0;
            left: 0;
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
     <%@include file="navbar.jsp" %> 
     <br><br><br><br>
    <div class="container">
        <h2 style="text-align: center; font-size: 24px;"><b>게시물 수정</b></h2>
        <form id="postForm" method="POST" onsubmit="handleFormSubmit(event)">
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
                <button type="submit" class="btn" style="background-color: #50C878; padding: 20px 40px; 
                font-size: 20px;; text-align: center;; padding: 20px 40px; font-size: 20px; text-align: center; 
                display: flex; align-items: center; justify-content: center;">글 수정</button>
            </div>
            <input type="hidden" name="post_id" value="<%= request.getParameter("post_id") %>">
        </form>
    </div>

<%@ page import="java.sql.*" %>
<%
    String postId = request.getParameter("post_id");
    if (postId != null && !postId.isEmpty()) {
        String url = "jdbc:mysql://localhost:3306/ws_db";
        String dbUser = "wsp";
        String dbPassword = "1234";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // JDBC 드라이버 로드
            Class.forName("com.mysql.cj.jdbc.Driver");
            // DB 연결
            conn = DriverManager.getConnection(url, dbUser, dbPassword);

            // SQL 쿼리 작성
            String sql = "SELECT title, content, user_nickname FROM posts WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, postId);

            // 쿼리 실행
            rs = pstmt.executeQuery();
            if (rs.next()) {
                String title = rs.getString("title");
                String content = rs.getString("content");
                String userNickname = rs.getString("user_nickname");

                // 게시물 데이터를 폼에 채우기
%>
                <script>
                    document.getElementById("title").value = "<%= title %>";
                    document.getElementById("content").value = "<%= content %>";
                    <% if ("익명".equals(userNickname)) { %>
                        document.getElementById("terms").checked = true;
                    <% } %>
                </script>
<%
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('오류가 발생했습니다: " + e.getMessage() + "'); history.back();</script>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        if (title == null || content == null || title.isEmpty() || content.isEmpty()) {
            out.println("<script>alert('제목과 내용을 모두 입력해 주세요.'); history.back();</script>");
            return;
        }
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

            // SQL 쿼리 작성 (UPDATE)
            String sql = "UPDATE posts SET title = ?, content = ?, user_nickname = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setString(2, content);
            pstmt.setString(3, userNickname);
            pstmt.setString(4, postId);

            // 쿼리 실행
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                out.println("<script>location.href='content_board.jsp'" + "?post_id=" + request.getParameter("post_id") + ";</script>");
            } else {
                out.println("<script>alert('게시글 수정에 실패했습니다.'); history.back();</script>");
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
<script>
    function handleFormSubmit(event) {
        event.preventDefault();
        fetch(window.location.href, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: new URLSearchParams(new FormData(document.getElementById('postForm'))).toString()
        }).then(response => {
            if (response.ok) {
                window.location.href = 'content_board.jsp?post_id=' + document.getElementsByName('post_id')[0].value;
            } else {
                alert('게시글 수정에 실패했습니다. 다시 시도해주세요.');
            }
        }).catch(error => {
            alert('오류가 발생했습니다: ' + error);
        });
    }
</script>
</body>
</html>
