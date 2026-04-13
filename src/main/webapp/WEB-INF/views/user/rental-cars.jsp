<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Rentals - DriveEase</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="nav-brand">🚗 DriveEase</div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/user/home">Browse Cars</a>
        <a href="${pageContext.request.contextPath}/user/rented-cars" class="active">My Rentals</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
</nav>
<div class="container">
    <div class="page-header">
        <h2>My Rented Cars</h2>
        <a href="${pageContext.request.contextPath}/user/home" class="btn btn-primary btn-sm">Browse More</a>
    </div>
    <div class="table-wrapper">
        <table class="table">
            <thead>
                <tr><th>Rental ID</th><th>Car</th><th>Brand</th><th>Price/Day</th><th>Date Rented</th></tr>
            </thead>
            <tbody>
                <c:forEach var="r" items="${rentals}">
                    <tr>
                        <td>${r.rentalId}</td><td><strong>${r.carName}</strong></td>
                        <td>${r.carBrand}</td><td>$${r.carPrice}</td><td>${r.rentalDate}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty rentals}">
                    <tr><td colspan="5" class="empty-msg">No rentals yet. <a href="${pageContext.request.contextPath}/user/home">Browse cars →</a></td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>