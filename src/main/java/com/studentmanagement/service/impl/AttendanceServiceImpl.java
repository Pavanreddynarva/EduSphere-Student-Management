
package com.studentmanagement.service.impl;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import com.studentmanagement.dao.AttendanceDAO;
import com.studentmanagement.dao.StudentDAO;
import com.studentmanagement.dao.impl.AttendanceDAOImpl;
import com.studentmanagement.dao.impl.StudentDAOImpl;
import com.studentmanagement.model.AttendanceRecord;
import com.studentmanagement.model.AttendanceSession;
import com.studentmanagement.model.Student;
import com.studentmanagement.model.TeacherAssignment;
import com.studentmanagement.service.AttendanceService;

public class AttendanceServiceImpl implements AttendanceService {

    private final AttendanceDAO attendanceDAO = new AttendanceDAOImpl();
    private final StudentDAO studentDAO = new StudentDAOImpl();

    @Override
    public List<TeacherAssignment> getTeacherAssignments(int teacherId) {
        return attendanceDAO.getAssignmentsByTeacher(teacherId);
    }

    @Override
    public AttendanceSession createSession(int teacherId, int assignmentId) {

        TeacherAssignment assignment = attendanceDAO
                .getAssignmentById(assignmentId)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Teacher assignment not found"));

        if (assignment.getTeacherId() != teacherId) {
            throw new SecurityException(
                    "You are not authorized to create this attendance session");
        }

        LocalDateTime now = LocalDateTime.now();

        AttendanceSession session = new AttendanceSession();

        session.setAssignmentId(assignmentId);
        session.setSessionDate(now);
        session.setStartTime(now);
        session.setExpiryTime(now.plusMinutes(5));
        session.setQrToken(UUID.randomUUID().toString());
        session.setStatus("ACTIVE");

        if (!attendanceDAO.createAttendanceSession(session)) {
            throw new RuntimeException("Could not create attendance session");
        }

        return session;
    }

    @Override
    public String markStudentAttendance(String token, String studentEmail) {

        AttendanceSession session = attendanceDAO
                .getSessionByToken(token)
                .orElse(null);

        if (session == null) {
            return "Invalid QR code";
        }

        if (!"ACTIVE".equals(session.getStatus())
                || LocalDateTime.now().isAfter(session.getExpiryTime())) {
            return "QR code has expired";
        }

        Student student = studentDAO.getAllStudents()
                .stream()
                .filter(s -> s.getEmail().equalsIgnoreCase(studentEmail))
                .findFirst()
                .orElse(null);

        if (student == null) {
            return "Student record not found";
        }

        TeacherAssignment assignment = attendanceDAO
                .getAssignmentById(session.getAssignmentId())
                .orElse(null);

        if (assignment == null) {
            return "Class assignment not found";
        }

        boolean sameClass =
                assignment.getDepartment().equalsIgnoreCase(student.getDepartment())
                && assignment.getYearOfStudy() == student.getYearOfStudy()
                && assignment.getSection().equalsIgnoreCase(student.getSection());

        if (!sameClass) {
            return "You are not part of this class";
        }

        if (attendanceDAO.hasStudentMarkedAttendance(
                session.getSessionId(), student.getStudentId())) {
            return "Attendance already marked";
        }

        AttendanceRecord record = new AttendanceRecord();

        record.setSessionId(session.getSessionId());
        record.setStudentId(student.getStudentId());
        record.setStatus("PRESENT");
        record.setMarkedBy("QR");

        if (!attendanceDAO.markAttendance(record)) {
            return "Attendance already marked";
        }

        return "Attendance marked successfully";
    }

    // Retrieve attendance history for a specific student
    @Override
    public List<AttendanceRecord> getStudentAttendance(int studentId) {

        if (studentId <= 0) {
            throw new IllegalArgumentException("Invalid student ID");
        }

        return attendanceDAO.getAttendanceByStudent(studentId);
    }

    // Teacher correction with validation and audit logging
    @Override
    public boolean correctAttendance(
            int attendanceId,
            int teacherId,
            String newStatus,
            String reason) {

        if (attendanceId <= 0 || teacherId <= 0) {
            throw new IllegalArgumentException("Invalid attendance or teacher ID");
        }

        if (!"PRESENT".equals(newStatus) && !"ABSENT".equals(newStatus)) {
            throw new IllegalArgumentException(
                    "Attendance status must be PRESENT or ABSENT");
        }

        if (reason == null || reason.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Please provide a reason for the correction");
        }

        return attendanceDAO.correctAttendance(
                attendanceId,
                teacherId,
                newStatus,
                reason.trim());
    }
}
