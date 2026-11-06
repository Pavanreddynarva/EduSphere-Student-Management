<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduSphere | User Management</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <style>
        /* PAGE LAYOUT */
        .main-content {
            min-width: 0;
        }

        .admin-welcome {
            color: #64748b;
            font-size: 14px;
            margin-top: 6px;
        }

        /* PAGE GRID */
        .user-management-grid {
            display: grid;
            grid-template-columns: minmax(280px, 0.8fr) minmax(0, 1.8fr);
            gap: 24px;
            align-items: start;
        }

        .user-management-grid .panel {
            min-width: 0;
        }

        /* FORM */
        .user-form {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .user-form .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .user-form .form-control {
            width: 100%;
            box-sizing: border-box;
            min-height: 44px;
        }

        .user-form .form-label {
            font-weight: 600;
        }

        .user-form .btn {
            width: 100%;
            margin-top: 5px;
        }

        /* USER TABLE */
        .users-table-wrapper {
            width: 100%;
            overflow-x: auto;
            border-radius: 10px;
        }

        .users-table {
            width: 100%;
            min-width: 700px;
            border-collapse: separate;
            border-spacing: 0;
        }

        .users-table th,
        .users-table td {
            padding: 17px 20px;
            text-align: left;
            vertical-align: middle;
            white-space: nowrap;
        }

        .users-table th {
            font-weight: 600;
        }

        .users-table tbody tr:hover {
            background: rgba(99, 102, 241, 0.045);
        }

        .users-table td:nth-child(2),
        .users-table th:nth-child(2) {
            min-width: 160px;
        }

        .users-table td:nth-child(3),
        .users-table th:nth-child(3) {
            min-width: 200px;
        }

        .users-table td:last-child,
        .users-table th:last-child {
            min-width: 200px;
        }

        /* ROLE BADGES */
        .role-badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            background: #e0e7ff;
            color: #3730a3;
        }

        .role-admin {
            background: #ede9fe;
            color: #6d28d9;
        }

        .role-teacher {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .role-student {
            background: #dcfce7;
            color: #15803d;
        }

        .protected-account {
            color: #64748b;
            font-size: 13px;
            font-weight: 600;
        }

        .role-update-form {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .role-update-form select {
            min-width: 110px;
            min-height: 38px;
            padding: 6px 10px;
            border-radius: 7px;
        }

        .role-update-form button {
            white-space: nowrap;
        }

        /* MESSAGES */
        .message-success {
            padding: 14px 18px;
            border-radius: 10px;
            background: #dcfce7;
            color: #166534;
            margin-bottom: 20px;
        }

        .message-error {
            padding: 14px 18px;
            border-radius: 10px;
            background: #fee2e2;
            color: #991b1b;
            margin-bottom: 20px;
        }

        .empty-users {
            text-align: center;
            padding: 35px 20px;
            color: #64748b;
        }

        .section-icon {
            font-size: 25px;
            margin-bottom: 12px;
        }

        /* RESPONSIVE DESIGN */
        @media (max-width: 1050px) {
            .user-management-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 600px) {
            .role-update-form {
                flex-wrap: wrap;
            }

            .users-table th,
            .users-table td {
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
               href="${pageContext.request.contextPath}/admin/dashboard">
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

            <a class="nav-link active"
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
               href="${pageContext.request.contextPath}/students">
                Student CRUD
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
                    Admin / User Management
                </p>

                <h1 class="page-title">
                    User Management
                </h1>

                <p class="page-description">
                    Create accounts and manage system users and their roles.
                </p>

                <p class="admin-welcome">
                    Welcome,
                    <c:out value="${sessionScope.fullName}"/>
                </p>

            </div>

            <div class="avatar">
                A
            </div>

        </header>

        <!-- SUCCESS MESSAGE -->
        <c:if test="${not empty success}">

            <div class="message-success">

                <strong>Success!</strong>

                <c:out value="${success}"/>

            </div>

        </c:if>

        <!-- ERROR MESSAGE -->
        <c:if test="${not empty error}">

            <div class="message-error">

                <strong>Error!</strong>

                <c:out value="${error}"/>

            </div>

        </c:if>

        <!-- USER MANAGEMENT CONTENT -->
        <div class="user-management-grid">

            <!-- CREATE USER PANEL -->
            <section class="panel">

                <div class="panel-header">

                    <div>

                        <div class="section-icon">
                            👤
                        </div>

                        <h2 class="panel-title">
                            Create New Account
                        </h2>

                        <p class="panel-description">
                            Register a new Teacher or Student.
                        </p>

                    </div>

                </div>

                <form class="user-form"
                      action="${pageContext.request.contextPath}/admin/users"
                      method="post">

                    <div class="form-group">

                        <label class="form-label" for="fullName">
                            Full Name
                        </label>

                        <input type="text"
                               class="form-control"
                               id="fullName"
                               name="fullName"
                               placeholder="Enter full name"
                               autocomplete="name"
                               required>

                    </div>

                    <div class="form-group">

                        <label class="form-label" for="email">
                            Email Address
                        </label>

                        <input type="email"
                               class="form-control"
                               id="email"
                               name="email"
                               placeholder="user@example.com"
                               autocomplete="email"
                               required>

                    </div>

                    <div class="form-group">

                        <label class="form-label" for="password">
                            Password
                        </label>

                        <input type="password"
                               class="form-control"
                               id="password"
                               name="password"
                               placeholder="Minimum 8 characters"
                               minlength="8"
                               autocomplete="new-password"
                               required>

                    </div>

                    <div class="form-group">

                        <label class="form-label" for="role">
                            Account Role
                        </label>

                        <select class="form-control"
                                id="role"
                                name="role"
                                required>

                            <option value="">
                                Select Role
                            </option>

                            <option value="TEACHER">
                                Teacher
                            </option>

                            <option value="STUDENT">
                                Student
                            </option>

                        </select>

                    </div>

                    <button type="submit" class="btn btn-primary">
                        + Create Account
                    </button>

                </form>

            </section>

            <!-- REGISTERED USERS PANEL -->
            <section class="panel">

                <div class="panel-header">

                    <div>

                        <div class="section-icon">
                            👥
                        </div>

                        <h2 class="panel-title">
                            Registered Users
                        </h2>

                        <p class="panel-description">
                            View registered users and manage their account roles.
                        </p>

                    </div>

                </div>

                <div class="users-table-wrapper">

                    <table class="users-table">

                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Change Role</th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:forEach var="user" items="${users}">

                                <tr>

                                    <td>
                                        <c:out value="${user.userId}"/>
                                    </td>

                                    <td>
                                        <strong>
                                            <c:out value="${user.fullName}"/>
                                        </strong>
                                    </td>

                                    <td>
                                        <c:out value="${user.email}"/>
                                    </td>

                                    <td>

                                        <c:choose>

                                            <c:when test="${user.role eq 'ADMIN'}">
                                                <span class="role-badge role-admin">
                                                    ADMIN
                                                </span>
                                            </c:when>

                                            <c:when test="${user.role eq 'TEACHER'}">
                                                <span class="role-badge role-teacher">
                                                    TEACHER
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="role-badge role-student">
                                                    STUDENT
                                                </span>
                                            </c:otherwise>

                                        </c:choose>

                                    </td>

                                    <td>

                                        <!-- ADMIN ACCOUNT PROTECTION -->
                                        <c:if test="${user.role ne 'ADMIN'}">

                                            <form class="role-update-form"
                                                  action="${pageContext.request.contextPath}/admin/users/role"
                                                  method="post">

                                                <input type="hidden"
                                                       name="userId"
                                                       value="${user.userId}">

                                                <select name="role" required>

                                                    <option value="TEACHER"
                                                        ${user.role eq 'TEACHER' ? 'selected' : ''}>
                                                        Teacher
                                                    </option>

                                                    <option value="STUDENT"
                                                        ${user.role eq 'STUDENT' ? 'selected' : ''}>
                                                        Student
                                                    </option>

                                                </select>

                                                <button type="submit"
                                                        class="btn btn-secondary">
                                                    Update
                                                </button>

                                            </form>

                                        </c:if>

                                        <c:if test="${user.role eq 'ADMIN'}">

                                            <span class="protected-account">
                                                🔒 Admin Protected
                                            </span>

                                        </c:if>

                                    </td>

                                </tr>

                            </c:forEach>

                            <c:if test="${empty users}">

                                <tr>
                                    <td colspan="5" class="empty-users">
                                        No registered users found.
                                    </td>
                                </tr>

                            </c:if>

                        </tbody>

                    </table>

                </div>

            </section>

        </div>

    </main>

</div>

</body>
</html>