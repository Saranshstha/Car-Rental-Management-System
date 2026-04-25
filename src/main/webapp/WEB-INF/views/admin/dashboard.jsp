<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
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
            <h2>Admin Dashboard</h2>
            <p class="subtitle">Welcome, <strong>${sessionScope.loggedUser.name}</strong></p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/add-car" class="btn btn-primary btn-sm">+ Add New Car</a>
    </div>

    <c:if test="${not empty param.success}"><div class="alert alert-success">${param.success}</div></c:if>
    <c:if test="${not empty param.error}"><div class="alert alert-error">${param.error}</div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>

    <!-- TAB BAR -->
    <div class="admin-tab-bar">
        <button class="admin-tab-btn active" id="btn-fleet"     onclick="showTab('fleet')">Fleet &amp; Rentals</button>
        <button class="admin-tab-btn"         id="btn-tracking" onclick="showTab('tracking')">Rental Tracking</button>
        <button class="admin-tab-btn"         id="btn-analytics" onclick="showTab('analytics')">Analytics</button>
    </div>

    <!-- ══ TAB 1: FLEET & RENTALS ══ -->
    <div id="tab-fleet" class="tab-panel active">
        <div class="stat-grid">
            <div class="stat-card"><div class="stat-label">Total vehicles</div><div class="stat-val" id="s-total">—</div><div class="stat-sub">In your fleet</div></div>
            <div class="stat-card accent"><div class="stat-label">Available now</div><div class="stat-val" id="s-avail">—</div><div class="stat-sub">Ready to rent</div></div>
            <div class="stat-card"><div class="stat-label">Currently rented</div><div class="stat-val" id="s-rented">—</div><div class="stat-sub">Active rentals</div></div>
            <div class="stat-card revenue"><div class="stat-label">Total rentals</div><div class="stat-val" id="s-rentals">—</div><div class="stat-sub">All time</div></div>
        </div>
        <div class="qa-grid">
            <div class="qa-card" onclick="location.href='${pageContext.request.contextPath}/admin/add-car'">
                <div class="qa-icon">+</div>
                <div><div class="qa-title">Add new vehicle</div><div class="qa-desc">Register a car to the fleet</div></div>
            </div>
            <div class="qa-card" onclick="document.getElementById('carSec').scrollIntoView({behavior:'smooth'})">
                <div class="qa-icon">&#9776;</div>
                <div><div class="qa-title">Manage fleet</div><div class="qa-desc">Edit or remove vehicles</div></div>
            </div>
            <div class="qa-card" onclick="document.getElementById('rentalSec').scrollIntoView({behavior:'smooth'})">
                <div class="qa-icon">&#128196;</div>
                <div><div class="qa-title">View all rentals</div><div class="qa-desc">Complete rental history</div></div>
            </div>
        </div>
        <div class="search-bar">
            <form action="${pageContext.request.contextPath}/search" method="get">
                <input type="text" name="keyword" placeholder="Search cars by name, brand or price...">
                <button type="submit" class="btn btn-primary">Search</button>
            </form>
        </div>
        <div class="section-header" id="carSec"><h3>All Cars</h3></div>
        <div class="table-wrapper">
            <table class="table">
                <thead><tr><th>#</th><th>Name</th><th>Brand</th><th>Price / Day</th><th>Status</th><th>Actions</th></tr></thead>
                <tbody>
                    <c:forEach var="car" items="${cars}">
                        <tr>
                            <td>${car.carId}</td>
                            <td><strong>${car.name}</strong></td>
                            <td>${car.brand}</td>
                            <td>$${car.price}</td>
                            <td><span class="badge ${car.availability ? 'badge-success' : 'badge-danger'}">${car.availability ? 'Available' : 'Rented'}</span></td>
                            <td class="action-cell">
                                <a href="${pageContext.request.contextPath}/admin/edit-car?id=${car.carId}" class="btn btn-sm btn-secondary">Edit</a>
                                <a href="${pageContext.request.contextPath}/admin/delete-car?id=${car.carId}" class="btn btn-sm btn-danger" onclick="return confirm('Delete ${car.name}?')">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty cars}"><tr><td colspan="6" class="empty-msg">No cars found. <a href="${pageContext.request.contextPath}/admin/add-car">Add one</a></td></tr></c:if>
                </tbody>
            </table>
        </div>
        <div class="section-header mt-30" id="rentalSec"><h3>All Rentals</h3></div>
        <div class="table-wrapper">
            <table class="table">
                <thead><tr><th>#</th><th>Renter</th><th>Car</th><th>Days</th><th>Total</th><th>Pickup</th><th>Return</th><th>Status</th></tr></thead>
                <tbody>
                    <c:forEach var="r" items="${rentals}">
                        <tr>
                            <td>${r.rentalId}</td>
                            <td>
                                <strong>${r.renterName}</strong>
                                <c:if test="${not empty r.renterEmail}"><br><span style="font-size:.74rem;color:var(--t60)">${r.renterEmail}</span></c:if>
                            </td>
                            <td>${r.carName} <span style="color:var(--t30);font-size:.76rem">${r.carBrand}</span></td>
                            <td>${r.days}</td>
                            <td>$<c:choose><c:when test="${r.totalCost > 0}">${r.totalCost}</c:when><c:otherwise>${r.carPrice}</c:otherwise></c:choose></td>
                            <td style="font-size:.76rem">${r.formattedPickup}</td>
                            <td style="font-size:.76rem">${r.formattedReturn}</td>
                            <td>
                                <span class="badge ${r.statusLabel eq 'EXPIRED' ? 'badge-danger' : 'badge-success'}">${r.statusLabel}</span>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty rentals}"><tr><td colspan="8" class="empty-msg">No rentals yet.</td></tr></c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- ══ TAB 2: RENTAL TRACKING ══ -->
    <div id="tab-tracking" class="tab-panel">
        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:22px;flex-wrap:wrap;gap:10px">
            <div>
                <h3 style="font-family:'Cormorant Garamond',serif;font-size:1.4rem;font-weight:300;margin-bottom:4px">Active Rental Tracking</h3>
                <p class="subtitle">Live countdown to return dates</p>
            </div>
            <span style="font-size:.7rem;letter-spacing:.1em;text-transform:uppercase;color:var(--t30);border:1px solid var(--border);padding:6px 14px" id="activeCount">0 active</span>
        </div>
        <c:choose>
            <c:when test="${not empty activeRentals}">
                <c:forEach var="r" items="${activeRentals}">
                    <div class="tracking-card">
                        <div class="tracking-card-body">
                            <div class="tracking-car-img" id="timg-${r.rentalId}"
                                 data-brand="${r.carBrand}" data-name="${r.carName}"
                                 data-img="${not empty r.carImageUrl ? r.carImageUrl : ''}"></div>
                            <div class="tracking-info">
                                <div>
                                    <div class="tracking-car-title">${r.carName}</div>
                                    <div class="tracking-car-brand">${r.carBrand}</div>
                                    <div class="tracking-grid">
                                        <div>
                                            <div class="tracking-field-label">Renter</div>
                                            <div class="tracking-field-val">${not empty r.renterName ? r.renterName : '—'}</div>
                                        </div>
                                        <div>
                                            <div class="tracking-field-label">Email</div>
                                            <div class="tracking-field-val">${not empty r.renterEmail ? r.renterEmail : '—'}</div>
                                        </div>
                                        <div>
                                            <div class="tracking-field-label">Phone</div>
                                            <div class="tracking-field-val">${not empty r.renterPhone ? r.renterPhone : '—'}</div>
                                        </div>
                                        <div>
                                            <div class="tracking-field-label">Location</div>
                                            <div class="tracking-field-val">${not empty r.renterLocation ? r.renterLocation : '—'}</div>
                                        </div>
                                        <div>
                                            <div class="tracking-field-label">Pickup</div>
                                            <div class="tracking-field-val">${not empty r.formattedPickup ? r.formattedPickup : '—'}</div>
                                        </div>
                                        <div>
                                            <div class="tracking-field-label">Return by</div>
                                            <div class="tracking-field-val" style="font-weight:500">${not empty r.formattedReturn ? r.formattedReturn : '—'}</div>
                                        </div>
                                    </div>
                                </div>
                                <div style="margin-top:10px;font-size:.76rem;color:var(--t60)">
                                    ${r.days} day<c:if test="${r.days > 1}">s</c:if> &nbsp;&middot;&nbsp;
                                    $<c:choose><c:when test="${r.totalCost > 0}">${r.totalCost}</c:when><c:otherwise>${r.carPrice}</c:otherwise></c:choose> total
                                    &nbsp;&middot;&nbsp;
                                    <span class="badge ${r.statusLabel eq 'CONFIRMED' ? 'badge-success' : 'badge-danger'}" style="font-size:.58rem;padding:2px 8px">${r.statusLabel}</span>
                                </div>
                            </div>
                            <div class="tracking-right">
                                <div class="countdown-label">Time Left</div>
                                <div class="countdown-display" id="cd-${r.rentalId}" data-return="${r.returnIso}">
                                    <div class="cd-unit"><div class="cd-num" id="cd-d-${r.rentalId}">—</div><div class="cd-lbl">days</div></div>
                                    <div class="cd-unit"><div class="cd-num" id="cd-h-${r.rentalId}">—</div><div class="cd-lbl">hrs</div></div>
                                    <div class="cd-unit"><div class="cd-num" id="cd-m-${r.rentalId}">—</div><div class="cd-lbl">min</div></div>
                                </div>
                                <div class="countdown-status" id="cds-${r.rentalId}">—</div>
                            </div>
                        </div>
                        <div class="tracking-footer">
                            <span>Rental #${r.rentalId} &nbsp;&middot;&nbsp; ${r.rentalDate}</span>
                            <a href="${pageContext.request.contextPath}/admin/edit-car?id=${r.carId}" class="btn btn-sm btn-secondary" style="font-size:.62rem">Override Availability</a>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state"><p>No active rentals. All cars are currently available.</p></div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- ══ TAB 3: ANALYTICS ══ -->
    <div id="tab-analytics" class="tab-panel">
        <div class="analytics-kpi">
            <div class="kpi-card"><div class="kpi-label">Total Revenue</div><div class="kpi-val" id="k-rev">$0</div><div class="kpi-trend">All time</div></div>
            <div class="kpi-card"><div class="kpi-label">Total Rentals</div><div class="kpi-val" id="k-cnt">0</div><div class="kpi-trend">All time</div></div>
            <div class="kpi-card"><div class="kpi-label">Avg Per Rental</div><div class="kpi-val" id="k-avg">$0</div><div class="kpi-trend">Revenue per booking</div></div>
            <div class="kpi-card"><div class="kpi-label">Unique Customers</div><div class="kpi-val" id="k-cus">0</div><div class="kpi-trend">Total renters</div></div>
        </div>
        <div class="analytics-row">
            <div class="chart-card">
                <div class="chart-title">Revenue over time</div>
                <div class="chart-wrap"><canvas id="chartRevenue"></canvas></div>
            </div>
            <div class="chart-card">
                <div class="chart-title">Most popular vehicles</div>
                <div class="chart-wrap"><canvas id="chartPopular"></canvas></div>
            </div>
        </div>
        <div class="analytics-row" style="grid-template-columns:1fr 1fr">
            <div class="chart-card">
                <div class="chart-title">Revenue by vehicle</div>
                <div class="chart-wrap"><canvas id="chartRevCar"></canvas></div>
            </div>
            <div class="chart-card">
                <div class="chart-title">Customer activity</div>
                <div style="overflow-x:auto">
                    <table class="activity-table" id="actTbl">
                        <thead><tr><th>#</th><th>Customer</th><th>Rentals</th><th>Total Spent</th><th>Last Active</th></tr></thead>
                        <tbody><tr><td colspan="5" style="padding:24px 0;color:var(--t30);font-size:.8rem">Loading…</td></tr></tbody>
                    </table>
                </div>
            </div>
        </div>
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
            <ul class="footer-links"><li><a href="#">Help Centre</a></li><li><a href="#">Privacy Policy</a></li></ul>
        </div>
    </div>
    <div class="footer-bottom">
        <span class="footer-copy">&copy; 2025 <span>DriveEase</span>. All rights reserved.</span>
        <div class="footer-legal"><a href="#">Privacy</a><a href="#">Terms</a></div>
    </div>
