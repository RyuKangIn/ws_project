import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class controlRegister extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 데이터베이스 연결 정보
    private static final String DB_URL = "jdbc:mysql://localhost:3306/ws_db"; // 데이터베이스 이름 변경
    private static final String DB_USER = "root";                                   // 사용자 이름
    private static final String DB_PASSWORD = "alslvk123";                          // 비밀번호

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 요청 파라미터 가져오기
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String nickname = request.getParameter("nickname");

        // 입력값 유효성 검사
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty() || 
            nickname == null || nickname.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("All fields are required.");
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 데이터베이스에 사용자 정보 삽입
            String query = "INSERT INTO users (username, password, nickname) VALUES (?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, username);
                stmt.setString(2, password); // 비밀번호는 암호화해서 저장하는 것이 권장됩니다.
                stmt.setString(3, nickname);
                stmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error occurred while registering user.");
            return;
        }

        // 성공적으로 저장되면 a.jsp로 리다이렉트
        response.sendRedirect("/ws_project/registerSucess.html");
    }
}

