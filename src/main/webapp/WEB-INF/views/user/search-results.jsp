<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results - DriveEase</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="nav-brand">DriveEase</div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/user/home">Browse Cars</a>
        <a href="${pageContext.request.contextPath}/user/rented-cars">My Rentals</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
    <button class="nav-toggle" onclick="document.querySelector('.nav-links').classList.toggle('open')">
        <span></span><span></span><span></span>
    </button>
</nav>

<div class="container">
    <div class="page-header">
        <div>
            <h2>Results for: <em style="font-family:'Cormorant Garamond',serif;font-style:italic;font-weight:300;">"${keyword}"</em></h2>
        </div>
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
            <div class="car-card" data-brand="${car.brand}" data-name="${car.name}">
                <div class="car-card-img" id="simg-${car.carId}"></div>
                <span class="badge ${car.availability ? 'badge-success' : 'badge-danger'}">
                    ${car.availability ? 'Available' : 'Rented'}
                </span>
                <div class="car-card-body">
                    <h3>${car.name}</h3>
                    <p class="car-brand">${car.brand}</p>
                    <div class="car-divider"></div>
                    <div class="car-card-footer">
                        <p class="car-price">$${car.price}<span class="per-day"> / day</span></p>
                        <c:if test="${car.availability}">
                            <form action="${pageContext.request.contextPath}/user/rent" method="post">
                                <input type="hidden" name="carId" value="${car.carId}">
                                <button type="submit" class="btn btn-primary btn-full">Rent Now</button>
                            </form>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty cars}">
            <div class="empty-state">
                <p>No cars found for "<strong>${keyword}</strong>".</p>
            </div>
        </c:if>
    </div>
</div>

<script>
const carImages = {
    honda:   'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=600&q=75&fit=crop',
    civic:   'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=600&q=75&fit=crop',
    toyota:  'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=600&q=75&fit=crop',
    corolla: 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=600&q=75&fit=crop',
    tesla:   'https://images.unsplash.com/photo-1560958089-b8a1929cea89?w=600&q=75&fit=crop',
    'model 3': 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?w=600&q=75&fit=crop',
    ford:    'https://images.unsplash.com/photo-1584345604476-8ec5e12e42dd?w=600&q=75&fit=crop',
    mustang: 'https://images.unsplash.com/photo-1584345604476-8ec5e12e42dd?w=600&q=75&fit=crop',
    audi:    'https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?w=600&q=75&fit=crop',
    a4:      'https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?w=600&q=75&fit=crop',
    bmw:     'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=600&q=75&fit=crop',
    mercedes:'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=600&q=75&fit=crop',
    default: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=600&q=75&fit=crop'
};
document.querySelectorAll('.car-card').forEach(card => {
    const brand = (card.dataset.brand || '').toLowerCase();
    const name  = (card.dataset.name  || '').toLowerCase();
    const img   = card.querySelector('.car-card-img');
    if (!img) return;
    const url = carImages[name] || carImages[brand] || carImages.default;
    img.style.backgroundImage = `url('${url}')`;
});
</script>
</body>
</html>
