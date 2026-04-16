<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Car — DriveEase</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="nav-brand">DriveEase <span class="role-badge">Admin</span></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/add-car" class="active">+ Add Car</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
    <button class="nav-toggle" onclick="document.querySelector('.nav-links').classList.toggle('open')">
        <span></span><span></span><span></span>
    </button>
</nav>

<div class="container">
    <div class="page-header">
        <div>
            <h2>Add New Car</h2>
            <p class="subtitle">Add a vehicle to the DriveEase fleet</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary btn-sm">← Back</a>
    </div>
    <c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>
    <div class="form-card">
        <form action="${pageContext.request.contextPath}/admin/add-car" method="post">
            <div class="form-group">
                <label>Car Model Name</label>
                <input type="text" name="name" required placeholder="e.g. Civic">
            </div>
            <div class="form-group">
                <label>Brand</label>
                <input type="text" name="brand" required placeholder="e.g. Honda">
            </div>
            <div class="form-group">
                <label>Price per Day ($)</label>
                <input type="number" name="price" step="0.01" min="0" required placeholder="e.g. 50.00">
            </div>
            <div class="form-group checkbox-group">
                <input type="checkbox" id="availability" name="availability" checked>
                <label for="availability">Mark as Available</label>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Add Car</button>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>

<footer>
    <div class="footer-top">
        <div>
            <span class="footer-brand">DriveEase</span>
            <p class="footer-desc">Premium car rental built around you. Every vehicle, every journey — considered.</p>
        </div>
        <div>
            <div class="footer-col-title">Admin</div>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/add-car">Add Car</a></li>
            </ul>
        </div>
        <div>
            <div class="footer-col-title">Account</div>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/logout">Sign Out</a></li>
            </ul>
        </div>
        <div>
            <div class="footer-col-title">Support</div>
            <ul class="footer-links">
                <li><a href="#">Help Centre</a></li>
                <li><a href="#">Privacy Policy</a></li>
            </ul>
        </div>
    </div>
    <div class="footer-bottom">
        <span class="footer-copy">© 2025 <span>DriveEase</span>. All rights reserved.</span>
        <div class="footer-legal"><a href="#">Privacy</a><a href="#">Terms</a></div>
    </div>
</footer>
</body>
</html>
