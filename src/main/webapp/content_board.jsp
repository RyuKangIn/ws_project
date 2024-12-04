
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.wsp.useclass.*" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.util.ArrayList, java.util.List" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 보기</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap">
    <!-- <link rel="stylesheet" type="text/css" href="NewFile.css"/> -->
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0 auto;
            line-height: 1.6;
            background-color: #f9f9f9;
            color: #333;
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
        .post-title {
            font-size: 2em;
            margin-bottom: 10px;
            color: #222;
        }
        .post-meta {
            font-size: 0.9em;
            color: #666;
            margin-bottom: 20px;
        }
        .post-content {
            font-size: 1.2em;
        }
        article {
            margin: 20px;
            padding: 20px;
        }
        .comment-section {
            margin: 20px;
            padding: 20px;
            background-color: #ffffff;
            border: 1px solid #ddd;
        }
        .comment-section h2 {
            font-size: 1.5em;
            margin-bottom: 15px;
        }
        .comment {
            margin-bottom: 15px;
            padding: 10px;
            border: 1px solid #ccc;
            background-color: #f9f9f9;
            border-radius: 4px;
        }
        .comment .comment-meta {
            font-size: 0.9em;
            color: #666;
            margin-bottom: 5px;
        }
        .reply {
            margin-left: 20px;
            margin-top: 10px;
            padding: 10px;
            border: 1px solid #ddd;
            background-color: #f5f5f5;
            border-radius: 4px;
        }
        .comment-form textarea {
            width: 98%;
            height: 100px;
            padding: 10px;
            font-size: 1em;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            resize: none;
        }
        .comment-form button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 1em;
            cursor: pointer;
            border-radius: 4px;
        }
        .comment-form button:hover {
            background-color: #0056b3;
        }
        .post-buttons {
            margin-top: 20px;
        }
        .post-buttons button {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 1em;
            cursor: pointer;
            border-radius: 4px;
            margin-right: 10px;
        }
        .post-buttons button:hover {
            background-color: #218838;
        }
        .post-buttons button.delete {
            background-color: #dc3545;
        }
        .post-buttons button.delete:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
    <%@include file="navbar.jsp" %> 
    
    <article>
<header>
<h1 class="post-title">
<%
System.out.println("Received post_id: " + request.getParameter("post_id"));

    List<Comment> commentList = new ArrayList<>();

    String dbURL = "jdbc:mysql://localhost:3306/ws_db";
    String dbUser = "wsp";
    String dbPassword = "1234";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        String query = "SELECT title, content, user_nickname FROM posts WHERE id = ?";
        stmt = conn.prepareStatement(query);
        stmt.setInt(1, Integer.parseInt(request.getParameter("post_id")));
        rs = stmt.executeQuery();
        if (rs.next()) {
            request.setAttribute("postTitle", rs.getString("title"));
            request.setAttribute("postContent", rs.getString("content"));
            request.setAttribute("author", rs.getString("user_nickname"));
        }
        
        query = "SELECT user_nickname, content FROM comment WHERE post_id = ?";
        stmt = conn.prepareStatement(query);
        stmt.setInt(1, Integer.parseInt(request.getParameter("post_id")));
        rs = stmt.executeQuery();
        while (rs.next()) {
            Comment comment = new Comment(rs.getString("user_nickname"), rs.getString("content"));
            commentList.add(comment);
        }
        
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (stmt != null) stmt.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
<%= request.getAttribute("postTitle") %>
</h1>
            <p class="post-meta">작성자: <%= request.getAttribute("author") %> <%--| 작성일: <%= request.getAttribute("postDate") %> --%></p>
        </header>
        <section class="post-content">
<p><%= request.getAttribute("postContent") %></p>
        </section>
        
        <div class="post-buttons">
            <button type="button" onclick="location.href='content_edit.jsp?post_id=<%= request.getParameter("post_id") %>'">수정</button>
            <button type="button" class="delete" onclick="deletePost(<%= request.getParameter("post_id") %>)">삭제</button>
<script>
    function deletePost(postId) {
        if (confirm('정말 삭제하시겠습니까?')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '<%= request.getRequestURI() %>?post_id=' + postId;
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'action';
            input.value = 'delete';
            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>
        </div>
    </article>
    <div class="comment-section">
        <h2>덧글</h2>
        <% 
            if(commentList != null)
                for(Comment comment : commentList) {
        %>
        <div class="comment">
            <div class="comment-meta">작성자: <%= comment.getAuthor() %> <%--| 작성일: <%= comment.getDate() %> --%></div>
            <p><%= comment.getContent() %></p>
        </div>
        <% } %>
        <form class="comment-form" action="<%= request.getRequestURI() + "?post_id=" + request.getParameter("post_id") %>" method="post">
            <textarea name="commentContent" placeholder="덧글을 작성하세요..."></textarea><br>
            <input type="hidden" name="postId" value="<%= request.getParameter("post_id") %>" />
            <label>
                <input type="checkbox" name="anonymous" value="true"> 익명
            </label>
            <br>
            <button type="submit">덧글 작성</button>
        </form>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            try {
                String postId = request.getParameter("post_id");
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                String deleteQuery = "DELETE FROM posts WHERE id = ?";
                stmt = conn.prepareStatement(deleteQuery);
                stmt.setInt(1, Integer.parseInt(postId));
                stmt.executeUpdate();
                response.sendRedirect("content_list.jsp");
                return;
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { if (stmt != null) stmt.close(); } catch (Exception e) { e.printStackTrace(); }
                try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
            }
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
            String commentContent = request.getParameter("commentContent");
            String postId = request.getParameter("postId");
            String userId = (String) session.getAttribute("userId");
            if (userId == null) {
                userId = "1";  // 기본 사용자 ID 설정
            }  // 사용자 ID는 세션에서 가져온다고 가정

            String userNickname;
            if ("true".equals(request.getParameter("anonymous"))) {
                userNickname = "익명"; // 익명으로 설정
            } else {
                userNickname = (String) session.getAttribute("nickname");
                if (userNickname == null) {
                    userNickname = "손님";  // 기본 사용자 닉네임 설정
                }
            }

            String query = "INSERT INTO comment (post_id, content, user_id, user_nickname) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, postId);
            stmt.setString(2, commentContent);
            stmt.setString(3, userId);
            stmt.setString(4, userNickname);
            stmt.executeUpdate();
            response.sendRedirect(request.getRequestURI() + "?post_id=" + postId);
            return;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
%>
    </div>
</body>
</html>