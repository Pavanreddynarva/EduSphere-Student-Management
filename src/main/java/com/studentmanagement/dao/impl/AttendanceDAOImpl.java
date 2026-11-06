
package com.studentmanagement.dao.impl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import com.studentmanagement.dao.AttendanceDAO;
import com.studentmanagement.model.AttendanceRecord;
import com.studentmanagement.model.AttendanceSession;
import com.studentmanagement.model.TeacherAssignment;
import com.studentmanagement.util.DBConnection;

public class AttendanceDAOImpl implements AttendanceDAO {

    // 1. Get all assignments belonging to a teacher
    @Override
    public List<TeacherAssignment> getAssignmentsByTeacher(int teacherId) {

        List<TeacherAssignment> assignments = new ArrayList<>();

        String sql = """
                SELECT * FROM teacher_assignments
                WHERE teacher_id = ?
                ORDER BY department, year_of_study, section, subject_name
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, teacherId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    TeacherAssignment assignment = new TeacherAssignment();

                    assignment.setAssignmentId(rs.getInt("assignment_id"));
                    assignment.setTeacherId(rs.getInt("teacher_id"));
                    assignment.setDepartment(rs.getString("department"));
                    assignment.setYearOfStudy(rs.getInt("year_of_study"));
                    assignment.setSection(rs.getString("section"));
                    assignment.setSubjectName(rs.getString("subject_name"));

                    assignments.add(assignment);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Unable to fetch teacher assignments", e);
        }

        return assignments;
    }

    // 2. Get a particular assignment
    @Override
    public Optional<TeacherAssignment> getAssignmentById(int assignmentId) {

        String sql = """
                SELECT * FROM teacher_assignments
                WHERE assignment_id = ?
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, assignmentId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    TeacherAssignment assignment = new TeacherAssignment();

                    assignment.setAssignmentId(rs.getInt("assignment_id"));
                    assignment.setTeacherId(rs.getInt("teacher_id"));
                    assignment.setDepartment(rs.getString("department"));
                    assignment.setYearOfStudy(rs.getInt("year_of_study"));
                    assignment.setSection(rs.getString("section"));
                    assignment.setSubjectName(rs.getString("subject_name"));

                    return Optional.of(assignment);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Unable to fetch assignment", e);
        }

