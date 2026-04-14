<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Search Results - DriveEase</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="nav-brand">🚗 DriveEase</div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/user/home">Browse Cars</a>
        <a href="${pageContext.request.contextPath}/user/rented-cars">My Rentals</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
</nav>
<div class="container">
    <div class="page-header">
        <h2>Results for: <em>"${keyword}"</em></h2>
        <a href="${pageContext.request.contextPath}/user/home" class="btn btn-secondary btn-sm">← Back</a>
    </div>
    <div class="search-bar">
        <form action="${pageContext.request.contextPath}/search" method="get">
            <input type="text" name="keyword" value="${keyword}" placeholder="Search again...">
            <button type="submit" class="btn btn-primary">Search</button>
        </form>
    </div>
    <div class="car-grid">
        <c:forEach var="car" items="${cars}">
            <div class="car-card">
                <div class="car-icon">🚗</div>
                <h3>${car.name}</h3>
                <p class="car-brand">${car.brand}</p>
                <p class="car-price">$${car.price}<span class="per-day"> / day</span></p>
                <span class="badge ${car.availability ? 'badge-success' : 'badge-danger'}">${car.availability ? 'Available' : 'Rented'}</span>
                <c:if test="${car.availability}">
                    <form action="${pageContext.request.contextPath}/user/rent" method="post">
                        <input type="hidden" name="carId" value="${car.carId}">
                        <button type="submit" class="btn btn-primary btn-full">Rent Now</button>
                    </form>
                </c:if>
            </div>
        </c:forEach>
        <c:if test="${empty cars}">
            <div class="empty-state"><p>No cars found for "<strong>${keyword}</strong>".</p></div>
        </c:if>
    </div>
</div>
</body>
</html>