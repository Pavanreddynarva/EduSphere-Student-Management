package com.studentmanagement.servlet;

import com.studentmanagement.dao.StudentDAO;
import com.studentmanagement.dao.impl.StudentDAOImpl;
import com.studentmanagement.model.Student;
import com.studentmanagement.model.SubjectImprovement;
import com.studentmanagement.service.ImprovementPlanService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/student/improvement-plan")
public class StudentImprovementPlanServlet extends HttpServlet {
    private final StudentDAO studentDAO = new StudentDAOImpl();
    private final ImprovementPlanService planService = new ImprovementPlanService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"STUDENT".equals(session.getAttribute("role"))
                || session.getAttribute("email") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        try {
            String email = (String) session.getAttribute("email");
            Student student = studentDAO.getAllStudents().stream()
                .filter(s -> s.getEmail() != null && s.getEmail().equalsIgnoreCase(email))
                .findFirst().orElse(null);
            if (student == null) throw new IllegalStateException("Student profile not found.");
            List<SubjectImprovement> subjects = planService.buildSubjectAnalysis(student);
            request.setAttribute("student", student);
            request.setAttribute("subjects", subjects);
            request.setAttribute("weeklyPlan", planService.buildSevenDayPlan(subjects));
        } catch (Exception e) {
            log("Unable to build personalized improvement plan", e);
            request.setAttribute("errorMessage", "We could not load your improvement plan right now. Please try again.");
        }
        request.getRequestDispatcher("/WEB-INF/views/student/improvement-plan.jsp").forward(request, response);
    }
}
