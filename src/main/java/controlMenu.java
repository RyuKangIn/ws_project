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
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            checkAndUpdateMenu();

            // 업데이트 후 바로 viewMenu.jsp로 포워드
            RequestDispatcher dispatcher = request.getRequestDispatcher("/viewMenu.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "메뉴 처리 중 오류가 발생했습니다.");
        }
    }

    private boolean checkAndUpdateMenu() throws Exception {
        String dbUrl = "jdbc:mysql://localhost:3306/ws_db";
        String username = "wsp";
        String password = "1234";

        boolean needsUpdate = false;

        try (Connection conn = DriverManager.getConnection(dbUrl, username, password)) {
            // Step 1: Check last updated time
            String checkSql = "SELECT last_updated FROM menu ORDER BY id LIMIT 1";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                 ResultSet rs = checkStmt.executeQuery()) {

                if (rs.next()) {
                    Timestamp lastUpdated = rs.getTimestamp("last_updated");
                    if (lastUpdated != null) {
                        LocalDateTime lastUpdateTime = lastUpdated.toInstant()
                                .atZone(ZoneId.systemDefault())
                                .toLocalDateTime();

                        LocalDateTime now = LocalDateTime.now();
                        LocalDateTime lastMonday = now.withHour(11).withMinute(0).withSecond(0).withNano(0)
                                .with(java.time.temporal.TemporalAdjusters.previousOrSame(java.time.DayOfWeek.MONDAY));

                        // 업데이트 여부 판단
                        needsUpdate = lastUpdateTime.isBefore(lastMonday);
                    } else {
                        needsUpdate = true; // last_updated가 null일 경우 업데이트 필요
                    }
                } else {
                    needsUpdate = true; // 테이블에 데이터가 없으면 업데이트 필요
                }
            }

            // Step 2: Update if needed
            if (needsUpdate) {
                List<String> imgSrcList = crawlMenuImages();
                if (imgSrcList != null && !imgSrcList.isEmpty()) {
                    String deleteSql = "DELETE FROM menu";
                    String insertSql = "INSERT INTO menu(src) VALUES (?)";

                    try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                        deleteStmt.executeUpdate();
                    }

                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                        for (String src : imgSrcList) {
                            insertStmt.setString(1, src);
                            insertStmt.executeUpdate();
                        }
                    }
                }
            }
        }

        return needsUpdate;
    }

    private List<String> crawlMenuImages() {
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless", "--disable-blink-features=AutomationControlled");
        options.addArguments("user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.117 Safari/537.36");
        options.addArguments("--remote-allow-origins=*");
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
