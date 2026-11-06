<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Academic Risk | EduSphere</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .risk-wrap {
            max-width: 1500px;
            margin: 0 auto;
        }

        .risk-card {
            background: #fff;
            border: 1px solid #e5eaf1;
            border-radius: 12px;
            padding: 20px;
            margin: 18px 0;
            box-shadow: 0 3px 12px rgba(20,35,60,.04);
        }

        .risk-table {
            width: 100%;
            border-collapse: collapse;
        }

        .risk-table th,
        .risk-table td {
            padding: 13px;
            border-bottom: 1px solid #e8edf4;
            text-align: left;
            vertical-align: top;
        }

        .risk-table th {
            background: #f3f6fb;
            white-space: nowrap;
        }

        .risk-pill {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 18px;
            font-size: 12px;
            font-weight: 700;
            background: #edf0f5;
            white-space: nowrap;
        }

        .HIGH_RISK {
            background: #ffe5e8;
            color: #a51f32;
        }

        .ATTENDANCE_RISK,
        .ACADEMIC_RISK {
            background: #fff1d8;
            color: #8a5100;
        }

        .LOW_RISK {
            background: #e2f7eb;
            color: #176b3c;
        }

        .INSUFFICIENT_DATA {
            background: #e8eaf0;
            color: #475569;
        }

        .risk-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(170px, 1fr));
            gap: 10px;
            align-items: end;
        }

        .risk-form label {
            display: block;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .risk-form input,
        .risk-form select,
        .risk-form textarea {
            width: 100%;
            padding: 9px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
        }

        .risk-form textarea {
            min-height: 42px;
        }

        .notice {
            padding: 12px 15px;
            border-radius: 8px;
            margin: 12px 0;
        }

        .ok {
            background: #e8f7ed;
            color: #176b3c;
        }

        .bad {
            background: #fff0f0;
            color: #a51f32;
        }

        .muted {
            color: #64748b;
        }

        .suggestion-list,
        .reason-list {
            padding-left: 19px;
            margin: 0;
        }

        .suggestion-list li,
        .reason-list li {
            margin-bottom: 6px;
            line-height: 1.5;
        }

        .suggestion-heading {
            color: #176b3c;
            font-weight: 700;
            margin-bottom: 7px;
        }

        .table-scroll {
            width: 100%;
            overflow-x: auto;
        }

        @media(max-width: 700px) {
            .risk-table {
                min-width: 1100px;
            }
        }
    </style>
</head>

<body>

<div class="app-layout">

    <!-- SIDEBAR -->
    <aside class="sidebar">

        <div class="brand">
            <div class="brand-icon">E</div>
            <div>
                <div class="brand-name">EduSphere</div>
                <span class="brand-subtitle">TEACHER PORTAL</span>
            </div>
        </div>

        <p class="nav-label">MAIN MENU</p>

        <nav class="nav-menu">

            <a class="nav-link"
               href="${pageContext.request.contextPath}/teacher/dashboard">
                🏠 Dashboard
            </a>

            <a class="nav-link"
               href="${pageContext.request.contextPath}/teacher/attendance">
                📷 Attendance
            </a>

            <a class="nav-link"
               href="${pageContext.request.contextPath}/teacher/assessments">
                📊 Academic Assessments
            </a>

            <a class="nav-link active"
               href="${pageContext.request.contextPath}/teacher/academic-risk">
                ⚠️ Student Risk & Interventions
            </a>

        </nav>

        <div class="sidebar-footer">
            <p>EduSphere Teacher Portal</p>

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

        <div class="risk-wrap">

            <header class="topbar">
                <div>
                    <p class="breadcrumb">Teacher / Academic Support</p>

                    <h1 class="page-title">
                        Student Risk & Interventions
                    </h1>

                    <p class="page-description">
                        Review risk indicators for your assigned classes
                        and record follow-up actions.
                    </p>
                </div>
            </header>


            <!-- NOTIFICATIONS -->
            <c:if test="${not empty success}">
                <div class="notice ok">
                    <c:out value="${success}"/>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="notice bad">
                    <c:out value="${error}"/>
                </div>
            </c:if>

            <c:if test="${not empty pageError}">
                <div class="notice bad">
                    <c:out value="${pageError}"/>
                </div>
            </c:if>


            <!-- RISK OVERVIEW -->
            <section class="risk-card">

                <h2>Risk Overview — Assigned Students Only</h2>

                <c:choose>

                    <c:when test="${empty risks}">
                        <p class="muted">
                            No students were found in your assigned classes.
                        </p>
                    </c:when>

                    <c:otherwise>

                        <div class="table-scroll">

                            <table class="risk-table">

                                <thead>
                                    <tr>
                                        <th>Student</th>
                                        <th>Class</th>
                                        <th>Attendance</th>
                                        <th>Academic</th>
                                        <th>Risk</th>
                                        <th>Risk Reasons</th>
                                        <th>Improvement Suggestions</th>
                                    </tr>
                                </thead>

                                <tbody>

                                    <c:forEach var="risk" items="${risks}">

                                        <tr>

                                            <!-- STUDENT -->
                                            <td>
                                                <strong>
                                                    <c:out value="${risk.fullName}"/>
                                                </strong>

                                                <br>

                                                <span class="muted">
                                                    <c:out value="${risk.rollNumber}"/>
                                                </span>
                                            </td>


                                            <!-- CLASS -->
                                            <td>
                                                <c:out value="${risk.department}"/>
                                                / Year
                                                <c:out value="${risk.yearOfStudy}"/>
                                                /
                                                <c:out value="${risk.section}"/>
                                            </td>


                                            <!-- ATTENDANCE -->
                                            <td>

                                                <c:choose>

                                                    <c:when test="${risk.attendancePercentage ne null}">

                                                        <c:out value="${risk.attendancePercentage}"/>%

                                                        <br>

                                                        <span class="muted">
                                                            (${risk.presentSessions}/${risk.totalSessions})
                                                        </span>

                                                    </c:when>

                                                    <c:otherwise>
                                                        Not available
                                                    </c:otherwise>

                                                </c:choose>

                                            </td>


                                            <!-- ACADEMIC PERFORMANCE -->
                                            <td>

                                                <c:choose>

                                                    <c:when test="${risk.academicPercentage ne null}">

                                                        <c:out value="${risk.academicPercentage}"/>%

                                                        <br>

                                                        <span class="muted">
                                                            (<c:out value="${risk.totalAssessments}"/> assessments)
                                                        </span>

                                                    </c:when>

                                                    <c:otherwise>
                                                        Not available
                                                    </c:otherwise>

                                                </c:choose>

                                            </td>


                                            <!-- RISK STATUS -->
                                            <td>
                                                <span class="risk-pill ${risk.riskStatus}">
                                                    <c:out value="${risk.riskStatus}"/>
                                                </span>
                                            </td>


                                            <!-- RISK REASONS -->
                                            <td>

                                                <c:choose>

                                                    <c:when test="${not empty risk.riskReasons}">

                                                        <ul class="reason-list">

                                                            <c:forEach var="reason"
                                                                       items="${risk.riskReasons}">

                                                                <li>
                                                                    <c:out value="${reason}"/>
                                                                </li>

                                                            </c:forEach>

                                                        </ul>

                                                    </c:when>

                                                    <c:otherwise>
                                                        <span class="muted">
                                                            No specific risk reasons available.
                                                        </span>
                                                    </c:otherwise>

                                                </c:choose>

                                            </td>


                                            <!-- IMPROVEMENT SUGGESTIONS -->
                                            <td>

                                                <c:choose>

                                                    <c:when test="${not empty risk.improvementAreas}">

                                                        <div class="suggestion-heading">
                                                            Recommended Actions
                                                        </div>

                                                        <ul class="suggestion-list">

                                                            <c:forEach var="suggestion"
                                                                       items="${risk.improvementAreas}">

                                                                <li>
                                                                    <c:out value="${suggestion}"/>
                                                                </li>

                                                            </c:forEach>

                                                        </ul>

                                                    </c:when>

                                                    <c:otherwise>

                                                        <span class="muted">
                                                            No specific improvement suggestions available.
                                                        </span>

                                                    </c:otherwise>

                                                </c:choose>

                                            </td>

                                        </tr>

                                    </c:forEach>

                                </tbody>

                            </table>

                        </div>

                    </c:otherwise>

                </c:choose>

            </section>


            <!-- RECORD INTERVENTION -->
            <section class="risk-card">

                <h2>Record a Student Intervention</h2>

                <p class="muted">
                    You can record actions only for students belonging
                    to your assigned classes.
                </p>

                <form class="risk-form"
                      method="post"
                      action="${pageContext.request.contextPath}/teacher/academic-risk">

                    <input type="hidden" name="action" value="record">


                    <div>
                        <label for="studentId">Student</label>

                        <select id="studentId" name="studentId" required>

                            <option value="">Select student</option>

                            <c:forEach var="risk" items="${risks}">

                                <option value="${risk.studentId}">
                                    <c:out value="${risk.fullName}"/>
                                    —
                                    <c:out value="${risk.rollNumber}"/>
                                </option>

                            </c:forEach>

                        </select>
                    </div>


                    <div>
                        <label for="interventionType">
                            Intervention Type
                        </label>

                        <select id="interventionType"
                                name="interventionType"
                                required>

                            <option value="">Select type</option>
                            <option value="COUNSELLING">Counselling</option>
                            <option value="PARENT_MEETING">Parent meeting</option>
                            <option value="REMEDIAL_CLASS">Remedial class</option>
                            <option value="ACADEMIC_GUIDANCE">Academic guidance</option>
                            <option value="ATTENDANCE_FOLLOW_UP">Attendance follow-up</option>
                            <option value="OTHER">Other</option>

                        </select>
                    </div>


                    <div>
                        <label for="actionTaken">Action Taken</label>

                        <input id="actionTaken"
                               name="actionTaken"
                               maxlength="1000"
                               required>
                    </div>


                    <div>
                        <label for="followUpDate">Follow-up Date</label>

                        <input id="followUpDate"
                               name="followUpDate"
                               type="date">
                    </div>


                    <div>
                        <label for="notes">Notes</label>

                        <input id="notes"
                               name="notes"
                               maxlength="2000">
                    </div>


                    <div>
                        <button class="btn btn-primary" type="submit">
                            Save Intervention
                        </button>
                    </div>

                </form>

            </section>


            <!-- INTERVENTION HISTORY -->
            <section class="risk-card">

                <h2>My Intervention Records</h2>

                <c:choose>

                    <c:when test="${empty interventions}">

                        <p class="muted">
                            You have not recorded any interventions yet.
                        </p>

                    </c:when>

                    <c:otherwise>

                        <div class="table-scroll">

                            <table class="risk-table">

                                <thead>
                                    <tr>
                                        <th>Student ID</th>
                                        <th>Type</th>
                                        <th>Action</th>
                                        <th>Follow-up Date</th>
                                        <th>Status / Update</th>
                                        <th>Notes</th>
                                    </tr>
                                </thead>

                                <tbody>

                                    <c:forEach var="item" items="${interventions}">

                                        <tr>

                                            <td>
                                                <c:out value="${item.studentId}"/>
                                            </td>

                                            <td>
                                                <c:out value="${item.interventionType}"/>
                                            </td>

                                            <td>
                                                <c:out value="${item.actionTaken}"/>
                                            </td>

                                            <td>
                                                <c:out value="${item.followUpDate}"/>
                                            </td>


                                            <!-- FOLLOW-UP STATUS -->
                                            <td>

                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/teacher/academic-risk"
                                                      class="risk-form">

                                                    <input type="hidden"
                                                           name="action"
                                                           value="update">

                                                    <input type="hidden"
                                                           name="interventionId"
                                                           value="${item.interventionId}">


                                                    <select name="followUpStatus">

                                                        <option value="PENDING"
                                                            ${item.followUpStatus eq 'PENDING' ? 'selected' : ''}>
                                                            Pending
                                                        </option>

                                                        <option value="COMPLETED"
                                                            ${item.followUpStatus eq 'COMPLETED' ? 'selected' : ''}>
                                                            Completed
                                                        </option>

                                                        <option value="OVERDUE"
                                                            ${item.followUpStatus eq 'OVERDUE' ? 'selected' : ''}>
                                                            Overdue
                                                        </option>

                                                    </select>


                                                    <button class="btn btn-primary"
                                                            type="submit">
                                                        Update
                                                    </button>

                                                </form>

                                            </td>


                                            <td>
                                                <c:out value="${item.notes}"/>
                                            </td>

                                        </tr>

                                    </c:forEach>

                                </tbody>

                            </table>

                        </div>

                    </c:otherwise>

                </c:choose>

            </section>

        </div>

    </main>

</div>

</body>
</html>