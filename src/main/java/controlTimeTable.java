import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

/**
 * Servlet implementation class controlTimeTable
 */

public class controlTimeTable extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String DB_URL = "jdbc:mysql://localhost:3306/ws_db";
    private static final String DB_USER = "wsp";
    private static final String DB_PASSWORD = "1234";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public controlTimeTable() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	 // 세션 가져오기
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("/ws_project/viewLogin.jsp");
            return;
        }
        int user_id = (int) session.getAttribute("user_id");
        Map<String, ArrayList<String>> timetable = new HashMap<>();
        String[] days = {"월", "화", "수", "목", "금"};
        
        // Map 초기화
        for (String day : days) {
            timetable.put(day, new ArrayList<>());
            for (int i = 0; i < 12; i++) {
                timetable.get(day).add("-");
            }
        }
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                String query = "SELECT day, lec_name, start_time, end_time FROM timetable WHERE user_id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setInt(1, user_id);
                    try (ResultSet rs = stmt.executeQuery()) {
                        while (rs.next()) {
                            String day = rs.getString("day");
                            String lecName = rs.getString("lec_name");
                            int startTime = rs.getInt("start_time");
                            int endTime = rs.getInt("end_time");
                            
                            for (int i = startTime - 1; i < endTime; i++) {
                                timetable.get(day).set(i, lecName);
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "시간표를 가져오는 도중 문제가 발생했습니다.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/error.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // JSP에 데이터 전달
        session.setAttribute("timetable", timetable);
        response.sendRedirect("/ws_project/viewTimeTable.jsp");
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
