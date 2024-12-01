<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메인페이지</title>
    <link rel="stylesheet" type="text/css" href="NewFile.css"/>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        h2 {
            margin-top: 80px; /* 네비게이션 바 아래 공간 확보 */
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
    <h2>자유게시판</h2>
    <div class="post-form" style="display: none;">
        <input type="text" id="title" placeholder="제목" style="width: 100%; margin-bottom: 10px;"><br>
        <textarea id="content" placeholder="내용" style="width: 100%; height: 100px; resize: none;"></textarea><br>
    </div>
    <div>
        <button onclick="addPost()" id="add-post-button" style="display: none; padding: 10px 20px; font-size: 16px; background-color: #28a745; color: white; border: none; border-radius: 5px; cursor: pointer; transition: background-color 0.3s ease; float: right;">글 올리기</button>
        <button onclick="togglePostForm()" id="toggle-button" style="padding: 10px 20px; font-size: 16px; background-color: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; transition: background-color 0.3s ease;">게시글 작성</button>
    </div>
    
    <div id="post-list" class="post-list">
        <div class="post-item" onclick="alert('게시글 제목: 첫 번째 글\n내용: 이것은 첫 번째 게시글의 내용입니다.')">첫 번째 글 - 이것은 첫 번째 게시글의 내용입니다.</div>
        <div class="post-item" onclick="alert('게시글 제목: 두 번째 글\n내용: 이것은 두 번째 게시글의 내용입니다.')">두 번째 글 - 이것은 두 번째 게시글의 내용입니다.</div>
        <div class="post-item" onclick="alert('게시글 제목: 세 번째 글\n내용: 이것은 세 번째 게시글의 내용입니다.')">세 번째 글 - 이것은 세 번째 게시글의 내용입니다.</div>
    	<button onclick="location.href='#'">이전</button>
    	<button onclick="location.href='#'">다음</button>
    </div>

    <script>
        function addPost() {
            const title = document.getElementById('title').value;
            const content = document.getElementById('content').value;

            if (title === "" || content === "") {
                alert("제목과 내용을 입력해주세요.");
                return;
            }

            const postDiv = document.createElement('div');
            postDiv.classList.add('post');

            const postTitle = document.createElement('div');
            postTitle.classList.add('post-title');
            postTitle.textContent = title;

            const postContent = document.createElement('div');
            postContent.classList.add('post-content');
            postContent.textContent = content;

            postDiv.appendChild(postTitle);
            postDiv.appendChild(postContent);

            const postsContainer = document.getElementById('posts');
            postsContainer.insertBefore(postDiv, postsContainer.firstChild);

            // 게시글 리스트에 추가
            const postItem = document.createElement('div');
            postItem.classList.add('post-item');
            postItem.textContent = title + ' - ' + content.substring(0, 20) + (content.length > 20 ? '...' : '');
            postItem.onclick = function() {
                alert("게시글 제목: " + title + "\n내용: " + content);
            };

            const postListContainer = document.getElementById('post-list');
            postListContainer.appendChild(postItem);

            // 입력 필드 초기화
            document.getElementById('title').value = "";
            document.getElementById('content').value = "";
        }
    </script>
<script>
        function togglePostForm() {
            const postForm = document.querySelector('.post-form');
            const postFormBtn = document.getElementById('add-post-button');
            const toggleButton = document.getElementById('toggle-button');
            const buttonContainer = document.getElementById('button-container');
            if (postForm.style.display === 'none') {
                postForm.style.display = 'block';
                postFormBtn.style.display = 'block';
                toggleButton.textContent = '작성 취소';
                
            } else {
                postForm.style.display = 'none';
                postFormBtn.style.display = 'none';
                toggleButton.textContent = '게시글 작성';
                
            }
        }
    </script>
<div class="search-form" style="margin-top: 20px; display: flex; align-items: center; gap: 10px;">
        <input type="text" id="search-input" placeholder="게시글 검색" style="flex: 1; padding: 10px; font-size: 16px;">
        <button onclick="searchPosts()" style="padding: 10px 20px; font-size: 16px; background-color: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; transition: background-color 0.3s ease;">검색</button>
    </div>
    <script>
        function searchPosts() {
            const searchTerm = document.getElementById('search-input').value.toLowerCase();
            const posts = document.querySelectorAll('.post');
            posts.forEach(post => {
                const title = post.querySelector('.post-title').textContent.toLowerCase();
                const content = post.querySelector('.post-content').textContent.toLowerCase();
                if (title.includes(searchTerm) || content.includes(searchTerm)) {
                    post.style.display = 'block';
                } else {
                    post.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>