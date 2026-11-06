
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduSphere | Attendance Result</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

<div class="main-content">

    <section class="stat-card" style="max-width:600px; margin:80px auto;">

        <h1>Attendance Result</h1>

        <p>
            <c:out value="${attendanceMessage}"/>
        </p>

        <a href="${pageContext.request.contextPath}/student/dashboard"
           class="btn btn-primary">
            Back to Dashboard
        </a>

    </section>

</div>

</body>
</html>
