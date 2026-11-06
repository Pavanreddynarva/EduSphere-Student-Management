<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>EduSphere | Admin Dashboard</title>

<style>
:root{
 --primary:#5b45c5;--primary-dark:#43319b;--primary-light:#f0edff;
 --bg:#f5f7fb;--surface:#fff;--text:#17233d;--muted:#66738a;
 --border:#e5eaf2;--green:#16845b;--red:#c44750;
 --shadow:0 8px 24px rgba(24,39,75,.055)
}
*{box-sizing:border-box}
html{scroll-behavior:smooth;scroll-padding-top:24px}
body{margin:0;background:var(--bg);color:var(--text);
 font-family:Inter,"Segoe UI",Arial,sans-serif;overflow-x:hidden}
a{text-decoration:none;color:inherit}
button,input,select{font:inherit}
.layout{display:flex;width:100%;min-height:100vh}
.sidebar{
 position:sticky;top:0;width:250px;height:100vh;flex:0 0 250px;
 padding:27px 17px;background:#17233d;color:#fff;
 display:flex;flex-direction:column;overflow-y:auto
}
.brand{font-size:25px;font-weight:800;padding:5px 12px 32px;letter-spacing:-.5px}
.brand span{color:#bdb1ff}
.nav-label{font-size:10px;letter-spacing:1.5px;color:#aebbd0;padding:0 12px;margin:12px 0}
.nav{display:flex;flex-direction:column;gap:5px}
.nav a{display:flex;align-items:center;gap:12px;padding:12px 13px;
 border-radius:10px;color:#dce4f1;margin:0;font-size:13px;transition:background .2s,color .2s}
.nav a:hover,.nav a.active{background:#303e5c;color:#fff}
.nav a.active{box-shadow:inset 3px 0 #9b8cff}
.sidebar-bottom{margin-top:auto;padding:18px 12px 0;border-top:1px solid #ffffff25;font-size:12px;color:#c4cede}
.sidebar-bottom a{display:inline-block;margin-top:12px;padding:9px 13px;background:#ffffff18;border-radius:8px}
.main{flex:1;width:calc(100% - 250px);min-width:0;max-width:none;margin:0;padding:30px clamp(18px,2.2vw,38px)}
.topbar{display:flex;justify-content:space-between;align-items:center;gap:15px;flex-wrap:wrap;margin-bottom:22px}
.eyebrow{font-size:11px;color:var(--primary);font-weight:750;letter-spacing:1px;text-transform:uppercase}
h1{font-size:29px;letter-spacing:-.7px;margin:7px 0;color:var(--text)}
.subtitle{font-size:14px;color:var(--muted);margin:0}
.top-actions{display:flex;gap:9px;flex-wrap:wrap}
.btn{display:inline-flex;align-items:center;justify-content:center;padding:10px 14px;border:0;border-radius:9px;
 background:var(--primary);color:#fff;font-size:12px;font-weight:650;cursor:pointer;transition:.2s}
.btn:hover{background:var(--primary-dark);transform:translateY(-1px)}
.btn.light{background:var(--primary-light);color:var(--primary-dark)}
.btn.light:hover{background:#e5e0ff}
.stats{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:15px;margin:22px 0 18px}
.stat{background:var(--surface);border:1px solid var(--border);border-radius:14px;padding:19px;box-shadow:var(--shadow);min-width:0}
.stat-top{display:flex;justify-content:space-between;align-items:center}
.stat-icon{width:36px;height:36px;border-radius:10px;display:grid;place-items:center;background:var(--primary-light);color:var(--primary);font-weight:800}
.stat-label{font-size:12px;color:var(--muted);margin:13px 0 6px}
.stat-value{font-size:26px;font-weight:800;color:var(--text);overflow-wrap:anywhere}
.stat-foot{font-size:11px;color:var(--muted);margin-top:5px}
.section-heading{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin:8px 0 14px}
.section-heading h2{font-size:18px;margin:0;color:var(--text)}
.section-heading p{font-size:12px;color:var(--muted);margin:5px 0 0}
.grid-two{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:17px}
.card{background:var(--surface);border:1px solid var(--border);border-radius:15px;padding:21px;
 box-shadow:var(--shadow);min-width:0;margin-bottom:17px;scroll-margin-top:20px}
.card h3{font-size:16px;margin:0 0 5px}
.card-sub{font-size:12px;color:var(--muted);margin:0 0 18px}
.wide{grid-column:1/-1}
.chart-row{display:grid;grid-template-columns:minmax(75px,1fr) 2fr 55px;gap:12px;align-items:center;margin:16px 0;font-size:12px}
.chart-label{overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.bar{height:9px;border-radius:20px;background:#e9edf5;overflow:hidden}
.fill{height:100%;border-radius:20px;background:linear-gradient(90deg,#5b45c5,#9d8cf5)}
.chart-value{text-align:right;font-weight:700}
.table-wrap{width:100%;max-width:100%;overflow:auto;max-height:480px;border:1px solid var(--border);border-radius:10px}
table{width:100%;border-collapse:collapse;font-size:12px}
th,td{padding:12px 13px;text-align:left;border-bottom:1px solid var(--border);white-space:nowrap}
th{background:#f5f6fb;color:#53617a;font-size:11px;text-transform:uppercase;letter-spacing:.4px;position:sticky;top:0;z-index:1}
td{color:#43516a}
tbody tr:hover{background:#f8f9fd}
.empty{padding:24px;text-align:center;color:var(--muted)}
.filters,.form-row{display:flex;gap:9px;flex-wrap:wrap;align-items:end;margin:15px 0}
input,select{border:1px solid #d9e0eb;border-radius:8px;padding:10px 11px;background:#fff;color:var(--text);min-width:100px;max-width:100%;font-size:12px}
input:focus,select:focus{outline:2px solid #d8d1ff;border-color:var(--primary)}
.filters input{flex:1}
.form-row label{display:flex;flex-direction:column;gap:6px;color:var(--muted);font-size:11px}
.form-row label input,.form-row label select{min-width:130px}
.muted{font-size:11px;color:var(--muted);line-height:1.6}
.good{padding:12px 15px;background:#e9f8f0;color:var(--green);border-radius:9px;font-size:13px}
.bad{padding:12px 15px;background:#fff0f0;color:var(--red);border-radius:9px;font-size:13px}
.pill{display:inline-block;padding:5px 9px;border-radius:20px;background:var(--primary-light);color:var(--primary-dark);font-size:11px}
.report-links{display:flex;gap:9px;flex-wrap:wrap;margin:15px 0}
.report-links a{padding:10px 13px;background:var(--primary-light);color:var(--primary-dark);border-radius:8px;font-size:12px;font-weight:650}
.report-links a:hover{background:#e5e0ff}
.anchor{scroll-margin-top:20px}
.embed-panel{padding:0;overflow:hidden;border:1px solid var(--border);border-radius:12px;background:#fff}
.admin-embedded-frame{display:block;width:100%;min-height:700px;border:0;background:#fff;border-radius:12px;overflow:hidden}
#user-management,#academic-risk,#student-crud{scroll-margin-top:22px}
@media(max-width:1250px){.stats{grid-template-columns:repeat(3,minmax(0,1fr))}}
@media(max-width:850px){
 .layout{display:block}.sidebar{position:relative;width:100%;height:auto;padding:15px;overflow:visible}
 .brand{padding:5px 8px 13px}.nav{flex-direction:row;overflow-x:auto;gap:4px}
 .nav-label,.sidebar-bottom{display:none}.nav a{white-space:nowrap;font-size:12px}
 .main{width:100%;padding:20px 14px}.stats{grid-template-columns:repeat(2,minmax(0,1fr))}
 .grid-two{grid-template-columns:1fr}.wide{grid-column:auto}h1{font-size:24px}
}
@media(max-width:480px){.stats{grid-template-columns:1fr}.card{padding:15px}.chart-row{grid-template-columns:75px 1fr 45px}}
</style>
</head>

<body>
<div class="layout">

<aside class="sidebar">
    <div class="brand">Edu<span>Sphere</span></div>
    <div class="nav-label">MAIN MENU</div>
    <nav class="nav">
        <a class="active" href="#overview">▦ Dashboard</a>
        <a href="#students">♙ Students</a>
        <a href="#performance">▤ Performance</a>
        <a href="#user-management">♧ User Management</a>
        <a href="#academic-risk">⚑ Academic Risk</a>
        <a href="#teachers">♧ Teachers</a>
        <a href="#timetable">▤ Timetable</a>
        <a href="#fees">₹ Fee Records</a>
        <a href="#reports">⇩ Reports</a>
        <a href="#student-crud">Student CRUD</a>
    </nav>
    <div class="sidebar-bottom">
        <div>EduSphere Student Management</div>
        <a href="${pageContext.request.contextPath}/logout">Logout ↗</a>
    </div>
</aside>

<main class="main">

<header class="topbar" id="overview">
    <div>
        <div class="eyebrow">Administration / Overview</div>
        <h1>Admin Dashboard</h1>
        <p class="subtitle">Your institution's academic and administrative overview.</p>
    </div>
    <div class="top-actions">
        <a class="btn light" href="#students">View students</a>
        <a class="btn" href="${pageContext.request.contextPath}/admin/reports?format=csv&amp;report=students">Export overview ↓</a>
    </div>
</header>

<c:if test="${param.message eq 'saved'}">
    <p class="good">✓ Your changes were saved successfully.</p>
</c:if>

<section class="stats">
    <div class="stat">
        <div class="stat-top"><span class="stat-icon">♙</span><span class="pill">Students</span></div>
        <div class="stat-label">Total students</div>
        <div class="stat-value"><c:out value="${totalStudents}" default="0"/></div>
        <div class="stat-foot">Registered student records</div>
    </div>
    <div class="stat">
        <div class="stat-top"><span class="stat-icon">♧</span><span class="pill">Faculty</span></div>
        <div class="stat-label">Total teachers</div>
        <div class="stat-value"><c:out value="${totalTeachers}" default="0"/></div>
        <div class="stat-foot">Registered teacher accounts</div>
    </div>
    <div class="stat">
        <div class="stat-top"><span class="stat-icon">％</span><span class="pill">Academics</span></div>
        <div class="stat-label">Assessment average</div>
        <div class="stat-value"><c:out value="${averageMarks}" default="—"/>%</div>
        <div class="stat-foot">Completed assessments</div>
    </div>
    <div class="stat">
        <div class="stat-top"><span class="stat-icon">✓</span><span class="pill">Attendance</span></div>
        <div class="stat-label">Attendance rate</div>
        <div class="stat-value"><c:out value="${attendanceRate}" default="—"/>%</div>
        <div class="stat-foot">Eligible sessions to date</div>
    </div>
    <div class="stat">
        <div class="stat-top"><span class="stat-icon">!</span><span class="pill">Attention</span></div>
        <div class="stat-label">Students flagged</div>
        <div class="stat-value"><c:out value="${highRiskCount}" default="0"/></div>
        <div class="stat-foot">Below marks or attendance threshold</div>
    </div>
</section>

<div class="section-heading" id="performance">
    <div><h2>Academic performance</h2>
    <p>Subject averages and completed assessment trends.</p></div>
</div>

<div class="grid-two">
    <section class="card">
        <h3>Subject-wise performance</h3>
        <p class="card-sub">Weighted average by subject</p>
        <c:forEach items="${subjects}" var="r">
            <div class="chart-row">
                <span class="chart-label"><c:out value="${r.subject_name}"/></span>
                <div class="bar"><div class="fill" style="width:${r.average_marks}%"></div></div>
                <span class="chart-value"><c:out value="${r.average_marks}"/>%</span>
            </div>
        </c:forEach>
        <c:if test="${empty subjects}"><div class="empty">No completed assessments available.</div></c:if>
    </section>

    <section class="card">
        <h3>Monthly performance trend</h3>
        <p class="card-sub">Average marks by assessment month</p>
        <c:forEach items="${monthly}" var="r">
            <div class="chart-row">
                <span class="chart-label"><c:out value="${r.month}"/></span>
                <div class="bar"><div class="fill" style="width:${r.average_marks}%"></div></div>
                <span class="chart-value"><c:out value="${r.average_marks}"/>%</span>
            </div>
        </c:forEach>
        <c:if test="${empty monthly}"><div class="empty">No monthly assessment data available.</div></c:if>
    </section>
</div>

<section class="card anchor" id="students">
    <div class="section-heading">
        <div><h2>Student directory</h2>
        <p>Search student records and view individual academic snapshots.</p></div>
        <a class="btn" href="#student-crud">Manage student records</a>
    </div>

    <form class="filters" method="get" action="${pageContext.request.contextPath}/admin/dashboard">
        <input name="q" placeholder="Search student, roll number or subject" value="${fn:escapeXml(param.q)}">
        <input name="department" placeholder="Department" value="${fn:escapeXml(param.department)}">
        <input name="year" type="number" min="1" placeholder="Year" value="${fn:escapeXml(param.year)}">
        <input name="section" placeholder="Section" value="${fn:escapeXml(param.section)}">
        <button class="btn">Apply filters</button>
        <a class="btn light" href="${pageContext.request.contextPath}/admin/dashboard#students">Reset</a>
    </form>

    <div class="table-wrap">
    <table>
        <thead><tr>
            <th>ID</th><th>Roll number</th><th>Student</th>
            <th>Department</th><th>Year</th><th>Section</th>
            <th>Average marks</th><th>Attendance</th><th>Reports</th>
        </tr></thead>
        <tbody>
        <c:forEach items="${students}" var="r">
            <tr>
                <td><c:out value="${r.student_id}"/></td>
                <td><c:out value="${r.roll_number}"/></td>
                <td><strong><c:out value="${r.full_name}"/></strong></td>
                <td><c:out value="${r.department}"/></td>
                <td><c:out value="${r.year_of_study}"/></td>
                <td><c:out value="${r.section}"/></td>
                <td><c:out value="${r.average_marks}" default="—"/>%</td>
                <td><c:out value="${r.attendance_rate}" default="—"/>%</td>
                <td>
                    <a class="btn light" href="${pageContext.request.contextPath}/admin/reports?format=csv&amp;report=assessments&amp;studentId=${r.student_id}">Marks</a>
                    <a class="btn light" href="${pageContext.request.contextPath}/admin/reports?format=csv&amp;report=attendance&amp;studentId=${r.student_id}">Attendance</a>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty students}">
            <tr><td colspan="9" class="empty">No student records match these filters.</td></tr>
        </c:if>
        </tbody>
    </table>
    </div>
</section>

<section class="card anchor" id="teachers">
    <div class="section-heading">
        <div><h2>Teacher management</h2>
        <p>Teacher directory and subject/class allocations.</p></div>
        <a class="btn light" href="#user-management">Manage accounts</a>
    </div>
    <div class="table-wrap">
    <table>
        <thead><tr><th>Teacher ID</th><th>Name</th><th>Email</th><th>Assignments</th><th>Classes and subjects</th></tr></thead>
        <tbody>
        <c:forEach items="${teachers}" var="r">
            <tr>
                <td><c:out value="${r.user_id}"/></td>
                <td><strong><c:out value="${r.full_name}"/></strong></td>
                <td><c:out value="${r.email}"/></td>
                <td><c:out value="${r.class_count}"/></td>
                <td><c:out value="${r.subjects}" default="Not assigned"/></td>
            </tr>
        </c:forEach>
        <c:if test="${empty teachers}">
            <tr><td colspan="5" class="empty">No teacher accounts found.</td></tr>
        </c:if>
        </tbody>
    </table>
    </div>

    <h3 style="margin-top:25px">Assign teacher to class and subject</h3>
    <form class="form-row" method="post" action="${pageContext.request.contextPath}/admin/operations">
        <input type="hidden" name="action" value="assign">
        <label>Teacher
            <select name="teacherId" required>
                <c:forEach items="${teachers}" var="t">
                    <option value="${t.user_id}"><c:out value="${t.full_name}"/> (#<c:out value="${t.user_id}"/>)</option>
                </c:forEach>
            </select>
        </label>
        <label>Department<input name="department" maxlength="50" placeholder="CSE" required></label>
        <label>Year<input name="year" type="number" min="1" max="4" required></label>
        <label>Section<input name="section" maxlength="20" required></label>
        <label>Subject<input name="subject" maxlength="100" required></label>
        <button class="btn" type="submit">Save allocation</button>
    </form>
</section>

<section class="card anchor" id="timetable">
    <div class="section-heading">
        <div><h2>Class timetable</h2>
        <p>View and add timetable slots for assigned classes.</p></div>
    </div>
    <div class="table-wrap">
    <table>
        <thead><tr><th>Day</th><th>Start</th><th>End</th><th>Room</th><th>Subject</th><th>Class</th><th>Teacher</th></tr></thead>
        <tbody>
        <c:forEach items="${timetable}" var="r">
            <tr>
                <td><c:out value="${r.day_of_week}"/></td>
                <td><c:out value="${r.start_time}"/></td>
                <td><c:out value="${r.end_time}"/></td>
                <td><c:out value="${r.room_number}"/></td>
                <td><c:out value="${r.subject_name}"/></td>
                <td><c:out value="${r.department}"/> <c:out value="${r.year_of_study}"/>-<c:out value="${r.section}"/></td>
                <td><c:out value="${r.teacher_name}"/></td>
            </tr>
        </c:forEach>
        <c:if test="${empty timetable}">
            <tr><td colspan="7" class="empty">No timetable slots have been added.</td></tr>
        </c:if>
        </tbody>
    </table>
    </div>

    <h3 style="margin-top:25px">Add timetable slot</h3>
    <form class="form-row" method="post" action="${pageContext.request.contextPath}/admin/operations">
        <input type="hidden" name="action" value="timetable">
        <label>Assigned subject
            <select name="assignmentId" required>
                <c:forEach items="${assignments}" var="a">
                    <option value="${a.assignment_id}">
                        <c:out value="${a.subject_name}"/> ·
                        <c:out value="${a.department}"/> <c:out value="${a.year_of_study}"/>-<c:out value="${a.section}"/> ·
                        <c:out value="${a.teacher_name}"/>
                    </option>
                </c:forEach>
            </select>
        </label>
        <label>Day
            <select name="day" required>
                <option value="MONDAY">Monday</option><option value="TUESDAY">Tuesday</option>
                <option value="WEDNESDAY">Wednesday</option><option value="THURSDAY">Thursday</option>
                <option value="FRIDAY">Friday</option><option value="SATURDAY">Saturday</option>
                <option value="SUNDAY">Sunday</option>
            </select>
        </label>
        <label>Start<input type="time" name="start" required></label>
        <label>End<input type="time" name="end" required></label>
        <label>Room<input name="room" maxlength="40" required></label>
        <button class="btn" type="submit">Add slot</button>
    </form>
    <p class="muted">Current timetable registration does not yet prevent teacher, room or class time conflicts.</p>
</section>

<section class="card anchor" id="fees">
    <div class="section-heading">
        <div><h2>Fee management</h2>
        <p>Recorded fee totals, paid amounts and outstanding balances.</p></div>
    </div>
    <div class="table-wrap">
    <table>
        <thead><tr><th>Student</th><th>Roll number</th><th>Academic year</th><th>Total</th><th>Paid</th><th>Pending</th><th>Last updated</th></tr></thead>
        <tbody>
        <c:forEach items="${fees}" var="r">
            <tr>
                <td><c:out value="${r.full_name}"/></td>
                <td><c:out value="${r.roll_number}"/></td>
                <td><c:out value="${r.academic_year}"/></td>
                <td>₹<c:out value="${r.total_amount}"/></td>
                <td>₹<c:out value="${r.paid_amount}"/></td>
                <td><strong>₹<c:out value="${r.pending_amount}"/></strong></td>
                <td><c:out value="${r.updated_at}"/></td>
            </tr>
        </c:forEach>
        <c:if test="${empty fees}">
            <tr><td colspan="7" class="empty">No fee accounts have been recorded.</td></tr>
        </c:if>
        </tbody>
    </table>
    </div>

    <h3 style="margin-top:25px">Add or update a fee account</h3>
    <form class="form-row" method="post" action="${pageContext.request.contextPath}/admin/operations">
        <input type="hidden" name="action" value="fee">
        <label>Student
            <select name="studentId" required>
                <c:forEach items="${students}" var="s">
                    <option value="${s.student_id}"><c:out value="${s.full_name}"/> (#<c:out value="${s.student_id}"/>)</option>
                </c:forEach>
            </select>
        </label>
        <label>Academic year<input name="academicYear" placeholder="2026-2027" pattern="[0-9]{4}-[0-9]{4}" required></label>
        <label>Total fee ₹<input name="total" type="number" min="0" step="0.01" required></label>
        <label>Amount paid ₹<input name="paid" type="number" min="0" step="0.01" required></label>
        <button class="btn" type="submit">Save fee account</button>
    </form>
    <p class="muted">This is a fee-balance register, not an individual payment transaction history.</p>
</section>

<section class="card anchor" id="reports">
    <div class="section-heading">
        <div><h2>Reports and exports</h2>
        <p>Download administrative records as CSV files.</p></div>
    </div>
    <div class="report-links">
        <a href="${pageContext.request.contextPath}/admin/reports?format=csv&amp;report=students">↓ Students CSV</a>
        <a href="${pageContext.request.contextPath}/admin/reports?format=csv&amp;report=teachers">↓ Teachers CSV</a>
        <a href="${pageContext.request.contextPath}/admin/reports?format=csv&amp;report=assessments">↓ Assessment CSV</a>
        <a href="${pageContext.request.contextPath}/admin/reports?format=csv&amp;report=attendance">↓ Attendance CSV</a>
        <a href="${pageContext.request.contextPath}/admin/reports?format=csv&amp;report=fees">↓ Fees CSV</a>
        <a href="${pageContext.request.contextPath}/admin/reports?format=csv&amp;report=timetable">↓ Timetable CSV</a>
        <a href="${pageContext.request.contextPath}/admin/reports?format=csv&amp;report=monthly">↓ Monthly CSV</a>
    </div>

    <h3 style="margin-top:22px">Assessment records</h3>
    <div class="table-wrap">
    <table>
        <thead><tr><th>Student</th><th>Subject</th><th>Assessment</th><th>Date</th><th>Obtained</th><th>Maximum</th><th>Percentage</th></tr></thead>
        <tbody>
        <c:forEach items="${assessments}" var="r">
            <tr>
                <td><c:out value="${r.full_name}"/></td>
                <td><c:out value="${r.subject_name}"/></td>
                <td><c:out value="${r.assessment_name}"/></td>
                <td><c:out value="${r.assessment_date}"/></td>
                <td><c:out value="${r.marks_obtained}"/></td>
                <td><c:out value="${r.max_marks}"/></td>
                <td><c:out value="${r.percentage}"/>%</td>
            </tr>
        </c:forEach>
        <c:if test="${empty assessments}">
            <tr><td colspan="7" class="empty">No completed assessment records found.</td></tr>
        </c:if>
        </tbody>
    </table>
    </div>
</section>

<section class="card anchor" id="user-management">
    <div class="section-heading">
        <div><h2>User Management</h2>
        <p>Create teacher/student accounts and manage registered user roles.</p></div>
    </div>
    <div class="embed-panel">
        <iframe class="admin-embedded-frame" title="User Management"
                src="${pageContext.request.contextPath}/admin/users?embed=1"></iframe>
    </div>
</section>

<section class="card anchor" id="academic-risk">
    <div class="section-heading">
        <div><h2>Academic Risk &amp; Interventions</h2>
        <p>Review student risk indicators and record follow-up actions.</p></div>
    </div>
    <div class="embed-panel">
        <iframe class="admin-embedded-frame" title="Academic Risk"
                src="${pageContext.request.contextPath}/admin/academic-risk?embed=1"></iframe>
    </div>
</section>

<section class="card anchor" id="student-crud">
    <div class="section-heading">
        <div><h2>Student Record Management</h2>
        <p>Add, search, edit and delete student records.</p></div>
    </div>
    <div class="embed-panel">
        <iframe class="admin-embedded-frame" title="Student CRUD"
                src="${pageContext.request.contextPath}/students?embed=1"></iframe>
    </div>
</section>

<script>
(function () {
    document.querySelectorAll(".admin-embedded-frame").forEach(function (frame) {
        function unifyFrame() {
            try {
                const doc = frame.contentDocument;
                if (!doc || !doc.body) return;

                let style = doc.getElementById("edusphere-embed-style");
                if (!style) {
                    style = doc.createElement("style");
                    style.id = "edusphere-embed-style";
                    doc.head.appendChild(style);
                }

                style.textContent = `
                    html, body {
                        margin: 0 !important;
                        padding: 0 !important;
                        width: 100% !important;
                        max-width: 100% !important;
                        overflow-x: hidden !important;
                        background: #fff !important;
                        font-family: Inter, "Segoe UI", Arial, sans-serif !important;
                    }
                    body > div[style*="background:#f2ebff"],
                    body > div[style*="background: #f2ebff"] {
                        display: none !important;
                    }
                    .app-layout, .layout {
                        display: block !important;
                        width: 100% !important;
                        min-height: 0 !important;
                    }
                    aside.sidebar, .sidebar, .sidebar-footer, .sidebar-bottom,
                    .nav-label, .nav-menu, .nav {
                        display: none !important;
                    }
                    .main-content, .main {
                        display: block !important;
                        width: 100% !important;
                        max-width: none !important;
                        min-width: 0 !important;
                        margin: 0 !important;
                        padding: 18px !important;
                    }
                    .topbar { margin-top: 0 !important; }
                    table { max-width: 100% !important; }
                    img, input, select, textarea { max-width: 100% !important; }
                `;

                const contentHeight = Math.max(
                    doc.body.scrollHeight,
                    doc.documentElement.scrollHeight,
                    700
                );
                frame.style.height = Math.min(contentHeight + 35, 6500) + "px";
            } catch (error) {
                frame.style.height = "1000px";
            }
        }

        frame.addEventListener("load", function () {
            unifyFrame();
            setTimeout(unifyFrame, 200);
            setTimeout(unifyFrame, 700);
            setTimeout(unifyFrame, 1400);
        });

        if (frame.contentDocument && frame.contentDocument.readyState === "complete") {
            unifyFrame();
        }
    });

    const links = document.querySelectorAll(".nav a[href^='#']");
    const sections = Array.from(links)
        .map(link => document.querySelector(link.getAttribute("href")))
        .filter(Boolean);

    if ("IntersectionObserver" in window) {
        const observer = new IntersectionObserver(entries => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    links.forEach(link => {
                        link.classList.toggle(
                            "active",
                            link.getAttribute("href") === "#" + entry.target.id
                        );
                    });
                }
            });
        }, { rootMargin: "-20% 0px -65% 0px" });

        sections.forEach(section => observer.observe(section));
    }
})();
</script>

<footer class="muted" style="text-align:center;padding:20px">
    EduSphere · Student Management System · Admin Console
</footer>

</main>
</div>
</body>
</html>