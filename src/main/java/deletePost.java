import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/deletePost.java")
public class deletePost extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String dbURL = "jdbc:mysql://localhost:3306/ws_db";
        String dbUser = "wsp";
        String dbPassword = "1234";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            String sessionUserId = request.getParameter("user_id");
            String postId = request.getParameter("post_id");

            // 유효성 검사
            if (sessionUserId == null || sessionUserId.isEmpty() || postId == null || postId.isEmpty()) {
                response.getWriter().println("<script>alert('잘못된 요청입니다.'); history.back();</script>");
                return;
            }

            // JDBC를 사용하여 데이터베이스 연결 및 삭제 처리
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            String query = "DELETE FROM posts WHERE id = ? AND user_id = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, Integer.parseInt(postId));
            stmt.setString(2, sessionUserId);

            int rows = stmt.executeUpdate();

            if (rows > 0) {
                // 삭제 성공 시, 게시글 목록 페이지로 리디렉션
                response.sendRedirect("content_list.jsp");
            } else {
                // 삭제 실패 시 경고 메시지 출력
                response.getWriter().println("<script>alert('게시글 삭제 권한이 없습니다.'); history.back();</script>");
            }
        } catch (NumberFormatException e) {
            response.getWriter().println("<script>alert('잘못된 게시글 ID 형식입니다.'); history.back();</script>");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('오류가 발생했습니다. 잠시 후 다시 시도해주세요.'); history.back();</script>");
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}
