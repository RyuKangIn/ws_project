import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.sql.*;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;



public class controlMenu extends HttpServlet {
	private static final long serialVersionUID = -7872938454139186415L;
	
	public controlMenu() {
        super();
        // TODO Auto-generated constructor stub
    }
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		List<String> imgSrcList = updateMenu();
		
		request.setAttribute("imageSrcList", imgSrcList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/viewMenu.jsp");
        dispatcher.forward(request, response);
		
        }
        
	private List<String> updateMenu() {
        String dbUrl = "jdbc:mysql://localhost:3306/ws_db";
        String username = "root";
        String password = "alslvk123";

        try (Connection conn = DriverManager.getConnection(dbUrl, username, password)) {
            
        	// Step 1: Check last updated time
        	String checkSql = "SELECT last_updated FROM menu ORDER BY id LIMIT 1";
        	PreparedStatement checkStmt = conn.prepareStatement(checkSql);
        	ResultSet rs = checkStmt.executeQuery();

        	boolean needsUpdate = true; // 기본적으로 업데이트가 필요하다고 설정
        	if (rs.next()) {
        	    Timestamp lastUpdated = rs.getTimestamp("last_updated");
        	    
        	    // Null 여부 확인
        	    if (lastUpdated != null) {
        	        LocalDateTime lastUpdateTime = lastUpdated.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();

        	        // Check if last update was within this week (Monday 11:00 AM)
        	        LocalDateTime now = LocalDateTime.now();
        	        LocalDateTime lastMonday = now.withHour(11).withMinute(0).withSecond(0).withNano(0)
        	                .with(java.time.temporal.TemporalAdjusters.previousOrSame(java.time.DayOfWeek.MONDAY));

        	        // lastUpdateTime과 비교하여 업데이트 여부 결정
        	        needsUpdate = lastUpdateTime.isBefore(lastMonday);
        	    }
        	}

        
            // Step 2: Update
            if (needsUpdate) {
                List<String> imgSrcList = crawlMenuImages();
                if (imgSrcList != null && !imgSrcList.isEmpty()) {
                    // Clear and update DB
                    String deleteSql = "DELETE FROM menu";
                    String insertSql = "INSERT INTO menu(src) VALUES (?)";

                    PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                    deleteStmt.executeUpdate();

                    PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                    for (String src : imgSrcList) {
                        insertStmt.setString(1, src);
                        insertStmt.executeUpdate();
                    }
                }
            }

            // Step 3: Fetch images from DB
            String fetchSql = "SELECT src FROM menu ORDER BY id";
            PreparedStatement fetchStmt = conn.prepareStatement(fetchSql);
            ResultSet fetchRs = fetchStmt.executeQuery();

            List<String> imgSrcList = new ArrayList<>();
            while (fetchRs.next()) {
                imgSrcList.add(fetchRs.getString("src"));
            }

            return imgSrcList;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
	
	private List<String> crawlMenuImages() {
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless", "--disable-blink-features=AutomationControlled");
        options.addArguments("user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.117 Safari/537.36"); // 사용자 에이전트 변경
		options.addArguments("--remote-allow-origins=*"); // 모든 Origin 허용
		System.setProperty("webdriver.chrome.driver", "C:\\tools\\chromedriver-win64\\chromedriver.exe");
        WebDriver driver = new ChromeDriver(options);

        List<String> imgSrcList = new ArrayList<>();
        try {
            driver.get("https://ibook.kpu.ac.kr/Viewer/menu02");

            WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
            wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector("img.pageImage")));

            List<WebElement> imgElements = driver.findElements(By.cssSelector("img.pageImage"));
            for (WebElement img : imgElements) {
                imgSrcList.add(img.getAttribute("src"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            driver.quit();
        }

        return imgSrcList;
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
