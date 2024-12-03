<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이 페이지</title>
    <link rel="stylesheet" type="text/css" href="NewFile.css"/>
    <style>
         body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            color: #333;
            line-height: 1.6;
        } 
        
        .container {
            width: 80%;
            margin: 0 auto;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin-top: 150px; /* 네비게이션 바 아래 공간 확보 */
        }
         .header {
            text-align: center;
            padding-bottom: 20px;
        } 
        .profile-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .profile-info img {
            border-radius: 50%;
            width: 120px;
            height: 120px;
            object-fit: cover;
        }
        .info {
            flex: 1;
        }
        .posts {
            margin-top: 20px;
        }
        .posts ul {
            list-style-type: none;
            padding: 0;
        }
        .posts li {
            background: #f9f9f9;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 5px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
        }
        .nickname-container p,
        .nickname-container button {
            display: inline;
        }
    </style>

</head>
<body>
    <%@include file="navbar.jsp"%> 
    <div class="container">
        <div class="header">
            <h1>마이 페이지</h1>
        </div>
        <div class="profile-info">
            <div class="info">
                <div id="nicknameDisplay">
                    <span><strong>닉네임</strong>: </span>
                    <span id="nicknameText">${nickname}</span>
                    <button id="editButton" style="margin-left: 10px;" onclick="editNickname()">수정</button>
                </div>
                <!-- 닉네임 수정 폼 -->
                <form id="nicknameForm" style="display: none;" action="/ws_project/updatenickname" method="post">
                    <input type="hidden" name="user_id" value="${sessionScope.user_id}">
                    <label for="nicknameInput">닉네임:</label>
                    <input type="text" id="nicknameInput" name="nickname" value="${nickname}" required>
                    <button type="submit">저장</button>
                    <button type="button" onclick="cancelEdit()">취소</button>
                </form>
            </div>
        </div>
        <hr>
        <div class="posts">
            <h3>내 게시물</h3>
            <ul>
                <c:forEach var="post" items="${userPosts}">
                    <li>
                        <a href="/ws_project/viewPost?postId=${post.postId}">
                            ${post.title}
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>
    <script>
        function editNickname() {
            // 닉네임 텍스트와 수정 버튼 숨기기
            document.getElementById('nicknameDisplay').style.display = 'none';
            // 닉네임 수정 폼 보이기
            document.getElementById('nicknameForm').style.display = 'block';
        }
        
        function cancelEdit() {
            // 닉네임 텍스트와 수정 버튼 보이기
            document.getElementById('nicknameDisplay').style.display = 'block';
            // 닉네임 수정 폼 숨기기
            document.getElementById('nicknameForm').style.display = 'none';
        }
    </script>
</body>
</html>
