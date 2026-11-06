
package com.studentmanagement.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(jakarta.servlet.ServletRequest request,
                         jakarta.servlet.ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getRequestURI()
                .substring(httpRequest.getContextPath().length());

        // Allow login page and static resources
        if (path.equals("/login")
                || path.equals("/login.jsp")
                || path.startsWith("/css/")
                || path.startsWith("/js/")) {

            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {

            // Preserve the original requested URL, including QR token
            HttpSession newSession = httpRequest.getSession(true);

            String originalUrl = path;

            String queryString = httpRequest.getQueryString();

            if (queryString != null && !queryString.isEmpty()) {
                originalUrl += "?" + queryString;
            }

            newSession.setAttribute(
                    "redirectAfterLogin",
                    originalUrl
            );

            httpResponse.sendRedirect(
                    httpRequest.getContextPath() + "/login"
            );

            return;
        }

        // Prevent browser from displaying protected pages after logout
        httpResponse.setHeader(
                "Cache-Control",
                "no-cache, no-store, must-revalidate"
        );
        httpResponse.setHeader("Pragma", "no-cache");
        httpResponse.setDateHeader("Expires", 0);

        chain.doFilter(request, response);
    }
}