</footer>

<!-- Embed rental data for Analytics JS (safe string concat) -->
<script>
var ALL_RENTALS = [];
<c:forEach var="r" items="${rentals}">
ALL_RENTALS.push({
    id:      ${r.rentalId},
    userId:  ${r.userId},
    carName: '${r.carName}',
    carBrand:'${r.carBrand}',
    total:   ${r.totalCost > 0 ? r.totalCost : r.carPrice},
    date:    '${r.rentalDate}',
    email:   '${r.renterEmail}',
    name:    '${r.renterName}',
    status:  '${r.statusLabel}'
});
</c:forEach>

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

/* Stat cards */
document.addEventListener('DOMContentLoaded', function() {
    var rows = document.querySelectorAll('#carSec + .table-wrapper tbody tr');
    var tot=0, avail=0, rented=0;
    rows.forEach(function(row) {
        var b = row.querySelector('.badge');
        if (!b || row.querySelector('.empty-msg')) return;
        tot++;
        if (b.classList.contains('badge-success')) avail++; else rented++;
    });
    document.getElementById('s-total').textContent   = tot;
    document.getElementById('s-avail').textContent   = avail;
    document.getElementById('s-rented').textContent  = rented;
    document.getElementById('s-rentals').textContent = ALL_RENTALS.length;
    document.getElementById('activeCount').textContent = rented + ' active';

    /* Tracking images */
    document.querySelectorAll('[id^="timg-"]').forEach(function(el) {
        var brand = (el.dataset.brand || '').toLowerCase().trim();
        var name  = (el.dataset.name  || '').toLowerCase().trim();
        var db    = (el.dataset.img   || '').trim();
        if (db && db !== 'null' && db.length > 1) {
            el.style.backgroundImage = "url('" + CTX + db + "')";
        } else {
            el.style.backgroundImage = "url('" + (PHOTOS[name]||PHOTOS[brand]||PHOTOS['default']) + "')";
        }
    });
});

