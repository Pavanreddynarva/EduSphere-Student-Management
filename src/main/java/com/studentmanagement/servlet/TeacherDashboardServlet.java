
package com.studentmanagement.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/teacher/dashboard")
public class TeacherDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check whether a session exists
        if (session == null) {
            response.sendRedirect(
                request.getContextPath() + "/login"
            );
            return;
        }

        // Get Teacher details from session
        String fullName = (String) session.getAttribute("fullName");

        request.setAttribute("teacherName", fullName);

        // Forward to Teacher dashboard JSP
        request.getRequestDispatcher(
            "/WEB-INF/views/teacher/teacher-dashboard.jsp"
        ).forward(request, response);
    }
}
