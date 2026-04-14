<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home page - DriveEase</title>
    <link rel="stylesheet" href="/week5forcoursework/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="nav-brand">🚗 DriveEase</div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/user/home" class="active">Browse Cars</a>
        <a href="${pageContext.request.contextPath}/user/rented-cars">My Rentals</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
    <button class="nav-toggle" onclick="document.querySelector('.nav-links').classList.toggle('open')">☰</button>
</nav>
<div class="container">
    <div class="page-header">
        <div>
            <h2>Available Cars</h2>
            <p class="subtitle">Hello, <strong>${sessionScope.loggedUser.name}</strong></p>
        </div>
    </div>
    <c:if test="${not empty param.success}"><div class="alert alert-success">${param.success}</div></c:if>
    <c:if test="${not empty param.error}"><div class="alert alert-error">${param.error}</div></c:if>
    <div class="search-bar">
        <form action="${pageContext.request.contextPath}/search" method="get">
            <input type="text" name="keyword" placeholder="Search by name, brand or price...">
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
                <span class="badge badge-success">Available</span>
                <form action="${pageContext.request.contextPath}/user/rent" method="post">
                    <input type="hidden" name="carId" value="${car.carId}">
                    <button type="submit" class="btn btn-primary btn-full">Rent Now</button>
                </form>
            </div>
        </c:forEach>
        <c:if test="${empty cars}">
            <div class="empty-state"><p>🚫 No cars available at the moment.</p></div>
        </c:if>
    </div>
</div>
</body>
</html>