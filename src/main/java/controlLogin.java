
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


public class controlLogin extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // DB 연결 정보
    private static final String DB_URL = "jdbc:mysql://localhost:3306/ws_db?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "alslvk123";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        boolean loginSuccess = false;

        // DB에서 아이디와 비밀번호 확인
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                String query = "SELECT user_id FROM users WHERE username = ? AND password = ?";
                try (PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setString(1, username);
                    stmt.setString(2, password);

                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            loginSuccess = true; // 로그인 성공
                            int userId = rs.getInt("user_id");
                            HttpSession session = request.getSession();
                            session.setAttribute("user_id", userId);
                            System.out.println("Session ID: " + session.getId());
                            System.out.println("User ID in session: " + session.getAttribute("user_id"));

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
