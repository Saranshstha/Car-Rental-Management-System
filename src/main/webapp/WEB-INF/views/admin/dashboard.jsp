<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — DriveEase</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="nav-brand">DriveEase <span class="role-badge">Admin</span></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/add-car">+ Add Car</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
    <button class="nav-toggle" onclick="document.querySelector('.nav-links').classList.toggle('open')">
        <span></span><span></span><span></span>
    </button>
</nav>

<div class="container">

    <!-- ── PAGE HEADER ── -->
    <div class="page-header">
        <div>
            <h2>Dashboard</h2>
            <p class="subtitle">Welcome back, <strong>${sessionScope.loggedUser.name}</strong> — here's your fleet overview.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/add-car" class="btn btn-primary btn-sm">+ Add New Car</a>
    </div>

    <c:if test="${not empty param.success}"><div class="alert alert-success">${param.success}</div></c:if>
    <c:if test="${not empty param.error}"><div class="alert alert-error">${param.error}</div></c:if>

    <!-- ── STAT CARDS ── -->
    <div class="stat-grid">
        <div class="stat-card">
            <div class="stat-card-icon">🚗</div>
            <div class="stat-card-label">Total Vehicles</div>
            <div class="stat-card-value" id="totalCars">—</div>
            <div class="stat-card-sub">In your fleet</div>
        </div>
        <div class="stat-card accent">
            <div class="stat-card-icon">✅</div>
            <div class="stat-card-label">Available Now</div>
            <div class="stat-card-value" id="availCars">—</div>
            <div class="stat-card-sub">Ready to rent</div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon">🔑</div>
            <div class="stat-card-label">Currently Rented</div>
            <div class="stat-card-value" id="rentedCars">—</div>
            <div class="stat-card-sub">Active rentals</div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon">📋</div>
            <div class="stat-card-label">Total Rentals</div>
            <div class="stat-card-value" id="totalRentals">—</div>
            <div class="stat-card-sub">All time</div>
        </div>
    </div>

    <!-- ── QUICK ACTIONS ── -->
    <div style="margin-bottom:12px;">
        <p style="font-size:.6rem;letter-spacing:.22em;text-transform:uppercase;color:var(--t30);margin-bottom:14px;">Quick Actions</p>
    </div>
    <div class="quick-actions">
        <a href="${pageContext.request.contextPath}/admin/add-car" class="qa-card">
            <div class="qa-icon">➕</div>
            <div>
                <div class="qa-title">Add New Vehicle</div>
                <div class="qa-desc">Register a new car to the fleet</div>
            </div>
        </a>
        <div class="qa-card" onclick="document.getElementById('carTable').scrollIntoView({behavior:'smooth'})">
            <div class="qa-icon">📋</div>
            <div>
                <div class="qa-title">Manage Fleet</div>
                <div class="qa-desc">Edit or remove existing vehicles</div>
            </div>
        </div>
        <div class="qa-card" onclick="document.getElementById('rentalTable').scrollIntoView({behavior:'smooth'})">
            <div class="qa-icon">🗂</div>
            <div>
                <div class="qa-title">View All Rentals</div>
                <div class="qa-desc">See complete rental history</div>
            </div>
        </div>
    </div>

    <!-- ── SEARCH ── -->
    <div class="search-bar">
        <form action="${pageContext.request.contextPath}/search" method="get">
            <input type="text" name="keyword" placeholder="Search cars by name, brand or price...">
            <button type="submit" class="btn btn-primary">Search</button>
        </form>
    </div>

    <!-- ── ALL CARS TABLE ── -->
    <div class="section-header" id="carTable">
        <h3>All Cars</h3>
    </div>
    <div class="table-wrapper">
        <table class="table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Name</th>
                    <th>Brand</th>
                    <th>Price / Day</th>
                    <th>Status</th>
                    <th>Actions</th>
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
                            <a href="${pageContext.request.contextPath}/admin/edit-car?id=${car.carId}" class="btn btn-sm btn-secondary">Edit</a>
                            <a href="${pageContext.request.contextPath}/admin/delete-car?id=${car.carId}" class="btn btn-sm btn-danger" onclick="return confirm('Delete ${car.name}?')">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty cars}">
                    <tr><td colspan="6" class="empty-msg">No cars found. <a href="${pageContext.request.contextPath}/admin/add-car">Add one →</a></td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- ── ALL RENTALS TABLE ── -->
    <div class="section-header mt-30" id="rentalTable">
        <h3>All Rentals</h3>
    </div>
    <div class="table-wrapper">
        <table class="table">
            <thead>
                <tr>
                    <th>Rental ID</th>
                    <th>User ID</th>
                    <th>Car</th>
                    <th>Brand</th>
                    <th>Price / Day</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="r" items="${rentals}">
                    <tr>
                        <td>${r.rentalId}</td>
                        <td>${r.userId}</td>
                        <td><strong>${r.carName}</strong></td>
                        <td>${r.carBrand}</td>
                        <td>$${r.carPrice}</td>
                        <td>${r.rentalDate}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty rentals}">
                    <tr><td colspan="6" class="empty-msg">No rentals yet.</td></tr>
                </c:if>
            </tbody>
        </table>
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
                <li><a href="${pageContext.request.contextPath}/admin/add-car">Add Vehicle</a></li>
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
                <li><a href="#">Terms of Service</a></li>
            </ul>
        </div>
    </div>
    <div class="footer-bottom">
        <span class="footer-copy">© 2025 <span>DriveEase</span>. All rights reserved.</span>
        <div class="footer-legal">
            <a href="#">Privacy</a><a href="#">Terms</a><a href="#">Cookies</a>
        </div>
    </div>
</footer>

<script>
/* Count stats from the rendered table rows */
document.addEventListener('DOMContentLoaded', function() {
    const rows  = document.querySelectorAll('#carTable + .table-wrapper tbody tr:not(:has(.empty-msg))');
    let total = 0, avail = 0, rented = 0;
    rows.forEach(row => {
        const badge = row.querySelector('.badge');
        if (!badge) return;
        total++;
        if (badge.classList.contains('badge-success')) avail++;
        else rented++;
    });

    const rentalRows = document.querySelectorAll('#rentalTable + .table-wrapper tbody tr:not(:has(.empty-msg))');
    let totalRentals = 0;
    rentalRows.forEach(r => { if (!r.querySelector('.empty-msg')) totalRentals++; });

    document.getElementById('totalCars').textContent    = total    || '0';
    document.getElementById('availCars').textContent    = avail    || '0';
    document.getElementById('rentedCars').textContent   = rented   || '0';
    document.getElementById('totalRentals').textContent = totalRentals || '0';
});
</script>
</body>
</html>
