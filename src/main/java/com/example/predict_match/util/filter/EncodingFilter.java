package com.example.predict_match.util.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.logging.Logger;

public class EncodingFilter implements Filter {
    private final Logger logger = Logger.getLogger(EncodingFilter.class.getName());
    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException, IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getRequestURI();
        if (path.contains("/matches/predict")) {
            // API 요청의 경우 필터를 적용하지 않고 그대로 통과
            chain.doFilter(req, resp);
            return;
        }

        response.setContentType("text/html;charset=UTF-8");
        chain.doFilter(req, resp);
    }
}
