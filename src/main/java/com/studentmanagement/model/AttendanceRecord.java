package com.studentmanagement.model;

import java.time.LocalDateTime;

public class AttendanceRecord {

    private int attendanceId;
    private int sessionId;
    private int studentId;
    private String status;
    private LocalDateTime markedAt;
    private String markedBy;

    public AttendanceRecord() {
    }

    public AttendanceRecord(int attendanceId, int sessionId,
                            int studentId, String status,
                            LocalDateTime markedAt, String markedBy) {
        this.attendanceId = attendanceId;
        this.sessionId = sessionId;
        this.studentId = studentId;
        this.status = status;
        this.markedAt = markedAt;
        this.markedBy = markedBy;
    }

    public int getAttendanceId() {
        return attendanceId;
    }

    public void setAttendanceId(int attendanceId) {
        this.attendanceId = attendanceId;
    }

    public int getSessionId() {
        return sessionId;
    }

    public void setSessionId(int sessionId) {
        this.sessionId = sessionId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getMarkedAt() {
        return markedAt;
    }

    public void setMarkedAt(LocalDateTime markedAt) {
        this.markedAt = markedAt;
    }

    public String getMarkedBy() {
        return markedBy;
    }

    public void setMarkedBy(String markedBy) {
        this.markedBy = markedBy;
    }
}