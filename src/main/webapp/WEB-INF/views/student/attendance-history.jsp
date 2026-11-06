
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Attendance | EduSphere</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .attendance-summary {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 25px;
        }

        .attendance-stat {
            padding: 22px;
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
        }

        .attendance-stat p {
            color: #64748b;
            font-size: 13px;
            margin-bottom: 10px;
        }

        .attendance-stat h2 {
            font-size: 28px;
            color: #172033;
        }

        .attendance-table-wrapper {
            overflow-x: auto;
        }

        .attendance-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 550px;
        }

        .attendance-table th,
        .attendance-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
            font-size: 13px;
        }

        .attendance-table th {
            background: #f8fafc;
            color: #64748b;
        }

        .status {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
        }

        .status-present {
            background: #dcfce7;
            color: #15803d;
        }

        .status-absent {
            background: #fee2e2;
            color: #b91c1c;
        }

        .empty-message {
            padding: 35px;
            text-align: center;
            color: #64748b;
        }

        /* QR Scanner */
        .scanner-panel {
            margin-bottom: 25px;
            padding: 25px;
        }

        .scanner-description {
            color: #64748b;
            font-size: 14px;
            margin: 10px 0 18px;
        }

        .scanner-video-container {
            display: none;
            max-width: 430px;
            margin: 20px auto;
            overflow: hidden;
            border-radius: 14px;
            background: #111827;
        }

        .scanner-video-container video {
            width: 100%;
            display: block;
        }

        .scanner-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 15px;
        }

        .scanner-message {
            margin-top: 15px;
            padding: 12px;
            border-radius: 8px;
            background: #f1f5f9;
            color: #334155;
            font-size: 13px;
        }

        .scanner-message.error {
            background: #fee2e2;
            color: #991b1b;
        }

        .scanner-message.success {
            background: #dcfce7;
            color: #166534;
        }

        .token-fallback {
            margin-top: 22px;
            padding-top: 20px;
            border-top: 1px solid #e5e7eb;
        }

        .token-fallback input {
            width: 100%;
            max-width: 430px;
            padding: 12px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            margin: 10px 0;
        }

        @media(max-width: 700px) {
            .attendance-summary {
                grid-template-columns: 1fr;
            }

            .scanner-panel {
                padding: 18px;
            }
        }
    </style>
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

                <a class="nav-link"
                   href="${pageContext.request.contextPath}/student/dashboard">
                    <span>&#127968;</span> Dashboard
                </a>

                <a class="nav-link active"
                   href="${pageContext.request.contextPath}/student/attendance/history">
                    <span>&#128197;</span> My Attendance
                </a>

                <a class="nav-link"
                   href="${pageContext.request.contextPath}/student/academic-progress">
                    <span>&#128202;</span> My Academic Progress
                </a>

                <a class="nav-link"
                   href="${pageContext.request.contextPath}/student/grade-simulator">
                    <span>&#129518;</span> What-If Grade Simulator
                </a>

            </nav>
        </div>

        <div class="sidebar-footer">
            <p>EduSphere Student Portal</p>

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
                <p class="breadcrumb">Student / My Attendance</p>
                <h1 class="page-title">My Attendance</h1>
                <p class="page-description">
                    Scan your teacher's QR code and view your attendance records.
                </p>
            </div>

            <div class="avatar">S</div>
        </header>

        <c:if test="${not empty error}">
            <section class="panel">
                <p style="color:#b91c1c;">
                    <c:out value="${error}"/>
                </p>
            </section>
        </c:if>

        <c:if test="${empty error}">

            <!-- QR SCANNER SECTION -->
            <section class="panel scanner-panel">

                <h2>Mark Today's Attendance</h2>

                <p class="scanner-description">
                    Scan the QR code displayed by your teacher.
                    Your attendance will be marked automatically.
                </p>

                <div class="scanner-actions">
                    <button type="button"
                            id="startScanner"
                            class="btn btn-primary">
                        Start QR Scanner
                    </button>

                    <button type="button"
                            id="stopScanner"
                            class="btn btn-danger"
                            style="display:none;">
                        Stop Scanner
                    </button>
                </div>

                <div class="scanner-video-container"
                     id="videoContainer">
                    <video id="scannerVideo"
                           autoplay
                           muted
                           playsinline></video>
                </div>

                <div id="scannerMessage"
                     class="scanner-message"
                     role="status"
                     aria-live="polite">
                    Tap Start QR Scanner to begin.
                </div>

                <!-- Fallback if camera access is unavailable -->
                <div class="token-fallback">

                    <h3>Enter QR Token</h3>

                    <p class="scanner-description">
                        If your camera is unavailable, you can enter
                        the token from the attendance QR URL.
                    </p>

                    <form id="tokenForm">
                        <input type="text"
                               id="qrToken"
                               placeholder="Enter attendance token"
                               autocomplete="off"
                               required>

                        <br>

                        <button type="submit"
                                class="btn btn-primary">
                            Submit Attendance
                        </button>
                    </form>

                </div>

            </section>

            <!-- ATTENDANCE WELCOME -->
            <section class="panel"
                     style="padding:22px; margin-bottom:25px;">
                <h2>Welcome, <c:out value="${studentName}"/>!</h2>
                <p class="page-description">
                    Here is your attendance overview.
                </p>
            </section>

            <!-- ATTENDANCE SUMMARY -->
            <section class="attendance-summary">

                <article class="attendance-stat">
                    <p>Total Recorded Sessions</p>
                    <h2><c:out value="${totalRecords}"/></h2>
                </article>

                <article class="attendance-stat">
                    <p>Present Sessions</p>
                    <h2 style="color:#15803d;">
                        <c:out value="${presentCount}"/>
                    </h2>
                </article>

                <article class="attendance-stat">
                    <p>Attendance Percentage</p>
                    <h2 style="color:#4338ca;">
                        <c:out value="${attendancePercentage}"/>%
                    </h2>
                </article>

            </section>

            <!-- EXISTING ATTENDANCE HISTORY -->
            <section class="panel" style="padding:25px;">

                <h2 style="margin-bottom:20px;">
                    Attendance History
                </h2>

                <div class="attendance-table-wrapper">

                    <table class="attendance-table">

                        <thead>
                            <tr>
                                <th>Session ID</th>
                                <th>Date &amp; Time</th>
                                <th>Status</th>
                                <th>Marked By</th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:forEach var="record"
                                       items="${attendanceRecords}">

                                <tr>
                                    <td>
                                        <c:out value="${record.sessionId}"/>
                                    </td>

                                    <td>
                                        <c:out value="${record.markedAt}"/>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${record.status == 'PRESENT'}">
                                                <span class="status status-present">
                                                    PRESENT
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="status status-absent">
                                                    ABSENT
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <c:out value="${record.markedBy}"/>
                                    </td>
                                </tr>

                            </c:forEach>

                            <c:if test="${empty attendanceRecords}">
                                <tr>
                                    <td colspan="4" class="empty-message">
                                        No attendance records found yet.
                                    </td>
                                </tr>
                            </c:if>

                        </tbody>

                    </table>

                </div>

            </section>

        </c:if>

    </main>

