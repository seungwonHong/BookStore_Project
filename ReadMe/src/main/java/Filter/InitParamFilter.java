package Filter;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class InitParamFilter implements Filter{
	private FilterConfig filterConfig = null;
	
	public void init(FilterConfig filterConfig) throws ServletException{
		System.out.println("Filter02 초기화...");
		this.filterConfig = filterConfig; // 초기화되면서 xml 파일에 있는 정보를 객체로 받아서 변수에 저장한다
	}
	
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException{
		System.out.println("Filter02 수행...");
		
		String id = request.getParameter("id");
		String password = request.getParameter("password");
		
		String param1 = filterConfig.getInitParameter("param1");
		String param2 = filterConfig.getInitParameter("param2");
		
		String message;
		
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset = UTF-8");
		PrintWriter writer = response.getWriter();
		
		if (id.equals(param1) && password.equals(param2)) {
			message = "로그인에 성공했습니다";
		}else {
			message = "로그인에 실패했습니다";
		}
		
		writer.print(message);
		
		filterChain.doFilter(request, response);
	}
	
	public void destroy() {
		System.out.println("Filter02 해제");
	}

}
