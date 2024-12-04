

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet Filter implementation class sessionFilter
 */
//@WebFilter("*.jsp")
public class sessionFilter extends HttpFilter implements Filter {
       
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpFilter#HttpFilter()
     */
    public sessionFilter() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // 요청 URI 가져오기
        String uri = httpRequest.getRequestURI();

        // 특정 JSP 파일 제외 (예: login.jsp)
        if (uri.endsWith("viewLogin.jsp")||uri.endsWith("viewRegister.jsp")) {
            chain.doFilter(request, response); // 필터 적용 없이 다음 단계로 진행
            return;
        }

        // 세션 확인
        HttpSession session = httpRequest.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/viewLogin.jsp");
            return;
        }

        // 세션이 유효하면 요청 진행
        chain.doFilter(request, response);
    }

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

}
