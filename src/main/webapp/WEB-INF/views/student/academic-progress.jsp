
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.studentmanagement.model.Student" %>
<%@ page import="com.studentmanagement.model.AcademicRisk" %>
<%@ page import="com.studentmanagement.servlet.StudentAcademicProgressServlet.AverageData" %>
<%@ page import="com.studentmanagement.servlet.StudentAcademicProgressServlet.ProgressRow" %>

<%
    Student student =
        (Student) request.getAttribute("student");

    List<AverageData> monthlyAverages =
        (List<AverageData>) request.getAttribute("monthlyAverages");

    List<ProgressRow> progressRows =
        (List<ProgressRow>) request.getAttribute("progressRows");

    Object overallObject = request.getAttribute("overallAverage");

    String overallAverage =
        overallObject == null ? "0.00" : overallObject.toString();

    AcademicRisk academicRisk =
        (AcademicRisk) request.getAttribute("academicRisk");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Academic Progress | EduSphere</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .progress-card {
            background: white;
            padding: 25px;
            margin-bottom: 22px;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            box-shadow: 0 3px 12px rgba(20,35,60,0.04);
        }

        .progress-card h2 {
            font-size: 20px;
            margin-bottom: 20px;
            color: #172033;
        }

        .detail-list p {
            margin-bottom: 13px;
            color: #334155;
        }

        .average-value {
            font-size: 32px;
            font-weight: 700;
            color: #4338ca;
        }

        .progress-table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        .progress-table {
            width: 100%;
            min-width: 550px;
            border-collapse: collapse;
        }

        .progress-table th,
        .progress-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
            font-size: 13px;
        }

        .progress-table th {
            background: #f8fafc;
            color: #64748b;
            font-weight: 700;
        }

        .risk-status {
            display: inline-block;
            padding: 7px 13px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
        }

        .HIGH_RISK {
            background: #fee2e2;
            color: #b91c1c;
        }

        .ATTENDANCE_RISK,
        .ACADEMIC_RISK {
            background: #fff1d8;
            color: #92400e;
        }

        .LOW_RISK {
            background: #dcfce7;
            color: #15803d;
        }

        .INSUFFICIENT_DATA {
            background: #e2e8f0;
            color: #475569;
        }

        .risk-list {
            padding-left: 25px;
            margin-top: 12px;
        }

        .risk-list li {
            margin-bottom: 10px;
            color: #334155;
        }

        .error-message {
            padding: 15px;
            background: #fee2e2;
            color: #b91c1c;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .empty-message {
            padding: 25px;
            text-align: center;
            color: #64748b;
        }

        @media(max-width: 700px) {
            .progress-card {
                padding: 18px;
            }

            .average-value {
                font-size: 27px;
            }
        }
    </style>
</head>

<body>

