<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Car — DriveEase</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* ── SPLIT LAYOUT ── */
        .add-layout {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 28px;
            align-items: start;
        }

        /* ── IMAGE UPLOAD ZONE ── */
        .img-upload-zone {
            border: 1.5px dashed rgba(0,0,0,0.18);
            background: var(--surface2, #f2f1ee);
            padding: 28px 20px;
            text-align: center;
            cursor: pointer;
            transition: border-color .25s, background .25s;
            position: relative;
        }
        .img-upload-zone:hover {
            border-color: rgba(0,0,0,0.35);
            background: #eeede9;
        }
        .img-upload-zone.has-img {
            border-style: solid;
            border-color: rgba(0,0,0,0.22);
            padding: 0;
            overflow: hidden;
        }
        .img-upload-zone input[type="file"] {
            position: absolute; inset: 0;
            opacity: 0; cursor: pointer; width: 100%; height: 100%;
        }
        .upload-placeholder {
            pointer-events: none;
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            gap: 10px; padding: 20px 0;
        }
        .upload-icon {
            width: 48px; height: 48px;
            border: 1.5px solid rgba(0,0,0,0.2);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px; color: rgba(0,0,0,0.35);
        }
        .upload-main-text {
            font-size: .82rem; font-weight: 500;
            color: var(--text, #111);
            letter-spacing: .02em;
        }
        .upload-sub-text {
            font-size: .72rem; color: rgba(0,0,0,0.35);
            letter-spacing: .04em;
        }
        .upload-formats {
            font-size: .68rem;
            color: rgba(0,0,0,0.3);
            letter-spacing: .08em;
            text-transform: uppercase;
            margin-top: 4px;
        }
        #imgPreview {
            display: none;
            width: 100%; height: 220px;
            object-fit: cover;
            pointer-events: none;
        }
        .img-upload-zone.has-img .upload-placeholder { display: none; }
        .img-upload-zone.has-img #imgPreview { display: block; }

        /* ── CHANGE IMAGE OVERLAY ── */
        .img-change-overlay {
            display: none;
            position: absolute; inset: 0;
            background: rgba(0,0,0,0.55);
            align-items: center; justify-content: center;
            z-index: 1;
        }
        .img-upload-zone.has-img:hover .img-change-overlay { display: flex; }
        .img-change-overlay span {
            font-size: .7rem; font-weight: 500;
            letter-spacing: .14em; text-transform: uppercase;
            color: #fff; border: 1px solid rgba(255,255,255,0.6);
            padding: 8px 18px; pointer-events: none;
        }

        /* ── PREVIEW CARD ── */
        .preview-card {
            background: var(--surface, #fff);
            border: 1px solid var(--border, rgba(0,0,0,0.08));
            overflow: hidden;
            position: sticky; top: 80px;
        }
        .preview-card-img-wrap {
            height: 200px;
            background: var(--surface2, #f2f1ee);
            position: relative; overflow: hidden;
            display: flex; align-items: center; justify-content: center;
        }
        #previewCardImg {
            width: 100%; height: 100%;
            object-fit: cover;
            display: none;
            filter: brightness(.85) saturate(.8);
            transition: filter .4s;
        }
        .preview-card-img-wrap:hover #previewCardImg { filter: brightness(.75) saturate(.7); }
        .preview-placeholder-icon {
            font-size: 2.2rem; opacity: .22;
        }
        .preview-card-badge {
            position: absolute; top: 12px; left: 12px;
            font-size: .56rem; font-weight: 500;
            letter-spacing: .18em; text-transform: uppercase;
            padding: 4px 10px; border: 1px solid;
        }
        .preview-card-badge.avail {
            background: rgba(15,60,35,0.55);
            border-color: rgba(91,186,138,0.4);
            color: #a8edcc;
        }
        .preview-card-body { padding: 20px 22px 22px; }
        .preview-car-name {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.4rem; font-weight: 400;
            color: var(--text, #111); margin-bottom: 3px;
            min-height: 1.6rem;
        }
        .preview-car-brand {
            font-size: .64rem; letter-spacing: .2em;
            text-transform: uppercase; color: rgba(17,17,17,0.3);
            margin-bottom: 14px; min-height: 1rem;
        }
        .preview-divider { height: 1px; background: var(--border, rgba(0,0,0,0.08)); margin-bottom: 14px; }
        .preview-price {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.5rem; font-weight: 400;
            color: var(--text, #111);
        }
        .preview-price span {
            font-family: 'DM Sans', sans-serif;
            font-size: .7rem; font-weight: 300;
            color: rgba(17,17,17,0.3); letter-spacing: .06em;
        }
        .preview-label {
            font-size: .6rem; letter-spacing: .2em;
            text-transform: uppercase; color: rgba(17,17,17,0.3);
            margin-bottom: 16px; display: block;
        }

        /* ── FORM LABEL EXTENSION ── */
        .img-field-label {
            display: block; font-size: .6rem;
            font-weight: 400; letter-spacing: .22em;
            text-transform: uppercase; color: var(--t30, rgba(17,17,17,0.32));
            margin-bottom: 9px;
        }
        .img-field-name {
            font-size: .78rem; color: rgba(17,17,17,0.55);
            margin-top: 8px; letter-spacing: .02em;
            min-height: 1.2em;
        }

        @media (max-width: 900px) {
            .add-layout { grid-template-columns: 1fr; }
            .preview-card { position: static; }
        }
    </style>
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

        <!-- ── LEFT: FORM ── -->
        <div class="form-card">
            <!--
                IMPORTANT: enctype="multipart/form-data" is REQUIRED for file upload.
                The AdminCarServlet must have @MultipartConfig to process this.
            -->
            <form action="${pageContext.request.contextPath}/admin/add-car"
                  method="post"
                  enctype="multipart/form-data"
                  id="addCarForm">

                <div class="form-group">
                    <label>Car Model Name</label>
                    <input type="text" name="name" id="inputName" required placeholder="e.g. Civic"
                           oninput="updatePreview()">
                </div>

                <div class="form-group">
                    <label>Brand</label>
                    <input type="text" name="brand" id="inputBrand" required placeholder="e.g. Honda"
                           oninput="updatePreview()">
                </div>

                <div class="form-group">
                    <label>Price per Day ($)</label>
                    <input type="number" name="price" id="inputPrice" step="0.01" min="0"
                           required placeholder="e.g. 50.00" oninput="updatePreview()">
                </div>

                <div class="form-group checkbox-group">
                    <input type="checkbox" id="availability" name="availability"
                           checked onchange="updatePreview()">
                    <label for="availability">Mark as Available</label>
                </div>

                <!-- ── IMAGE UPLOAD ── -->
                <div class="form-group" style="margin-top:24px;">
                    <label class="img-field-label">Car Image</label>
                    <div class="img-upload-zone" id="uploadZone" onclick="triggerFileInput()">
                        <input type="file"
                               name="carImage"
                               id="carImageInput"
                               accept=".jpg,.jpeg,.png,.webp,.gif"
                               onchange="handleImageSelect(event)">
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

                <div class="form-actions" style="margin-top:32px;">
                    <button type="submit" class="btn btn-primary">Add Car</button>
                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                       class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>

        <!-- ── RIGHT: LIVE PREVIEW CARD ── -->
        <div>
            <span class="preview-label">Live Preview</span>
            <div class="preview-card">
                <div class="preview-card-img-wrap">
                    <img id="previewCardImg" src="" alt="Car preview">
                    <span id="previewCardBadge" class="preview-card-badge avail">Available</span>
                    <div class="preview-placeholder-icon" id="previewPlaceholderIcon">&#128663;</div>
                </div>
                <div class="preview-card-body">
                    <div class="preview-car-name" id="previewName">Car Name</div>
                    <div class="preview-car-brand" id="previewBrand">Brand</div>
                    <div class="preview-divider"></div>
                    <div class="preview-price">
                        $<span id="previewPrice">0.00</span>
                        <span>/ day</span>
                    </div>
                </div>
            </div>
        </div>

    </div><!-- end .add-layout -->
</div>

<footer>
    <div class="footer-top">
        <div>
            <span class="footer-brand">DriveEase</span>
            <p class="footer-desc">Premium car rental built around you.</p>
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
            </ul>
        </div>
    </div>
    <div class="footer-bottom">
        <span class="footer-copy">&copy; 2025 <span>DriveEase</span>. All rights reserved.</span>
        <div class="footer-legal"><a href="#">Privacy</a><a href="#">Terms</a></div>
    </div>
</footer>

<script>
function triggerFileInput() {
    document.getElementById('carImageInput').click();
}

function handleImageSelect(event) {
    var file = event.target.files[0];
    if (!file) return;

    var allowed = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
    if (allowed.indexOf(file.type) === -1) {
        document.getElementById('imgFileName').textContent = 'Invalid file type. Use JPG, PNG, WEBP, or GIF.';
        document.getElementById('imgFileName').style.color = '#c0392b';
        return;
    }

    var sizeMB = file.size / (1024 * 1024);
    if (sizeMB > 5) {
        document.getElementById('imgFileName').textContent = 'File too large. Maximum 5 MB.';
        document.getElementById('imgFileName').style.color = '#c0392b';
        return;
    }

    var reader = new FileReader();
    reader.onload = function(e) {
        var dataUrl = e.target.result;

        /* Update upload zone */
        document.getElementById('imgPreview').src = dataUrl;
        document.getElementById('uploadZone').classList.add('has-img');

        /* Update preview card */
        var cardImg = document.getElementById('previewCardImg');
        cardImg.src = dataUrl;
        cardImg.style.display = 'block';
        document.getElementById('previewPlaceholderIcon').style.display = 'none';
    };
    reader.readAsDataURL(file);

    /* Show filename */
    var name = file.name;
    if (name.length > 36) name = name.substring(0, 33) + '...';
    document.getElementById('imgFileName').textContent = name + '  (' + sizeMB.toFixed(1) + ' MB)';
    document.getElementById('imgFileName').style.color = '';
}

function updatePreview() {
    var name   = document.getElementById('inputName').value  || 'Car Name';
    var brand  = document.getElementById('inputBrand').value || 'Brand';
    var price  = parseFloat(document.getElementById('inputPrice').value) || 0;
    var avail  = document.getElementById('availability').checked;

    document.getElementById('previewName').textContent  = name;
    document.getElementById('previewBrand').textContent = brand;
    document.getElementById('previewPrice').textContent = price.toFixed(2);

    var badge = document.getElementById('previewCardBadge');
    badge.textContent = avail ? 'Available' : 'Rented';
    badge.className = 'preview-card-badge ' + (avail ? 'avail' : 'rented');
}

/* Drag-and-drop support */
var zone = document.getElementById('uploadZone');
zone.addEventListener('dragover', function(e) {
    e.preventDefault();
    zone.style.borderColor = 'rgba(0,0,0,0.5)';
    zone.style.background  = '#e8e7e3';
});
zone.addEventListener('dragleave', function() {
    zone.style.borderColor = '';
    zone.style.background  = '';
});
zone.addEventListener('drop', function(e) {
    e.preventDefault();
    zone.style.borderColor = '';
    zone.style.background  = '';
    var files = e.dataTransfer.files;
    if (files.length > 0) {
        document.getElementById('carImageInput').files = files;
        handleImageSelect({ target: { files: files } });
    }
});
</script>
</body>
</html>
