

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

/**
 * Servlet implementation class controlUpdateNickname
 */
public class controlUpdateNickname extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:mysql://localhost:3306/ws_db";
    private static final String DB_USER = "wsp";
    private static final String DB_PASSWORD = "1234";
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("/ws_project/viewLogin.jsp");
            return;
        }
        String userId = (String) session.getAttribute("user_id").toString();
        String newNickname = request.getParameter("nickname");
        newNickname = newNickname.replaceAll("\\s+", "");

        // DB 연결 및 닉네임 업데이트 로직
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                String sql = "UPDATE users SET nickname = ? WHERE user_id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, newNickname);
                    stmt.setString(2, userId);
                    stmt.executeUpdate();
                    session.setAttribute("nickname", newNickname);
                    response.sendRedirect("viewMypage.jsp");
            
                }
            } 
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("mypage.jsp?error=Database error");
        }
    }
}