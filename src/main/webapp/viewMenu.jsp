<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%
    List<String> imgSrcList = (List<String>) request.getAttribute("imageSrcList");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>학식 메뉴 조회</title>
<link rel="stylesheet" type="text/css" href="/ws_project/NewFile.css"/>
<style>
body {		
			padding: 0;
            margin: 0;
            font-family: Arial, sans-serif;
            text-align: center;
        }
        h2 {
            margin-top: 80px; /* 네비게이션 바 아래 공간 확보 */
        }
        </style>
</head>
<body>

    <div id="navbar">
            <button onclick="location.href='#'">홈</button>
            
            <button onclick="location.href='#'">시간표</button>
            <button onclick="location.href='#'">학식</button>
            <button onclick="location.href='#'">쪽지</button>
            <div class="auth-buttons">
            	<button onclick="location.href='#'">마이페이지</button>
                <button onclick="location.href='#'">로그아웃</button>
            </div>
        </div>
<img src="//contents.kpu.ac.kr/contents/U/U2Q/U2QZ8Z1KW6ZL/images/scale1/XLXPNZ76AA09.jpg" alt="Menu Image" style="width:600px; height:auto;"/><br>
    <%
        if (imgSrcList != null) {
            String tip = imgSrcList.get(0);
            String e = imgSrcList.get(1);
            
    %>
    			<h5> TIP 학생 식당</h5>
                <img src="contents.kpu.ac.kr/contents/U/U2Q/U2QZ8Z1KW6ZL/images/scale1/XLXPNZ76AA09.jpg" alt="Menu Image" style="width:600px; height:auto;"/><br>
                <!-- <img src="" alt="Menu Image" style="width:600px; height:auto;"/> -->
    <%
        } 
        else {
    %>
        <p>이미지를 불러올 수 없습니다.</p>
    <%
        }
    %>

</body>
</html>
