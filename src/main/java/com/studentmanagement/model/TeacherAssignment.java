package com.studentmanagement.model;

public class TeacherAssignment {

    private int assignmentId;
    private int teacherId;
    private String department;
    private int yearOfStudy;
    private String section;
    private String subjectName;

    public TeacherAssignment() {
    }

    public TeacherAssignment(int assignmentId, int teacherId,
                             String department, int yearOfStudy,
                             String section, String subjectName) {
        this.assignmentId = assignmentId;
        this.teacherId = teacherId;
        this.department = department;
        this.yearOfStudy = yearOfStudy;
        this.section = section;
        this.subjectName = subjectName;
    }

    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public int getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(int teacherId) {
        this.teacherId = teacherId;
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

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }
}