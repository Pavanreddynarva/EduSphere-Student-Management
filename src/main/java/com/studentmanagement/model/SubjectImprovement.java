package com.studentmanagement.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class SubjectImprovement {
    private int assignmentId;
    private String subjectName;
    private int totalSessions;
    private int presentSessions;
    private int assessmentCount;
    private BigDecimal marksObtained = BigDecimal.ZERO;
    private BigDecimal maxMarks = BigDecimal.ZERO;
    private BigDecimal averagePercentage;
    private String trend = "INSUFFICIENT_DATA";
    private String priority = "NEEDS_MORE_DATA";
    private final List<String> assessmentNames = new ArrayList<>();

    public int getAssignmentId() { return assignmentId; }
    public void setAssignmentId(int v) { assignmentId = v; }
    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String v) { subjectName = v; }
    public int getTotalSessions() { return totalSessions; }
    public void setTotalSessions(int v) { totalSessions = v; }
    public int getPresentSessions() { return presentSessions; }
    public void setPresentSessions(int v) { presentSessions = v; }
    public int getAssessmentCount() { return assessmentCount; }
    public void setAssessmentCount(int v) { assessmentCount = v; }
    public BigDecimal getMarksObtained() { return marksObtained; }
    public void setMarksObtained(BigDecimal v) { marksObtained = v; }
    public BigDecimal getMaxMarks() { return maxMarks; }
    public void setMaxMarks(BigDecimal v) { maxMarks = v; }
    public BigDecimal getAveragePercentage() { return averagePercentage; }
    public void setAveragePercentage(BigDecimal v) { averagePercentage = v; }
    public String getTrend() { return trend; }
    public void setTrend(String v) { trend = v; }
    public String getPriority() { return priority; }
    public void setPriority(String v) { priority = v; }
    public List<String> getAssessmentNames() { return assessmentNames; }
    public double getAttendancePercentage() {
        return totalSessions == 0 ? -1.0 : presentSessions * 100.0 / totalSessions;
    }
}
