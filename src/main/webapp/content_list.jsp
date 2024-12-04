<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.wsp.useclass.*" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.util.ArrayList, java.util.List" %>
<%@ page import="java.io.PrintWriter" %>
<%@ taglib uri="/WEB-INF/tags/PostListTagHandler.tld" prefix="pl" %>
<%
    // DB 연결 설정
    String dbURL = "jdbc:mysql://localhost:3306/ws_db";
    String dbUser = "wsp";
    String dbPassword = "1234";
    Connection conn = null;
    List<Post> postList = new ArrayList<>();

    // 게시글 목록 불러오기
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        String query = "SELECT id, title, content, user_nickname FROM posts ORDER BY created_at DESC";
        PreparedStatement pstmt = conn.prepareStatement(query);
        ResultSet rs = pstmt.executeQuery();

        while (rs.next()) {
            Post post = new Post();
            post.setId(rs.getInt("id"));
            post.setTitle(rs.getString("title"));
            post.setContent(rs.getString("content"));
            post.setNickname(rs.getString("user_nickname"));
            postList.add(post);
        }
        request.setAttribute("postList", postList);
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (conn != null) {
            try {
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시판</title>
    <style>
        header {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .post-form {
            margin-bottom: 20px;
        }
        .post {
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 10px;
        }
        .post-title {
            font-weight: bold;
            font-size: 1.2em;
        }
        .post-content {
            margin-top: 5px;
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
        .post-list {
            margin-bottom: 20px;
        }
        .post-item {
            padding: 10px;
            border: 1px solid #ddd;
            margin-bottom: 10px;
            cursor: pointer;
        }
        .post-item:hover {
            background-color: #f0f0f0;
        }
        #toggle-button:hover {
            background-color: #0056b3;
        }
        #add-post-button:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <%@include file="navbar.jsp" %> 
    <br><br><br><br>
    <h1>게시판</h1>
    <div>
        <button type="button" onclick="location.href='content_create.jsp'" id="toggle-button" style="padding: 10px 20px; font-size: 16px; background-color: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; transition: background-color 0.3s ease;">게시글 작성</button>
    </div>
    
    <div class="search-form" style="margin-top: 20px; display: flex; align-items: center; gap: 10px;">
        <input type="text" id="search-input" placeholder="게시글 검색" style="flex: 1; padding: 10px; font-size: 16px;">
        <button onclick="searchPosts()" style="padding: 10px 20px; font-size: 16px; background-color: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; transition: background-color 0.3s ease;">검색</button>
    </div>
    
    <div id="post-list" class="post-list">
        <h2>게시글 리스트</h2>
        <pl:postList/>
        <%--<c:forEach var="post" items="${postList}">
            <custom:displayPost post="${post}" />
        </c:forEach> --%>
    </div>
    
    <script>
        function searchPosts() {
            const searchTerm = document.getElementById('search-input').value.toLowerCase();
            const posts = document.querySelectorAll('.post-item');
            posts.forEach(post => {
                if (post.textContent.toLowerCase().includes(searchTerm)) {
                    post.style.display = 'block';
                } else {
                    post.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>
