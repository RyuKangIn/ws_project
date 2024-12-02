<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="com.wsp.useclass.*" %>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String destUserId = request.getParameter("dest_id");
    List<chat> chatList = new ArrayList<>();
    List<chat> userList = new ArrayList<>();
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ws_db", "wsp", "1234");
        String sql;
        

        sql = "SELECT DISTINCT CASE WHEN source_user_id = ? THEN dest_user_id ELSE source_user_id END AS other_user_id, CASE WHEN source_user_id = ? THEN dest_user_nickname ELSE source_user_nickname END AS other_user_nickname FROM chat WHERE source_user_id = ? OR dest_user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, "1");
        pstmt.setString(2, "1");
        pstmt.setString(3, "1");
        pstmt.setString(4, "1");
        
        rs = pstmt.executeQuery();

        while (rs.next()) {
            chat chatRecord = new chat();
            chatRecord.source_user_id = rs.getString("other_user_id");
            chatRecord.source_user_nickname = rs.getString("other_user_nickname");
            userList.add(chatRecord);
        }
        
        
        sql = "SELECT DISTINCT source_user_id, dest_user_id, source_user_nickname, dest_user_nickname, content FROM chat WHERE (source_user_id = ? AND dest_user_id = ?) OR (source_user_id = ? AND dest_user_id = ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, "1");
        pstmt.setString(2, destUserId);
        pstmt.setString(3, destUserId);
        pstmt.setString(4, "1");
        
        rs = pstmt.executeQuery();
        while (rs.next()) {
            chat chatRecord = new chat();
            chatRecord.source_user_id = rs.getString("source_user_id");
            chatRecord.source_user_nickname = rs.getString("source_user_nickname");
            chatRecord.dest_user_id = rs.getString("dest_user_id");
            chatRecord.dest_user_nickname = rs.getString("dest_user_nickname");
            chatRecord.content = rs.getString("content");
            chatList.add(chatRecord);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException se) {
            se.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <link rel="stylesheet" type="text/css" href="chat_css.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>채팅 게시판</title>
    
</head>
<body>
    <div id="navbar">
        <button onclick="location.href='home.jsp'">홈</button>
        <button onclick="location.href='board.jsp'">게시판</button>
        <button onclick="location.href='timetable.jsp'">시간표</button>
        <button onclick="location.href='food.jsp'">학식</button>
        <button onclick="location.href='chat.jsp'">대화</button>
        <div class="auth-buttons">
            <button onclick="location.href='login.jsp'">로그인</button>
            <button onclick="location.href='logout.jsp'">로그아웃</button>
        </div>
    </div>

    <h1>채팅 게시판</h1>
    <div id="search-container">
        <input type="text" id="search-user" placeholder="유저 검색...">
        <button onclick="searchUser()">검색</button>
    </div>
    <div id="content-container">
        <div id="chat-list" class="chat-list">
            <h2>채팅 기록</h2>
            <%
                for (chat user : userList) {
                    out.println("<div class='chat-item' onclick=\"location.href='chat.jsp?dest_id=" + user.source_user_id + "'\">" + user.source_user_nickname + "</div>");
                }
            %>
        </div>

        <div id="chat-window" class="chat-window">
            <%
                for (chat c : chatList) {
                    if (c.source_user_id.equals("1")) {
                        out.println("<div class='message user-message'>" + c.content + "</div>");
                    } else {
                        out.println("<div class='message bot-message'>" + c.content + "</div>");
                    }
                }
            %>
        </div>
    </div>

    <div id="input-container">
        <input type="text" id="user-input" placeholder="메시지를 입력하세요...">
        <button onclick="sendMessage()" id="send-message-button">전송</button>
    </div>

    <script>
        function loadChat(sourceNickname, destNickname) {
            const chatWindow = document.getElementById('chat-window');
            chatWindow.innerHTML = '';
            fetchChat(sourceNickname, destNickname);
        }

        function fetchChat(sourceNickname, destNickname) {
            // 서버와의 통신은 실제로 서버 쪽에서 구현되어야 합니다.
            // 여기는 단순히 메시지를 불러오는 것만 가정합니다.
        }

        function sendMessage() {
            const chatWindow = document.getElementById("chat-window");
            const userInput = document.getElementById("user-input");
            const message = userInput.value.trim();

            if (message === "") return;

            // Add user message to chat window
            const userMessage = document.createElement("div");
            userMessage.className = "message user-message";
            userMessage.textContent = message;
            chatWindow.appendChild(userMessage);

            // Clear the input field
            userInput.value = "";

            // Scroll to the bottom of the chat window
            chatWindow.scrollTop = chatWindow.scrollHeight;

            // Send the message to the server to store in the database
            const urlParams = new URLSearchParams(window.location.search);
            const destUserId = urlParams.get("dest_id");

            const xhr = new XMLHttpRequest();
            xhr.open("POST", "storeMessage.jsp", true);
            xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    console.log('Message stored in DB');
                    
                    // 페이지 새로고침
                    window.location.reload(true);
                }
            };
            xhr.send("source_user_id=1&dest_user_id=" + encodeURIComponent(destUserId) + "&content=" + encodeURIComponent(message));
        }

        function searchUser() {
            const searchTerm = document.getElementById("search-user").value.trim();
            if (searchTerm === "") return;

            // 서버에 요청 보내기
            const xhr = new XMLHttpRequest();
            xhr.open("GET", "searchUser.jsp?username=" + encodeURIComponent(searchTerm), true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    const userId = xhr.responseText.trim();
                    if (userId !== "") {
                        // 검색된 userId를 이용해 대화 페이지로 이동
                        location.href = "chat.jsp?dest_id=" + userId;
                    } else {
                        alert("사용자를 찾을 수 없습니다.");
                    }
                }
            };
            xhr.send();
        }
        function checkNewMessages() {
            const urlParams = new URLSearchParams(window.location.search);
            const destUserId = urlParams.get("dest_id");

            const xhr = new XMLHttpRequest();
            xhr.open("GET", "checkNewMessages.jsp?dest_user_id=" + encodeURIComponent(destUserId), true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    const response = xhr.responseText.trim();
                    if (response !== "") {
                        // 새로운 메시지가 있을 경우 채팅창에 추가하거나 알림 표시
                        const chatWindow = document.getElementById("chat-window");
                        const newMessage = document.createElement("div");
                        newMessage.className = "message bot-message";
                        newMessage.textContent = response;
                        chatWindow.appendChild(newMessage);
                        
                        // 채팅창 스크롤을 최신 메시지로 이동
                        chatWindow.scrollTop = chatWindow.scrollHeight;
                    }
                }
            };
            xhr.send();
        }

        // 5초마다 새 메시지 확인
        setInterval(checkNewMessages, 1000);

    </script>
<!-- JSP file to handle storing the message in the database -->
<jsp:include page="storeMessage.jsp" />

</body>
</html>
