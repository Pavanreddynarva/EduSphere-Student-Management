
package com.studentmanagement.servlet;

import java.io.IOException;

import com.studentmanagement.service.UserService;
import com.studentmanagement.service.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private final UserService userService = new UserServiceImpl();

    private static final String VIEW =
            "/WEB-INF/views/change-password.jsp";

    // Display the Change Password page
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher(VIEW)
               .forward(request, response);
    }

    // Process password change
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String email = (String) session.getAttribute("email");

        String currentPassword =
                request.getParameter("currentPassword");

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");

        if (email == null || email.isBlank()
                || currentPassword == null || currentPassword.isEmpty()
                || newPassword == null || newPassword.isEmpty()
                || confirmPassword == null || confirmPassword.isEmpty()) {

            showError(request, response,
                    "All password fields are required.");
            return;
        }

        if (newPassword.length() < 8) {
            showError(request, response,
                    "New password must contain at least 8 characters.");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            showError(request, response,
                    "New password and confirm password do not match.");
            return;
        }

        boolean changed = userService.changePassword(
                email, currentPassword, newPassword);

        if (!changed) {
            showError(request, response,
                    "Current password is incorrect, or the new password is the same as your current password.");
            return;
        }

        String role = (String) session.getAttribute("role");

        request.getSession().setAttribute(
                "passwordChangeSuccess",
                "Your password has been changed successfully."
        );

        // Return to the correct role dashboard
        if ("ADMIN".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath() + "/students");

        } else if ("TEACHER".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath() + "/teacher/dashboard");

        } else if ("STUDENT".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath() + "/student/dashboard");

        } else {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath() + "/login");
        }
    }

    private void showError(HttpServletRequest request,
                           HttpServletResponse response,
                           String error)
            throws ServletException, IOException {

        request.setAttribute("error", error);

        request.getRequestDispatcher(VIEW)
               .forward(request, response);
    }
}
