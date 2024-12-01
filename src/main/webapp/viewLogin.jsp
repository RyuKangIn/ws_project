<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link rel="stylesheet" type="text/css" href="NewFile.css"/>
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

    <h2>로그인</h2>
    <form action="/ws_project/login" method="post">
        <label>아이디: <input type="text" name="username" required></label><br>
        <label>비밀번호: <input type="password" name="password" required></label><br>
        <button type="submit">로그인</button>
    </form>
    <p><a href="/ws_project/viewRegister.jsp">회원가입</a></p>
    </div>

</body>
</html>