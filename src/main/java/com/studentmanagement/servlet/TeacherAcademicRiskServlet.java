package com.studentmanagement.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

import com.studentmanagement.model.AcademicRisk;
import com.studentmanagement.model.TeacherIntervention;
import com.studentmanagement.service.AcademicRiskService;
import com.studentmanagement.service.TeacherInterventionService;
import com.studentmanagement.service.impl.AcademicRiskServiceImpl;
import com.studentmanagement.service.impl.TeacherInterventionServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/teacher/academic-risk")
public class TeacherAcademicRiskServlet extends HttpServlet {

    private AcademicRiskService riskService;
    private TeacherInterventionService interventionService;

    @Override
    public void init() {
        riskService = new AcademicRiskServiceImpl();
        interventionService = new TeacherInterventionServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null
                || !"TEACHER".equalsIgnoreCase(
                        String.valueOf(session.getAttribute("role")))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int teacherId = (Integer) session.getAttribute("userId");
        try {
            List<AcademicRisk> risks =
                    riskService.getTeacherStudentRisks(teacherId);
            List<TeacherIntervention> interventions =
                    interventionService.getTeacherInterventions(teacherId);

            request.setAttribute("risks", risks);
            request.setAttribute("interventions", interventions);
            request.setAttribute("success", session.getAttribute("riskSuccess"));
            request.setAttribute("error", session.getAttribute("riskError"));
            session.removeAttribute("riskSuccess");
            session.removeAttribute("riskError");
        } catch (RuntimeException e) {
            log("Unable to load teacher academic risk page", e);
            request.setAttribute("pageError",
                    "Unable to load academic risk information. Please try again.");
        }

        request.getRequestDispatcher(
                "/WEB-INF/views/teacher/academic-risk.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null
                || !"TEACHER".equalsIgnoreCase(
                        String.valueOf(session.getAttribute("role")))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int teacherId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");

        try {
            if ("record".equals(action)) {
                TeacherIntervention intervention = new TeacherIntervention();
                intervention.setStudentId(Integer.parseInt(
                        request.getParameter("studentId")));
                intervention.setInterventionType(
                        request.getParameter("interventionType"));
                intervention.setActionTaken(request.getParameter("actionTaken"));
                intervention.setNotes(request.getParameter("notes"));
                intervention.setFollowUpStatus("PENDING");

                String followUpDate = request.getParameter("followUpDate");
                if (followUpDate != null && !followUpDate.isBlank()) {
                    intervention.setFollowUpDate(LocalDate.parse(followUpDate));
                }

                interventionService.recordIntervention(teacherId, intervention);
                session.setAttribute("riskSuccess", "Intervention recorded successfully.");

            } else if ("update".equals(action)) {
                int interventionId = Integer.parseInt(
                        request.getParameter("interventionId"));
                String status = request.getParameter("followUpStatus");
                String notes = request.getParameter("notes");
                boolean updated = interventionService.updateFollowUp(
                        interventionId, teacherId, status, notes);
                session.setAttribute(updated ? "riskSuccess" : "riskError",
                        updated ? "Follow-up updated successfully."
                                : "The intervention could not be updated.");
            } else {
                throw new IllegalArgumentException("Invalid action.");
            }
        } catch (NumberFormatException | DateTimeParseException e) {
            session.setAttribute("riskError", "Please enter valid intervention details.");
        } catch (SecurityException | IllegalArgumentException e) {
            session.setAttribute("riskError", e.getMessage());
        } catch (Exception e) {
            log("Unable to save teacher intervention", e);
            session.setAttribute("riskError",
                    "Unable to save the intervention. Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/teacher/academic-risk");
    }
}
