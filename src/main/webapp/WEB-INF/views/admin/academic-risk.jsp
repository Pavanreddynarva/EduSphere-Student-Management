<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.studentmanagement.model.AcademicRisk" %>
<%@ page import="com.studentmanagement.model.AcademicRiskSettings" %>

<%!
    private String safe(Object value) {
        if (value == null) return "N/A";

        return value.toString()
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
    AcademicRiskSettings settings =
            (AcademicRiskSettings) request.getAttribute("settings");

    List<AcademicRisk> risks =
            (List<AcademicRisk>) request.getAttribute("risks");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>EduSphere | Academic Risk</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <style>

        /* PAGE LAYOUT */

        .main-content {
            min-width: 0;
        }

        .risk-welcome {
            color: #64748b;
            font-size: 14px;
            margin-top: 6px;
        }

        /* SUMMARY CARDS */

        .risk-summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 18px;
            margin-bottom: 24px;
        }

        .risk-summary-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.05);
            border: 1px solid #edf0f5;
        }

        .risk-summary-card h3 {
            font-size: 14px;
            color: #64748b;
            font-weight: 600;
            margin: 0 0 12px;
        }

        .risk-summary-card .summary-value {
            font-size: 25px;
            font-weight: 750;
            color: #25334d;
            margin: 0;
        }

        .risk-summary-card .summary-description {
            font-size: 12px;
            color: #718096;
            margin-top: 7px;
        }

        /* PANELS */

        .risk-panel {
            background: white;
            padding: 25px;
            border-radius: 14px;
            margin-bottom: 24px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.05);
            border: 1px solid #edf0f5;
        }

        .risk-panel-header {
            margin-bottom: 22px;
        }

        .risk-panel-header h2 {
            font-size: 21px;
            color: #25334d;
            margin: 0 0 8px;
        }

        .risk-panel-header p {
            color: #718096;
            font-size: 14px;
            margin: 0;
        }

        /* THRESHOLD SETTINGS */

        .settings-info {
            padding: 14px 16px;
            background: #f1f5ff;
            border-radius: 9px;
            color: #4055a5;
            font-size: 13px;
            line-height: 1.6;
            margin-bottom: 22px;
        }

        .settings-form {
            display: grid;
            grid-template-columns: repeat(2, minmax(200px, 1fr));
            gap: 20px;
            align-items: end;
        }

        .settings-form .form-group {
            display: flex;
            flex-direction: column;
            gap: 9px;
        }

        .settings-form label {
            font-weight: 600;
            font-size: 14px;
            color: #475569;
        }

        .settings-form input {
            width: 100%;
            min-height: 45px;
            padding: 11px 13px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .settings-form input:focus {
            outline: none;
            border-color: #4055d8;
            box-shadow: 0 0 0 3px rgba(64,85,216,0.1);
        }

        .settings-form button {
            grid-column: 1 / -1;
            justify-self: start;
        }

        /* MESSAGES */

        .success {
            color: #16803c;
            background: #e9f8ef;
            padding: 14px 18px;
            border-radius: 9px;
            margin-bottom: 20px;
        }

        .error {
            color: #c62828;
            background: #fff0f0;
            padding: 14px 18px;
            border-radius: 9px;
            margin-bottom: 20px;
        }

        /* RISK TABLE */

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
            border-radius: 10px;
        }

        .risk-table {
            width: 100%;
            min-width: 1250px;
            border-collapse: separate;
            border-spacing: 0;
            background: white;
        }

        .risk-table th,
        .risk-table td {
            padding: 17px 20px;
            border-bottom: 1px solid #e8edf4;
            text-align: left;
            vertical-align: middle;
        }

        .risk-table th {
            background: #f1f5f9;
            color: #40516b;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            font-weight: 700;
            white-space: nowrap;
        }

        .risk-table tbody tr:hover {
            background: #f8faff;
        }

        .student-name {
            font-weight: 700;
            color: #25334d;
            min-width: 150px;
        }

        .muted {
            color: #718096;
            font-size: 13px;
            margin-top: 6px;
            line-height: 1.5;
        }

        /* RISK STATUS BADGES */

        .risk {
            display: inline-block;
            padding: 8px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 750;
            white-space: nowrap;
        }

        .LOW_RISK {
            color: #167442;
            background: #e2f7eb;
        }

        .ATTENDANCE_RISK,
        .ACADEMIC_RISK {
            color: #a65b00;
            background: #fff1d8;
        }

        .HIGH_RISK {
            color: #b42332;
            background: #ffe5e8;
        }

        .INSUFFICIENT_DATA {
            color: #586579;
            background: #edf0f5;
        }

        /* REASONS AND IMPROVEMENT AREAS */

        .reason-list,
        .improvement-list {
            margin: 0;
            padding-left: 19px;
            min-width: 180px;
        }

        .reason-list li,
        .improvement-list li {
            margin-bottom: 8px;
            line-height: 1.55;
            font-size: 13px;
            color: #475569;
        }

        .empty {
            text-align: center;
            padding: 35px 20px !important;
            color: #718096;
        }

        .attendance-value,
        .academic-value {
            font-weight: 700;
            color: #25334d;
            white-space: nowrap;
        }

        /* RESPONSIVE DESIGN */

        @media (max-width: 850px) {

            .settings-form {
                grid-template-columns: 1fr;
            }

            .settings-form button {
                grid-column: auto;
                width: 100%;
            }

        }

        @media (max-width: 600px) {

            .risk-panel {
                padding: 18px;
            }

            .risk-table th,
            .risk-table td {
                padding: 13px 15px;
            }

        }

    </style>

