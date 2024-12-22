package Filter;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class LogFileFilter implements Filter{
	PrintWriter writer;
	
	public void init(FilterConfig filterConfig) throws ServletException{
		String filename = filterConfig.getInitParameter("loginfile");
		if(filename==null) throw new ServletException("로그 파일을 찾을 수 없습니다");
		
		// 다른 파일로 
		try {
			writer = new PrintWriter(new FileWriter(filename, true), true); // true는 자동 버퍼 플러시 기능
		} catch (IOException e) {
			// TODO: handle exception
			throw new ServletException("로그 파일을 열 수 없습니다");
		}
	}
	
	private String getcurrentTime() {
		DateFormat format = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		Calendar calendar = Calendar.getInstance();
		calendar.setTimeInMillis(System.currentTimeMillis());
		return format.format(calendar.getTime());
	}
	
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws ServletException, IOException{
		writer.printf("현재일시 : %s %n", getcurrentTime());
		String clientAddress = request.getRemoteAddr();
		writer.printf("클라이언트 주소 : %s, %n",clientAddress);
		
		filterChain.doFilter(request, response);
		
		String contentType = response.getContentType();
		writer.printf("문서의 콘텐츠 유형 : %s, %n", contentType);
		writer.println("--------------------------------------------");
	}
	
	public void destroy() {
		writer.close();
	}

}
