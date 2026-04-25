<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results — DriveEase Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="nav-brand">DriveEase <span class="role-badge">Admin</span></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/add-car">+ Add Car</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
    <button class="nav-toggle" onclick="document.querySelector('.nav-links').classList.toggle('open')">
        <span></span><span></span><span></span>
    </button>
</nav>

<div class="container">
    <div class="page-header">
        <div>
            <h2>Results for: <em style="font-style:italic;font-weight:300">"${keyword}"</em></h2>
            <p class="subtitle"><c:choose><c:when test="${not empty cars}">${cars.size()} vehicle(s) found</c:when><c:otherwise>No results</c:otherwise></c:choose></p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary btn-sm">&#8592; Dashboard</a>
    </div>

    <div class="search-bar">
        <form action="${pageContext.request.contextPath}/search" method="get">
            <input type="text" name="keyword" value="${keyword}" placeholder="Search again...">
            <button type="submit" class="btn btn-primary">Search</button>
        </form>
    </div>

    <div class="table-wrapper">
        <table class="table">
            <thead>
                <tr>
                    <th>#</th><th>Name</th><th>Brand</th>
                    <th>Price / Day</th><th>Status</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="car" items="${cars}">
                    <tr>
                        <td>${car.carId}</td>
                        <td><strong>${car.name}</strong></td>
                        <td>${car.brand}</td>
                        <td>$${car.price}</td>
                        <td>
                            <span class="badge ${car.availability ? 'badge-success' : 'badge-danger'}">
                                ${car.availability ? 'Available' : 'Rented'}
                            </span>
                        </td>
                        <td class="action-cell">
                            <a href="${pageContext.request.contextPath}/admin/edit-car?id=${car.carId}"
                               class="btn btn-sm btn-secondary">Edit</a>
                            <a href="${pageContext.request.contextPath}/admin/delete-car?id=${car.carId}"
                               class="btn btn-sm btn-danger"
                               onclick="return confirm('Delete ${car.name}?')">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty cars}">
                    <tr><td colspan="6" class="empty-msg">No cars found for "${keyword}".</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<footer>
    <div class="footer-top">
        <div><span class="footer-brand">DriveEase</span><p class="footer-desc">Premium car rental built around you.</p></div>
        <div>
            <div class="footer-col-title">Admin</div>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/add-car">Add Vehicle</a></li>
            </ul>
        </div>
        <div>
            <div class="footer-col-title">Account</div>
            <ul class="footer-links"><li><a href="${pageContext.request.contextPath}/logout">Sign Out</a></li></ul>
        </div>
        <div>
            <div class="footer-col-title">Support</div>
            <ul class="footer-links"><li><a href="#">Help Centre</a></li></ul>
        </div>
    </div>
    <div class="footer-bottom">
        <span class="footer-copy">&copy; 2025 <span>DriveEase</span>. All rights reserved.</span>
        <div class="footer-legal"><a href="#">Privacy</a><a href="#">Terms</a></div>
    </div>
</footer>
</body>
</html>