/* Tab switching */
function showTab(name) {
    ['fleet','tracking','analytics'].forEach(function(t) {
        document.getElementById('tab-'+t).classList.toggle('active', t===name);
        document.getElementById('btn-'+t).classList.toggle('active', t===name);
    });
    if (name === 'tracking')  buildCountdowns();
    if (name === 'analytics') buildAnalytics();
}

/* Countdowns */
var cdBuilt = false;
function buildCountdowns() {
    if (cdBuilt) return; cdBuilt = true;
    function tick() {
        document.querySelectorAll('.countdown-display').forEach(function(el) {
            var iso = el.dataset.return;
            if (!iso) return;
            var diff = new Date(iso) - new Date();
            var id   = el.id.replace('cd-','');
            var st   = document.getElementById('cds-'+id);
            if (diff <= 0) {
                document.getElementById('cd-d-'+id).textContent = '0';
                document.getElementById('cd-h-'+id).textContent = '00';
                document.getElementById('cd-m-'+id).textContent = '00';
                if (st) { st.textContent='Overdue'; st.className='countdown-status cs-over'; }
                return;
            }
            var days = Math.floor(diff/86400000);
            var hrs  = Math.floor((diff%86400000)/3600000);
            var mins = Math.floor((diff%3600000)/60000);
            document.getElementById('cd-d-'+id).textContent = days;
            document.getElementById('cd-h-'+id).textContent = String(hrs).padStart(2,'0');
            document.getElementById('cd-m-'+id).textContent = String(mins).padStart(2,'0');
            if (st) {
                if (days===0 && hrs<24) { st.textContent='Due soon'; st.className='countdown-status cs-warn'; }
                else { st.textContent='On time'; st.className='countdown-status cs-ok'; }
            }
        });
    }
    tick(); setInterval(tick, 30000);
}

