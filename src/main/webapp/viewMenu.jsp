<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
String dbUrl = "jdbc:mysql://localhost:3306/ws_db";
String username = "wsp";
String password = "1234";
String tip = null; // 초기화
String e_ = null;   // 초기화
Class.forName("com.mysql.cj.jdbc.Driver");
try (Connection conn = DriverManager.getConnection(dbUrl, username, password)) {
    String sql = "SELECT src FROM menu ORDER BY id";
    PreparedStatement pstmt = conn.prepareStatement(sql);
    ResultSet rs = pstmt.executeQuery();
    
    rs.next();
    tip = rs.getString("src");
    rs.next();
    e_ = rs.getString("src");
} catch (Exception e) {
	e.printStackTrace();
}
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
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

   <header><%@include file="navbar.jsp" %> </header>
	<h2> </h2><br>
<img src="<%= tip %>" alt="Menu Image" style="width:600px; height:auto;"/><br>
<img src="<%= e_ %>" alt="Menu Image" style="width:600px; height:auto;"/>
    
  
</body>
</html>