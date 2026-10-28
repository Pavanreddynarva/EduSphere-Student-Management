]
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
</head>
<body>

<div class="app-layout">

    <aside class="sidebar">
        <div class="brand">EduSphere</div>
        <p class="nav-label">MAIN MENU</p>
        <nav class="nav-menu">
            <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Dashboard</a>
            <a class="nav-link active" href="${pageContext.request.contextPath}/students">Students</a>
            <a class="nav-link" href="#student-list">Performance</a>
        </nav>
        <div class="sidebar-footer">Student Management System</div>
    </aside>

    <main class="main-content">

        <header class="topbar">
            <div>
                <p class="breadcrumb">Main Menu / Students</p>
                <h1 class="page-title">Student Management</h1>
                <p class="page-description">Manage student records and academic performance.</p>
            </div>
            <div class="avatar">A</div>
        </header>

        <c:if test="${param.success == 'added'}">
            <div class="alert alert-success">Student added successfully!</div>
        </c:if>
        <c:if test="${param.success == 'updated'}">
            <div class="alert alert-success">Student updated successfully!</div>
        </c:if>
        <c:if test="${param.success == 'deleted'}">
            <div class="alert alert-success">Student deleted successfully!</div>
        </c:if>
        <c:if test="${not empty formError}">
            <div class="alert alert-error"><c:out value="${formError}"/></div>
        </c:if>

        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <p class="stat-label">Total Students</p>
                <h2 class="stat-value"><c:out value="${students.size()}"/></h2>
            </div>
            <div class="stat-card">
                <div class="stat-icon">📊</div>
                <p class="stat-label">Departments</p>
                <h2 class="stat-value" id="departmentCount">0</h2>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🎯</div>
                <p class="stat-label">Average Marks</p>
                <h2 class="stat-value" id="averageMarks">0%</h2>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🏆</div>
                <p class="stat-label">Passing Students</p>
                <h2 class="stat-value" id="passingStudents">0</h2>
            </div>
        </section>

        <section class="panel" id="student-list">
            <div class="panel-header">
                <div>
                    <h2 class="panel-title">All Students</h2>
                    <p class="panel-description">View, edit, or remove student records.</p>
                </div>
            </div>

            <div class="toolbar">
                <div class="search-box">
                    <span class="search-icon">⌕</span>
                    <input type="text" id="studentSearch" class="form-control"
                           placeholder="Search students...">
                </div>

                <button type="button"
                        class="btn btn-primary"
                        id="addStudentButton"
                        onclick="openAddStudentForm()">
                    + Add Student
                </button>
            </div>

            <div style="overflow-x:auto">
                <table class="student-table" id="studentTable">
                    <thead>
                    <tr>
                        <th>Student</th>
                        <th>Roll Number</th>
                        <th>Department</th>
                        <th>Year</th>
                        <th>Marks</th>
                        <th>Performance</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="student" items="${students}">
                        <tr>
                            <td>
                                <div class="student-name"><c:out value="${student.fullName}"/></div>
                                <div class="student-meta"><c:out value="${student.email}"/></div>
                            </td>
                            <td><c:out value="${student.rollNumber}"/></td>
                            <td>
                                <span class="department-badge">
                                    <c:out value="${student.department}"/>
                                </span>
                            </td>
                            <td><c:out value="${student.yearOfStudy}"/></td>
                            <td class="marks-cell"><c:out value="${student.marks}"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${student.marks >= 40}">
                                        <span class="status-badge success">Passing</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge danger">Needs Improvement</span>
                                    </c:otherwise>
                                </c:choose>
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
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="studentId"
                                               value="${student.studentId}">
                                        <button type="submit" class="btn btn-secondary">Delete</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty students}">
                        <tr id="noResultsRow">
                            <td colspan="7" class="empty-state">
                                No students found. Add your first student!
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <div class="table-footer" id="resultCount">Student records</div>
        </section>

        <section class="panel"
                 id="addStudentSection"
                 style="${showAddForm or not empty editStudent ? '' : 'display:none;'}">

            <div class="panel-header">
                <div>
                    <h2 class="panel-title">
                        <c:choose>
                            <c:when test="${not empty editStudent}">Edit Student</c:when>
                            <c:otherwise>Add New Student</c:otherwise>
                        </c:choose>
                    </h2>
                    <p class="panel-description">Enter the student's details below.</p>
                </div>
            </div>

            <form id="addStudentForm"
                  action="${pageContext.request.contextPath}/students"
                  method="post">

                <c:choose>
                    <c:when test="${not empty editStudent}">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="studentId"
                               value="${editStudent.studentId}">
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="action" value="add">
                    </c:otherwise>
                </c:choose>

                <div class="form-grid">

                    <div class="form-group">
                        <label class="form-label" for="rollNumber">Roll Number *</label>
                        <input class="form-control" id="rollNumber" name="rollNumber"
                               value="<c:out value='${editStudent.rollNumber}'/>"
                               placeholder="e.g. SRM101" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="fullName">Full Name *</label>
                        <input class="form-control" id="fullName" name="fullName"
                               value="<c:out value='${editStudent.fullName}'/>"
                               placeholder="Enter full name" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="email">Email *</label>
                        <input class="form-control" id="email" name="email" type="email"
                               value="<c:out value='${editStudent.email}'/>"
                               placeholder="student@example.com" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="phone">Phone</label>
                        <input class="form-control" id="phone" name="phone"
                               value="<c:out value='${editStudent.phone}'/>"
                               placeholder="10-digit mobile number">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="department">Department *</label>
                        <select class="form-control" id="department" name="department" required>
                            <option value="">Select department</option>
                            <option value="CSE" ${editStudent.department == 'CSE' ? 'selected' : ''}>CSE</option>
                            <option value="ECE" ${editStudent.department == 'ECE' ? 'selected' : ''}>ECE</option>
                            <option value="EEE" ${editStudent.department == 'EEE' ? 'selected' : ''}>EEE</option>
                            <option value="MECH" ${editStudent.department == 'MECH' ? 'selected' : ''}>MECH</option>
                            <option value="CIVIL" ${editStudent.department == 'CIVIL' ? 'selected' : ''}>CIVIL</option>
                            <option value="IT" ${editStudent.department == 'IT' ? 'selected' : ''}>IT</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="yearOfStudy">Year of Study *</label>
                        <select class="form-control" id="yearOfStudy" name="yearOfStudy" required>
                            <option value="">Select year</option>
                            <option value="1" ${editStudent.yearOfStudy == 1 ? 'selected' : ''}>1st Year</option>
                            <option value="2" ${editStudent.yearOfStudy == 2 ? 'selected' : ''}>2nd Year</option>
                            <option value="3" ${editStudent.yearOfStudy == 3 ? 'selected' : ''}>3rd Year</option>
                            <option value="4" ${editStudent.yearOfStudy == 4 ? 'selected' : ''}>4th Year</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="marks">Marks (0–100) *</label>
                        <input class="form-control" id="marks" name="marks" type="number"
                               min="0" max="100" step="0.01"
                               value="<c:out value='${editStudent.marks}'/>"
                               placeholder="e.g. 85" required>
                    </div>

                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary" id="studentFormSubmit">
                        <c:choose>
                            <c:when test="${not empty editStudent}">Update Student</c:when>
                            <c:otherwise>Save Student</c:otherwise>
                        </c:choose>
                    </button>
                    <a class="btn btn-secondary"
                       href="${pageContext.request.contextPath}/students">Cancel</a>
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

    // Reset fields, then clear any values restored by the server in Edit mode.
    form.reset();

    form.querySelectorAll("input:not([type='hidden']), select, textarea")
        .forEach(function (field) {
            field.value = "";
        });

    // Switch the shared form to Add mode.
    let actionInput = form.querySelector("input[name='action']");
    if (!actionInput) {
        actionInput = document.createElement("input");
        actionInput.type = "hidden";
        actionInput.name = "action";
        form.appendChild(actionInput);
    }
    actionInput.value = "add";

    // Remove the ID belonging to the previously edited student.
    const idInput = form.querySelector("input[name='studentId']");
    if (idInput) {
        idInput.remove();
    }

    // Update the heading and submit button.
    const heading = section.querySelector(".panel-title");
    if (heading) {
        heading.textContent = "Add New Student";
    }

    const submitButton = document.getElementById("studentFormSubmit");
    if (submitButton) {
        submitButton.textContent = "Save Student";
    }

    // Display the form and scroll to it.
    section.style.display = "block";
    section.scrollIntoView({ behavior: "smooth", block: "start" });
}
</script>

</body>
</html>
