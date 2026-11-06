<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.studentmanagement.model.TeacherAssignment" %>
<%@ page import="com.studentmanagement.model.Student" %>
<%@ page import="com.studentmanagement.model.StudentAssessment" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    List<TeacherAssignment> assignments =
            (List<TeacherAssignment>) request.getAttribute("assignments");
    List<Student> students =
            (List<Student>) request.getAttribute("students");
    List<StudentAssessment> assessments =
            (List<StudentAssessment>) request.getAttribute("assessments");
    Object selectedObject = request.getAttribute("selectedAssignmentId");
    String selectedAssignmentId =
            selectedObject == null ? "" : selectedObject.toString();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduSphere | Academic Assessments</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/teacher-pages.css">
</head>
<body class="teacher-page">
<div class="app-layout">
    <aside class="sidebar">
        <div class="brand">
            <div class="brand-icon">E</div>
            <div>
                <div class="brand-name">EduSphere</div>
                <span class="brand-subtitle">TEACHER PORTAL</span>
            </div>
        </div>
        <div>
            <p class="nav-label">MAIN MENU</p>
            <nav class="nav-menu">
                <a class="nav-link" href="<%= request.getContextPath() %>/teacher/dashboard"><span>🏠</span> Dashboard</a>
                <a class="nav-link" href="<%= request.getContextPath() %>/teacher/attendance"><span>📷</span> Attendance</a>
                <a class="nav-link active" href="<%= request.getContextPath() %>/teacher/assessments"><span>📊</span> Academic Assessments</a>
                <a class="nav-link" href="<%= request.getContextPath() %>/teacher/academic-risk"><span>⚠️</span> Student Risk &amp; Interventions</a>
            </nav>
        </div>
        <div class="sidebar-footer">
            <p>EduSphere Teacher Portal</p>
            <form action="<%= request.getContextPath() %>/logout" method="post">
                <button type="submit" class="btn btn-danger">Logout</button>
            </form>
        </div>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div>
                <p class="breadcrumb">Teacher / Academic Assessments</p>
                <h1 class="page-title">Academic Assessments</h1>
                <p class="page-description">Record marks and review assessment history for your assigned classes.</p>
            </div>
            <div class="avatar" aria-label="Teacher">T</div>
        </header>

        <div class="teacher-page-content">
            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("successMessage") %></div>
            <% } %>
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-error"><%= request.getAttribute("errorMessage") %></div>
            <% } %>

            <div class="teacher-card-grid">
                <section class="teacher-card">
                    <h2>Select class and subject</h2>
                    <p class="card-description">Load the students and assessment records for one of your assigned classes.</p>
                    <form method="get" action="<%= request.getContextPath() %>/teacher/assessments" class="teacher-form">
                        <div class="form-group">
                            <label for="assignmentId">Assigned subject and class</label>
                            <select name="assignmentId" id="assignmentId" required>
                                <option value="">Select an assignment</option>
                                <% if (assignments != null) {
                                    for (TeacherAssignment assignment : assignments) { %>
                                        <option value="<%= assignment.getAssignmentId() %>" <%= selectedAssignmentId.equals(String.valueOf(assignment.getAssignmentId())) ? "selected" : "" %>>
                                            <%= assignment.getSubjectName() %> - <%= assignment.getDepartment() %> - Year <%= assignment.getYearOfStudy() %> - Section <%= assignment.getSection() %>
                                        </option>
                                <%  }
                                   } %>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">Load Students</button>
                    </form>
                </section>

                <% if (!selectedAssignmentId.isEmpty()) { %>
                    <section class="teacher-card">
                        <h2>Record assessment</h2>
                        <p class="card-description">Enter the student's marks. The assessment will be saved against the selected subject and class.</p>
                        <form method="post" action="<%= request.getContextPath() %>/teacher/assessments" class="teacher-form assessment-form-grid">
                            <input type="hidden" name="assignmentId" value="<%= selectedAssignmentId %>">
                            <div class="form-group full-row">
                                <label for="studentId">Student</label>
                                <select name="studentId" id="studentId" required>
                                    <option value="">Select a student</option>
                                    <% if (students != null) {
                                        for (Student student : students) { %>
                                            <option value="<%= student.getStudentId() %>"><%= student.getFullName() %> - <%= student.getRollNumber() %></option>
                                    <%  }
                                       } %>
                                </select>
                            </div>
                            <div class="form-group full-row">
                                <label for="assessmentName">Assessment name</label>
                                <input type="text" id="assessmentName" name="assessmentName" maxlength="100" placeholder="e.g. Unit Test 1" required>
                            </div>
                            <div class="form-group">
                                <label for="assessmentDate">Assessment date</label>
                                <input type="date" id="assessmentDate" name="assessmentDate" required>
                            </div>
                            <div class="form-group">
                                <label for="marksObtained">Marks obtained</label>
                                <input type="number" id="marksObtained" name="marksObtained" min="0" step="0.01" placeholder="e.g. 42" required>
                            </div>
                            <div class="form-group">
                                <label for="maxMarks">Maximum marks</label>
                                <input type="number" id="maxMarks" name="maxMarks" min="0.01" step="0.01" placeholder="e.g. 50" required>
                            </div>
                            <div class="form-group" style="align-self:end">
                                <button type="submit" class="btn btn-primary">Save Assessment</button>
                            </div>
                        </form>
                        <% if (students == null || students.isEmpty()) { %>
                            <p class="inline-error">No students were found for this assigned class.</p>
                        <% } %>
                    </section>

                    <section class="teacher-card teacher-card-wide">
                        <h2>Assessment history</h2>
                        <p class="card-description">Previously recorded marks for the selected subject and class.</p>
                        <% if (assessments != null && !assessments.isEmpty()) { %>
                            <div class="table-wrap">
                                <table class="teacher-table">
                                    <thead>
                                    <tr>
                                        <th>Student ID</th>
                                        <th>Assessment</th>
                                        <th>Date</th>
                                        <th>Marks obtained</th>
                                        <th>Maximum marks</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <% for (StudentAssessment assessment : assessments) { %>
                                        <tr>
                                            <td><%= assessment.getStudentId() %></td>
                                            <td><%= assessment.getAssessmentName() %></td>
                                            <td><%= assessment.getAssessmentDate() %></td>
                                            <td><strong><%= assessment.getMarksObtained() %></strong></td>
                                            <td><%= assessment.getMaxMarks() %></td>
                                        </tr>
                                    <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } else { %>
                            <div class="empty-state">No assessments have been recorded for this assignment yet.</div>
                        <% } %>
                    </section>
                <% } %>
            </div>
        </div>
    </main>
</div>
</body>
</html>
