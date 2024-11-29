import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
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
		//ChromeDriver 설정
		ChromeOptions options = new ChromeOptions();
		options.addArguments("--headless"); // 브라우저 창을 표시하지 않음
		options.addArguments("--disable-blink-features=AutomationControlled"); // 자동화 감지 방지
		options.addArguments("user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6723.117 Safari/537.36"); // 사용자 에이전트 변경
		options.addArguments("--remote-allow-origins=*"); // 모든 Origin 허용
		
		// WebDriver
        System.setProperty("webdriver.chrome.driver", "C:\\tools\\chromedriver-win64\\chromedriver.exe");
        WebDriver driver = new ChromeDriver(options);

        try {
            driver.get("https://ibook.kpu.ac.kr/Viewer/menu02");
            
            // 페이지 로드 대기
            WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
            wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector("img.pageImage")));

            List<WebElement> imgElements = driver.findElements(By.cssSelector("img.pageImage"));
            
            // img 태그에서 src 속성 추출
            List<String> imgSrcList = new ArrayList<>();
            for (WebElement imgElement : imgElements) {
                imgSrcList.add(imgElement.getAttribute("src"));
            }

            // JSP forward
            request.setAttribute("imageSrcList", imgSrcList);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/viewMenu.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
        }finally {
            // WebDriver 종료
            driver.quit();
        }}
        
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
