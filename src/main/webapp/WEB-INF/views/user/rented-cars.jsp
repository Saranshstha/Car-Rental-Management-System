<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Rentals — DriveEase</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .rental-card{background:#fff;border:1px solid rgba(0,0,0,0.08);margin-bottom:16px;overflow:hidden;transition:border-color .25s,transform .25s,box-shadow .25s}
        .rental-card:hover{border-color:rgba(0,0,0,0.15);transform:translateY(-2px);box-shadow:0 6px 24px rgba(0,0,0,0.08)}
        .rental-card-header{display:flex;align-items:stretch;gap:0}
        .rental-card-img{width:180px;min-height:130px;background-size:cover;background-position:center;flex-shrink:0;filter:brightness(.82) saturate(.85)}
        .rental-card-info{flex:1;padding:20px 24px;display:flex;flex-direction:column;justify-content:space-between}
        .rental-card-top{display:flex;align-items:flex-start;justify-content:space-between;gap:12px;flex-wrap:wrap}
        .rental-car-name{font-family:'Cormorant Garamond',serif;font-size:1.35rem;font-weight:400;color:#111;margin-bottom:3px}
        .rental-car-brand{font-size:.64rem;letter-spacing:.2em;text-transform:uppercase;color:rgba(17,17,17,0.32);margin-bottom:12px}
        .rental-status-badge{font-size:.58rem;font-weight:500;letter-spacing:.2em;text-transform:uppercase;padding:4px 10px;border:1px solid rgba(30,110,69,0.35);color:#1e6e45;background:rgba(30,110,69,0.06)}
        .rental-meta{display:flex;gap:24px;flex-wrap:wrap;margin-top:4px}
        .rental-meta-item{}
        .rental-meta-label{font-size:.58rem;letter-spacing:.18em;text-transform:uppercase;color:rgba(17,17,17,0.32);margin-bottom:3px}
        .rental-meta-value{font-size:.9rem;font-weight:400;color:#111}
        .rental-meta-value.price{font-family:'Cormorant Garamond',serif;font-size:1.15rem}
        .rental-card-footer{background:#f8f7f4;border-top:1px solid rgba(0,0,0,0.07);padding:12px 24px;display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap}
        .rental-footer-date{font-size:.72rem;color:rgba(17,17,17,0.45);letter-spacing:.03em}
        .btn-cancel{padding:8px 18px;font-size:.62rem;font-weight:500;letter-spacing:.14em;text-transform:uppercase;background:transparent;color:#c0392b;border:1px solid rgba(192,57,43,0.35);cursor:pointer;font-family:'DM Sans',sans-serif;transition:all .2s}
        .btn-cancel:hover{background:rgba(192,57,43,0.06);border-color:#c0392b}
        .empty-rentals{text-align:center;padding:72px 40px;background:#fff;border:1px solid rgba(0,0,0,0.08)}
        .empty-rentals h3{font-family:'Cormorant Garamond',serif;font-size:1.5rem;font-weight:300;color:#111;margin-bottom:10px}
        .empty-rentals p{font-size:.82rem;font-weight:300;color:rgba(17,17,17,0.45);letter-spacing:.04em;margin-bottom:24px}
        /* cancel confirm popup */
        .cancel-backdrop{position:fixed;inset:0;background:rgba(0,0,0,0.65);backdrop-filter:blur(4px);z-index:900;display:flex;align-items:center;justify-content:center;padding:20px;opacity:0;pointer-events:none;transition:opacity .25s}
        .cancel-backdrop.open{opacity:1;pointer-events:all}
        .cancel-box{background:#fff;max-width:380px;width:100%;padding:32px;transform:scale(.96);transition:transform .25s}
        .cancel-backdrop.open .cancel-box{transform:scale(1)}
        .cancel-box h3{font-family:'Cormorant Garamond',serif;font-size:1.3rem;font-weight:300;color:#111;margin-bottom:10px}
        .cancel-box p{font-size:.82rem;font-weight:300;color:rgba(17,17,17,0.55);line-height:1.7;margin-bottom:24px}
        .cancel-actions{display:flex;gap:10px}
    </style>
</head>
<body>
<nav class="navbar">
    <div class="nav-brand">DriveEase</div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/user/home">Browse Cars</a>
        <a href="${pageContext.request.contextPath}/user/rented-cars" class="active">My Rentals</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
    <button class="nav-toggle" onclick="document.querySelector('.nav-links').classList.toggle('open')">
        <span></span><span></span><span></span>
    </button>
</nav>

<div class="container">
    <div class="page-header">
        <div>
            <h2>My Rentals</h2>
            <p class="subtitle">Your active and completed reservations</p>
        </div>
        <a href="${pageContext.request.contextPath}/user/home" class="btn btn-secondary btn-sm">&#8592; Browse More</a>
    </div>

    <c:if test="${not empty param.success}"><div class="alert alert-success">${param.success}</div></c:if>
    <c:if test="${not empty param.error}"><div class="alert alert-error">${param.error}</div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>

    <c:choose>
        <c:when test="${not empty rentals}">
            <c:forEach var="r" items="${rentals}">
                <div class="rental-card" data-brand="${r.carBrand}" data-name="${r.carName}">
                    <div class="rental-card-header">
                        <div class="rental-card-img" id="rimg-${r.rentalId}"></div>
                        <div class="rental-card-info">
                            <div class="rental-card-top">
                                <div>
                                    <div class="rental-car-name">${r.carName}</div>
                                    <div class="rental-car-brand">${r.carBrand}</div>
                                </div>
                                <span class="rental-status-badge">Active</span>
                            </div>
                            <div class="rental-meta">
                                <div class="rental-meta-item">
                                    <div class="rental-meta-label">Days Rented</div>
                                    <div class="rental-meta-value">
                                        <c:choose>
                                            <c:when test="${r.days > 0}">${r.days} day<c:if test="${r.days > 1}">s</c:if></c:when>
                                            <c:otherwise>1 day</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="rental-meta-item">
                                    <div class="rental-meta-label">Price / Day</div>
                                    <div class="rental-meta-value">$${r.carPrice}</div>
                                </div>
                                <div class="rental-meta-item">
                                    <div class="rental-meta-label">Total Cost</div>
                                    <div class="rental-meta-value price">
                                        <c:choose>
                                            <c:when test="${r.totalCost > 0}">$${r.totalCost}</c:when>
                                            <c:otherwise>$${r.carPrice}</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <c:if test="${not empty r.renterPhone}">
                                    <div class="rental-meta-item">
                                        <div class="rental-meta-label">Contact</div>
                                        <div class="rental-meta-value">${r.renterPhone}</div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    <div class="rental-card-footer">
                        <span class="rental-footer-date">Rented on ${r.rentalDate} &nbsp;&middot;&nbsp; Rental #${r.rentalId}</span>
                        <button type="button" class="btn-cancel"
                                onclick="openCancelModal(${r.rentalId}, '${r.carName}')">
                            Cancel Reservation
                        </button>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="empty-rentals">
                <h3>No rentals yet</h3>
                <p>You haven't rented any vehicles. Browse the fleet and reserve your first car.</p>
                <a href="${pageContext.request.contextPath}/user/home" class="btn btn-primary">Browse Fleet</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<footer>
    <div class="footer-top">
        <div>
            <span class="footer-brand">DriveEase</span>
            <p class="footer-desc">Premium car rental built around you. Every vehicle, every journey — considered.</p>
        </div>
        <div>
            <div class="footer-col-title">Navigate</div>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/user/home">Browse Fleet</a></li>
                <li><a href="${pageContext.request.contextPath}/user/rented-cars">My Rentals</a></li>
            </ul>
        </div>
        <div>
            <div class="footer-col-title">Account</div>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/logout">Sign Out</a></li>
                <li><a href="${pageContext.request.contextPath}/reset-password">Reset Password</a></li>
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
        <span class="footer-copy">&copy; 2025 <span>DriveEase</span>. All rights reserved.</span>
        <div class="footer-legal">
            <a href="#">Privacy</a><a href="#">Terms</a><a href="#">Cookies</a>
        </div>
    </div>
</footer>

<!-- ── CANCEL CONFIRMATION ── -->
<div class="cancel-backdrop" id="cancelBackdrop" onclick="closeCancelOutside(event)">
    <div class="cancel-box">
        <h3>Cancel Reservation</h3>
        <p>Are you sure you want to cancel the reservation for <strong id="cancelCarName">this car</strong>? This action cannot be undone and the vehicle will be made available again.</p>
        <div class="cancel-actions">
            <form id="cancelForm" action="${pageContext.request.contextPath}/user/cancel" method="post" style="display:inline">
                <input type="hidden" name="rentalId" id="cancelRentalId">
                <button type="submit" class="btn btn-danger btn-sm">Yes, Cancel</button>
            </form>
            <button type="button" class="btn btn-secondary btn-sm" onclick="closeCancel()">Keep Reservation</button>
        </div>
    </div>
</div>

<script>
/* Car photo mapping — string concat only, no backticks */
var carPhotos = {
    'civic':    'https://images.unsplash.com/photo-1590362891991-f776e747a588?w=500&q=75&fit=crop',
    'honda':    'https://images.unsplash.com/photo-1590362891991-f776e747a588?w=500&q=75&fit=crop',
    'corolla':  'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=500&q=75&fit=crop',
    'toyota':   'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=500&q=75&fit=crop',
    'model 3':  'https://images.unsplash.com/photo-1554744512-d6c603f27c54?w=500&q=75&fit=crop',
    'tesla':    'https://images.unsplash.com/photo-1554744512-d6c603f27c54?w=500&q=75&fit=crop',
    'mustang':  'https://images.unsplash.com/photo-1547744152-14d985cb937f?w=500&q=75&fit=crop',
    'ford':     'https://images.unsplash.com/photo-1547744152-14d985cb937f?w=500&q=75&fit=crop',
    'a4':       'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=500&q=75&fit=crop',
    'audi':     'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=500&q=75&fit=crop',
    'bmw':      'https://images.unsplash.com/photo-1556189250-72ba954cfc2b?w=500&q=75&fit=crop',
    'mercedes': 'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=500&q=75&fit=crop',
    'default':  'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=500&q=75&fit=crop'
};
document.querySelectorAll('.rental-card').forEach(function(card) {
    var brand = (card.dataset.brand || '').toLowerCase().trim();
    var name  = (card.dataset.name  || '').toLowerCase().trim();
    var imgId = 'rimg-' + card.querySelector('[id^="rimg-"]').id.replace('rimg-','');
    var img   = document.getElementById(imgId);
    if (!img) return;
    var url = carPhotos[name] || carPhotos[brand] || carPhotos['default'];
    img.style.backgroundImage = "url('" + url + "')";
});

/* Cancel modal */
function openCancelModal(rentalId, carName) {
    document.getElementById('cancelRentalId').value       = rentalId;
    document.getElementById('cancelCarName').textContent  = carName;
    document.getElementById('cancelBackdrop').classList.add('open');
    document.body.style.overflow = 'hidden';
}
function closeCancel() {
    document.getElementById('cancelBackdrop').classList.remove('open');
    document.body.style.overflow = '';
}
function closeCancelOutside(e) {
    if (e.target === document.getElementById('cancelBackdrop')) closeCancel();
}
document.addEventListener('keydown', function(e){ if(e.key==='Escape') closeCancel(); });
</script>
</body>
</html>
