
package com.studentmanagement.service;

import java.util.List;

import com.studentmanagement.model.AttendanceRecord;
import com.studentmanagement.model.AttendanceSession;
import com.studentmanagement.model.TeacherAssignment;

public interface AttendanceService {

    List<TeacherAssignment> getTeacherAssignments(int teacherId);

    AttendanceSession createSession(int teacherId, int assignmentId);

    String markStudentAttendance(String token, String studentEmail);

    // Student attendance history
    List<AttendanceRecord> getStudentAttendance(int studentId);

    // Teacher attendance correction with audit logging
    boolean correctAttendance(
            int attendanceId,
            int teacherId,
            String newStatus,
            String reason
    );
}