        return Optional.empty();
    }

    // 3. Create an attendance session
    @Override
    public boolean createAttendanceSession(AttendanceSession session) {

        String sql = """
                INSERT INTO attendance_sessions
                (assignment_id, session_date, start_time,
                 expiry_time, qr_token, status)
                VALUES (?, ?, ?, ?, ?, ?)
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, session.getAssignmentId());
            ps.setDate(2, Date.valueOf(
                    session.getSessionDate().toLocalDate()));
            ps.setTimestamp(3, Timestamp.valueOf(session.getStartTime()));
            ps.setTimestamp(4, Timestamp.valueOf(session.getExpiryTime()));
            ps.setString(5, session.getQrToken());
            ps.setString(6, session.getStatus());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        session.setSessionId(keys.getInt(1));
                    }
                }
                return true;
            }

        } catch (SQLException e) {
            throw new RuntimeException("Unable to create attendance session", e);
        }

        return false;
    }

    // 4. Find an attendance session using its QR token
    @Override
    public Optional<AttendanceSession> getSessionByToken(String qrToken) {

        String sql = """
                SELECT * FROM attendance_sessions
                WHERE qr_token = ?
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, qrToken);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    AttendanceSession session = new AttendanceSession();

                    session.setSessionId(rs.getInt("session_id"));
                    session.setAssignmentId(rs.getInt("assignment_id"));
                    session.setSessionDate(
                            rs.getDate("session_date")
                                    .toLocalDate().atStartOfDay());
                    session.setStartTime(
                            rs.getTimestamp("start_time").toLocalDateTime());
                    session.setExpiryTime(
                            rs.getTimestamp("expiry_time").toLocalDateTime());
                    session.setQrToken(rs.getString("qr_token"));
                    session.setStatus(rs.getString("status"));

                    return Optional.of(session);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Unable to fetch attendance session", e);
        }

        return Optional.empty();
    }

    // 5. Insert a student's attendance
    @Override
    public boolean markAttendance(AttendanceRecord record) {

        String sql = """
                INSERT INTO attendance_records
                (session_id, student_id, status, marked_by)
                VALUES (?, ?, ?, ?)
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, record.getSessionId());
            ps.setInt(2, record.getStudentId());
            ps.setString(3, record.getStatus());
            ps.setString(4, record.getMarkedBy());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            // Duplicate attendance is prevented by the database UNIQUE constraint.
            if ("23000".equals(e.getSQLState())) {
                return false;
            }

            throw new RuntimeException("Unable to mark attendance", e);
        }
    }

    // 6. Check whether a student has already marked attendance
    @Override
    public boolean hasStudentMarkedAttendance(int sessionId, int studentId) {

        String sql = """
                SELECT COUNT(*) FROM attendance_records
                WHERE session_id = ? AND student_id = ?
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, sessionId);
            ps.setInt(2, studentId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Unable to check attendance", e);
        }

        return false;
    }

    // 7. Get all attendance records for a session
    @Override
    public List<AttendanceRecord> getAttendanceBySession(int sessionId) {

        List<AttendanceRecord> records = new ArrayList<>();

        String sql = """
                SELECT * FROM attendance_records
                WHERE session_id = ?
                ORDER BY marked_at
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, sessionId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    AttendanceRecord record = new AttendanceRecord();

                    record.setAttendanceId(rs.getInt("attendance_id"));
                    record.setSessionId(rs.getInt("session_id"));
                    record.setStudentId(rs.getInt("student_id"));
                    record.setStatus(rs.getString("status"));
                    record.setMarkedAt(
                            rs.getTimestamp("marked_at").toLocalDateTime());
                    record.setMarkedBy(rs.getString("marked_by"));

                    records.add(record);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Unable to fetch attendance records", e);
        }

        return records;
    }

    // 8. Get all attendance records for a particular student
    @Override
    public List<AttendanceRecord> getAttendanceByStudent(int studentId) {

        List<AttendanceRecord> records = new ArrayList<>();

        String sql = """
                SELECT ar.attendance_id,
                       ar.session_id,
                       ar.student_id,
                       ar.status,
                       ar.marked_at,
                       ar.marked_by
                FROM attendance_records ar
                JOIN attendance_sessions s
                    ON ar.session_id = s.session_id
                WHERE ar.student_id = ?
                ORDER BY s.session_date DESC, ar.marked_at DESC
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    AttendanceRecord record = new AttendanceRecord();

                    record.setAttendanceId(rs.getInt("attendance_id"));
                    record.setSessionId(rs.getInt("session_id"));
                    record.setStudentId(rs.getInt("student_id"));
                    record.setStatus(rs.getString("status"));
                    record.setMarkedAt(
                            rs.getTimestamp("marked_at").toLocalDateTime());
                    record.setMarkedBy(rs.getString("marked_by"));

                    records.add(record);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to fetch student attendance history", e);
        }

        return records;
    }

    // 9. Correct attendance and save audit history
    @Override
    public boolean correctAttendance(
            int attendanceId,
            int teacherId,
            String newStatus,
            String reason) {

        if (!"PRESENT".equals(newStatus) && !"ABSENT".equals(newStatus)) {
            throw new IllegalArgumentException("Invalid attendance status");
        }

        if (reason == null || reason.trim().isEmpty()) {
            throw new IllegalArgumentException("Correction reason is required");
        }

        String selectSql = """
                SELECT ar.status
                FROM attendance_records ar
                JOIN attendance_sessions s
                    ON ar.session_id = s.session_id
                JOIN teacher_assignments ta
                    ON s.assignment_id = ta.assignment_id
                WHERE ar.attendance_id = ?
                  AND ta.teacher_id = ?
                FOR UPDATE
                """;

        String updateSql = """
                UPDATE attendance_records
                SET status = ?, marked_by = 'TEACHER'
                WHERE attendance_id = ?
                """;

        String auditSql = """
                INSERT INTO attendance_audit_logs
                (attendance_id, changed_by, old_status, new_status, reason)
                VALUES (?, ?, ?, ?, ?)
                """;

        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try {
                String oldStatus;

                // Verify that this attendance belongs to this teacher.
                try (PreparedStatement ps = con.prepareStatement(selectSql)) {

                    ps.setInt(1, attendanceId);
                    ps.setInt(2, teacherId);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (!rs.next()) {
                            con.rollback();
                            return false;
                        }

                        oldStatus = rs.getString("status");
                    }
                }

                // No audit entry is needed if the status is unchanged.
                if (oldStatus.equals(newStatus)) {
                    con.rollback();
                    return false;
                }

                // Update attendance.
                try (PreparedStatement ps = con.prepareStatement(updateSql)) {

                    ps.setString(1, newStatus);
                    ps.setInt(2, attendanceId);

                    ps.executeUpdate();
                }

                // Insert audit history.
                try (PreparedStatement ps = con.prepareStatement(auditSql)) {

                    ps.setInt(1, attendanceId);
                    ps.setInt(2, teacherId);
                    ps.setString(3, oldStatus);
                    ps.setString(4, newStatus);
                    ps.setString(5, reason.trim());

                    ps.executeUpdate();
                }

                con.commit();
                return true;

            } catch (SQLException | RuntimeException e) {

                con.rollback();
                throw e;

            } finally {
                con.setAutoCommit(true);
            }

        } catch (SQLException e) {
            throw new RuntimeException("Unable to correct attendance", e);
        }
    }
}
