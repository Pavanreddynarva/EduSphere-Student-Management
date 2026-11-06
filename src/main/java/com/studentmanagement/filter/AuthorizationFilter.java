
package com.studentmanagement.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AuthorizationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getRequestURI()
                .substring(httpRequest.getContextPath().length());

        // Public pages and static resources
        if (path.equals("/login")
                || path.equals("/login.jsp")
                || path.startsWith("/css/")
                || path.startsWith("/js/")) {

            chain.doFilter(request, response);
            return;
        }

        // Get the existing session
        HttpSession session = httpRequest.getSession(false);

        // Handle unauthenticated users safely
        if (session == null || session.getAttribute("userId") == null) {
            httpResponse.sendRedirect(
                    httpRequest.getContextPath() + "/login"
            );
            return;
        }

        // Get the logged-in user's role
        String role = (String) session.getAttribute("role");

        // Determine the required role for this URL
        String requiredRole = null;

        if (path.equals("/students")
                || path.equals("/students.jsp")
                || path.equals("/admin")
                || path.startsWith("/admin/")) {

            requiredRole = "ADMIN";

        } else if (path.equals("/teacher")
                || path.startsWith("/teacher/")) {

            requiredRole = "TEACHER";

        } else if (path.equals("/student")
                || path.startsWith("/student/")) {

            requiredRole = "STUDENT";
        }

        // Check whether the user has the required role
        if (requiredRole != null
                && !requiredRole.equalsIgnoreCase(role)) {

            httpResponse.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You do not have permission to access this resource."
            );
            return;
        }

        chain.doFilter(request, response);
    }
}
