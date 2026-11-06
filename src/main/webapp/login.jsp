
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduSphere | Sign In</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <style>
        body.login-page {
            background: #f1f5f9 !important;
        }

        .login-wrapper {
            display: grid !important;
            grid-template-columns: 1fr 1fr !important;
            min-height: 100vh !important;
        }

        .login-showcase {
            background: linear-gradient(135deg, #111827, #4338ca) !important;
            color: white !important;
            padding: 60px !important;
        }

        .login-panel {
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            background: white !important;
        }

        .login-card {
            width: 100% !important;
            max-width: 420px !important;
            padding: 30px !important;
        }
    </style>
</head>

<body class="login-page">

<div class="login-wrapper">

    <section class="login-showcase">
        <div class="login-brand">
            <div class="login-brand-icon">E</div>
            <span>EduSphere</span>
        </div>

        <div class="showcase-content">
            <span class="showcase-tag">STUDENT MANAGEMENT PLATFORM</span>

            <h1>Empowering education.<br>
                Connecting futures.</h1>

            <p>
                A smarter way to manage students, track academic progress
                and bring your educational community together.
            </p>

            <div class="showcase-features">
                <div>✓ Smart Student Management</div>
                <div>✓ Academic Performance Tracking</div>
                <div>✓ Simplified Administration</div>
            </div>
        </div>

        <div class="showcase-footer">
            Your academic journey, all in one place.
        </div>
    </section>

    <section class="login-panel">

        <div class="login-card">

            <div class="login-mobile-brand">
                <div class="login-brand-icon">E</div>
                <span>EduSphere</span>
            </div>

            <div class="login-heading">
                <span class="login-eyebrow">WELCOME BACK</span>
                <h2>Sign in to your account</h2>
                <p>Enter your credentials to access your portal.</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="login-error" role="alert">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form id="loginForm"
                  action="${pageContext.request.contextPath}/login"
                  method="POST"
                  accept-charset="UTF-8">

                <div class="login-form-group">
                    <label for="email">Email Address</label>

                    <input type="email"
                           id="email"
                           name="email"
                           placeholder="Enter your email address"
                           autocomplete="username"
                           required>
                </div>

                <div class="login-form-group">
                    <label for="password">Password</label>

                    <div class="password-wrapper">
                        <input type="password"
                               id="password"
                               name="password"
                               placeholder="Enter your password"
                               autocomplete="current-password"
                               required>

                        <button type="button"
                                class="password-toggle"
                                id="togglePassword"
                                aria-label="Show password">
                            Show
                        </button>
                    </div>
                </div>

               <button type="submit"
        id="loginSubmit"
        class="login-submit">
    Sign In <span>→</span>
</button>

<button type="submit"
        id="firstTimeLogin"
        class="login-submit"
        style="margin-top:12px; background:#0f766e;">
    First Time Login <span>→</span>
</button>

            </form>

            <div class="login-security">
                <span>🔒</span>
                Secure access to your EduSphere account
            </div>

        </div>

        <footer class="login-footer">
            © 2026 EduSphere. All rights reserved.
        </footer>

    </section>

</div>

<script>
    const passwordInput = document.getElementById("password");
    const toggleButton = document.getElementById("togglePassword");

    toggleButton.addEventListener("click", function () {
        const isPassword = passwordInput.type === "password";

        passwordInput.type = isPassword ? "text" : "password";
        toggleButton.textContent = isPassword ? "Hide" : "Show";

        toggleButton.setAttribute(
            "aria-label",
            isPassword ? "Hide password" : "Show password"
        );
    });
</script>

</body>
</html>
