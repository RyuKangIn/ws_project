//import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.*;

public class controlAddTimeTable extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 세션 가져오기
        HttpSession session = request.getSession();

        // 사용자별 시간표 가져오기 (없으면 새로 생성)
        @SuppressWarnings("unchecked")
        Map<String, String[]> userTimetable = (Map<String, String[]>) session.getAttribute("timetable");
        if (userTimetable == null) {
            userTimetable = new LinkedHashMap<>();
            for (String day : new String[]{"월", "화", "수", "목", "금"}) {
                userTimetable.put(day, new String[12]); // 12교시 초기화
            }
            session.setAttribute("timetable", userTimetable); // 세션에 저장
        }

        // 요청 파라미터 처리
        String lec_name = request.getParameter("lec_name"); // 강의명
        String day = request.getParameter("day");           // 요일
        int start = Integer.parseInt(request.getParameter("start")); // 시작 교시
        int end = Integer.parseInt(request.getParameter("end"));     // 끝 교시

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

	/*
	 * @Override protected void doGet(HttpServletRequest request,
	 * HttpServletResponse response) throws ServletException, IOException { // 세션
	 * 가져오기 HttpSession session = request.getSession();
	 * 
	 * // 사용자별 시간표 가져오기
	 * 
	 * @SuppressWarnings("unchecked") Map<String, String[]> userTimetable =
	 * (Map<String, String[]>) session.getAttribute("timetable");
	 * 
	 * // 시간표가 없으면 초기화 if (userTimetable == null) { userTimetable = new
	 * LinkedHashMap<>(); for (String day : new String[]{"월", "화", "수", "목", "금"}) {
	 * userTimetable.put(day, new String[12]); } session.setAttribute("timetable",
	 * userTimetable); }
	 * 
	 * // JSP로 시간표 데이터 전달 request.setAttribute("timetable", userTimetable);
	 * 
	 * // JSP로 포워드 RequestDispatcher dispatcher =
	 * request.getRequestDispatcher("/ws_proj/viewTimeTable.jsp");
	 * dispatcher.forward(request, response); }
	 */
}
