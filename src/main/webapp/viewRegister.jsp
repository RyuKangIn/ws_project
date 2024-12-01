<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
	<link rel="stylesheet" type="text/css" href="NewFile.css"/>
    <script>
    	let isDuplicateChecked = false; // 중복 확인 여부를 추적

    
        function checkDuplicate() {
        	const username = document.querySelector('input[name="username"]').value;
            if (!username) {
                alert('아이디를 입력하세요.');
                return;
            }

         // EL 영향을 받지 않도록 " 대신 '를 사용하거나 이스케이프 처리
            const xhr = new XMLHttpRequest();
            xhr.open("GET", "/ws_project/checkduplicateid?username=" + encodeURIComponent(username), true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    if (xhr.responseText === 'true') {
                        alert('이미 존재하는 아이디입니다.');
                    } else {
                        alert('사용 가능한 아이디입니다.');
                        isDuplicateChecked = true; // 중복 확인 완료
                    }
                }
            };
            xhr.send();
        }

        function validateForm(event) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirm-password').value;
         	// 아이디 중복 확인 여부 확인
            if (!isDuplicateChecked) {
                event.preventDefault();
                alert('아이디 중복 확인을 해주세요.');
                return false;
            }
         	
            if (password !== confirmPassword) {
                event.preventDefault();
                alert('비밀번호가 일치하지 않습니다.');
                return false;
            }
        }
    </script>
    <style>
body {
    display: flex;
    justify-content: center; /* 가로 중앙 정렬 */
    align-items: center; /* 세로 중앙 정렬 */
    height: 100vh; /* 화면 전체 높이를 사용 */
    margin: 0; /* 여백 제거 */
    background-color: #f0f0f0; /* 배경색 추가 (선택 사항) */
}
    </style>
</head>
<body>

    <div class="login-container">
        <h2>회원가입</h2>
        <form action="/ws_project/adduser" method="post" onsubmit="validateForm(event)">
            <label class="userid">
                    <input type="text" name="username" required placeholder="아이디를 입력하세요">
                    <button type="button" onclick="checkDuplicate()">중복확인</button>
            </label>
            <label>
                <input type="password" id="password" name="password" required placeholder="비밀번호를 입력하세요">
            </label>
            <label>
                <input type="password" id="confirm-password" required placeholder="비밀번호를 다시 입력하세요">
            </label>
            <label>
                <input type="text" name="nickname" required placeholder="닉네임을 입력하세요">
            </label>
            <button type="submit">회원가입</button>
        </form>
    </div>

</body>
</html>
