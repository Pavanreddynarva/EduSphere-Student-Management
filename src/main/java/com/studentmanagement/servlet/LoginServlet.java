
package com.studentmanagement.servlet;

import java.io.IOException;

import com.studentmanagement.model.User;
import com.studentmanagement.service.UserService;
import com.studentmanagement.service.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/login.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userService.authenticate(email, password);

        if (user == null) {
            request.setAttribute("error", "Invalid email or password.");

            request.getRequestDispatcher("/login.jsp")
                   .forward(request, response);

            return;
        }

        // Capture the original QR attendance URL before replacing the session
        HttpSession oldSession = request.getSession(false);

        String redirectAfterLogin = null;

        if (oldSession != null) {
            Object savedRedirect =
                    oldSession.getAttribute("redirectAfterLogin");

            if (savedRedirect instanceof String) {
                redirectAfterLogin = (String) savedRedirect;
            }

            oldSession.invalidate();
        }

        // Create authenticated session
        HttpSession session = request.getSession(true);

        session.setAttribute("userId", user.getUserId());
        session.setAttribute("fullName", user.getFullName());
        session.setAttribute("email", user.getEmail());
        session.setAttribute("role", user.getRole());

        session.setMaxInactiveInterval(20 * 60);

        // Restore original QR request only for students
        if ("STUDENT".equalsIgnoreCase(user.getRole())
                && redirectAfterLogin != null
                && redirectAfterLogin.startsWith("/student/attendance?token=")) {

            response.sendRedirect(
                    request.getContextPath() + redirectAfterLogin
            );

            return;
        }

        // Normal role-based navigation
        String role = user.getRole();

        if ("ADMIN".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath() + "/students"
            );

        } else if ("TEACHER".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath() + "/teacher/dashboard"
            );

        } else if ("STUDENT".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath() + "/student/dashboard"
            );

        } else {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
        }
    }
}
