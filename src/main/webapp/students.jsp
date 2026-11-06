<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduSphere | Student Management</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/script.js" defer></script>

    <style>
        /* Student table improvements */
        .student-table {
            width: 100%;
            min-width: 1080px;
            border-collapse: separate;
            border-spacing: 0;
        }

        .student-table th,
        .student-table td {
            padding: 16px 20px;
            vertical-align: middle;
            white-space: nowrap;
        }

        .student-table td:first-child,
        .student-table th:first-child {
            min-width: 230px;
            white-space: normal;
        }

        .student-table td:last-child,
        .student-table th:last-child {
            min-width: 170px;
        }

        .student-table tbody tr:hover {
            background: rgba(99, 102, 241, 0.045);
        }

        .table-scroll {
            width: 100%;
            overflow-x: auto;
            border-radius: 10px;
        }

        /* Page section scrolling */
        #student-list,
        #addStudentSection,
        #performance-summary {
            scroll-margin-top: 24px;
        }

        /* Performance overview */
        .performance-summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(190px, 1fr));
            gap: 16px;
            margin-top: 18px;
        }

        .performance-summary-card {
            padding: 18px;
            border: 1px solid rgba(148, 163, 184, 0.22);
            border-radius: 14px;
            background: var(--card-bg, #fff);
        }

        .performance-summary-card .stat-label {
            margin-bottom: 8px;
        }

        .performance-summary-card .stat-value {
            margin: 0;
        }

        .performance-note {
            margin-top: 12px;
            color: var(--text-muted, #64748b);
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .student-table th,
            .student-table td {
                padding: 13px 15px;
            }
        }
    </style>
</head>

<body>

<div class="app-layout">

    <!-- SIDEBAR -->
    <aside class="sidebar">

        <div class="brand">EduSphere</div>

        <p class="nav-label">MAIN MENU</p>

        <nav class="nav-menu">

            <!-- Dashboard uses the existing authenticated students route -->
            <a class="nav-link"
               href="${pageContext.request.contextPath}/students">
                Dashboard
            </a>

            <a class="nav-link active"
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

            <a class="nav-link"
               href="${pageContext.request.contextPath}/admin/academic-risk">
                Academic Risk
            </a>

            <a class="nav-link"
               href="${pageContext.request.contextPath}/admin/dashboard#teachers">
                Teacher Allocation
            </a>

            <a class="nav-link"
               href="${pageContext.request.contextPath}/admin/dashboard#timetable">
                Timetable
            </a>

            <a class="nav-link"
               href="${pageContext.request.contextPath}/admin/dashboard#fees">
                Fee Records
            </a>

            <a class="nav-link"
               href="${pageContext.request.contextPath}/admin/dashboard#reports">
                Reports &amp; Exports
            </a>

            <a class="nav-link"
               href="${pageContext.request.contextPath}/admin/dashboard">
                Admin Command Center
            </a>
            <a class="nav-link"
   href="${pageContext.request.contextPath}/change-password">
    Change Password
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

        <header class="topbar">

            <div>
                <p class="breadcrumb">Main Menu / Students</p>
                <h1 class="page-title">Student Management</h1>
                <p class="page-description">
                    Manage student records and academic performance.
                </p>
            </div>

            <div class="avatar">A</div>

        </header>

        <!-- SUCCESS AND ERROR MESSAGES -->

        <c:if test="${param.success == 'added'}">
            <div class="alert alert-success">
                Student added successfully!
            </div>
        </c:if>

        <c:if test="${param.success == 'updated'}">
            <div class="alert alert-success">
                Student updated successfully!
            </div>
        </c:if>

        <c:if test="${param.success == 'deleted'}">
            <div class="alert alert-success">
                Student deleted successfully!
            </div>
        </c:if>

        <c:if test="${not empty formError}">
            <div class="alert alert-error">
                <c:out value="${formError}"/>
            </div>
        </c:if>

        <!-- STATISTICS -->

        <section class="stats-grid">

            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <p class="stat-label">Total Students</p>
                <h2 class="stat-value">
                    <c:out value="${students.size()}"/>
                </h2>
            </div>

            <div class="stat-card">
                <div class="stat-icon">📊</div>
                <p class="stat-label">Departments</p>
                <h2 class="stat-value" id="departmentCount">—</h2>
            </div>

            <div class="stat-card">
                <div class="stat-icon">🎯</div>
                <p class="stat-label">Average Marks</p>
                <h2 class="stat-value" id="averageMarks">—</h2>
            </div>

            <div class="stat-card">
                <div class="stat-icon">🏆</div>
                <p class="stat-label">Passing Students</p>
                <h2 class="stat-value" id="passingStudents">—</h2>
            </div>

        </section>

        <!-- PERFORMANCE OVERVIEW -->

        <section class="panel" id="performance-summary">

            <div class="panel-header">
                <div>
                    <h2 class="panel-title">Performance Overview</h2>
                    <p class="panel-description">
                        Summary of student marks and pass status.
                    </p>
                </div>
            </div>

            <div class="performance-summary-grid">

                <div class="performance-summary-card">
                    <p class="stat-label">Class Average</p>
                    <h3 class="stat-value" id="performanceAverage">—</h3>
                </div>

                <div class="performance-summary-card">
                    <p class="stat-label">Passing Rate</p>
                    <h3 class="stat-value" id="performancePassRate">—</h3>
                </div>

                <div class="performance-summary-card">
                    <p class="stat-label">Highest Marks</p>
                    <h3 class="stat-value" id="performanceHighest">—</h3>
                </div>

                <div class="performance-summary-card">
                    <p class="stat-label">Lowest Marks</p>
                    <h3 class="stat-value" id="performanceLowest">—</h3>
                </div>

            </div>

            <p class="performance-note" id="performanceNote">
                Statistics are calculated from the student records displayed on this page.
            </p>

        </section>

        <!-- STUDENT TABLE -->

        <section class="panel" id="student-list">

            <div class="panel-header">
                <div>
                    <h2 class="panel-title">All Students</h2>
                    <p class="panel-description">
                        View, edit, or remove student records.
                    </p>
                </div>
            </div>

            <div class="toolbar">

                <div class="search-box">
                    <span class="search-icon">⌕</span>

                    <input type="text"
                           id="studentSearch"
                           class="form-control"
                           placeholder="Search students...">
                </div>

                <button type="button"
                        class="btn btn-primary"
                        id="addStudentButton"
                        onclick="openAddStudentForm()">
                    + Add Student
                </button>

            </div>

            <div class="table-scroll">

                <table class="student-table" id="studentTable">

                    <thead>
                    <tr>
                        <th>Student</th>
                        <th>Roll Number</th>
                        <th>Department</th>
                        <th>Year</th>
                        <th>Section</th>
                        <th>Marks</th>
                        <th>Performance</th>
                        <th>Actions</th>
                    </tr>
                    </thead>

                    <tbody>

                    <c:forEach var="student" items="${students}">

                        <tr>

                            <td>
                                <div class="student-name">
                                    <c:out value="${student.fullName}"/>
                                </div>

                                <div class="student-meta">
                                    <c:out value="${student.email}"/>
                                </div>
                            </td>

                            <td>
                                <c:out value="${student.rollNumber}"/>
                            </td>

                            <td>
                                <span class="department-badge">
                                    <c:out value="${student.department}"/>
                                </span>
                            </td>

                            <td>
                                <c:out value="${student.yearOfStudy}"/>
                            </td>

                            <td>
                                <c:out value="${student.section}"/>
                            </td>

                            <td class="marks-cell">
                                <c:out value="${student.marks}"/>
                            </td>

                            <td>
                                <span class="status-badge ${student.marks >= 40 ? 'success' : 'danger'}">
                                    ${student.marks >= 40 ? 'Passing' : 'Needs Improvement'}
                                </span>
                            </td>

                            <td>
                                <div style="display:flex;gap:8px;align-items:center">

                                    <a class="btn btn-secondary"
                                       href="${pageContext.request.contextPath}/students?action=edit&id=${student.studentId}">
                                        Edit
                                    </a>

                                    <form method="post"
                                          action="${pageContext.request.contextPath}/students"
                                          onsubmit="return confirm('Are you sure you want to delete this student?');">

                                        <input type="hidden"
                                               name="action"
                                               value="delete">

                                        <input type="hidden"
                                               name="studentId"
                                               value="${student.studentId}">

                                        <button type="submit"
                                                class="btn btn-secondary">
                                            Delete
                                        </button>

                                    </form>

                                </div>
                            </td>

                        </tr>

                    </c:forEach>

                    <c:if test="${empty students}">
                        <tr id="noResultsRow">
                            <td colspan="8" class="empty-state">
                                No students found. Add your first student!
                            </td>
                        </tr>
                    </c:if>

                    </tbody>

                </table>

            </div>

            <div class="table-footer" id="resultCount">
                Student records
            </div>

        </section>

        <!-- ADD / EDIT STUDENT FORM -->

        <section class="panel"
                 id="addStudentSection"
                 style="${showAddForm or not empty editStudent ? '' : 'display:none;'}">

            <div class="panel-header">
                <div>

                    <h2 class="panel-title">
                        ${not empty editStudent ? 'Edit Student' : 'Add New Student'}
                    </h2>

                    <p class="panel-description">
                        Enter the student's details below.
                    </p>

                </div>
            </div>

            <form id="addStudentForm"
                  action="${pageContext.request.contextPath}/students"
                  method="post">

                <c:if test="${not empty editStudent}">
                    <input type="hidden"
                           name="studentId"
                           value="${editStudent.studentId}">
                </c:if>

                <input type="hidden"
                       name="action"
                       value="${not empty editStudent ? 'update' : 'add'}">

                <div class="form-grid">

                    <div class="form-group">
                        <label class="form-label" for="rollNumber">
                            Roll Number *
                        </label>

                        <input class="form-control"
                               id="rollNumber"
                               name="rollNumber"
                               value="${not empty submittedStudent ? submittedStudent.rollNumber : editStudent.rollNumber}"
                               placeholder="e.g. SRM101"
                               required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="fullName">
                            Full Name *
                        </label>

                        <input class="form-control"
                               id="fullName"
                               name="fullName"
                               value="${not empty submittedStudent ? submittedStudent.fullName : editStudent.fullName}"
                               placeholder="Enter full name"
                               required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="email">
                            Email *
                        </label>

                        <input class="form-control"
                               id="email"
                               name="email"
                               type="email"
                               value="${not empty submittedStudent ? submittedStudent.email : editStudent.email}"
                               placeholder="student@example.com"
                               required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="phone">
                            Phone
                        </label>

                        <input class="form-control"
                               id="phone"
                               name="phone"
                               value="${not empty submittedStudent ? submittedStudent.phone : editStudent.phone}"
                               placeholder="10-digit mobile number">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="department">
                            Department *
                        </label>

                        <select class="form-control"
                                id="department"
                                name="department"
                                required>

                            <option value="">Select department</option>

                            <option value="CSE" ${((not empty submittedStudent ? submittedStudent.department : editStudent.department) == 'CSE') ? 'selected' : ''}>CSE</option>
                            <option value="ECE" ${((not empty submittedStudent ? submittedStudent.department : editStudent.department) == 'ECE') ? 'selected' : ''}>ECE</option>
                            <option value="EEE" ${((not empty submittedStudent ? submittedStudent.department : editStudent.department) == 'EEE') ? 'selected' : ''}>EEE</option>
                            <option value="MECH" ${((not empty submittedStudent ? submittedStudent.department : editStudent.department) == 'MECH') ? 'selected' : ''}>MECH</option>
                            <option value="CIVIL" ${((not empty submittedStudent ? submittedStudent.department : editStudent.department) == 'CIVIL') ? 'selected' : ''}>CIVIL</option>
                            <option value="IT" ${((not empty submittedStudent ? submittedStudent.department : editStudent.department) == 'IT') ? 'selected' : ''}>IT</option>

                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="yearOfStudy">
                            Year of Study *
                        </label>

                        <select class="form-control"
                                id="yearOfStudy"
                                name="yearOfStudy"
                                required>

                            <option value="">Select year</option>

                            <option value="1" ${((not empty submittedStudent ? submittedStudent.yearOfStudy : editStudent.yearOfStudy) == 1) ? 'selected' : ''}>1st Year</option>
                            <option value="2" ${((not empty submittedStudent ? submittedStudent.yearOfStudy : editStudent.yearOfStudy) == 2) ? 'selected' : ''}>2nd Year</option>
                            <option value="3" ${((not empty submittedStudent ? submittedStudent.yearOfStudy : editStudent.yearOfStudy) == 3) ? 'selected' : ''}>3rd Year</option>
                            <option value="4" ${((not empty submittedStudent ? submittedStudent.yearOfStudy : editStudent.yearOfStudy) == 4) ? 'selected' : ''}>4th Year</option>

                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="section">
                            Section *
                        </label>

                        <select class="form-control"
                                id="section"
                                name="section"
                                required>

                            <option value="">Select section</option>

                            <option value="A" ${((not empty submittedStudent ? submittedStudent.section : editStudent.section) == 'A') ? 'selected' : ''}>A</option>
                            <option value="B" ${((not empty submittedStudent ? submittedStudent.section : editStudent.section) == 'B') ? 'selected' : ''}>B</option>
                            <option value="C" ${((not empty submittedStudent ? submittedStudent.section : editStudent.section) == 'C') ? 'selected' : ''}>C</option>

                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="marks">
                            Marks (0–100) *
                        </label>

                        <input class="form-control"
                               id="marks"
                               name="marks"
                               type="number"
                               min="0"
                               max="100"
                               step="0.01"
                               value="${not empty submittedStudent ? submittedStudent.marks : editStudent.marks}"
                               placeholder="e.g. 85"
                               required>
                    </div>

                </div>

                <div class="form-actions">

                    <button type="submit"
                            class="btn btn-primary"
                            id="studentFormSubmit">
                        ${not empty editStudent ? 'Update Student' : 'Save Student'}
                    </button>

                    <a class="btn btn-secondary"
                       href="${pageContext.request.contextPath}/students">
                        Cancel
                    </a>

                </div>

            </form>

        </section>

    </main>

</div>

<script>
    function openAddStudentForm() {

        const section = document.getElementById("addStudentSection");
        const form = document.getElementById("addStudentForm");

        if (!section || !form) {
            console.error("Add Student form section was not found.");
            return;
        }

        form.reset();

        form.querySelectorAll("input:not([type='hidden']), select, textarea")
            .forEach(function(field) {
                field.value = "";
            });

        let actionInput = form.querySelector("input[name='action']");

        if (!actionInput) {
            actionInput = document.createElement("input");
            actionInput.type = "hidden";
            actionInput.name = "action";
            form.appendChild(actionInput);
        }

        actionInput.value = "add";

        const idInput = form.querySelector("input[name='studentId']");

        if (idInput) {
            idInput.remove();
        }

        const heading = section.querySelector(".panel-title");

        if (heading) {
            heading.textContent = "Add New Student";
        }

        const submitButton = document.getElementById("studentFormSubmit");

        if (submitButton) {
            submitButton.textContent = "Save Student";
        }

        section.style.display = "block";

        section.scrollIntoView({
            behavior: "smooth",
            block: "start"
        });
    }


    document.addEventListener("DOMContentLoaded", function() {

        const table = document.getElementById("studentTable");
        const searchInput = document.getElementById("studentSearch");
        const resultCount = document.getElementById("resultCount");

        const studentRows = table
            ? Array.from(table.querySelectorAll("tbody tr")).filter(function(row) {
                return row.querySelector("td") && row.id !== "noResultsRow";
            })
            : [];


        // STUDENT SEARCH

        if (searchInput && table) {

            searchInput.addEventListener("input", function() {

                const query = searchInput.value.trim().toLowerCase();
                let visible = 0;

                studentRows.forEach(function(row) {

                    const matches = row.textContent.toLowerCase().includes(query);

                    row.style.display = matches ? "" : "none";

                    if (matches) {
                        visible++;
                    }
                });

                const noResults = document.getElementById("clientNoResultsRow");

                if (noResults) {
                    noResults.remove();
                }

                if (visible === 0 && studentRows.length > 0) {

                    const row = document.createElement("tr");

                    row.id = "clientNoResultsRow";

                    row.innerHTML =
                        '<td colspan="8" class="empty-state">No matching students found.</td>';

                    table.querySelector("tbody").appendChild(row);
                }

                if (resultCount) {
                    resultCount.textContent =
                        "Showing " + visible + " of " + studentRows.length + " student records";
                }

            });
        }


        // CALCULATE DASHBOARD STATISTICS

        const marks = [];
        const departments = new Set();

        let passing = 0;

        studentRows.forEach(function(row) {

            const cells = row.querySelectorAll("td");

            if (cells.length < 8) {
                return;
            }

            const department = cells[2].textContent.trim();
            const markText = cells[5].textContent.trim();
            const mark = Number.parseFloat(markText);

            if (department) {
                departments.add(department);
            }

            if (Number.isFinite(mark)) {

                marks.push(mark);

                if (mark >= 40) {
                    passing++;
                }
            }

        });


        const total = studentRows.length;

        const average = marks.length
            ? marks.reduce(function(sum, value) {
                return sum + value;
            }, 0) / marks.length
            : null;

        const passRate = marks.length
            ? (passing / marks.length) * 100
            : null;

        const highest = marks.length
            ? Math.max.apply(null, marks)
            : null;

        const lowest = marks.length
            ? Math.min.apply(null, marks)
            : null;


        const format = function(value) {
            return value === null ? "—" : value.toFixed(1) + "%";
        };


        // UPDATE STATISTIC CARDS

        const departmentCount = document.getElementById("departmentCount");
        const averageMarks = document.getElementById("averageMarks");
        const passingStudents = document.getElementById("passingStudents");

        if (departmentCount) {
            departmentCount.textContent = String(departments.size);
        }

        if (averageMarks) {
            averageMarks.textContent = format(average);
        }

        if (passingStudents) {
            passingStudents.textContent = String(passing);
        }


        // UPDATE PERFORMANCE OVERVIEW

        const performanceAverage =
            document.getElementById("performanceAverage");

        const performancePassRate =
            document.getElementById("performancePassRate");

        const performanceHighest =
            document.getElementById("performanceHighest");

        const performanceLowest =
            document.getElementById("performanceLowest");

        const performanceNote =
            document.getElementById("performanceNote");


        if (performanceAverage) {
            performanceAverage.textContent = format(average);
        }

        if (performancePassRate) {
            performancePassRate.textContent = format(passRate);
        }

        if (performanceHighest) {
            performanceHighest.textContent =
                highest === null ? "—" : highest.toFixed(1) + "%";
        }

        if (performanceLowest) {
            performanceLowest.textContent =
                lowest === null ? "—" : lowest.toFixed(1) + "%";
        }

        if (performanceNote) {

            performanceNote.textContent = marks.length
                ? "Calculated using " + marks.length +
                  " student mark record(s). Passing threshold: 40 marks."
                : "No student marks are available to calculate performance statistics.";
        }


        if (resultCount) {
            resultCount.textContent =
                "Showing " + total + " student record(s)";
        }


        // AUTOMATICALLY SCROLL TO THE EDIT FORM

        const editFormIsOpen =
            document.getElementById("addStudentSection")
            && document.getElementById("addStudentSection").style.display !== "none"
            && document.querySelector("#addStudentForm input[name='studentId']");

        if (editFormIsOpen) {

            window.setTimeout(function() {

                document.getElementById("addStudentSection")
                    .scrollIntoView({
                        behavior: "smooth",
                        block: "start"
                    });

            }, 150);
        }

    });
</script>

</body>
</html>