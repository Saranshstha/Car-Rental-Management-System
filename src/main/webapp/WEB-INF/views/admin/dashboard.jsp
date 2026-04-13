<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - DriveEase</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="nav-brand">🚗 DriveEase <span class="role-badge">Admin</span></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/add-car">+ Add Car</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
    <button class="nav-toggle" onclick="document.querySelector('.nav-links').classList.toggle('open')">☰</button>
</nav>
<div class="container">
    <div class="page-header">
        <div>
            <h2>Dashboard</h2>
            <p class="subtitle">Welcome, <strong>${sessionScope.loggedUser.name}</strong></p>
        </div>
    </div>
    <c:if test="${not empty param.success}"><div class="alert alert-success">${param.success}</div></c:if>
    <c:if test="${not empty param.error}"><div class="alert alert-error">${param.error}</div></c:if>
    <div class="search-bar">
        <form action="${pageContext.request.contextPath}/search" method="get">
            <input type="text" name="keyword" placeholder="Search cars by name, brand or price...">
            <button type="submit" class="btn btn-primary">Search</button>
        </form>
    </div>
    <div class="section-header">
        <h3>All Cars</h3>
        <a href="${pageContext.request.contextPath}/admin/add-car" class="btn btn-primary btn-sm">+ Add New Car</a>
    </div>
    <div class="table-wrapper">
        <table class="table">
            <thead>
                <tr><th>#</th><th>Name</th><th>Brand</th><th>Price/Day</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
                <c:forEach var="car" items="${cars}">
                    <tr>
                        <td>${car.carId}</td>
                        <td><strong>${car.name}</strong></td>
                        <td>${car.brand}</td>
                        <td>$${car.price}</td>
                        <td><span class="badge ${car.availability ? 'badge-success' : 'badge-danger'}">${car.availability ? 'Available' : 'Rented'}</span></td>
                        <td class="action-cell">
                            <a href="${pageContext.request.contextPath}/admin/edit-car?id=${car.carId}" class="btn btn-sm btn-secondary">Edit</a>
                            <a href="${pageContext.request.contextPath}/admin/delete-car?id=${car.carId}" class="btn btn-sm btn-danger" onclick="return confirm('Delete ${car.name}?')">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty cars}"><tr><td colspan="6" class="empty-msg">No cars found.</td></tr></c:if>
            </tbody>
        </table>
    </div>
    <h3 class="mt-30">All Rentals</h3>
    <div class="table-wrapper">
        <table class="table">
            <thead>
                <tr><th>Rental ID</th><th>User ID</th><th>Car</th><th>Brand</th><th>Price/Day</th><th>Date</th></tr>
            </thead>
            <tbody>
                <c:forEach var="r" items="${rentals}">
                    <tr>
                        <td>${r.rentalId}</td><td>${r.userId}</td>
                        <td><strong>${r.carName}</strong></td>
                        <td>${r.carBrand}</td><td>$${r.carPrice}</td><td>${r.rentalDate}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty rentals}"><tr><td colspan="6" class="empty-msg">No rentals yet.</td></tr></c:if>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>