</head>

<body>

<div class="app-layout">

    <!-- ADMIN SIDEBAR -->

    <aside class="sidebar">

        <div class="brand">
            EduSphere
        </div>

        <p class="nav-label">
            MAIN MENU
        </p>

        <nav class="nav-menu">

            <a class="nav-link"
               href="${pageContext.request.contextPath}/students">
                Dashboard
            </a>

            <a class="nav-link"
               href="${pageContext.request.contextPath}/students">
                Students
            </a>

            <a class="nav-link"
               href="${pageContext.request.contextPath}/students#performance-summary">
                Performance
            </a>

            <a class="nav-link"
               href="${pageContext.request.contextPath}/admin/users">
                User Management
            </a>

            <a class="nav-link active"
               href="${pageContext.request.contextPath}/admin/academic-risk">
                Academic Risk
            </a>

        </nav>

        <div class="sidebar-footer">

            <p>Student Management System</p>

            <form action="${pageContext.request.contextPath}/logout"
                  method="post"
                  style="margin-top: 15px;">

                <button type="submit" class="btn btn-secondary">
                    Logout
                </button>

            </form>

        </div>

    </aside>


    <!-- MAIN CONTENT -->

    <main class="main-content">


        <!-- HEADER -->

        <header class="topbar">

            <div>

                <p class="breadcrumb">
                    Admin / Academic Risk
                </p>

                <h1 class="page-title">
                    Academic Risk Dashboard
                </h1>

                <p class="page-description">
                    Monitor student performance, attendance and academic risk.
                </p>

                <p class="risk-welcome">
                    Welcome,
                    <%= safe(session.getAttribute("fullName")) %>
                </p>

            </div>

            <div class="avatar">
                A
            </div>

        </header>


        <!-- SUCCESS MESSAGE -->

        <% if (request.getAttribute("success") != null) { %>

            <p class="success">
                <strong>Success!</strong>
                <%= safe(request.getAttribute("success")) %>
            </p>

        <% } %>


        <!-- ERROR MESSAGE -->

        <% if (request.getAttribute("error") != null) { %>

            <p class="error">
                <strong>Error!</strong>
                <%= safe(request.getAttribute("error")) %>
            </p>

        <% } %>


        <!-- RISK SUMMARY -->

        <section class="risk-summary-grid">

            <div class="risk-summary-card">

                <h3>Total Student Reports</h3>

                <p class="summary-value">
                    <%= risks != null ? risks.size() : 0 %>
                </p>

                <p class="summary-description">
                    Students evaluated by the risk system
                </p>

            </div>


            <div class="risk-summary-card">

                <h3>High Risk</h3>

                <p class="summary-value" id="highRiskCount">
                    —
                </p>

                <p class="summary-description">
                    Students requiring immediate attention
                </p>

            </div>


            <div class="risk-summary-card">

                <h3>Needs Attention</h3>

                <p class="summary-value" id="attentionRiskCount">
                    —
                </p>

                <p class="summary-description">
                    Attendance or academic risk
                </p>

            </div>


            <div class="risk-summary-card">

                <h3>Low Risk</h3>

                <p class="summary-value" id="lowRiskCount">
                    —
                </p>

                <p class="summary-description">
                    Students currently classified as low risk
                </p>

            </div>


            <div class="risk-summary-card">

                <h3>Insufficient Data</h3>

                <p class="summary-value" id="insufficientRiskCount">
                    —
                </p>

                <p class="summary-description">
                    Students without enough evaluation data
                </p>

            </div>

        </section>


        <!-- GLOBAL RISK THRESHOLDS -->

        <section class="risk-panel">

            <div class="risk-panel-header">

                <h2>
                    ⚙ Global Risk Thresholds
                </h2>

                <p>
                    Configure the attendance and academic performance
                    thresholds used by the risk evaluation system.
                </p>

            </div>


            <div class="settings-info">

                Students are evaluated using these thresholds.
                Changes made here apply to the global risk settings.

            </div>


            <form class="settings-form"
                  method="post"
                  action="${pageContext.request.contextPath}/admin/academic-risk">


                <div class="form-group">

                    <label for="attendanceThreshold">
                        Attendance Threshold (%)
                    </label>

                    <input type="number"
                           id="attendanceThreshold"
                           name="attendanceThreshold"
                           min="0"
                           max="100"
                           step="0.01"
                           required
                           value="<%= settings != null ? safe(settings.getAttendanceThreshold()) : "75.00" %>">

                </div>


                <div class="form-group">

                    <label for="performanceThreshold">
                        Academic Performance Threshold (%)
                    </label>

                    <input type="number"
                           id="performanceThreshold"
                           name="performanceThreshold"
                           min="0"
                           max="100"
                           step="0.01"
                           required
                           value="<%= settings != null ? safe(settings.getPerformanceThreshold()) : "60.00" %>">

                </div>


                <button type="submit" class="btn btn-primary">
                    Update Thresholds
                </button>


            </form>

        </section>


        <!-- ALL STUDENT RISK REPORTS -->

        <section class="risk-panel">

            <div class="risk-panel-header">

                <h2>
                    📊 All Student Risk Reports
                </h2>

                <p>
                    Review each student's attendance, academic performance,
                    risk classification and recommended improvement areas.
                </p>

            </div>


            <div class="table-wrapper">

                <table class="risk-table" id="riskTable">

                    <thead>

                        <tr>

                            <th>Student</th>

                            <th>Class</th>

                            <th>Attendance</th>

                            <th>Academic Performance</th>

                            <th>Risk Status</th>

                            <th>Why Flagged?</th>

                            <th>Improvement Areas</th>

                        </tr>

                    </thead>


                    <tbody>


                    <% if (risks != null && !risks.isEmpty()) {

                        for (AcademicRisk risk : risks) {

                            String status = risk.getRiskStatus();

                            if (status == null) {
                                status = "INSUFFICIENT_DATA";
                            }

                    %>


                        <tr data-risk-status="<%= safe(status) %>">


                            <!-- STUDENT DETAILS -->

                            <td>

                                <div class="student-name">
                                    <%= safe(risk.getFullName()) %>
                                </div>

                                <div class="muted">
                                    <%= safe(risk.getRollNumber()) %>
                                </div>

                            </td>


                            <!-- CLASS DETAILS -->

                            <td>

                                <strong>
                                    <%= safe(risk.getDepartment()) %>
                                </strong>

                                <div class="muted">

                                    Year <%= risk.getYearOfStudy() %>,

                                    Section <%= safe(risk.getSection()) %>

                                </div>

                            </td>


                            <!-- ATTENDANCE -->

                            <td>

                                <div class="attendance-value">

                                    <%= risk.getAttendancePercentage() != null
                                            ? safe(risk.getAttendancePercentage()) + "%"
                                            : "No data" %>

                                </div>

                                <div class="muted">

                                    <%= risk.getPresentSessions() %> /
                                    <%= risk.getTotalSessions() %> sessions

                                </div>

                            </td>


                            <!-- ACADEMIC PERFORMANCE -->

                            <td>

                                <div class="academic-value">

                                    <%= risk.getAcademicPercentage() != null
                                            ? safe(risk.getAcademicPercentage()) + "%"
                                            : "No data" %>

                                </div>

                                <div class="muted">

                                    Assessments:
                                    <%= risk.getTotalAssessments() %>

                                </div>

                            </td>


                            <!-- RISK STATUS -->

                            <td>

                                <span class="risk <%= safe(status) %>">

                                    <%= safe(status.replace("_", " ")) %>

                                </span>

                            </td>


                            <!-- RISK REASONS -->

                            <td>

                                <% if (risk.getRiskReasons() != null
                                        && !risk.getRiskReasons().isEmpty()) { %>


                                    <ul class="reason-list">

                                        <% for (String reason : risk.getRiskReasons()) { %>

                                            <li>
                                                <%= safe(reason) %>
                                            </li>

                                        <% } %>

                                    </ul>


                                <% } else { %>


                                    <span class="muted">
                                        No specific risk reasons.
                                    </span>


                                <% } %>

                            </td>


                            <!-- IMPROVEMENT AREAS -->

                            <td>

                                <% if (risk.getImprovementAreas() != null
                                        && !risk.getImprovementAreas().isEmpty()) { %>


                                    <ul class="improvement-list">

                                        <% for (String area : risk.getImprovementAreas()) { %>

                                            <li>
                                                <%= safe(area) %>
                                            </li>

                                        <% } %>

                                    </ul>


                                <% } else { %>


                                    <span class="muted">
                                        No improvement suggestions.
                                    </span>


                                <% } %>

                            </td>


                        </tr>


                    <%  }

                       } else { %>


                        <tr>

                            <td colspan="7" class="empty">

                                No student risk records found.

                            </td>

                        </tr>


                    <% } %>


                    </tbody>

                </table>

            </div>

        </section>


    </main>

</div>


<!-- SUMMARY COUNTS FROM THE EXISTING RISK REPORTS -->

<script>

    document.addEventListener("DOMContentLoaded", function() {

        const rows = document.querySelectorAll(
            "#riskTable tbody tr[data-risk-status]"
        );

        let highRisk = 0;
        let attentionRisk = 0;
        let lowRisk = 0;
        let insufficientRisk = 0;

        rows.forEach(function(row) {

            const status = row.getAttribute("data-risk-status");

            if (status === "HIGH_RISK") {

                highRisk++;

            } else if (
                status === "ATTENDANCE_RISK" ||
                status === "ACADEMIC_RISK"
            ) {

                attentionRisk++;

            } else if (status === "LOW_RISK") {

                lowRisk++;

            } else if (status === "INSUFFICIENT_DATA") {

                insufficientRisk++;

            }

        });


        document.getElementById("highRiskCount").textContent = highRisk;

        document.getElementById("attentionRiskCount").textContent =
            attentionRisk;

        document.getElementById("lowRiskCount").textContent =
            lowRisk;

        document.getElementById("insufficientRiskCount").textContent =
            insufficientRisk;

    });

</script>


</body>

</html>