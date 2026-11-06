
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Dashboard | EduSphere</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

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

                <a class="nav-link active"
                   href="${pageContext.request.contextPath}/teacher/dashboard">
                    <span>🏠</span> Dashboard
                </a>

                <a class="nav-link"
                   href="${pageContext.request.contextPath}/teacher/attendance">
                    <span>📷</span> Attendance
                </a>

                <a class="nav-link"
                   href="${pageContext.request.contextPath}/teacher/assessments">
                    <span>📊</span> Academic Assessments
                </a>

                <a class="nav-link"
                   href="${pageContext.request.contextPath}/teacher/academic-risk">
                    <span>⚠️</span> Student Risk &amp; Interventions
                </a>
                <a class="nav-link"
   href="${pageContext.request.contextPath}/change-password">
    Change Password
</a>

            </nav>
        </div>

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

    <main class="main-content">

        <header class="topbar">

            <div>
                <p class="breadcrumb">Teacher / Dashboard</p>

                <h1 class="page-title">Teacher Dashboard</h1>

                <p class="page-description">
                    Manage your classes, attendance and academic activities.
                </p>
            </div>

            <div class="avatar">T</div>

        </header>

        <section class="panel"
                 style="padding:25px; margin-bottom:30px;">

            <h2>Welcome, ${teacherName}!</h2>

            <p class="page-description">
                You are successfully logged in as a Teacher.
            </p>

        </section>

        <section class="stats-grid">

            <article class="stat-card">

                <div class="stat-icon">🏫</div>

                <p class="stat-label">My Classes</p>

                <h2 class="stat-value">Classes</h2>

                <p class="page-description">
                    View your assigned classes.
                </p>

            </article>

            <article class="stat-card">

                <div class="stat-icon">📷</div>

                <p class="stat-label">Attendance</p>

                <h2 class="stat-value">QR Attendance</h2>

                <p class="page-description">
                    Generate QR codes and manage attendance.
                </p>

                <a class="btn btn-primary"
                   href="${pageContext.request.contextPath}/teacher/attendance">
                    Manage Attendance
                </a>

            </article>

            <article class="stat-card">

                <div class="stat-icon">📊</div>

                <p class="stat-label">Academic Performance</p>

                <h2 class="stat-value">Performance</h2>

                <p class="page-description">
                    Record assessments and manage marks for assigned subjects.
                </p>

                <a class="btn btn-primary"
                   href="${pageContext.request.contextPath}/teacher/assessments">
                    Manage Assessments
                </a>

            </article>

            <article class="stat-card">
                <div class="stat-icon">⚠️</div>
                <p class="stat-label">Student Support</p>
                <h2 class="stat-value">Risk &amp; Interventions</h2>
                <p class="page-description">
                    Review academic risk indicators and track student support actions.
                </p>
                <a class="btn btn-primary"
                   href="${pageContext.request.contextPath}/teacher/academic-risk">
                    View Student Risks
                </a>
            </article>

        </section>

    </main>

</div>

</body>
</html>