<div class="app-layout">

    <!-- STUDENT SIDEBAR -->
    <aside class="sidebar">

        <div class="brand">
            <div class="brand-icon">E</div>

            <div>
                <div class="brand-name">EduSphere</div>
                <span class="brand-subtitle">STUDENT PORTAL</span>
            </div>
        </div>

        <div>
            <p class="nav-label">STUDENT MENU</p>

            <nav class="nav-menu">

                <a class="nav-link"
                   href="${pageContext.request.contextPath}/student/dashboard">
                    <span>&#127968;</span> Dashboard
                </a>

                <a class="nav-link"
                   href="${pageContext.request.contextPath}/student/attendance/history">
                    <span>&#128197;</span> My Attendance
                </a>

                <a class="nav-link active"
                   href="${pageContext.request.contextPath}/student/academic-progress">
                    <span>&#128202;</span> My Academic Progress
                </a>

                            <a class="nav-link" href="${pageContext.request.contextPath}/student/grade-simulator"><span>&#129518;</span> What-If Grade Simulator</a>

            </nav>
        </div>

        <div class="sidebar-footer">
            <p>EduSphere Student Portal</p>

            <form action="${pageContext.request.contextPath}/logout"
                  method="post">

                <button type="submit" class="btn btn-danger">
                    Logout
                </button>

            </form>
        </div>

    </aside>

    <!-- MAIN CONTENT -->
    <main class="main-content">

        <header class="topbar">

            <div>
                <p class="breadcrumb">
                    Student / Academic Progress
                </p>

                <h1 class="page-title">
                    My Academic Progress
                </h1>

                <p class="page-description">
                    Track your academic performance, attendance and improvement areas.
                </p>
            </div>

            <div class="avatar">S</div>

        </header>

        <% if (request.getAttribute("errorMessage") != null) { %>

            <div class="error-message">
                <%= request.getAttribute("errorMessage") %>
            </div>

        <% } %>

        <% if (student != null) { %>

            <!-- STUDENT DETAILS -->
            <section class="progress-card">

                <h2>Student Details</h2>

                <div class="detail-list">

                    <p><strong>Name:</strong>
                        <%= student.getFullName() %>
                    </p>

                    <p><strong>Roll Number:</strong>
                        <%= student.getRollNumber() %>
                    </p>

                    <p><strong>Department:</strong>
                        <%= student.getDepartment() %>
                    </p>

                    <p><strong>Year:</strong>
                        <%= student.getYearOfStudy() %>
                    </p>

                    <p><strong>Section:</strong>
                        <%= student.getSection() %>
                    </p>

                </div>

            </section>

            <!-- ACADEMIC RISK STATUS -->
            <section class="progress-card">

                <h2>My Academic Risk Status</h2>

                <% if (request.getAttribute("riskErrorMessage") != null) { %>

                    <div class="error-message">
                        <%= request.getAttribute("riskErrorMessage") %>
                    </div>

                <% } else if (academicRisk != null) { %>

                    <p>
                        <strong>Status:</strong>

                        <span class="risk-status <%= academicRisk.getRiskStatus() %>">
                            <%= academicRisk.getRiskStatus() %>
                        </span>
                    </p>

                    <p style="margin-top:18px;">
                        <strong>Attendance:</strong>

                        <%= academicRisk.getAttendancePercentage() == null
                                ? "Not available"
                                : academicRisk.getAttendancePercentage() + "%" %>
                    </p>

                    <p style="margin-top:14px;">
                        <strong>Academic Performance:</strong>

                        <%= academicRisk.getAcademicPercentage() == null
                                ? "Not available"
                                : academicRisk.getAcademicPercentage() + "%" %>
                    </p>

                    <% if (academicRisk.getRiskReasons() != null
                            && !academicRisk.getRiskReasons().isEmpty()) { %>

                        <h3 style="margin-top:22px;">
                            Explanation
                        </h3>

                        <ul class="risk-list">

                            <% for (String reason : academicRisk.getRiskReasons()) { %>

                                <li>
                                    <%= reason.replace("&", "&amp;")
                                              .replace("<", "&lt;")
                                              .replace(">", "&gt;") %>
                                </li>

                            <% } %>

                        </ul>

                    <% } %>

                    <% if (academicRisk.getImprovementAreas() != null
                            && !academicRisk.getImprovementAreas().isEmpty()) { %>

                        <h3 style="margin-top:22px;">
                            Suggested Improvement Areas
                        </h3>

                        <ul class="risk-list">

                            <% for (String area : academicRisk.getImprovementAreas()) { %>

                                <li>
                                    <%= area.replace("&", "&amp;")
                                            .replace("<", "&lt;")
                                            .replace(">", "&gt;") %>
                                </li>

                            <% } %>

                        </ul>

                    <% } %>

                <% } %>

            </section>

            <!-- OVERALL AVERAGE -->
            <section class="progress-card">

                <h2>Overall Academic Average</h2>

                <div class="average-value">
                    <%= overallAverage %>%
                </div>

            </section>

            <!-- MONTHLY AVERAGES -->
            <section class="progress-card">

                <h2>Monthly Subject-wise Averages</h2>

                <% if (monthlyAverages != null
                        && !monthlyAverages.isEmpty()) { %>

                    <div class="progress-table-wrapper">

                        <table class="progress-table">

                            <thead>
                                <tr>
                                    <th>Month</th>
                                    <th>Subject</th>
                                    <th>Average</th>
                                </tr>
                            </thead>

                            <tbody>

                                <% for (AverageData average : monthlyAverages) { %>

                                    <tr>
                                        <td><%= average.getMonth() %></td>
                                        <td><%= average.getSubject() %></td>
                                        <td><%= average.getAverage() %>%</td>
                                    </tr>

                                <% } %>

                            </tbody>

                        </table>

                    </div>

                <% } else { %>

                    <div class="empty-message">
                        No monthly assessment data available yet.
                    </div>

                <% } %>

            </section>

            <!-- ASSESSMENT HISTORY -->
            <section class="progress-card">

                <h2>My Assessment History</h2>

                <% if (progressRows != null
                        && !progressRows.isEmpty()) { %>

                    <div class="progress-table-wrapper">

                        <table class="progress-table">

                            <thead>
                                <tr>
                                    <th>Subject</th>
                                    <th>Assessment</th>
                                    <th>Date</th>
                                    <th>Marks</th>
                                    <th>Maximum Marks</th>
                                </tr>
                            </thead>

                            <tbody>

                                <% for (ProgressRow row : progressRows) { %>

                                    <tr>
                                        <td><%= row.getSubject() %></td>
                                        <td><%= row.getAssessmentName() %></td>
                                        <td><%= row.getDate() %></td>
                                        <td><%= row.getMarks() %></td>
                                        <td><%= row.getMaxMarks() %></td>
                                    </tr>

                                <% } %>

                            </tbody>

                        </table>

                    </div>

                <% } else { %>

                    <div class="empty-message">
                        No assessments have been recorded yet.
                    </div>

                <% } %>

            </section>

        <% } %>

    </main>

</div>

</body>
</html>
