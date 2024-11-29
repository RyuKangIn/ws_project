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
import java.util.Arrays;
import java.util.List;
/**
 * Servlet implementation class controlTimeTable
 */

public class controlTimeTable extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String DB_URL = "jdbc:mysql://localhost:3306/jspdb?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "alslvk123";
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
		HttpSession session = request.getSession(false);
		String user_id = (String)session.getAttribute("user_id");
		List<String> days = Arrays.asList("월", "화", "수", "목", "금");
        
		try {
        	Class.forName("com.mysql.cj.jdbc.Driver");
        	try(Connection conn = DriverManager.getConnection(DB_URL,DB_USER,DB_PASSWORD)){
        		String query = "select * from timetable where userid = ?";
        		try(PreparedStatement stmt = conn.prepareStatement(query)){
        			stmt.setString(1, user_id);
        			}
        		}
        	
        }catch() {
        	
        }
        
		RequestDispatcher dispatcher = request.getRequestDispatcher("/viewTimeTable.jsp");
        dispatcher.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
