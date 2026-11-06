<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduSphere | Attendance</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/teacher-pages.css">
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
                <a class="nav-link" href="${pageContext.request.contextPath}/teacher/dashboard"><span>🏠</span> Dashboard</a>
                <a class="nav-link active" href="${pageContext.request.contextPath}/teacher/attendance"><span>📷</span> Attendance</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/teacher/assessments"><span>📊</span> Academic Assessments</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/teacher/academic-risk"><span>⚠️</span> Student Risk &amp; Interventions</a>
            </nav>
        </div>

        <div class="sidebar-footer">
            <p>EduSphere Teacher Portal</p>
            <form action="${pageContext.request.contextPath}/logout" method="post">
                <button type="submit" class="btn btn-danger">Logout</button>
            </form>
        </div>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div>
                <p class="breadcrumb">Teacher / Attendance</p>
                <h1 class="page-title">Attendance Management</h1>
                <p class="page-description">Create QR attendance sessions and maintain accurate class records.</p>
            </div>
            <div class="avatar" aria-label="Teacher">T</div>
        </header>

        <div class="teacher-page-content">
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success"><c:out value="${successMessage}"/></div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error"><c:out value="${errorMessage}"/></div>
            </c:if>

            <div class="teacher-card-grid">
                <section class="teacher-card">
                    <h2>Create Attendance Session</h2>
                    <p class="card-description">Choose one of your assigned classes. The QR code will remain active for five minutes.</p>

                    <c:choose>
                        <c:when test="${not empty assignments}">
                            <form method="post" action="${pageContext.request.contextPath}/teacher/attendance" class="teacher-form">
                                <input type="hidden" name="action" value="create">
                                <div class="form-group">
                                    <label for="assignmentId">Assigned class and subject</label>
                                    <select name="assignmentId" id="assignmentId" required>
                                        <option value="">Select an assignment</option>
                                        <c:forEach var="assignment" items="${assignments}">
                                            <option value="${assignment.assignmentId}">
                                                <c:out value="${assignment.department}"/> - Year <c:out value="${assignment.yearOfStudy}"/> - Section <c:out value="${assignment.section}"/> - <c:out value="${assignment.subjectName}"/>
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary">Generate Attendance QR</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">No class assignments found. Please contact the administrator.</div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <section class="teacher-card">
                    <h2>Correct Attendance</h2>
                    <p class="card-description">Update a record when required. A reason is mandatory, and each successful correction is added to the audit log.</p>
                    <form method="post" action="${pageContext.request.contextPath}/teacher/attendance" class="teacher-form">
                        <input type="hidden" name="action" value="correct">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="attendanceId">Attendance record ID</label>
                                <input type="number" id="attendanceId" name="attendanceId" min="1" placeholder="e.g. 125" required>
                            </div>
                            <div class="form-group">
                                <label for="status">Correct status</label>
                                <select id="status" name="status" required>
                                    <option value="">Select status</option>
                                    <option value="PRESENT">PRESENT</option>
                                    <option value="ABSENT">ABSENT</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="reason">Reason for correction</label>
                            <textarea id="reason" name="reason" rows="3" maxlength="500" placeholder="Briefly explain why this correction is required" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Update Attendance</button>
                    </form>
                </section>

                <c:if test="${not empty createdSession}">
                    <section class="teacher-card teacher-card-wide qr-panel">
                        <h2>Attendance session created</h2>
                        <p class="card-description">Ask students in the selected class to scan this QR code to mark their attendance.</p>
                        <img src="data:image/png;base64,${qrImage}" alt="Attendance QR Code" width="220" height="220">
                        <div class="session-meta">
                            <span class="meta-chip"><strong>Session ID:</strong> <c:out value="${createdSession.sessionId}"/></span>
                            <span class="meta-chip"><strong>Expires:</strong> <c:out value="${createdSession.expiryTime}"/></span>
                            <span class="meta-chip"><strong>Status:</strong> <c:out value="${createdSession.status}"/></span>
                        </div>
                        <p class="status-note">This QR code is valid for five minutes.</p>
                    </section>
                </c:if>
            </div>
        </div>
    </main>
</div>
</body>
</html>
