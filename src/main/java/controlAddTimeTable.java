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
    private static final String DB_URL = "jdbc:mysql://localhost:3306/ws_db";
    private static final String DB_USER = "wsp";
    private static final String DB_PASSWORD = "1234";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 세션 가져오기
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("/ws_project/viewLogin.jsp");
            return;
        }
        int userId = (int) session.getAttribute("user_id");

        // 요청 파라미터 처리
        String lec_name = request.getParameter("lec_name"); // 강의명
        String day = request.getParameter("day");           // 요일
        String startParam = request.getParameter("start");
        String endParam = request.getParameter("end");
        
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (lec_name == null || lec_name.trim().isEmpty()) {
            response.getWriter().write("<script>alert('과목명을 입력하세요.'); history.back();</script>");
            return;
        }
        
        int start, end;
        try {
            start = Integer.parseInt(startParam);
            end = Integer.parseInt(endParam);
        } catch (NumberFormatException e) {
            response.getWriter().write("<script>alert('유효한 시간을 입력하세요.'); history.back();</script>");
            return;
        }

        if (start > end) {
            response.getWriter().write("<script>alert('시작 시간이 종료 시간보다 클 수 없습니다.'); history.back();</script>");
            return;
        }

        // 세션에서 사용자 시간표 가져오기
        @SuppressWarnings("unchecked")
        Map<String, ArrayList<String>> userTimetable = (Map<String, ArrayList<String>>) session.getAttribute("timetable");
        if (userTimetable == null) {
            response.getWriter().write("<script>alert('시간표 정보를 로드할 수 없습니다. 다시 로그인하세요.'); history.back();</script>");
            return;
        }

        ArrayList<String> dayTable = userTimetable.get(day);

        // 2. 해당 시간에 이미 과목 존재
        for (int i = start - 1; i <= end - 1; i++) {
            if (!dayTable.get(i).equals("-")) {
                response.getWriter().write("<script>alert('해당 시간에 이미 과목이 존재합니다.'); history.back();</script>");
                return;
            }
        }

        // 4. 해당 요일에 이미 같은 과목 존재
        if (dayTable.contains(lec_name)) {
            response.getWriter().write("<script>alert('해당 요일에 이미 같은 과목이 존재합니다.'); history.back();</script>");
            return;
        }

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

        // 시간표 업데이트
        for (int i = start - 1; i <= end - 1; i++) {
            dayTable.set(i, lec_name);
        }

        // 업데이트된 시간표를 세션에 다시 저장
        session.setAttribute("timetable", userTimetable);

        // 시간표 페이지로 리다이렉트
        response.sendRedirect("/ws_project/viewTimeTable.jsp");
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response); // GET 요청을 POST 메서드로 위임
    }
	
}
