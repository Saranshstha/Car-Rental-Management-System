<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Fleet — DriveEase</title>
    <link rel="stylesheet" href="/week5forcoursework/css/style.css">
    <style>
        .modal-backdrop{position:fixed;inset:0;background:rgba(0,0,0,0.72);backdrop-filter:blur(6px);z-index:900;display:flex;align-items:center;justify-content:center;padding:20px;opacity:0;pointer-events:none;transition:opacity .3s}
        .modal-backdrop.open{opacity:1;pointer-events:all}
        .modal-box{background:#fff;max-width:520px;width:100%;transform:translateY(20px) scale(.97);transition:all .3s;overflow:hidden;max-height:90vh;overflow-y:auto}
        .modal-backdrop.open .modal-box{transform:translateY(0) scale(1)}
        .modal-header{background:#1a1a1a;padding:22px 28px;display:flex;align-items:flex-start;justify-content:space-between;position:sticky;top:0;z-index:1}
        .modal-header h3{font-family:'Cormorant Garamond',serif;font-size:1.4rem;font-weight:300;color:#f5f4f0}
        .modal-header p{font-size:.72rem;color:rgba(245,244,240,0.5);margin-top:4px}
        .modal-close-btn{background:none;border:none;color:rgba(245,244,240,0.5);font-size:1.1rem;cursor:pointer;line-height:1;transition:color .2s;flex-shrink:0}
        .modal-close-btn:hover{color:#f5f4f0}
        .modal-body{padding:24px 28px}
        .modal-car-info{background:#f8f7f4;border:1px solid rgba(0,0,0,0.07);padding:12px 16px;margin-bottom:20px;display:flex;align-items:center;justify-content:space-between}
        .modal-car-name{font-family:'Cormorant Garamond',serif;font-size:1.1rem;font-weight:400;color:#111}
        .modal-car-brand{font-size:.65rem;letter-spacing:.18em;text-transform:uppercase;color:rgba(17,17,17,0.35);margin-top:2px}
        .modal-car-price{font-family:'Cormorant Garamond',serif;font-size:1.2rem;font-weight:400;color:#111;text-align:right}
        .modal-car-price small{font-family:'DM Sans',sans-serif;font-size:.65rem;color:rgba(17,17,17,0.35);display:block}
        .modal-field{margin-bottom:16px}
        .modal-label{display:block;font-size:.58rem;letter-spacing:.2em;text-transform:uppercase;color:rgba(17,17,17,0.35);margin-bottom:6px}
        .modal-input{width:100%;padding:9px 0;background:transparent;border:none;border-bottom:1px solid rgba(0,0,0,0.15);font-size:.88rem;font-family:'DM Sans',sans-serif;color:#111;outline:none;transition:border-color .2s}
        .modal-input:focus{border-bottom-color:#1a1a1a}
        .modal-input::placeholder{color:rgba(17,17,17,0.28)}
        .modal-row{display:grid;grid-template-columns:1fr 1fr;gap:16px}
        .modal-info-bar{background:#f8f7f4;border:1px solid rgba(0,0,0,0.07);padding:10px 16px;margin:12px 0;display:flex;align-items:center;justify-content:space-between}
        .modal-info-label{font-size:.6rem;letter-spacing:.18em;text-transform:uppercase;color:rgba(17,17,17,0.45)}
        .modal-info-value{font-family:'Cormorant Garamond',serif;font-size:1.1rem;font-weight:400;color:#111}
        .modal-submit-btn{width:100%;padding:13px;background:#1a1a1a;color:#f5f4f0;border:none;font-size:.7rem;font-weight:500;letter-spacing:.18em;text-transform:uppercase;cursor:pointer;font-family:'DM Sans',sans-serif;transition:background .2s;margin-top:16px}
        .modal-submit-btn:hover{background:#2a2a2a}
    </style>
</head>
<body>
<nav class="navbar">
    <div class="nav-brand">DriveEase</div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/user/home" class="active">Browse Cars</a>
        <a href="${pageContext.request.contextPath}/user/rented-cars">My Rentals</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
    <button class="nav-toggle" onclick="document.querySelector('.nav-links').classList.toggle('open')">
        <span></span><span></span><span></span>
    </button>
</nav>

<section class="hero" id="hero">
    <div class="hero-bg" id="heroBg"></div>
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <div class="hero-eyebrow">Premium Car Rental</div>
        <h1>Drive the car<br>you <em>deserve.</em></h1>
        <p>Handpicked vehicles, transparent pricing, and the freedom to go anywhere. Welcome, <strong style="font-weight:400;color:#f5f4f0;">${sessionScope.loggedUser.name}</strong>.</p>
        <div class="hero-actions">
            <a href="#fleet" class="btn-hero">Browse Fleet <span class="btn-hero-arrow">&#8250;</span></a>
            <a href="${pageContext.request.contextPath}/user/rented-cars" class="btn-hero-ghost">My Rentals</a>
        </div>
    </div>
    <div class="hero-dots">
        <div class="hero-dot active" onclick="changeHero(0)"></div>
        <div class="hero-dot" onclick="changeHero(1)"></div>
        <div class="hero-dot" onclick="changeHero(2)"></div>
    </div>
    <div class="hero-scroll"><div class="hero-scroll-line"></div>Scroll</div>
</section>

<div class="brand-strip">
    <span class="bs-label">Our Fleet Includes</span>
    <div class="bs-sep"></div>
    <div class="bs-items">
        <span class="bs-item">Toyota</span><span class="bs-item">Honda</span>
        <span class="bs-item">Tesla</span><span class="bs-item">BMW</span>
        <span class="bs-item">Audi</span><span class="bs-item">Mercedes</span>
        <span class="bs-item">Ford</span><span class="bs-item">Porsche</span>
    </div>
</div>

<div class="intro-strip">
    <div class="intro-col">
        <div class="intro-col-icon">&#9889;</div>
        <div class="intro-col-title">Instant Booking</div>
        <div class="intro-col-text">Reserve any vehicle in under two minutes. No paperwork, no hidden fees.</div>
    </div>
    <div class="intro-col">
        <div class="intro-col-icon">&#128737;</div>
        <div class="intro-col-title">Fully Insured</div>
        <div class="intro-col-text">Every rental includes comprehensive coverage so you can focus on the journey.</div>
    </div>
    <div class="intro-col">
        <div class="intro-col-icon">&#128205;</div>
        <div class="intro-col-title">Delivered to You</div>
        <div class="intro-col-text">We deliver to your home, office, or hotel. Fuelled, cleaned, and ready.</div>
    </div>
</div>

<div class="container" id="fleet">
    <c:if test="${not empty param.success}"><div class="alert alert-success">${param.success}</div></c:if>
    <c:if test="${not empty param.error}"><div class="alert alert-error">${param.error}</div></c:if>

    <div class="page-header">
        <div>
            <h2>Available Cars</h2>
            <p class="subtitle">Choose from our curated fleet of premium vehicles</p>
        </div>
    </div>

    <div class="search-bar">
        <form action="${pageContext.request.contextPath}/search" method="get">
            <input type="text" name="keyword" placeholder="Search by name, brand or price...">
            <button type="submit" class="btn btn-primary">Search</button>
        </form>
    </div>

    <div class="car-grid">
        <c:forEach var="car" items="${cars}">
            <div class="car-card"
                 data-brand="${car.brand}"
                 data-name="${car.name}"
                 data-img="${not empty car.imageUrl ? car.imageUrl : ''}">
                <div class="car-card-img"></div>
                <span class="badge badge-success">Available</span>
                <div class="car-card-body">
                    <h3>${car.name}</h3>
                    <p class="car-brand">${car.brand}</p>
                    <div class="car-divider"></div>
                    <div class="car-card-footer">
                        <p class="car-price">$${car.price}<span class="per-day"> / day</span></p>
                        <button type="button" class="btn btn-primary"
                                onclick="openRentModal('${car.carId}','${car.name}','${car.brand}','${car.price}')">
                            Rent Now
                        </button>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty cars}">
            <div class="empty-state"><p>No cars available at the moment. Check back soon.</p></div>
        </c:if>
    </div>
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
        <div class="footer-legal"><a href="#">Privacy</a><a href="#">Terms</a><a href="#">Cookies</a></div>
    </div>
</footer>

<!-- RENTAL CONFIRMATION MODAL -->
<div class="modal-backdrop" id="rentModal" onclick="closeModalOutside(event)">
    <div class="modal-box">
        <div class="modal-header">
            <div>
                <h3>Confirm Rental</h3>
                <p>Review your details before confirming</p>
            </div>
            <button class="modal-close-btn" onclick="closeModal()">&#10005;</button>
        </div>
        <div class="modal-body">
            <div class="modal-car-info">
                <div>
                    <div class="modal-car-name" id="modalCarName">—</div>
                    <div class="modal-car-brand" id="modalCarBrand">—</div>
                </div>
                <div class="modal-car-price">
                    $<span id="modalCarPrice">—</span>
                    <small>per day</small>
                </div>
            </div>
            <form action="${pageContext.request.contextPath}/user/rent" method="post">
                <input type="hidden" name="carId" id="modalCarId">
                <div class="modal-row">
                    <div class="modal-field">
                        <label class="modal-label">Full Name</label>
                        <input class="modal-input" type="text" name="renterName" id="modalRenterName" placeholder="Your name" required>
                    </div>
                    <div class="modal-field">
                        <label class="modal-label">Phone Number</label>
                        <input class="modal-input" type="tel" name="renterPhone" id="modalRenterPhone" placeholder="+977 98XXXXXXXX" required>
                    </div>
                </div>
                <div class="modal-field">
                    <label class="modal-label">Email Address</label>
                    <input class="modal-input" type="email" name="renterEmail" id="modalRenterEmail" placeholder="your@email.com" required>
                </div>
                <div class="modal-field">
                    <label class="modal-label">Pickup Location</label>
                    <input class="modal-input" type="text" name="renterLocation" id="modalLocation" placeholder="e.g. Kathmandu, Thamel" required>
                </div>
                <div class="modal-row">
                    <div class="modal-field">
                        <label class="modal-label">Pickup Date &amp; Time</label>
                        <input class="modal-input" type="datetime-local" name="pickupDatetime" id="modalPickup" required oninput="updateReturn()">
                    </div>
                    <div class="modal-field">
                        <label class="modal-label">Number of Days</label>
                        <input class="modal-input" type="number" name="days" id="modalDays" min="1" max="365" value="1" required oninput="updateReturn()">
                    </div>
                </div>
                <div class="modal-info-bar">
                    <span class="modal-info-label">Return Date</span>
                    <span class="modal-info-value" id="modalReturn">—</span>
                </div>
                <div class="modal-info-bar">
                    <span class="modal-info-label">Estimated Total</span>
                    <span class="modal-info-value" id="modalTotal">$0.00</span>
                </div>
                <button type="submit" class="modal-submit-btn">Confirm &amp; Reserve</button>
            </form>
        </div>
    </div>
</div>

<script>
var SESSION_NAME  = '${sessionScope.loggedUser.name}';
var SESSION_EMAIL = '${sessionScope.loggedUser.email}';
var CTX           = '${pageContext.request.contextPath}';
var PRICE_NOW     = 0;

/* ── Hero slideshow ── */
var heroImgs = [
    'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=1800&q=85&fit=crop',
    'https://images.unsplash.com/photo-1553440569-bcc63803a83d?w=1800&q=85&fit=crop',
    'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=1800&q=85&fit=crop'
];
var heroIdx = 0;
var heroBg  = document.getElementById('heroBg');
var heroDots = document.querySelectorAll('.hero-dot');
function changeHero(i) {
    heroIdx = i;
    heroBg.style.backgroundImage = "url('" + heroImgs[i] + "')";
    heroDots.forEach(function(d,j){ d.classList.toggle('active', i===j); });
}
changeHero(0);
setInterval(function(){ changeHero((heroIdx+1) % heroImgs.length); }, 6000);

/* ── Fallback photo map ── */
var PHOTOS = {
    'civic':   'https://images.unsplash.com/photo-1590362891991-f776e747a588?w=700&q=80&fit=crop',
    'honda':   'https://images.unsplash.com/photo-1590362891991-f776e747a588?w=700&q=80&fit=crop',
    'corolla': 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=700&q=80&fit=crop',
    'supra':   'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=700&q=80&fit=crop',
    'toyota':  'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=700&q=80&fit=crop',
    'model 3': 'https://images.unsplash.com/photo-1554744512-d6c603f27c54?w=700&q=80&fit=crop',
    'tesla':   'https://images.unsplash.com/photo-1554744512-d6c603f27c54?w=700&q=80&fit=crop',
    'mustang': 'https://images.unsplash.com/photo-1547744152-14d985cb937f?w=700&q=80&fit=crop',
    'ford':    'https://images.unsplash.com/photo-1547744152-14d985cb937f?w=700&q=80&fit=crop',
    'a4':      'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=700&q=80&fit=crop',
    'audi':    'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=700&q=80&fit=crop',
    'bmw':     'https://images.unsplash.com/photo-1556189250-72ba954cfc2b?w=700&q=80&fit=crop',
    'mercedes':'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=700&q=80&fit=crop',
    'porsche': 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=700&q=80&fit=crop',
    'maybach': 'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=700&q=80&fit=crop',
    'default': 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=700&q=80&fit=crop'
};

/* ── Assign car images — DB first, fallback second ── */
document.querySelectorAll('.car-card').forEach(function(card) {
    var brand  = (card.dataset.brand || '').toLowerCase().trim();
    var name   = (card.dataset.name  || '').toLowerCase().trim();
    var dbImg  = (card.dataset.img   || '').trim();
    var imgEl  = card.querySelector('.car-card-img');
    if (!imgEl) return;
    if (dbImg && dbImg !== 'null' && dbImg.length > 1) {
        imgEl.style.backgroundImage = "url('" + CTX + dbImg + "')";
    } else {
        var url = PHOTOS[name] || PHOTOS[brand] || PHOTOS['default'];
        imgEl.style.backgroundImage = "url('" + url + "')";
    }
});

/* ── Rent modal ── */
function openRentModal(carId, carName, carBrand, carPrice) {
    PRICE_NOW = parseFloat(carPrice) || 0;
    document.getElementById('modalCarId').value          = carId;
    document.getElementById('modalCarName').textContent  = carName;
    document.getElementById('modalCarBrand').textContent = carBrand;
    document.getElementById('modalCarPrice').textContent = parseFloat(carPrice).toFixed(2);
    document.getElementById('modalDays').value           = 1;
    document.getElementById('modalRenterName').value     = SESSION_NAME  || '';
    document.getElementById('modalRenterEmail').value    = SESSION_EMAIL || '';
    document.getElementById('modalRenterPhone').value    = '';
    document.getElementById('modalLocation').value       = '';
    var now = new Date();
    var pad = function(n){ return String(n).padStart(2,'0'); };
    document.getElementById('modalPickup').value =
        now.getFullYear() + '-' + pad(now.getMonth()+1) + '-' + pad(now.getDate()) +
        'T' + pad(now.getHours()) + ':' + pad(now.getMinutes());
    updateReturn();
    document.getElementById('rentModal').classList.add('open');
    document.body.style.overflow = 'hidden';
}
function closeModal() {
    document.getElementById('rentModal').classList.remove('open');
    document.body.style.overflow = '';
}
function closeModalOutside(e) {
    if (e.target === document.getElementById('rentModal')) closeModal();
}
function updateReturn() {
    var pickupVal = document.getElementById('modalPickup').value;
    var days = parseInt(document.getElementById('modalDays').value) || 1;
    var pad  = function(n){ return String(n).padStart(2,'0'); };
    if (pickupVal) {
        var pickup = new Date(pickupVal);
        var ret    = new Date(pickup.getTime() + days * 86400000);
        document.getElementById('modalReturn').textContent =
            ret.getFullYear() + '-' + pad(ret.getMonth()+1) + '-' + pad(ret.getDate()) +
            ' ' + pad(ret.getHours()) + ':' + pad(ret.getMinutes());
    } else {
        document.getElementById('modalReturn').textContent = '—';
    }
    document.getElementById('modalTotal').textContent = '$' + (PRICE_NOW * days).toFixed(2);
}
document.addEventListener('keydown', function(e){ if(e.key === 'Escape') closeModal(); });

/* ── After rent/error: scroll to fleet ── */
(function() {
    var p = new URLSearchParams(window.location.search);
    if (p.get('success') || p.get('error')) {
        setTimeout(function() {
            var el = document.getElementById('fleet');
            if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }, 120);
    }
})();
</script>
</body>
</html>
