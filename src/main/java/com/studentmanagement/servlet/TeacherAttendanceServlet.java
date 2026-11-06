
package com.studentmanagement.servlet;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.List;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.studentmanagement.model.AttendanceSession;
import com.studentmanagement.model.TeacherAssignment;
import com.studentmanagement.service.AttendanceService;
import com.studentmanagement.service.impl.AttendanceServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/teacher/attendance")
public class TeacherAttendanceServlet extends HttpServlet {

    private AttendanceService attendanceService;

    @Override
    public void init() {
        attendanceService = new AttendanceServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        int teacherId = (Integer) session.getAttribute("userId");

        List<TeacherAssignment> assignments =
                attendanceService.getTeacherAssignments(teacherId);

        request.setAttribute("assignments", assignments);

        request.getRequestDispatcher(
                "/WEB-INF/views/teacher/attendance.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        int teacherId = (Integer) session.getAttribute("userId");

        String action = request.getParameter("action");

        // TEACHER ATTENDANCE CORRECTION
        if ("correct".equals(action)) {

            try {
                int attendanceId = Integer.parseInt(
                        request.getParameter("attendanceId")
                );

                String newStatus = request.getParameter("status");
                String reason = request.getParameter("reason");

                boolean updated = attendanceService.correctAttendance(
                        attendanceId,
                        teacherId,
                        newStatus,
                        reason
                );

                if (updated) {
                    request.setAttribute(
                            "successMessage",
                            "Attendance corrected successfully. Audit log saved."
                    );
                } else {
                    request.setAttribute(
                            "errorMessage",
                            "Attendance was not changed. Check the record and new status."
                    );
                }

            } catch (NumberFormatException e) {

                request.setAttribute(
                        "errorMessage",
                        "Invalid attendance record ID."
                );

            } catch (IllegalArgumentException e) {

                request.setAttribute(
                        "errorMessage",
                        e.getMessage()
                );

            } catch (Exception e) {

                log("Unable to correct attendance", e);

                request.setAttribute(
                        "errorMessage",
                        "Unable to correct attendance."
                );
            }

            doGet(request, response);
            return;
        }

        // EXISTING QR SESSION CREATION
        try {
            int assignmentId = Integer.parseInt(
                    request.getParameter("assignmentId")
            );

            AttendanceSession createdSession =
                    attendanceService.createSession(
                            teacherId, assignmentId
                    );

            String attendanceUrl =
                    request.getScheme() + "://"
                    + request.getServerName() + ":"
                    + request.getServerPort()
                    + request.getContextPath()
                    + "/student/attendance?token="
                    + createdSession.getQrToken();

            QRCodeWriter qrCodeWriter = new QRCodeWriter();

            BitMatrix matrix = qrCodeWriter.encode(
                    attendanceUrl,
                    BarcodeFormat.QR_CODE,
                    300,
                    300
            );

            ByteArrayOutputStream output =
                    new ByteArrayOutputStream();

            MatrixToImageWriter.writeToStream(
                    matrix,
                    "PNG",
                    output
            );

            String qrImage = Base64.getEncoder()
                    .encodeToString(output.toByteArray());

            request.setAttribute("createdSession", createdSession);
            request.setAttribute("qrImage", qrImage);

            request.setAttribute(
                    "successMessage",
                    "Attendance session created successfully!"
            );

        } catch (NumberFormatException e) {

            request.setAttribute(
                    "errorMessage",
                    "Invalid class selection."
            );

        } catch (Exception e) {

            log("Unable to create attendance session or QR code", e);

            request.setAttribute(
                    "errorMessage",
                    "Unable to create attendance session."
            );
        }

        doGet(request, response);
    }
}
