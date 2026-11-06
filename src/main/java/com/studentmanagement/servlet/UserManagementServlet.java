
package com.studentmanagement.servlet;

import java.io.IOException;
import java.util.List;

import com.studentmanagement.model.User;
import com.studentmanagement.service.UserService;
import com.studentmanagement.service.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/admin/users", "/admin/users/role"})
public class UserManagementServlet extends HttpServlet {

    private final UserService userService = new UserServiceImpl();

    // Display all registered users
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<User> users = userService.getAllUsers();

        request.setAttribute("users", users);

        request.getRequestDispatcher(
                "/WEB-INF/views/admin/users.jsp")
                .forward(request, response);
    }

    // Create users or change their roles
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if (path.equals("/admin/users/role")) {
            changeUserRole(request);
        } else {
            createUser(request);
        }

        // Reload registered users after the operation
        List<User> users = userService.getAllUsers();

        request.setAttribute("users", users);

        request.getRequestDispatcher(
                "/WEB-INF/views/admin/users.jsp")
                .forward(request, response);
    }

    // Create a Teacher or Student account
    private void createUser(HttpServletRequest request) {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        User user = new User();

        user.setFullName(fullName);
        user.setEmail(email);
        user.setRole(role);

        boolean created = userService.createUser(user, password);

        if (created) {
            request.setAttribute(
                    "success",
                    "User account created successfully!");
        } else {
            request.setAttribute(
                    "error",
                    "Unable to create user. Check the details, password length, role, or duplicate email.");
        }
    }

    // Change an existing user's role
    private void changeUserRole(HttpServletRequest request) {

        try {
            int userId = Integer.parseInt(
                    request.getParameter("userId"));

            String role = request.getParameter("role");

            boolean updated =
                    userService.changeUserRole(userId, role);

            if (updated) {
                request.setAttribute(
                        "success",
                        "User role updated successfully!");
            } else {
                request.setAttribute(
                        "error",
                        "Unable to update role. Admin accounts cannot be modified.");
            }

        } catch (NumberFormatException e) {

            request.setAttribute(
                    "error",
                    "Invalid user ID.");
        }
    }
}
