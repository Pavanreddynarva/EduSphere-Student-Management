package com.studentmanagement.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import com.studentmanagement.model.AcademicRisk;
import com.studentmanagement.model.AcademicRiskSettings;
import com.studentmanagement.service.AcademicRiskService;
import com.studentmanagement.service.impl.AcademicRiskServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/academic-risk")
public class AcademicRiskAdminServlet extends HttpServlet {

    private final AcademicRiskService riskService =
            new AcademicRiskServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        AcademicRiskSettings settings = riskService.getRiskSettings();
        List<AcademicRisk> risks = riskService.getAllStudentRisks();

        request.setAttribute("settings", settings);
        request.setAttribute("risks", risks);

        request.getRequestDispatcher(
                "/WEB-INF/views/admin/academic-risk.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        try {
            Object userIdValue = session.getAttribute("userId");
            int adminId = Integer.parseInt(userIdValue.toString());

            BigDecimal attendanceThreshold = new BigDecimal(
                    request.getParameter("attendanceThreshold"));

            BigDecimal performanceThreshold = new BigDecimal(
                    request.getParameter("performanceThreshold"));

            AcademicRiskSettings settings =
                    new AcademicRiskSettings();

            settings.setAttendanceThreshold(attendanceThreshold);
            settings.setPerformanceThreshold(performanceThreshold);

            boolean updated = riskService.updateSettings(adminId, settings);

            if (updated) {
                request.setAttribute("success",
                        "Risk thresholds updated successfully!");
            } else {
                request.setAttribute("error",
                        "Unable to update risk thresholds.");
            }

        } catch (Exception e) {
            request.setAttribute("error",
                    "Invalid threshold values. Please enter valid numbers between 0 and 100.");
        }

        doGet(request, response);
    }
}