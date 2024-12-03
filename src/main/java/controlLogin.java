
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt; // BCrypt 라이브러리 추가

public class controlLogin extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // DB 연결 정보
    private static final String DB_URL = "jdbc:mysql://localhost:3306/ws_db";
    private static final String DB_USER = "wsp";
    private static final String DB_PASSWORD = "1234";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        boolean loginSuccess = false;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                // 사용자 이름으로 암호화된 비밀번호 조회
                String query = "SELECT user_id, password FROM users WHERE username = ?";
                try (PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setString(1, username);

                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            int userId = rs.getInt("user_id");
                            String storedHashedPassword = rs.getString("password");

                            // 사용자가 입력한 비밀번호와 데이터베이스의 해시된 비밀번호 비교
                            if (BCrypt.checkpw(password, storedHashedPassword)) {
                                loginSuccess = true;

                                // 세션 생성 및 사용자 정보 저장
                                HttpSession session = request.getSession();
                                session.setAttribute("user_id", userId);
                                System.out.println("Session ID: " + session.getId());
                                System.out.println("User ID in session: " + session.getAttribute("user_id"));
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Internal Server Error");
            return;
        }

        // 로그인 성공 여부에 따른 처리
        if (loginSuccess) {
            response.sendRedirect("/ws_project/main.jsp"); 
        } else {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('아이디 또는 비밀번호를 다시 확인해주세요.'); history.back();</script>");
        }
    }
}