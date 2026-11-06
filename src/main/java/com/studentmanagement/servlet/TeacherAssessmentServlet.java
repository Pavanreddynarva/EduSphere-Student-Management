package com.studentmanagement.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.studentmanagement.dao.StudentDAO;
import com.studentmanagement.dao.impl.StudentDAOImpl;
import com.studentmanagement.model.Student;
import com.studentmanagement.model.StudentAssessment;
import com.studentmanagement.model.TeacherAssignment;
import com.studentmanagement.service.AttendanceService;
import com.studentmanagement.service.StudentAssessmentService;
import com.studentmanagement.service.impl.AttendanceServiceImpl;
import com.studentmanagement.service.impl.StudentAssessmentServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/teacher/assessments")
public class TeacherAssessmentServlet extends HttpServlet {

    private AttendanceService attendanceService;
    private StudentAssessmentService assessmentService;
    private StudentDAO studentDAO;

    @Override
    public void init() {
        attendanceService = new AttendanceServiceImpl();
        assessmentService = new StudentAssessmentServiceImpl();
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

        int teacherId = (Integer) session.getAttribute("userId");
        loadPage(request, teacherId);
        request.getRequestDispatcher(
                "/WEB-INF/views/teacher/assessments.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int teacherId = (Integer) session.getAttribute("userId");

        try {
            StudentAssessment assessment = new StudentAssessment();

            assessment.setStudentId(
                    Integer.parseInt(request.getParameter("studentId"))
            );

            assessment.setAssignmentId(
                    Integer.parseInt(request.getParameter("assignmentId"))
            );

            assessment.setAssessmentName(
                    request.getParameter("assessmentName")
            );

            assessment.setAssessmentDate(
                    LocalDate.parse(request.getParameter("assessmentDate"))
            );

            assessment.setMarksObtained(
                    new BigDecimal(request.getParameter("marksObtained"))
            );

            assessment.setMaxMarks(
                    new BigDecimal(request.getParameter("maxMarks"))
            );

            boolean saved = assessmentService.recordAssessment(
                    teacherId, assessment
            );

            if (saved) {
                request.setAttribute(
                        "successMessage",
                        "Assessment recorded successfully!"
                );
            } else {
                request.setAttribute(
                        "errorMessage",
                        "Assessment could not be saved."
                );
            }

            request.setAttribute(
                    "selectedAssignmentId",
                    assessment.getAssignmentId()
            );

        } catch (NumberFormatException | java.time.format.DateTimeParseException e) {
            request.setAttribute(
                    "errorMessage",
                    "Please enter valid assessment details."
            );

        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());

        } catch (Exception e) {
            log("Unable to record assessment", e);
            request.setAttribute(
                    "errorMessage",
                    "Unable to record assessment. Please try again."
            );
        }

        loadPage(request, teacherId);

        request.getRequestDispatcher(
                "/WEB-INF/views/teacher/assessments.jsp"
        ).forward(request, response);
    }

    private void loadPage(HttpServletRequest request, int teacherId) {

        List<TeacherAssignment> assignments =
                attendanceService.getTeacherAssignments(teacherId);

        request.setAttribute("assignments", assignments);

        String selectedId = request.getParameter("assignmentId");

        if (selectedId == null) {
            Object savedId = request.getAttribute("selectedAssignmentId");
            if (savedId != null) {
                selectedId = savedId.toString();
            }
        }

        if (selectedId == null || selectedId.isBlank()) {
            return;
        }

        try {
            int assignmentId = Integer.parseInt(selectedId);

            TeacherAssignment selectedAssignment = null;

            for (TeacherAssignment assignment : assignments) {
                if (assignment.getAssignmentId() == assignmentId) {
                    selectedAssignment = assignment;
                    break;
                }
            }

            // Only allow assignments belonging to this teacher.
            if (selectedAssignment == null) {
                request.setAttribute(
                        "errorMessage",
                        "Invalid subject or class selection."
                );
                return;
            }

            request.setAttribute("selectedAssignmentId", assignmentId);

            List<Student> matchingStudents = new ArrayList<>();

            for (Student student : studentDAO.getAllStudents()) {
                if (student.getDepartment() != null
                        && student.getSection() != null
                        && student.getDepartment().equalsIgnoreCase(
                                selectedAssignment.getDepartment())
                        && student.getSection().equalsIgnoreCase(
                                selectedAssignment.getSection())
                        && student.getYearOfStudy()
                                == selectedAssignment.getYearOfStudy()) {

                    matchingStudents.add(student);
                }
            }

            request.setAttribute("students", matchingStudents);

            request.setAttribute(
                    "assessments",
                    assessmentService.getAssignmentAssessments(
                            teacherId, assignmentId
                    )
            );

        } catch (NumberFormatException e) {
            request.setAttribute(
                    "errorMessage",
                    "Invalid subject or class selection."
            );
        }
    }
}