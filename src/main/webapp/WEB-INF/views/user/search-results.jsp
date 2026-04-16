<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results — DriveEase</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .modal-backdrop{position:fixed;inset:0;background:rgba(0,0,0,0.72);backdrop-filter:blur(6px);z-index:900;display:flex;align-items:center;justify-content:center;padding:20px;opacity:0;pointer-events:none;transition:opacity .3s}
        .modal-backdrop.open{opacity:1;pointer-events:all}
        .modal-box{background:#fff;max-width:480px;width:100%;padding:0;transform:translateY(20px) scale(.97);transition:all .3s;overflow:hidden}
        .modal-backdrop.open .modal-box{transform:translateY(0) scale(1)}
        .modal-header{background:#1a1a1a;padding:24px 28px;display:flex;align-items:flex-start;justify-content:space-between}
        .modal-header h3{font-family:'Cormorant Garamond',serif;font-size:1.4rem;font-weight:300;color:#f5f4f0;letter-spacing:.02em}
        .modal-header p{font-size:.72rem;color:rgba(245,244,240,0.5);margin-top:4px;letter-spacing:.04em}
        .modal-close-btn{background:none;border:none;color:rgba(245,244,240,0.5);font-size:1.1rem;cursor:pointer;padding:2px;line-height:1;transition:color .2s}
        .modal-close-btn:hover{color:#f5f4f0}
        .modal-body{padding:28px}
        .modal-car-info{background:#f8f7f4;border:1px solid rgba(0,0,0,0.07);padding:14px 16px;margin-bottom:22px;display:flex;align-items:center;justify-content:space-between}
        .modal-car-name{font-family:'Cormorant Garamond',serif;font-size:1.1rem;font-weight:400;color:#111}
        .modal-car-brand{font-size:.65rem;letter-spacing:.18em;text-transform:uppercase;color:rgba(17,17,17,0.35);margin-top:2px}
        .modal-car-price{font-family:'Cormorant Garamond',serif;font-size:1.2rem;font-weight:400;color:#111;text-align:right}
        .modal-car-price small{font-family:'DM Sans',sans-serif;font-size:.65rem;color:rgba(17,17,17,0.35);display:block;letter-spacing:.06em}
        .modal-field{margin-bottom:18px}
        .modal-label{display:block;font-size:.58rem;letter-spacing:.2em;text-transform:uppercase;color:rgba(17,17,17,0.35);margin-bottom:7px}
        .modal-input{width:100%;padding:10px 0;background:transparent;border:none;border-bottom:1px solid rgba(0,0,0,0.15);font-size:.88rem;font-family:'DM Sans',sans-serif;color:#111;outline:none;transition:border-color .2s}
        .modal-input:focus{border-bottom-color:#1a1a1a}
        .modal-input::placeholder{color:rgba(17,17,17,0.28)}
        .modal-row{display:grid;grid-template-columns:1fr 1fr;gap:16px}
        .modal-total-bar{background:#f8f7f4;border:1px solid rgba(0,0,0,0.07);padding:14px 16px;margin:22px 0 22px;display:flex;align-items:center;justify-content:space-between}
        .modal-total-label{font-size:.65rem;letter-spacing:.18em;text-transform:uppercase;color:rgba(17,17,17,0.45)}
        .modal-total-value{font-family:'Cormorant Garamond',serif;font-size:1.3rem;font-weight:400;color:#111}
        .modal-submit-btn{width:100%;padding:14px;background:#1a1a1a;color:#f5f4f0;border:none;font-size:.7rem;font-weight:500;letter-spacing:.18em;text-transform:uppercase;cursor:pointer;font-family:'DM Sans',sans-serif;transition:background .2s}
        .modal-submit-btn:hover{background:#2a2a2a}
    </style>
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
            <h2>Results for: <em style="font-style:italic;font-weight:300;">"${keyword}"</em></h2>
        </div>
        <a href="${pageContext.request.contextPath}/user/home" class="btn btn-secondary btn-sm">&#8592; Back</a>
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
                <div class="car-card-img"></div>
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
                            <button type="button" class="btn btn-primary btn-full"
                                    onclick="openRentModal('${car.carId}','${car.name}','${car.brand}','${car.price}')">
                                Rent Now
                            </button>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty cars}">
            <div class="empty-state"><p>No cars found for "<strong>${keyword}</strong>".</p></div>
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
        <div class="footer-legal"><a href="#">Privacy</a><a href="#">Terms</a></div>
    </div>
</footer>

<!-- MODAL -->
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
                    <span id="modalCarPrice">—</span>
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
                    <label class="modal-label">Number of Days</label>
                    <input class="modal-input" type="number" name="days" id="modalDays" min="1" max="365" value="1" required oninput="updateTotal()">
                </div>
                <div class="modal-total-bar">
                    <span class="modal-total-label">Estimated Total</span>
                    <span class="modal-total-value" id="modalTotal">$0.00</span>
                </div>
                <button type="submit" class="modal-submit-btn">Confirm &amp; Reserve</button>
            </form>
        </div>
    </div>
</div>

<script>
var sessionName  = '${sessionScope.loggedUser.name}';
var sessionEmail = '${sessionScope.loggedUser.email}';
var currentCarPrice = 0;

var carPhotos = {
    'civic':'https://images.unsplash.com/photo-1590362891991-f776e747a588?w=700&q=80&fit=crop',
    'honda':'https://images.unsplash.com/photo-1590362891991-f776e747a588?w=700&q=80&fit=crop',
    'corolla':'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=700&q=80&fit=crop',
    'toyota':'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=700&q=80&fit=crop',
    'model 3':'https://images.unsplash.com/photo-1554744512-d6c603f27c54?w=700&q=80&fit=crop',
    'tesla':'https://images.unsplash.com/photo-1554744512-d6c603f27c54?w=700&q=80&fit=crop',
    'mustang':'https://images.unsplash.com/photo-1547744152-14d985cb937f?w=700&q=80&fit=crop',
    'ford':'https://images.unsplash.com/photo-1547744152-14d985cb937f?w=700&q=80&fit=crop',
    'a4':'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=700&q=80&fit=crop',
    'audi':'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=700&q=80&fit=crop',
    'bmw':'https://images.unsplash.com/photo-1556189250-72ba954cfc2b?w=700&q=80&fit=crop',
    'mercedes':'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=700&q=80&fit=crop',
    'default':'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=700&q=80&fit=crop'
};
document.querySelectorAll('.car-card').forEach(function(card){
    var b = (card.dataset.brand||'').toLowerCase().trim();
    var n = (card.dataset.name ||'').toLowerCase().trim();
    var img = card.querySelector('.car-card-img');
    if (!img) return;
    img.style.backgroundImage = "url('" + (carPhotos[n]||carPhotos[b]||carPhotos['default']) + "')";
});

function openRentModal(carId,carName,carBrand,carPrice){
    currentCarPrice = parseFloat(carPrice)||0;
    document.getElementById('modalCarId').value=carId;
    document.getElementById('modalCarName').textContent=carName;
    document.getElementById('modalCarBrand').textContent=carBrand;
    document.getElementById('modalCarPrice').textContent='$'+parseFloat(carPrice).toFixed(2);
    document.getElementById('modalDays').value=1;
    document.getElementById('modalRenterName').value=sessionName||'';
    document.getElementById('modalRenterEmail').value=sessionEmail||'';
    document.getElementById('modalRenterPhone').value='';
    updateTotal();
    document.getElementById('rentModal').classList.add('open');
    document.body.style.overflow='hidden';
}
function closeModal(){document.getElementById('rentModal').classList.remove('open');document.body.style.overflow='';}
function closeModalOutside(e){if(e.target===document.getElementById('rentModal'))closeModal();}
function updateTotal(){
    var days=parseInt(document.getElementById('modalDays').value)||1;
    document.getElementById('modalTotal').textContent='$'+(currentCarPrice*days).toFixed(2);
}
document.addEventListener('keydown',function(e){if(e.key==='Escape')closeModal();});
</script>
</body>
</html>