</div>

<!-- QR DECODING LIBRARY -->
<script src="https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.min.js"></script>

<script>
(function () {

    const startButton = document.getElementById("startScanner");
    const stopButton = document.getElementById("stopScanner");
    const video = document.getElementById("scannerVideo");
    const videoContainer = document.getElementById("videoContainer");
    const message = document.getElementById("scannerMessage");
    const tokenForm = document.getElementById("tokenForm");
    const tokenInput = document.getElementById("qrToken");

    if (!startButton || !stopButton || !video || !tokenForm) {
        return;
    }

    const attendancePath =
        "${pageContext.request.contextPath}/student/attendance";

    let cameraStream = null;
    let scanning = false;
    let animationId = null;
    let lastScanTime = 0;
    let invalidQrMessageShown = false;

    // Canvas used to capture image frames from the camera.
    const scanCanvas = document.createElement("canvas");
    const scanContext = scanCanvas.getContext("2d");

    function showMessage(text, type) {
        message.textContent = text;
        message.className = "scanner-message";

        if (type) {
            message.classList.add(type);
        }
    }

    function stopCamera() {
        scanning = false;

        if (animationId !== null) {
            cancelAnimationFrame(animationId);
            animationId = null;
        }

        if (cameraStream) {
            cameraStream.getTracks().forEach(track => track.stop());
            cameraStream = null;
        }

        video.srcObject = null;
        videoContainer.style.display = "none";
        stopButton.style.display = "none";
        startButton.style.display = "inline-block";
    }

    function submitToken(token) {

        if (!token || !token.trim()) {
            showMessage("Please provide a valid QR token.", "error");
            return;
        }

        stopCamera();

        showMessage("Submitting attendance...", "success");

        window.location.href =
            attendancePath + "?token=" + encodeURIComponent(token.trim());
    }

    function extractToken(value) {

        // QR normally contains the full attendance URL.
        try {
            const url = new URL(value);

            if (url.pathname !== attendancePath) {
                return null;
            }

            return url.searchParams.get("token");

        } catch (error) {

            // Also support a raw token entered manually.
            if (/^[a-zA-Z0-9-]{20,100}$/.test(value.trim())) {
                return value.trim();
            }

            return null;
        }
    }

    function scanFrame(timestamp) {

        if (!scanning) {
            return;
        }

        // Wait until the camera provides a usable frame.
        if (video.readyState < 2 || !video.videoWidth || !video.videoHeight) {
            animationId = requestAnimationFrame(scanFrame);
            return;
        }

        // Limit scanning to approximately 8 frames per second.
        if (timestamp - lastScanTime < 120) {
            animationId = requestAnimationFrame(scanFrame);
            return;
        }

        lastScanTime = timestamp;

        try {

            const width = video.videoWidth;
            const height = video.videoHeight;

            if (scanCanvas.width !== width || scanCanvas.height !== height) {
                scanCanvas.width = width;
                scanCanvas.height = height;
            }

            scanContext.drawImage(video, 0, 0, width, height);

            const imageData = scanContext.getImageData(
                0,
                0,
                width,
                height
            );

            const result = window.jsQR(
                imageData.data,
                imageData.width,
                imageData.height,
                {
                    inversionAttempts: "attemptBoth"
                }
            );

            if (result && result.data) {

                const token = extractToken(result.data);

                if (token) {
                    submitToken(token);
                    return;
                }

                if (!invalidQrMessageShown) {
                    showMessage(
                        "This QR code is not a valid EduSphere attendance QR. Keep the scanner open and scan your teacher's QR code.",
                        "error"
                    );

                    invalidQrMessageShown = true;
                }
            }

        } catch (error) {
            console.error("QR detection error:", error);
        }

        if (scanning) {
            animationId = requestAnimationFrame(scanFrame);
        }
    }

    startButton.addEventListener("click", async function () {

        // Camera access requires a secure HTTPS connection.
        if (!window.isSecureContext) {

            showMessage(
                "Camera access requires HTTPS. Open EduSphere through a secure HTTPS address to use the scanner. You can use the token-entry option below in the meantime.",
                "error"
            );

            return;
        }

        // Check browser camera availability.
        if (!navigator.mediaDevices ||
            !navigator.mediaDevices.getUserMedia) {

            showMessage(
                "Camera access is unavailable in this browser.",
                "error"
            );

            return;
        }

        // Check whether jsQR has loaded.
        if (typeof window.jsQR !== "function") {

            showMessage(
                "The QR-scanning library could not be loaded. Check your internet connection and reload this page.",
                "error"
            );

            return;
        }

        if (!scanContext) {

            showMessage(
                "This browser could not initialize the QR scanner. Please use the token-entry option below.",
                "error"
            );

            return;
        }

        try {

            invalidQrMessageShown = false;
            lastScanTime = 0;

            // Start the mobile back camera.
            cameraStream = await navigator.mediaDevices.getUserMedia({

                video: {
                    facingMode: {
                        ideal: "environment"
                    }
                },

                audio: false

            });

            video.srcObject = cameraStream;

            await video.play();

            videoContainer.style.display = "block";
            startButton.style.display = "none";
            stopButton.style.display = "inline-block";

            scanning = true;

            showMessage(
                "Camera started. Point it towards your teacher's QR code.",
                "success"
            );

            scanFrame();

        } catch (error) {

            stopCamera();

            if (error.name === "NotAllowedError") {

                showMessage(
                    "Camera permission was denied. Allow camera access in your browser settings.",
                    "error"
                );

            } else {

                showMessage(
                    "Unable to start the camera: " + error.message,
                    "error"
                );

            }
        }
    });

    // Stop button.
    stopButton.addEventListener("click", function () {

        stopCamera();

        showMessage("Scanner stopped.");
    });

    // Existing manual token-entry fallback.
    tokenForm.addEventListener("submit", function (event) {

        event.preventDefault();

        const token = tokenInput.value.trim();

        submitToken(token);
    });

    // Release the camera when leaving the page.
    window.addEventListener("pagehide", stopCamera);

})();
</script>

</body>
</html>
