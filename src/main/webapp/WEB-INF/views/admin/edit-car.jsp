<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Car - DriveEase</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="nav-brand">🚗 DriveEase <span class="role-badge">Admin</span></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
</nav>
<div class="container">
    <div class="page-header">
        <h2>Edit Car</h2>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary btn-sm">← Back</a>
    </div>
    <div class="form-card">
        <form action="${pageContext.request.contextPath}/admin/edit-car" method="post">
            <input type="hidden" name="carId" value="${car.carId}">
            <div class="form-group">
                <label>Car Model Name</label>
                <input type="text" name="name" value="${car.name}" required>
            </div>
            <div class="form-group">
                <label>Brand</label>
                <input type="text" name="brand" value="${car.brand}" required>
            </div>
            <div class="form-group">
                <label>Price per Day ($)</label>
                <input type="number" name="price" step="0.01" min="0" value="${car.price}" required>
            </div>
            <div class="form-group checkbox-group">
                <input type="checkbox" id="availability" name="availability" ${car.availability ? 'checked' : ''}>
                <label for="availability">Mark as Available</label>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Update Car</button>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>