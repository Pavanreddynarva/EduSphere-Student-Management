
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard | EduSphere</title>
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
                <span class="brand-subtitle">STUDENT PORTAL</span>
            </div>
        </div>

        <div>
            <p class="nav-label">STUDENT MENU</p>
            <nav class="nav-menu">

                <a class="nav-link active"
                   href="${pageContext.request.contextPath}/student/dashboard">
                    <span>🏠</span> Dashboard
                </a>

                <a class="nav-link"
                   href="${pageContext.request.contextPath}/student/attendance/history">
                    <span>📅</span> My Attendance
                </a>

                <a class="nav-link"
                   href="${pageContext.request.contextPath}/student/academic-progress">
                    <span>📊</span> My Academic Progress
                </a>

                <a class="nav-link"
                   href="${pageContext.request.contextPath}/student/grade-simulator">
                    <span>🧮</span> What-If Grade Simulator
                </a>

                <!-- Day 9: Improvement Plan navigation -->
                <a class="nav-link"
                   href="${pageContext.request.contextPath}/student/improvement-plan">
                    <span>📚</span> Improvement Plan
                </a>
                <a class="nav-link"
   href="${pageContext.request.contextPath}/change-password">
    Change Password
</a>

            </nav>
        </div>

        <div class="sidebar-footer">
            <p>EduSphere Student Portal</p>
            <form action="${pageContext.request.contextPath}/logout" method="post">
                <button type="submit" class="btn btn-danger">Logout</button>
            </form>
        </div>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div>
                <p class="breadcrumb">Student / Dashboard</p>
                <h1 class="page-title">Student Dashboard</h1>
                <p class="page-description">
                    Track your attendance, academics and learning progress.
                </p>
            </div>
            <div class="avatar">S</div>
        </header>

        <section class="panel" style="padding: 25px; margin-bottom: 25px;">
            <h2>Welcome, ${studentName}!</h2>
            <p class="page-description">
                You are successfully logged in as a Student.
            </p>
        </section>

        <section class="stats-grid">

            <article class="stat-card">
                <div class="stat-icon">👤</div>
                <p class="stat-label">My Profile</p>
                <h2 class="stat-value">Profile</h2>
                <p class="page-description">
                    View your personal and academic details.
                </p>
            </article>

            <article class="stat-card">
                <div class="stat-icon">📅</div>
                <p class="stat-label">My Attendance</p>
                <h2 class="stat-value">Attendance</h2>
                <p class="page-description">
                    View your attendance records.
                </p>
                <a class="btn btn-primary"
                   href="${pageContext.request.contextPath}/student/attendance/history">
                    View Attendance
                </a>
            </article>

            <article class="stat-card">
                <div class="stat-icon">📊</div>
                <p class="stat-label">Academic Performance</p>
                <h2 class="stat-value">Performance</h2>
                <p class="page-description">
                    View your subject marks, monthly averages and academic progress.
                </p>
                <a class="btn btn-primary"
                   href="${pageContext.request.contextPath}/student/academic-progress">
                    View Academic Progress
                </a>
            </article>

            <article class="stat-card">
                <div class="stat-icon">🧮</div>
                <p class="stat-label">What-If Grade Simulator</p>
                <h2 class="stat-value">Try Your Targets</h2>
                <p class="page-description">
                    Experiment with hypothetical marks without changing your official academic records.
                </p>
                <a class="btn btn-primary"
                   href="${pageContext.request.contextPath}/student/grade-simulator">
                    Open Grade Simulator
                </a>
            </article>

            <article class="stat-card">
                <div class="stat-icon">📚</div>
                <p class="stat-label">Study Recommendations</p>
                <h2 class="stat-value">Learning</h2>
                <p class="page-description">
                    Review weaker subjects, attendance patterns and a practical 7-day study plan.
                </p>
                <a class="btn btn-primary"
                   href="${pageContext.request.contextPath}/student/improvement-plan">
                    View Improvement Plan
                </a>
            </article>

        </section>

    </main>
</div>

</body>
</html>
