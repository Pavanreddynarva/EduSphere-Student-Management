
package com.studentmanagement.servlet;

import java.io.IOException;
import java.util.List;

import com.studentmanagement.dao.StudentDAO;
import com.studentmanagement.dao.impl.StudentDAOImpl;
import com.studentmanagement.model.AttendanceRecord;
import com.studentmanagement.model.Student;
import com.studentmanagement.service.AttendanceService;
import com.studentmanagement.service.impl.AttendanceServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {
        "/student/attendance",
        "/student/attendance/history"
})
public class StudentAttendanceServlet extends HttpServlet {

    private AttendanceService attendanceService;
    private StudentDAO studentDAO;

    @Override
    public void init() {
        attendanceService = new AttendanceServiceImpl();
        studentDAO = new StudentDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");

        if (!"STUDENT".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String path = request.getServletPath();

        // My Attendance: display the logged-in student's history
        if ("/student/attendance/history".equals(path)) {
            showAttendanceHistory(request, response, session);
            return;
        }

        // QR attendance: preserve the existing token-based functionality
        markQrAttendance(request, response, session);
    }

    private void markQrAttendance(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws ServletException, IOException {

        String studentEmail = (String) session.getAttribute("email");
        String token = request.getParameter("token");

        String result;

        if (studentEmail == null || studentEmail.isBlank()) {
            result = "Student login information not found. Please log in again.";
        } else if (token == null || token.isBlank()) {
            result = "Invalid QR code. No attendance token was provided.";
        } else {
            result = attendanceService.markStudentAttendance(
                    token, studentEmail);
        }

        request.setAttribute("attendanceMessage", result);

        request.getRequestDispatcher(
                "/WEB-INF/views/student/attendance-result.jsp")
                .forward(request, response);
    }

    private void showAttendanceHistory(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws ServletException, IOException {

        String studentEmail = (String) session.getAttribute("email");

        if (studentEmail == null || studentEmail.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Student student = studentDAO.getAllStudents()
                .stream()
                .filter(s -> s.getEmail() != null
                        && s.getEmail().equalsIgnoreCase(studentEmail))
                .findFirst()
                .orElse(null);

        if (student == null) {
            request.setAttribute("error",
                    "Your student record could not be found.");
            request.getRequestDispatcher(
                    "/WEB-INF/views/student/attendance-history.jsp")
                    .forward(request, response);
            return;
        }

        List<AttendanceRecord> records =
                attendanceService.getStudentAttendance(student.getStudentId());

        long presentCount = records.stream()
                .filter(r -> "PRESENT".equalsIgnoreCase(r.getStatus()))
                .count();

        long absentCount = records.stream()
                .filter(r -> "ABSENT".equalsIgnoreCase(r.getStatus()))
                .count();

        double attendancePercentage = records.isEmpty()
                ? 0.0
                : (presentCount * 100.0) / records.size();

        request.setAttribute("studentName", student.getFullName());
        request.setAttribute("attendanceRecords", records);
        request.setAttribute("totalRecords", records.size());
        request.setAttribute("presentCount", presentCount);
        request.setAttribute("absentCount", absentCount);
        request.setAttribute("attendancePercentage",
                String.format("%.2f", attendancePercentage));

        request.getRequestDispatcher(
                "/WEB-INF/views/student/attendance-history.jsp")
                .forward(request, response);
    }
}
