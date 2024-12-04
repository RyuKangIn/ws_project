
import com.wsp.useclass.Post;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.util.*;

import com.wsp.useclass.Post;
/**
 * Servlet implementation class controlMypage
 */

public class controlMypage extends HttpServlet {
	private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/ws_db";
    private static final String DB_USER = "wsp";
    private static final String DB_PASSWORD = "1234";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public controlMypage() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 세션에서 user_id 가져오기
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("/ws_project/viewLogin.jsp");
            return;
        }

        int userId = (int) session.getAttribute("user_id");

        List<Map<String, String>> postsData = new ArrayList<>();
        String nickname = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                // 닉네임 가져오기
                String nicknameQuery = "SELECT nickname FROM users WHERE user_id = ?";
                try (PreparedStatement nicknameStmt = conn.prepareStatement(nicknameQuery)) {
                    nicknameStmt.setInt(1, userId);
                    try (ResultSet rs = nicknameStmt.executeQuery()) {
                        if (rs.next()) {
                            nickname = rs.getString("nickname");
                        }
                    }
                }

                // 게시물 제목 가져오기
                String postsQuery = "SELECT id, title FROM posts WHERE user_id = ? ORDER BY id DESC";
                try (PreparedStatement postsStmt = conn.prepareStatement(postsQuery)) {
                    postsStmt.setInt(1, userId);
                    try (ResultSet rs = postsStmt.executeQuery()) {
                        while (rs.next()) {
                            Map<String, String> post = new HashMap<>();
                            post.put("id", String.valueOf(rs.getInt("id")));
                            post.put("title", rs.getString("title"));
                        
                            postsData.add(post);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // JSP로 데이터 전달
        request.setAttribute("postsData", postsData);
        request.setAttribute("nickname", nickname);
        request.getRequestDispatcher("/viewMypage.jsp").forward(request, response);
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}

//Post 클래스 
//class Post {
// private int postId;
// private String title;
//
// public Post(int postId, String title) {
//     this.postId = postId;
//     this.title = title;
// }
//
// public int getPostId() {
//     return postId;
// }
//
// public String getTitle() {
//     return title;
// }
//}