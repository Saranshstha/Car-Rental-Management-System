<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Rentals — DriveEase</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .rental-card{background:#fff;border:1px solid rgba(0,0,0,0.08);margin-bottom:18px;overflow:hidden;transition:border-color .25s,transform .2s,box-shadow .25s}
        .rental-card:hover{border-color:rgba(0,0,0,0.14);transform:translateY(-2px);box-shadow:0 6px 24px rgba(0,0,0,0.08)}
        .rental-card.is-expired{opacity:.72;filter:grayscale(.3)}
        .rc-top{display:flex;align-items:stretch}
        .rc-img{width:180px;min-height:150px;background-size:cover;background-position:center;flex-shrink:0;filter:brightness(.82) saturate(.8)}
        .rc-body{flex:1;padding:20px 24px;display:flex;flex-direction:column;justify-content:space-between}
        .rc-head{display:flex;align-items:flex-start;justify-content:space-between;gap:12px;flex-wrap:wrap;margin-bottom:12px}
        .rc-car-name{font-family:'Cormorant Garamond',serif;font-size:1.35rem;font-weight:400;color:#111}
        .rc-car-brand{font-size:.64rem;letter-spacing:.2em;text-transform:uppercase;color:rgba(17,17,17,0.32);margin-top:2px}
        .rc-badge-active{font-size:.58rem;font-weight:500;letter-spacing:.2em;text-transform:uppercase;padding:4px 10px;border:1px solid rgba(30,110,69,0.35);color:#1e6e45;background:rgba(30,110,69,0.06)}
        .rc-badge-confirmed{font-size:.58rem;font-weight:500;letter-spacing:.2em;text-transform:uppercase;padding:4px 10px;border:1px solid rgba(58,91,228,0.35);color:#3a5be4;background:rgba(58,91,228,0.06)}
        .rc-badge-expired{font-size:.58rem;font-weight:500;letter-spacing:.2em;text-transform:uppercase;padding:4px 10px;border:1px solid rgba(136,136,128,0.35);color:#5f5e5a;background:rgba(136,136,128,0.08)}
        .rc-meta{display:grid;grid-template-columns:repeat(4,auto);gap:0 26px;flex-wrap:wrap}
        .rc-meta-item{margin-bottom:6px}
        .rc-meta-lbl{font-size:.58rem;letter-spacing:.16em;text-transform:uppercase;color:rgba(17,17,17,0.32);margin-bottom:2px}
        .rc-meta-val{font-size:.88rem;font-weight:400;color:#111}
        .rc-meta-val.big{font-family:'Cormorant Garamond',serif;font-size:1.1rem}
        .rc-dates{display:flex;gap:18px;margin-top:10px;padding-top:10px;border-top:1px solid rgba(0,0,0,0.06);flex-wrap:wrap}
        .rc-date-item{font-size:.78rem;color:rgba(17,17,17,0.55)}
        .rc-date-item strong{color:#111;font-weight:500}
        .rc-date-item.expired-date strong{color:#c0392b}
        .rc-footer{background:#f8f7f4;border-top:1px solid rgba(0,0,0,0.07);padding:12px 24px;display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap}
        .rc-footer-left{font-size:.72rem;color:rgba(17,17,17,0.45)}
        .rc-footer-right{display:flex;gap:10px;align-items:center;flex-wrap:wrap}
        .btn-confirm{padding:8px 20px;font-size:.62rem;font-weight:500;letter-spacing:.14em;text-transform:uppercase;background:#1e6e45;color:#fff;border:none;cursor:pointer;font-family:'DM Sans',sans-serif;transition:background .2s}
        .btn-confirm:hover{background:#155233}
        .btn-cancel-r{padding:8px 18px;font-size:.62rem;font-weight:500;letter-spacing:.14em;text-transform:uppercase;background:transparent;color:#c0392b;border:1px solid rgba(192,57,43,0.35);cursor:pointer;font-family:'DM Sans',sans-serif;transition:all .2s}
        .btn-cancel-r:hover{background:rgba(192,57,43,0.06);border-color:#c0392b}
        .confirmed-note{font-size:.72rem;color:rgba(58,91,228,0.8);letter-spacing:.02em}
        .empty-rentals{text-align:center;padding:72px 40px;background:#fff;border:1px solid rgba(0,0,0,0.08)}
        .empty-rentals h3{font-family:'Cormorant Garamond',serif;font-size:1.5rem;font-weight:300;color:#111;margin-bottom:10px}
        .empty-rentals p{font-size:.82rem;font-weight:300;color:rgba(17,17,17,0.45);margin-bottom:24px}
        /* cancel popup */
        .cxl-back{position:fixed;inset:0;background:rgba(0,0,0,0.65);backdrop-filter:blur(4px);z-index:900;display:flex;align-items:center;justify-content:center;padding:20px;opacity:0;pointer-events:none;transition:opacity .25s}
        .cxl-back.open{opacity:1;pointer-events:all}
        .cxl-box{background:#fff;max-width:380px;width:100%;padding:32px;transform:scale(.96);transition:transform .25s}
        .cxl-back.open .cxl-box{transform:scale(1)}
        .cxl-box h3{font-family:'Cormorant Garamond',serif;font-size:1.3rem;font-weight:300;color:#111;margin-bottom:10px}
        .cxl-box p{font-size:.82rem;font-weight:300;color:rgba(17,17,17,0.55);line-height:1.7;margin-bottom:24px}
        .cxl-actions{display:flex;gap:10px}
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
            <p class="subtitle">Active, confirmed and expired reservations</p>
        </div>
        <a href="${pageContext.request.contextPath}/user/home" class="btn btn-secondary btn-sm">&#8592; Browse More</a>
    </div>

    <c:if test="${not empty param.success}"><div class="alert alert-success">${param.success}</div></c:if>
    <c:if test="${not empty param.error}"><div class="alert alert-error">${param.error}</div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>

    <c:choose>
        <c:when test="${not empty rentals}">
            <c:forEach var="r" items="${rentals}">
                <%-- Use carBrand and carName for JS image lookup; carImageUrl if set --%>
                <div class="rental-card ${r.statusLabel eq 'EXPIRED' ? 'is-expired' : ''}"
                     data-brand="${r.carBrand}"
                     data-name="${r.carName}"
                     data-img="${not empty r.carImageUrl ? r.carImageUrl : ''}">
                    <div class="rc-top">
                        <div class="rc-img" id="rimg-${r.rentalId}"></div>
                        <div class="rc-body">
                            <div class="rc-head">
                                <div>
                                    <div class="rc-car-name">${r.carName}</div>
                                    <div class="rc-car-brand">${r.carBrand}</div>
                                </div>
                                <c:choose>
                                    <c:when test="${r.statusLabel eq 'EXPIRED'}">
                                        <span class="rc-badge-expired">Expired</span>
                                    </c:when>
                                    <c:when test="${r.statusLabel eq 'CONFIRMED'}">
                                        <span class="rc-badge-confirmed">Confirmed</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="rc-badge-active">Active</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="rc-meta">
                                <div class="rc-meta-item">
                                    <div class="rc-meta-lbl">Days Rented</div>
                                    <div class="rc-meta-val">${r.days} day<c:if test="${r.days > 1}">s</c:if></div>
                                </div>
                                <div class="rc-meta-item">
                                    <div class="rc-meta-lbl">Price / Day</div>
                                    <div class="rc-meta-val">$${r.carPrice}</div>
                                </div>
                                <div class="rc-meta-item">
                                    <div class="rc-meta-lbl">Total Cost</div>
                                    <div class="rc-meta-val big">$<c:choose><c:when test="${r.totalCost > 0}">${r.totalCost}</c:when><c:otherwise>${r.carPrice}</c:otherwise></c:choose></div>
                                </div>
                                <c:if test="${not empty r.renterPhone}">
                                    <div class="rc-meta-item">
                                        <div class="rc-meta-lbl">Contact</div>
                                        <div class="rc-meta-val">${r.renterPhone}</div>
                                    </div>
                                </c:if>
                            </div>
                            <div class="rc-dates">
                                <div class="rc-date-item">Rented: <strong>${r.rentalDate}</strong></div>
                                <c:if test="${not empty r.formattedPickup}">
                                    <div class="rc-date-item">Pickup: <strong>${r.formattedPickup}</strong></div>
                                </c:if>
                                <c:if test="${not empty r.formattedReturn}">
                                    <div class="rc-date-item ${r.statusLabel eq 'EXPIRED' ? 'expired-date' : ''}">
                                        Return by: <strong>${r.formattedReturn}</strong>
                                    </div>
                                </c:if>
                                <c:if test="${not empty r.renterLocation}">
                                    <div class="rc-date-item">Location: <strong>${r.renterLocation}</strong></div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    <div class="rc-footer">
                        <div class="rc-footer-left">Rental #${r.rentalId} &nbsp;&middot;&nbsp; ${r.rentalDate}</div>
                        <div class="rc-footer-right">
                            <c:choose>
                                <c:when test="${r.statusLabel eq 'EXPIRED'}">
                                    <span style="font-size:.72rem;color:rgba(17,17,17,0.4);">Rental period ended</span>
                                </c:when>
                                <c:when test="${r.statusLabel eq 'CONFIRMED'}">
                                    <span class="confirmed-note">&#10003; Confirmed — cannot cancel</span>
                                </c:when>
                                <c:otherwise>
                                    <form action="${pageContext.request.contextPath}/user/confirm" method="post" style="display:inline">
                                        <input type="hidden" name="rentalId" value="${r.rentalId}">
                                        <button type="submit" class="btn-confirm"
                                                onclick="return confirm('Confirm this rental? You will NOT be able to cancel after.')">
                                            Confirm Rental
                                        </button>
                                    </form>
                                    <button type="button" class="btn-cancel-r"
                                            onclick="openCancelModal(${r.rentalId}, '${r.carName}')">
                                        Cancel
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
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
            </ul>
        </div>
    </div>
    <div class="footer-bottom">
        <span class="footer-copy">&copy; 2025 <span>DriveEase</span>. All rights reserved.</span>
        <div class="footer-legal"><a href="#">Privacy</a><a href="#">Terms</a><a href="#">Cookies</a></div>
    </div>
</footer>

<!-- CANCEL CONFIRM POPUP -->
<div class="cxl-back" id="cxlBack" onclick="closeCxlOutside(event)">
    <div class="cxl-box">
        <h3>Cancel Reservation</h3>
        <p>Are you sure you want to cancel your reservation for <strong id="cxlCarName">this car</strong>? This action cannot be undone and the car will be made available again.</p>
        <div class="cxl-actions">
            <form id="cxlForm" action="${pageContext.request.contextPath}/user/cancel" method="post" style="display:inline">
                <input type="hidden" name="rentalId" id="cxlRentalId">
                <button type="submit" class="btn btn-danger btn-sm">Yes, Cancel</button>
            </form>
            <button type="button" class="btn btn-secondary btn-sm" onclick="closeCxl()">Keep It</button>
        </div>
    </div>
</div>

<script>
var CTX = '${pageContext.request.contextPath}';
var PHOTOS = {
    'civic':   'https://images.unsplash.com/photo-1590362891991-f776e747a588?w=500&q=75&fit=crop',
    'honda':   'https://images.unsplash.com/photo-1590362891991-f776e747a588?w=500&q=75&fit=crop',
    'corolla': 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=500&q=75&fit=crop',
    'supra':   'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=500&q=75&fit=crop',
    'toyota':  'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=500&q=75&fit=crop',
    'model 3': 'https://images.unsplash.com/photo-1554744512-d6c603f27c54?w=500&q=75&fit=crop',
    'tesla':   'https://images.unsplash.com/photo-1554744512-d6c603f27c54?w=500&q=75&fit=crop',
    'mustang': 'https://images.unsplash.com/photo-1547744152-14d985cb937f?w=500&q=75&fit=crop',
    'ford':    'https://images.unsplash.com/photo-1547744152-14d985cb937f?w=500&q=75&fit=crop',
    'a4':      'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=500&q=75&fit=crop',
    'audi':    'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=500&q=75&fit=crop',
    'bmw':     'https://images.unsplash.com/photo-1556189250-72ba954cfc2b?w=500&q=75&fit=crop',
    'mercedes':'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=500&q=75&fit=crop',
    'porsche': 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=500&q=75&fit=crop',
    'maybach': 'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=500&q=75&fit=crop',
    'default': 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=500&q=75&fit=crop'
};

document.querySelectorAll('.rental-card').forEach(function(card) {
    var brand  = (card.dataset.brand || '').toLowerCase().trim();
    var name   = (card.dataset.name  || '').toLowerCase().trim();
    var dbImg  = (card.dataset.img   || '').trim();
    /* find the rc-img div inside this card */
    var imgEl  = card.querySelector('.rc-img');
    if (!imgEl) return;
    if (dbImg && dbImg !== 'null' && dbImg.length > 1) {
        imgEl.style.backgroundImage = "url('" + CTX + dbImg + "')";
    } else {
        var url = PHOTOS[name] || PHOTOS[brand] || PHOTOS['default'];
        imgEl.style.backgroundImage = "url('" + url + "')";
    }
});

function openCancelModal(rentalId, carName) {
    document.getElementById('cxlRentalId').value       = rentalId;
    document.getElementById('cxlCarName').textContent  = carName;
    document.getElementById('cxlBack').classList.add('open');
    document.body.style.overflow = 'hidden';
}
function closeCxl() {
    document.getElementById('cxlBack').classList.remove('open');
    document.body.style.overflow = '';
}
function closeCxlOutside(e) {
    if (e.target === document.getElementById('cxlBack')) closeCxl();
}
document.addEventListener('keydown', function(e){ if(e.key==='Escape') closeCxl(); });
</script>
</body>
</html>
