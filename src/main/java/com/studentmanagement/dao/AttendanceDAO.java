
package com.studentmanagement.dao;

import java.util.List;
import java.util.Optional;

import com.studentmanagement.model.AttendanceRecord;
import com.studentmanagement.model.AttendanceSession;
import com.studentmanagement.model.TeacherAssignment;

public interface AttendanceDAO {

    // Teacher assignments
    List<TeacherAssignment> getAssignmentsByTeacher(int teacherId);

    Optional<TeacherAssignment> getAssignmentById(int assignmentId);

    // Attendance sessions
    boolean createAttendanceSession(AttendanceSession session);

    Optional<AttendanceSession> getSessionByToken(String qrToken);

    // Attendance records
    boolean markAttendance(AttendanceRecord record);

    boolean hasStudentMarkedAttendance(int sessionId, int studentId);

    List<AttendanceRecord> getAttendanceBySession(int sessionId);

    // Student attendance history
    List<AttendanceRecord> getAttendanceByStudent(int studentId);

    // Teacher attendance correction with audit logging
    boolean correctAttendance(
            int attendanceId,
            int teacherId,
            String newStatus,
            String reason
    );
}
