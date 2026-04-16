<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — DriveEase</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .auth-page::before {
            background-image: url('https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=1800&q=85&fit=crop');
            background-position: center 55%;
        }
    </style>
</head>
<body class="auth-page">
<div class="auth-container">
    <div class="auth-card">
        <div class="auth-logo">🚗</div>
        <h1>DriveEase</h1>
        <h2>Create your account</h2>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-group">
                <label for="name">Full Name</label>
                <input type="text" id="name" name="name" required placeholder="John Doe">
            </div>
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" required placeholder="you@example.com">
            </div>
            <div class="form-group">
                <label for="password">Password <span class="hint">(min 6 characters)</span></label>
                <input type="password" id="password" name="password" required minlength="6">
            </div>
            <button type="submit" class="btn btn-primary btn-full">Create Account</button>
        </form>
        <div class="auth-links">
            <a href="${pageContext.request.contextPath}/login">Already have an account? Login</a>
        </div>
    </div>
</div>
</body>
</html>
