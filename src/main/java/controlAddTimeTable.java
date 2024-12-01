//import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.util.*;

public class controlAddTimeTable extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // DB 연결 정보
    private static final String DB_URL = "jdbc:mysql://localhost:3306/ws_db?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "alslvk123";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 세션 가져오기
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("user_id");
        
        // 요청 파라미터 처리
        String lec_name = request.getParameter("lec_name"); // 강의명
        String day = request.getParameter("day");           // 요일
        int start = Integer.parseInt(request.getParameter("start")); // 시작 교시
        int end = Integer.parseInt(request.getParameter("end"));     // 끝 교시
        
        // 시간표를 DB에 추가
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                String query = "INSERT INTO timetable (user_id, lec_name, day, start_time, end_time) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setInt(1, userId);
                    stmt.setString(2, lec_name);
                    stmt.setString(3, day);
                    stmt.setInt(4, start);
                    stmt.setInt(5, end);

                    stmt.executeUpdate(); // 데이터베이스에 삽입
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("<script>alert('시간표 추가 중 오류가 발생했습니다.'); history.back();</script>");
            return;
        }
        
        // 사용자별 시간표 가져오기 (없으면 새로 생성)
        @SuppressWarnings("unchecked")
        Map<String, String[]> userTimetable = (Map<String, String[]>) session.getAttribute("timetable");
        if (userTimetable == null) {
            userTimetable = new LinkedHashMap<>();
            for (String days : new String[]{"월", "화", "수", "목", "금"}) {
                userTimetable.put(days, new String[12]); // 12교시 초기화
            }
            session.setAttribute("timetable", userTimetable); // 세션에 저장
        }

        

        // 시간표 업데이트
        String[] dayTable = userTimetable.get(day);
        for (int i = start - 1; i <= end - 1; i++) {
            dayTable[i] = lec_name;
        }

        // 업데이트된 시간표를 세션에 다시 저장
        session.setAttribute("timetable", userTimetable);

        // 시간표 페이지로 리다이렉트
        response.sendRedirect("/ws_project/timetable");
    }

	
}
