package com.studentmanagement.servlet;

import java.io.IOException;
import java.util.List;
import com.studentmanagement.dao.StudentDAO;
import com.studentmanagement.dao.impl.StudentDAOImpl;
import com.studentmanagement.model.Student;
import com.studentmanagement.model.StudentAssessment;
import com.studentmanagement.service.StudentAssessmentService;
import com.studentmanagement.service.impl.StudentAssessmentServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/student/grade-simulator")
public class GradeSimulatorServlet extends HttpServlet {
    private StudentDAO studentDAO;
    private StudentAssessmentService assessmentService;

    @Override
    public void init() {
        studentDAO = new StudentDAOImpl();
        assessmentService = new StudentAssessmentServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"STUDENT".equals(session.getAttribute("role"))
                || session.getAttribute("email") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String email = (String) session.getAttribute("email");
        try {
            Student loggedInStudent = null;
            for (Student student : studentDAO.getAllStudents()) {
                if (student.getEmail() != null && student.getEmail().equalsIgnoreCase(email)) {
                    loggedInStudent = student;
                    break;
                }
            }

            if (loggedInStudent == null) {
                request.setAttribute("errorMessage", "Your student profile could not be found.");
            } else {
                // READ ONLY: retrieve this student's existing official assessments.
                // No assessment save/update/delete method is called in this servlet.
                List<StudentAssessment> officialAssessments =
                        assessmentService.getStudentAssessmentHistory(loggedInStudent.getStudentId());
                request.setAttribute("officialAssessments", officialAssessments);
            }
        } catch (Exception e) {
            log("Unable to load grade simulator data", e);
            request.setAttribute("errorMessage",
                    "Unable to load your official assessment data right now.");
        }

        request.getRequestDispatcher("/WEB-INF/views/student/grade-simulator.jsp")
                .forward(request, response);
    }
}
