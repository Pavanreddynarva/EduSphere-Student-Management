package com.studentmanagement.model;

import java.math.BigDecimal;
import java.util.List;

public class AcademicRisk {

    private int studentId;
    private String rollNumber;
    private String fullName;
    private String department;
    private int yearOfStudy;
    private String section;

    private BigDecimal attendancePercentage;
    private int totalSessions;
    private int presentSessions;

    private BigDecimal academicPercentage;
    private int totalAssessments;

    private boolean attendanceRisk;
    private boolean academicRisk;
    private String riskStatus;

    private List<String> riskReasons;
    private List<String> improvementAreas;

    public AcademicRisk() {
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public String getRollNumber() {
        return rollNumber;
    }

    public void setRollNumber(String rollNumber) {
        this.rollNumber = rollNumber;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public int getYearOfStudy() {
        return yearOfStudy;
    }

    public void setYearOfStudy(int yearOfStudy) {
        this.yearOfStudy = yearOfStudy;
    }

    public String getSection() {
        return section;
    }

    public void setSection(String section) {
        this.section = section;
    }

    public BigDecimal getAttendancePercentage() {
        return attendancePercentage;
    }

    public void setAttendancePercentage(BigDecimal attendancePercentage) {
        this.attendancePercentage = attendancePercentage;
    }

    public int getTotalSessions() {
        return totalSessions;
    }

    public void setTotalSessions(int totalSessions) {
        this.totalSessions = totalSessions;
    }

    public int getPresentSessions() {
        return presentSessions;
    }

    public void setPresentSessions(int presentSessions) {
        this.presentSessions = presentSessions;
    }

    public BigDecimal getAcademicPercentage() {
        return academicPercentage;
    }

    public void setAcademicPercentage(BigDecimal academicPercentage) {
        this.academicPercentage = academicPercentage;
    }

    public int getTotalAssessments() {
        return totalAssessments;
    }

    public void setTotalAssessments(int totalAssessments) {
        this.totalAssessments = totalAssessments;
    }

    public boolean isAttendanceRisk() {
        return attendanceRisk;
    }

    public void setAttendanceRisk(boolean attendanceRisk) {
        this.attendanceRisk = attendanceRisk;
    }

    public boolean isAcademicRisk() {
        return academicRisk;
    }

    public void setAcademicRisk(boolean academicRisk) {
        this.academicRisk = academicRisk;
    }

    public String getRiskStatus() {
        return riskStatus;
    }

    public void setRiskStatus(String riskStatus) {
        this.riskStatus = riskStatus;
    }

    public List<String> getRiskReasons() {
        return riskReasons;
    }

    public void setRiskReasons(List<String> riskReasons) {
        this.riskReasons = riskReasons;
    }

    public List<String> getImprovementAreas() {
        return improvementAreas;
    }

    public void setImprovementAreas(List<String> improvementAreas) {
        this.improvementAreas = improvementAreas;
    }
}