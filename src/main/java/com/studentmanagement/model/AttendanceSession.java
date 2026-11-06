package com.studentmanagement.model;

import java.time.LocalDateTime;

public class AttendanceSession {

    private int sessionId;
    private int assignmentId;
    private LocalDateTime sessionDate;
    private LocalDateTime startTime;
    private LocalDateTime expiryTime;
    private String qrToken;
    private String status;

    public AttendanceSession() {
    }

    public AttendanceSession(int sessionId, int assignmentId,
                              LocalDateTime sessionDate,
                              LocalDateTime startTime,
                              LocalDateTime expiryTime,
                              String qrToken, String status) {
        this.sessionId = sessionId;
        this.assignmentId = assignmentId;
        this.sessionDate = sessionDate;
        this.startTime = startTime;
        this.expiryTime = expiryTime;
        this.qrToken = qrToken;
        this.status = status;
    }

    public int getSessionId() {
        return sessionId;
    }

    public void setSessionId(int sessionId) {
        this.sessionId = sessionId;
    }

    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public LocalDateTime getSessionDate() {
        return sessionDate;
    }

    public void setSessionDate(LocalDateTime sessionDate) {
        this.sessionDate = sessionDate;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public LocalDateTime getExpiryTime() {
        return expiryTime;
    }

    public void setExpiryTime(LocalDateTime expiryTime) {
        this.expiryTime = expiryTime;
    }

    public String getQrToken() {
        return qrToken;
    }

    public void setQrToken(String qrToken) {
        this.qrToken = qrToken;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}