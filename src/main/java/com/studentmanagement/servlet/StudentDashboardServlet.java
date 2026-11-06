package com.studentmanagement.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                request.getContextPath() + "/login"
            );
            return;
        }

        String fullName = (String) session.getAttribute("fullName");

        request.setAttribute("studentName", fullName);

        request.getRequestDispatcher(
            "/WEB-INF/views/student/student-dashboard.jsp"
        ).forward(request, response);
    }
}