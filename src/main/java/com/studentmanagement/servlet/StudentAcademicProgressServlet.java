
package com.studentmanagement.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.studentmanagement.dao.AttendanceDAO;
import com.studentmanagement.dao.StudentDAO;
import com.studentmanagement.dao.impl.AttendanceDAOImpl;
import com.studentmanagement.dao.impl.StudentDAOImpl;
import com.studentmanagement.model.Student;
import com.studentmanagement.model.StudentAssessment;
import com.studentmanagement.model.TeacherAssignment;
import com.studentmanagement.model.AcademicRisk;
import com.studentmanagement.service.AcademicRiskService;
import com.studentmanagement.service.impl.AcademicRiskServiceImpl;
import com.studentmanagement.service.StudentAssessmentService;
import com.studentmanagement.service.impl.StudentAssessmentServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/student/academic-progress")
public class StudentAcademicProgressServlet extends HttpServlet {

    private StudentDAO studentDAO;
    private AttendanceDAO attendanceDAO;
    private StudentAssessmentService assessmentService;
    private AcademicRiskService academicRiskService;

    @Override
    public void init() {
        studentDAO = new StudentDAOImpl();
        attendanceDAO = new AttendanceDAOImpl();
        assessmentService = new StudentAssessmentServiceImpl();
        academicRiskService = new AcademicRiskServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || !"STUDENT".equals(session.getAttribute("role"))
                || session.getAttribute("email") == null) {

            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String email = (String) session.getAttribute("email");

        try {
            Student loggedInStudent = null;

            for (Student student : studentDAO.getAllStudents()) {
                if (student.getEmail() != null
                        && student.getEmail().equalsIgnoreCase(email)) {
                    loggedInStudent = student;
                    break;
                }
            }

            if (loggedInStudent == null) {
                request.setAttribute(
                        "errorMessage",
                        "Your student profile could not be found."
                );
                request.getRequestDispatcher(
                        "/WEB-INF/views/student/academic-progress.jsp"
                ).forward(request, response);
                return;
            }

            List<StudentAssessment> history =
                    assessmentService.getStudentAssessmentHistory(
                            loggedInStudent.getStudentId()
                    );

            Map<String, AverageData> monthlyData =
                    new LinkedHashMap<>();

            List<ProgressRow> progressRows = new ArrayList<>();

            BigDecimal totalObtained = BigDecimal.ZERO;
            BigDecimal totalMaximum = BigDecimal.ZERO;

            for (StudentAssessment assessment : history) {

                TeacherAssignment assignment = attendanceDAO
                        .getAssignmentById(assessment.getAssignmentId())
                        .orElse(null);

                String subject = assignment == null
                        ? "Unknown Subject"
                        : assignment.getSubjectName();

                String month = YearMonth.from(
                        assessment.getAssessmentDate()
                ).toString();

                String key = month + " | " + subject;

                monthlyData.putIfAbsent(key, new AverageData(
                        month, subject
                ));

                AverageData average = monthlyData.get(key);

                average.add(
                        assessment.getMarksObtained(),
                        assessment.getMaxMarks()
                );

                totalObtained = totalObtained.add(
                        assessment.getMarksObtained()
                );

                totalMaximum = totalMaximum.add(
                        assessment.getMaxMarks()
                );

                progressRows.add(new ProgressRow(
                        subject,
                        assessment.getAssessmentName(),
                        assessment.getAssessmentDate().toString(),
                        assessment.getMarksObtained(),
                        assessment.getMaxMarks()
                ));
            }

            List<AverageData> monthlyAverages =
                    new ArrayList<>(monthlyData.values());

            BigDecimal overallAverage = BigDecimal.ZERO;

            if (totalMaximum.compareTo(BigDecimal.ZERO) > 0) {
                overallAverage = totalObtained
                        .multiply(BigDecimal.valueOf(100))
                        .divide(totalMaximum, 2, RoundingMode.HALF_UP);
            }

            request.setAttribute("student", loggedInStudent);

            // Students can view only their own calculated risk summary.
            // Intervention records and internal teacher notes are never exposed here.
            try {
                AcademicRisk academicRisk = academicRiskService
                        .calculateStudentRisk(loggedInStudent.getStudentId());
                request.setAttribute("academicRisk", academicRisk);
            } catch (Exception riskException) {
                log("Unable to calculate student academic risk", riskException);
                request.setAttribute("riskErrorMessage",
                        "Academic risk information is temporarily unavailable.");
            }

            request.setAttribute("progressRows", progressRows);
            request.setAttribute("monthlyAverages", monthlyAverages);
            request.setAttribute("overallAverage", overallAverage);

        } catch (Exception e) {
            log("Unable to load student academic progress", e);
            request.setAttribute(
                    "errorMessage",
                    "Unable to load academic progress."
            );
        }

        request.getRequestDispatcher(
                "/WEB-INF/views/student/academic-progress.jsp"
        ).forward(request, response);
    }

    public static class AverageData {

        private final String month;
        private final String subject;
        private BigDecimal obtained = BigDecimal.ZERO;
        private BigDecimal maximum = BigDecimal.ZERO;

        public AverageData(String month, String subject) {
            this.month = month;
            this.subject = subject;
        }

        public void add(BigDecimal marks, BigDecimal maxMarks) {
            obtained = obtained.add(marks);
            maximum = maximum.add(maxMarks);
        }

        public String getMonth() {
            return month;
        }

        public String getSubject() {
            return subject;
        }

        public BigDecimal getAverage() {
            if (maximum.compareTo(BigDecimal.ZERO) == 0) {
                return BigDecimal.ZERO;
            }

            return obtained.multiply(BigDecimal.valueOf(100))
                    .divide(maximum, 2, RoundingMode.HALF_UP);
        }
    }

    public static class ProgressRow {

        private final String subject;
        private final String assessmentName;
        private final String date;
        private final BigDecimal marks;
        private final BigDecimal maxMarks;

        public ProgressRow(String subject, String assessmentName,
                           String date, BigDecimal marks,
                           BigDecimal maxMarks) {
            this.subject = subject;
            this.assessmentName = assessmentName;
            this.date = date;
            this.marks = marks;
            this.maxMarks = maxMarks;
        }

        public String getSubject() {
            return subject;
        }

        public String getAssessmentName() {
            return assessmentName;
        }

        public String getDate() {
            return date;
        }

        public BigDecimal getMarks() {
            return marks;
        }

        public BigDecimal getMaxMarks() {
            return maxMarks;
        }
    }
}
