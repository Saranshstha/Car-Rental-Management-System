<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password — DriveEase</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .auth-page::before {
            background-image: url('https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=1800&q=85&fit=crop');
            background-position: center 40%;
        }
    </style>
</head>
<body class="auth-page">
<div class="auth-container">
    <div class="auth-card">
        <div class="auth-logo">🔐</div>
        <h1>DriveEase</h1>
        <h2>Reset your password</h2>
        <c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>
        <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
        <form action="${pageContext.request.contextPath}/reset-password" method="post">
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" required placeholder="your registered email">
            </div>
            <div class="form-group">
                <label for="newPassword">New Password</label>
                <input type="password" id="newPassword" name="newPassword" required minlength="6">
            </div>
            <button type="submit" class="btn btn-primary btn-full">Reset Password</button>
        </form>
        <div class="auth-links">
            <a href="${pageContext.request.contextPath}/login">Back to Login</a>
        </div>
    </div>
</div>
</body>
</html>
