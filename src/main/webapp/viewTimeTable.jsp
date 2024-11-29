<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 시간표</title>
<link rel="stylesheet" type="text/css" href="/ws_project/NewFile.css"/>
<style>.main-container{
margin-top: 80px;
}</style>

</head>
<body> 
	<div id="navbar">
            <button onclick="location.href='/ws_project/mainpage.html'">홈</button>
        	<button onclick="location.href='/ws_project/timetable'">시간표</button>
        	<button onclick="location.href='/ws_project/menu'">학식</button>
        	<button onclick="location.href='#'">쪽지</button>
            <div class="auth-buttons">
                <button onclick="location.href='/ws_project/mypage.html'">마이페이지</button>
                <button onclick="location.href='#'">로그아웃</button>
            </div>
            </div>
<div class="main-container">
    <!-- 시간표 -->
    <div class="table-container">
        <table border="1">
            <tr>
                <th></th>
                <th>월</th>
                <th>화</th>
                <th>수</th>
                <th>목</th>
                <th>금</th>
            </tr>
            <c:forEach var="i" begin="1" end="12">
                <tr>
                    <td>${i}교시</td>
                    <c:forEach var="day" items="${days}">
                        <td>
                            <c:out value="${timetable[day][i - 1]}" default="-"/>
                        </td>
                    </c:forEach>
                </tr>
            </c:forEach>
        </table>
    </div>

    <!-- 시간표 추가 -->
    <div class="add-container">    
        <form action="/ws_project/addtimetable" method="post">
            <!-- 강의명 입력 -->
            <label>강의명: 
                <input type="text" name="lec_name" required placeholder="강의명을 입력하세요">
            </label><br />
            <label>요일:
                <select name="day" required>
                    <option value="월">월</option>
                    <option value="화">화</option>
                    <option value="수">수</option>
                    <option value="목">목</option>
                    <option value="금">금</option>
                </select>
            </label><br />
            <!-- 교시 범위 선택 -->
            <div class="range-select">
                <label>교시:</label>
                <select name="start" required>
                    <c:forEach var="period" begin="1" end="12">
                        <option value="${period}">${period}교시</option>
                    </c:forEach>
                </select>
                <span>~</span>
                <select name="end" required>
                    <c:forEach var="period" begin="1" end="12">
                        <option value="${period}">${period}교시</option>
                    </c:forEach>
                </select>
            </div><br />
            
            <button type="submit">추가</button>
        </form>
    </div>
</div>
</body>
</html>
