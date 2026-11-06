<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Personalized Improvement Plan | EduSphere</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
.plan-wrap{max-width:1150px}.plan-card{background:#fff;border:1px solid #e5e7eb;border-radius:14px;padding:22px;margin:0 0 20px;box-shadow:0 3px 12px rgba(20,35,60,.04)}
.plan-card h2{font-size:19px;margin:0 0 14px;color:#172033}.muted{color:#64748b;font-size:13px}.subject-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(245px,1fr));gap:14px}
.subject{border:1px solid #e2e8f0;border-radius:12px;padding:17px}.subject h3{margin:0 0 12px;font-size:17px}.metric{display:flex;justify-content:space-between;gap:10px;padding:7px 0;border-bottom:1px solid #f1f5f9;font-size:13px}.metric:last-child{border:0}
.tag{display:inline-block;border-radius:20px;padding:5px 10px;font-size:11px;font-weight:700;background:#e2e8f0;color:#475569}.HIGH{background:#fee2e2;color:#991b1b}.MEDIUM{background:#fef3c7;color:#92400e}.MAINTAIN{background:#dcfce7;color:#166534}
.week-list{list-style:none;padding:0;margin:0;display:grid;gap:10px}.week-list li{padding:13px 15px;background:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;color:#334155;font-size:13px;line-height:1.55}.notice{background:#eff6ff;border:1px solid #bfdbfe;color:#1e40af;padding:13px 15px;border-radius:10px;font-size:13px;margin-bottom:18px}.error{background:#fee2e2;color:#991b1b;padding:14px;border-radius:10px}
</style></head>
<body><div class="app-layout">
<aside class="sidebar"><div class="brand"><div class="brand-icon">E</div><div><div class="brand-name">EduSphere</div><span class="brand-subtitle">STUDENT PORTAL</span></div></div>
<div><p class="nav-label">STUDENT MENU</p><nav class="nav-menu">
<a class="nav-link" href="${pageContext.request.contextPath}/student/dashboard"><span>🏠</span> Dashboard</a>
<a class="nav-link" href="${pageContext.request.contextPath}/student/attendance/history"><span>📅</span> My Attendance</a>
<a class="nav-link" href="${pageContext.request.contextPath}/student/academic-progress"><span>📊</span> My Academic Progress</a>
<a class="nav-link" href="${pageContext.request.contextPath}/student/grade-simulator"><span>🧮</span> What-If Grade Simulator</a>
<a class="nav-link active" href="${pageContext.request.contextPath}/student/improvement-plan"><span>📚</span> Improvement Plan</a>
</nav></div>
<div class="sidebar-footer"><p>EduSphere Student Portal</p><form action="${pageContext.request.contextPath}/logout" method="post"><button type="submit" class="btn btn-danger">Logout</button></form></div></aside>
<main class="main-content"><header class="topbar"><div><p class="breadcrumb">Student / Improvement Plan</p><h1 class="page-title">Personalized Improvement Plan</h1><p class="page-description">Subject performance, attendance insights and your next 7 days of study.</p></div><div class="avatar">S</div></header>
<div class="plan-wrap">
<c:if test="${not empty errorMessage}"><div class="error">${errorMessage}</div></c:if>
<c:if test="${empty errorMessage}">
<div class="notice">This plan uses completed assessments only. Future-dated assessments are excluded. Attendance counts sessions dated today or earlier; sessions without a PRESENT record count as not attended. This page is read-only and does not change official records.</div>
<section class="plan-card"><h2>Subject analysis</h2><p class="muted">Weighted average = total marks obtained ÷ total maximum marks. Trend is shown only when at least four completed assessments are available.</p>
<c:choose><c:when test="${empty subjects}"><p class="muted">No subject assignments were found for your class yet.</p></c:when><c:otherwise><div class="subject-grid"><c:forEach var="s" items="${subjects}"><article class="subject"><h3>${s.subjectName}</h3><div class="metric"><span>Completed assessments</span><strong>${s.assessmentCount}</strong></div><div class="metric"><span>Weighted average</span><strong><c:choose><c:when test="${s.averagePercentage != null}">${s.averagePercentage}%</c:when><c:otherwise>Not available</c:otherwise></c:choose></strong></div><div class="metric"><span>Attendance</span><strong><c:choose><c:when test="${s.totalSessions gt 0}"><fmt:formatNumber value="${s.attendancePercentage}" maxFractionDigits="1"/>% (${s.presentSessions}/${s.totalSessions})</c:when><c:otherwise>No sessions</c:otherwise></c:choose></strong></div><div class="metric"><span>Recent trend</span><strong>${s.trend}</strong></div><div class="metric"><span>Study priority</span><span class="tag ${s.priority}">${s.priority}</span></div></article></c:forEach></div></c:otherwise></c:choose>
</section>
<section class="plan-card"><h2>Your 7-day study plan</h2><p class="muted">Suggested daily study time: approximately 60–90 minutes. Adjust it around your classes and other commitments.</p><ol class="week-list"><c:forEach var="task" items="${weeklyPlan}"><li>${task}</li></c:forEach></ol></section>
<section class="plan-card"><h2>How priorities are assigned</h2><ul class="muted"><li><strong>High:</strong> completed assessment average below 60% or a declining trend.</li><li><strong>Medium:</strong> attendance below 75% or assessment average below 75%.</li><li><strong>Maintain:</strong> no current high/medium signal.</li><li><strong>Needs more data:</strong> insufficient assessment and attendance history.</li></ul></section>
</c:if>
<a class="btn btn-primary" href="${pageContext.request.contextPath}/student/dashboard">Back to Dashboard</a>
</div></main></div></body></html>
