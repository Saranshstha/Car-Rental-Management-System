<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Car — DriveEase</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="nav-brand">DriveEase <span class="role-badge">Admin</span></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/add-car" class="active">+ Add Car</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
    <button class="nav-toggle" onclick="document.querySelector('.nav-links').classList.toggle('open')">
        <span></span><span></span><span></span>
    </button>
</nav>

<div class="container">
    <div class="page-header">
        <div>
            <h2>Add New Car</h2>
            <p class="subtitle">Add a vehicle to the DriveEase fleet</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary btn-sm">&#8592; Back</a>
    </div>

    <c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>

    <div class="add-layout">
        <!-- LEFT: FORM -->
        <div class="form-card">
            <form action="${pageContext.request.contextPath}/admin/add-car"
                  method="post"
                  enctype="multipart/form-data">

                <div class="form-group">
                    <label>Car Model Name</label>
                    <input type="text" name="name" id="iName" required placeholder="e.g. Civic" oninput="livePreview()">
                </div>
                <div class="form-group">
                    <label>Brand</label>
                    <input type="text" name="brand" id="iBrand" required placeholder="e.g. Honda" oninput="livePreview()">
                </div>
                <div class="form-group">
                    <label>Price per Day ($)</label>
                    <input type="number" name="price" id="iPrice" step="0.01" min="0" required placeholder="e.g. 50.00" oninput="livePreview()">
                </div>
                <div class="form-group checkbox-group">
                    <input type="checkbox" id="availability" name="availability" checked onchange="livePreview()">
                    <label for="availability">Mark as Available</label>
                </div>

                <!-- IMAGE UPLOAD -->
                <div class="form-group" style="margin-top:24px">
                    <label class="img-field-label">Car Image</label>
                    <div class="img-upload-zone" id="uploadZone">
                        <input type="file" name="carImage" id="carImageInput"
                               accept=".jpg,.jpeg,.png,.webp,.gif"
                               onchange="handleImage(event)">
                        <img id="imgPreview" src="" alt="Preview">
                        <div class="img-change-overlay"><span>Change Image</span></div>
                        <div class="upload-placeholder">
                            <div class="upload-icon">&#128247;</div>
                            <div class="upload-main-text">Click to upload car image</div>
                            <div class="upload-sub-text">or drag and drop here</div>
                            <div class="upload-formats">JPG &nbsp;&bull;&nbsp; PNG &nbsp;&bull;&nbsp; WEBP &nbsp;&bull;&nbsp; GIF</div>
                        </div>
                    </div>
                    <div class="img-field-name" id="imgFileName">No file selected</div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Add Car</button>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>

        <!-- RIGHT: LIVE PREVIEW -->
        <div>
            <span class="preview-label">Live Preview</span>
            <div class="preview-card">
                <div class="preview-card-img-wrap">
                    <img id="previewCardImg" src="" alt="Car preview">
                    <div class="preview-placeholder-icon" id="previewIcon">&#128663;</div>
                    <span id="previewBadge" class="preview-card-badge avail">Available</span>
                </div>
                <div class="preview-card-body">
                    <div class="preview-car-name" id="previewName">Car Name</div>
                    <div class="preview-car-brand" id="previewBrand">Brand</div>
                    <div class="preview-divider"></div>
                    <div class="preview-price">$<span id="previewPrice">0.00</span><span> / day</span></div>
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
            <ul class="footer-links"><li><a href="#">Help Centre</a></li></ul>
        </div>
    </div>
    <div class="footer-bottom">
        <span class="footer-copy">&copy; 2025 <span>DriveEase</span>. All rights reserved.</span>
        <div class="footer-legal"><a href="#">Privacy</a><a href="#">Terms</a></div>
    </div>
</footer>

<script>
function handleImage(event) {
    var file = event.target.files[0];
    if (!file) return;
    var allowed = ['image/jpeg','image/png','image/webp','image/gif'];
    var nameEl  = document.getElementById('imgFileName');
    if (allowed.indexOf(file.type) === -1) {
        nameEl.textContent = 'Invalid type. Use JPG, PNG, WEBP or GIF.';
        nameEl.style.color = '#c0392b';
        return;
    }
    var mb = file.size / (1024 * 1024);
    if (mb > 5) {
        nameEl.textContent = 'File too large. Max 5 MB.';
        nameEl.style.color = '#c0392b';
        return;
    }
    var reader = new FileReader();
    reader.onload = function(e) {
        var url = e.target.result;
        document.getElementById('imgPreview').src = url;
        document.getElementById('uploadZone').classList.add('has-img');
        var cardImg = document.getElementById('previewCardImg');
        cardImg.src = url;
        cardImg.style.display = 'block';
        document.getElementById('previewIcon').style.display = 'none';
    };
    reader.readAsDataURL(file);
    var fn = file.name.length > 36 ? file.name.substring(0,33) + '...' : file.name;
    nameEl.textContent = fn + '  (' + mb.toFixed(1) + ' MB)';
    nameEl.style.color = '';
}

function livePreview() {
    document.getElementById('previewName').textContent  = document.getElementById('iName').value  || 'Car Name';
    document.getElementById('previewBrand').textContent = document.getElementById('iBrand').value || 'Brand';
    var price = parseFloat(document.getElementById('iPrice').value) || 0;
    document.getElementById('previewPrice').textContent = price.toFixed(2);
    var avail = document.getElementById('availability').checked;
    var badge = document.getElementById('previewBadge');
    badge.textContent = avail ? 'Available' : 'Rented';
    badge.className   = 'preview-card-badge ' + (avail ? 'avail' : 'rented');
}

/* Drag and drop */
var zone = document.getElementById('uploadZone');
zone.addEventListener('dragover',  function(e){ e.preventDefault(); zone.style.borderColor='rgba(0,0,0,0.5)'; });
zone.addEventListener('dragleave', function(){ zone.style.borderColor=''; });
zone.addEventListener('drop', function(e){
    e.preventDefault(); zone.style.borderColor='';
    var files = e.dataTransfer.files;
    if (files.length > 0) {
        document.getElementById('carImageInput').files = files;
        handleImage({ target: { files: files } });
    }
});
</script>
</body>
</html>
