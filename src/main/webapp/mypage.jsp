<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<script>
        function editNickname() {
            const nicknameElement = document.querySelector('.nickname-container');
            const currentNickname = document.getElementById('nicknameText').textContent;
            const inputHTML = `<input type='text' id='nicknameInput' value='${currentNickname}'> <button onclick='saveNickname()'>확인</button>`;
            nicknameElement.innerHTML = `<strong>닉네임</strong>: ${inputHTML}`;
        }
        
        function saveNickname() {
            const newNickname = document.getElementById('nicknameInput').value;
            const nicknameElement = document.querySelector('.nickname-container');
            nicknameElement.innerHTML = `
                    <p><strong>닉네임</strong>: </p> 
                    <p id="nicknameText">${newNickname}</p>
                    <button style="display: inline; margin-left: 10px;" onclick="editNickname()">수정</button>`;
        }
    </script>
</head>
<body>
	<%@include file="navbar.jsp"%> 
    <div class="container">
        <div class="header">
            <h1>마이 페이지</h1>
        </div>
        <div class="profile-info">
            <div class="info">
                <h2>홍길동</h2>
                <div class="nickname-container">
                    <p><strong>닉네임</strong>: </p> 
                    <p id="nicknameText">프로게이머123</p>
                    <button style="display: inline; margin-left: 10px;" onclick="editNickname()">수정</button>
                </div>
            </div>
        </div>
        <hr>
        <div class="posts">
            <h3>내 게시물</h3>
            <ul>
                <li>게시물 1: 오늘의 프로그래밍 일기</li>
                <li>게시물 2: 보드게임 Space Crew 후기</li>
                <li>게시물 3: 리그 오브 레전드 플레이 전략 공유</li>
            </ul>
        </div>
    </div>
</body>
</html>