/* Analytics */
var analyticsBuilt = false;
function buildAnalytics() {
    if (analyticsBuilt) return; analyticsBuilt = true;

    var totalRev=0, emails={};
    ALL_RENTALS.forEach(function(r){ totalRev += parseFloat(r.total)||0; if(r.email) emails[r.email]=true; });
    var avg = ALL_RENTALS.length > 0 ? totalRev/ALL_RENTALS.length : 0;
    document.getElementById('k-rev').textContent = '$'+Math.round(totalRev).toLocaleString();
    document.getElementById('k-cnt').textContent = ALL_RENTALS.length;
    document.getElementById('k-avg').textContent = '$'+Math.round(avg);
    document.getElementById('k-cus').textContent = Object.keys(emails).length;

    /* Revenue by month */
    var monthly={};
    ALL_RENTALS.forEach(function(r){ if(!r.date||r.date.length<7) return; var m=r.date.substring(0,7); monthly[m]=(monthly[m]||0)+(parseFloat(r.total)||0); });
    var months=Object.keys(monthly).sort(), revs=months.map(function(m){ return Math.round(monthly[m]); });
    new Chart(document.getElementById('chartRevenue'),{type:'line',data:{labels:months.length?months:['No data'],datasets:[{label:'Revenue ($)',data:revs.length?revs:[0],borderColor:'#1a1a1a',backgroundColor:'rgba(26,26,26,0.07)',tension:0.4,fill:true,pointRadius:4,pointBackgroundColor:'#1a1a1a'}]},options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{display:false}},scales:{y:{beginAtZero:true,ticks:{callback:function(v){return '$'+v;}}}}}});

    /* Popular vehicles */
    var cnt={};
    ALL_RENTALS.forEach(function(r){ if(!r.carName) return; var k=r.carName+' ('+r.carBrand+')'; cnt[k]=(cnt[k]||0)+1; });
    var sp=Object.entries(cnt).sort(function(a,b){return b[1]-a[1];}).slice(0,8);
    new Chart(document.getElementById('chartPopular'),{type:'bar',data:{labels:sp.length?sp.map(function(c){return c[0];}):['No data'],datasets:[{label:'Rentals',data:sp.length?sp.map(function(c){return c[1];}):  [0],backgroundColor:'#1a1a1a'}]},options:{indexAxis:'y',responsive:true,maintainAspectRatio:false,plugins:{legend:{display:false}},scales:{x:{beginAtZero:true,ticks:{stepSize:1}}}}});

    /* Revenue by vehicle */
    var rv={};
    ALL_RENTALS.forEach(function(r){ if(!r.carName) return; rv[r.carName]=(rv[r.carName]||0)+(parseFloat(r.total)||0); });
    var srV=Object.entries(rv).sort(function(a,b){return b[1]-a[1];}).slice(0,8);
    var pal=['#1a1a1a','#3a3a3a','#5a5a5a','#6b6b6b','#888','#aaa','#ccc','#e0e0e0'];
    new Chart(document.getElementById('chartRevCar'),{type:'bar',data:{labels:srV.length?srV.map(function(c){return c[0];}):['No data'],datasets:[{label:'Revenue ($)',data:srV.length?srV.map(function(c){return Math.round(c[1]);}): [0],backgroundColor:pal}]},options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{display:false}},scales:{y:{beginAtZero:true,ticks:{callback:function(v){return '$'+v;}}}}}});

    /* Customer activity */
    var umap={};
    ALL_RENTALS.forEach(function(r){
        var k=r.email||(r.userId+'');
        if(!umap[k]) umap[k]={name:r.name||k,email:k,count:0,total:0,last:r.date};
        umap[k].count++; umap[k].total+=parseFloat(r.total)||0;
        if(r.date>umap[k].last) umap[k].last=r.date;
    });
    var users=Object.values(umap).sort(function(a,b){return b.total-a.total;});
    var tb=document.querySelector('#actTbl tbody');
    if(!users.length){tb.innerHTML='<tr><td colspan="5" style="padding:24px 0;color:var(--t30);font-size:.8rem">No data yet.</td></tr>';return;}
    tb.innerHTML=users.map(function(u,i){
        return '<tr><td class="activity-rank">'+(i+1)+'</td><td><strong style="font-size:.84rem">'+(u.name||'—')+'</strong><br><span style="font-size:.72rem;color:var(--t60)">'+u.email+'</span></td><td>'+u.count+'</td><td style="font-weight:500">$'+Math.round(u.total).toLocaleString()+'</td><td style="font-size:.78rem;color:var(--t60)">'+(u.last||'—')+'</td></tr>';
    }).join('');
}
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>
</body>
</html>
