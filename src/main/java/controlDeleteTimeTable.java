

import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.*;
import java.io.IOException;
import java.sql.*;
;/**
 * Servlet implementation class controlDeleteTimeTable
 */
public class controlDeleteTimeTable extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/ws_db";
    private static final String DB_USER = "wsp";
    private static final String DB_PASSWORD = "1234";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("/ws_project/viewLogin.jsp");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String day = request.getParameter("day");
        String lecName = request.getParameter("lec_name"); // 과목명

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                // 데이터베이스에서 연속된 시간을 삭제
                String query = "DELETE FROM timetable WHERE user_id = ? AND day = ? AND lec_name = ?";
                try (PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setInt(1, userId);
                    stmt.setString(2, day);
                    stmt.setString(3, lecName);
                    stmt.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("<script>alert('시간표 삭제 중 오류가 발생했습니다.'); history.back();</script>");
            return;
        }

        // 세션의 시간표 데이터 업데이트
        @SuppressWarnings("unchecked")
        Map<String, ArrayList<String>> userTimetable = (Map<String, ArrayList<String>>) session.getAttribute("timetable");

        if (userTimetable != null) {
            ArrayList<String> dayTable = userTimetable.get(day);
            if (dayTable != null) {
                for (int i = 0; i < dayTable.size(); i++) {
                    if (lecName.equals(dayTable.get(i))) {
                        dayTable.set(i, "-"); // 연속된 시간 삭제
                    }
                }
            }
        }

        session.setAttribute("timetable", userTimetable);
        response.sendRedirect("/ws_project/viewTimeTable.jsp");
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 기존에 작성된 코드를 여기에 추가
        doPost(request, response); // GET 요청을 POST 메서드로 위임 가능
    }
}