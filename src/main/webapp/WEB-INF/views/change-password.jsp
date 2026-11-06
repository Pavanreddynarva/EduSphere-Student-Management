
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Change Password | EduSphere</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .password-page {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: #f1f5f9;
            padding: 25px;
        }

        .password-card {
            width: 100%;
            max-width: 460px;
            background: white;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 10px 35px rgba(0,0,0,0.07);
        }

        .password-card h1 {
            color: #172033;
            margin-bottom: 10px;
            font-size: 26px;
        }

        .password-card .description {
            color: #64748b;
            margin-bottom: 25px;
            line-height: 1.6;
        }

        .password-group {
            margin-bottom: 20px;
        }

        .password-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #334155;
        }

        .password-group input {
            box-sizing: border-box;
            width: 100%;
            padding: 13px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
        }

        .password-submit {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 8px;
            background: #4338ca;
            color: white;
            font-weight: 600;
            cursor: pointer;
        }

        .password-submit:hover {
            background: #3730a3;
        }

        .message-error {
            padding: 13px;
            background: #fee2e2;
            color: #991b1b;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .account-email {
            color: #4338ca;
            font-weight: 600;
            margin-bottom: 20px;
            overflow-wrap: anywhere;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #4338ca;
            text-decoration: none;
        }
    </style>
</head>

<body>

<div class="password-page">

    <section class="password-card">

        <h1>Change Password</h1>

        <p class="description">
            Update your EduSphere account password securely.
        </p>

        <p class="account-email">
            ${sessionScope.email}
        </p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="message-error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/change-password"
              method="post">

            <div class="password-group">
                <label for="currentPassword">
                    Current Password
                </label>

                <input type="password"
                       id="currentPassword"
                       name="currentPassword"
                       autocomplete="current-password"
                       required>
            </div>

            <div class="password-group">
                <label for="newPassword">
                    New Password
                </label>

                <input type="password"
                       id="newPassword"
                       name="newPassword"
                       minlength="8"
                       autocomplete="new-password"
                       required>
            </div>

            <div class="password-group">
                <label for="confirmPassword">
                    Confirm New Password
                </label>

                <input type="password"
                       id="confirmPassword"
                       name="confirmPassword"
                       minlength="8"
                       autocomplete="new-password"
                       required>
            </div>

            <button type="submit" class="password-submit">
                Update Password
            </button>

        </form>

        <a href="javascript:history.back()" class="back-link">
            ← Go Back
        </a>

    </section>

</div>

</body>
</html>
