<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DriveEase — Premium Car Rental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .pub-nav{background:transparent;position:absolute;top:0;left:0;right:0;border-bottom:none}
        .pub-hero{position:relative;height:100vh;min-height:600px;overflow:hidden;display:flex;align-items:center}
        .pub-hero-bg{position:absolute;inset:0;background-image:url('https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=1800&q=85&fit=crop');background-size:cover;background-position:center 35%;animation:hzoom 16s ease forwards}
        @keyframes hzoom{from{transform:scale(1.05)}to{transform:scale(1)}}
        .pub-hero-overlay{position:absolute;inset:0;background:linear-gradient(to right,rgba(5,5,8,0.82) 0%,rgba(5,5,8,0.4) 55%,rgba(5,5,8,0.1) 100%)}
        .pub-hero-content{position:relative;z-index:2;padding:0 80px;max-width:700px}
        .pub-eyebrow{font-size:.62rem;letter-spacing:.28em;text-transform:uppercase;color:var(--accent);margin-bottom:18px;display:flex;align-items:center;gap:12px}
        .pub-eyebrow::before{content:'';display:block;width:32px;height:1px;background:var(--accent)}
        .pub-hero-content h1{font-family:'Cormorant Garamond',serif;font-size:clamp(3rem,6vw,5.5rem);font-weight:300;line-height:1.05;color:#f5f4f0;margin-bottom:22px;letter-spacing:-.01em}
        .pub-hero-content h1 em{font-style:italic}
        .pub-hero-content p{font-size:.95rem;font-weight:300;color:rgba(245,244,240,0.75);line-height:1.9;max-width:400px;margin-bottom:42px;letter-spacing:.02em}
        .pub-cta{display:flex;gap:14px;flex-wrap:wrap}
        .pub-pill{padding:14px 36px;border-radius:40px;font-size:.78rem;font-weight:400;letter-spacing:.12em;text-transform:uppercase;font-family:'DM Sans',sans-serif;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:10px;transition:all .25s}
        .pub-pill-solid{background:#f5f4f0;color:#1a1a1a;border:1px solid #f5f4f0}
        .pub-pill-solid:hover{background:var(--accent);border-color:var(--accent)}
        .pub-pill-ghost{background:transparent;color:rgba(245,244,240,0.75);border:1px solid rgba(245,244,240,0.25)}
        .pub-pill-ghost:hover{border-color:rgba(245,244,240,0.6);color:#f5f4f0}
        .pub-scroll{position:absolute;bottom:32px;right:56px;z-index:2;display:flex;flex-direction:column;align-items:center;gap:8px;font-size:.58rem;letter-spacing:.24em;text-transform:uppercase;color:rgba(245,244,240,0.45);writing-mode:vertical-rl}
        .pub-scroll-line{width:1px;height:48px;background:linear-gradient(to bottom,rgba(245,244,240,0.4),transparent);animation:scrl2 2s ease-in-out infinite}
        @keyframes scrl2{0%,100%{opacity:.3}50%{opacity:.85}}
        .pub-strip{background:#1c1c1c;padding:20px 80px;display:flex;align-items:center;gap:48px;border-bottom:1px solid rgba(255,255,255,0.05)}
        .pub-strip-label{font-size:.58rem;letter-spacing:.24em;text-transform:uppercase;color:rgba(245,244,240,0.4);white-space:nowrap;flex-shrink:0}
        .pub-strip-sep{width:1px;height:16px;background:rgba(255,255,255,0.12);flex-shrink:0}
        .pub-strip-brands{display:flex;gap:44px;overflow-x:auto;scrollbar-width:none}
        .pub-strip-brands::-webkit-scrollbar{display:none}
        .pub-brand-item{font-family:'Cormorant Garamond',serif;font-size:.92rem;font-weight:600;letter-spacing:.22em;text-transform:uppercase;color:rgba(245,244,240,0.2);white-space:nowrap;transition:color .2s}
        .pub-brand-item:hover{color:rgba(245,244,240,0.45)}
        .pub-features{background:#fff;padding:72px 80px;display:grid;grid-template-columns:repeat(3,1fr);gap:0;border-bottom:1px solid rgba(0,0,0,0.08)}
        .pub-feat{padding:0 44px;border-right:1px solid rgba(0,0,0,0.08)}
        .pub-feat:first-child{padding-left:0}
        .pub-feat:last-child{padding-right:0;border-right:none}
        .pub-feat-icon{font-size:1.2rem;opacity:.4;margin-bottom:14px}
        .pub-feat-title{font-family:'Cormorant Garamond',serif;font-size:1.2rem;font-weight:400;color:#111;margin-bottom:8px}
        .pub-feat-text{font-size:.8rem;font-weight:300;color:rgba(17,17,17,0.58);line-height:1.8;letter-spacing:.02em}
        .pub-cta-band{background:#1a1a1a;padding:80px;text-align:center}
        .pub-cta-band h2{font-family:'Cormorant Garamond',serif;font-size:clamp(2rem,4vw,3.2rem);font-weight:300;color:#f5f4f0;margin-bottom:14px;letter-spacing:-.01em}
        .pub-cta-band p{font-size:.9rem;font-weight:300;color:rgba(245,244,240,0.5);margin-bottom:36px;letter-spacing:.04em}
        .pub-cta-band-btns{display:flex;gap:14px;justify-content:center;flex-wrap:wrap}
        @media(max-width:1024px){.pub-features{grid-template-columns:1fr;padding:48px}.pub-feat{padding:28px 0;border-right:none;border-bottom:1px solid rgba(0,0,0,0.08)}.pub-feat:last-child{border-bottom:none}}
        @media(max-width:768px){.pub-hero-content{padding:0 28px}.pub-strip{padding:18px 28px;gap:24px}.pub-cta-band{padding:56px 28px}}
    </style>
</head>
<body>

<!-- PUBLIC NAV -->
<nav class="navbar pub-nav">
    <div class="nav-brand">DriveEase</div>
    <div class="nav-links">
        <a href="#features">Features</a>
        <a href="${pageContext.request.contextPath}/login">Sign In</a>
        <a href="${pageContext.request.contextPath}/register"
           style="border:1px solid rgba(245,244,240,0.3);padding:6px 16px;color:var(--wh)!important">Get Started</a>
    </div>
    <button class="nav-toggle" onclick="document.querySelector('.nav-links').classList.toggle('open')">
        <span></span><span></span><span></span>
    </button>
</nav>

<!-- HERO -->
<section class="pub-hero">
    <div class="pub-hero-bg"></div>
    <div class="pub-hero-overlay"></div>
    <div class="pub-hero-content">
        <div class="pub-eyebrow">Premium Car Rental</div>
        <h1>The road on<br>your <em>terms.</em></h1>
        <p>Handpicked vehicles, transparent pricing, and the freedom to go anywhere — delivered straight to you.</p>
        <div class="pub-cta">
            <a href="${pageContext.request.contextPath}/register" class="pub-pill pub-pill-solid">
                Start Renting &#8250;
            </a>
            <a href="${pageContext.request.contextPath}/login" class="pub-pill pub-pill-ghost">
                Sign In
            </a>
        </div>
    </div>
    <div class="pub-scroll">
        <div class="pub-scroll-line"></div>
        Discover
    </div>
</section>

<!-- BRAND STRIP -->
<div class="pub-strip">
    <span class="pub-strip-label">Our Fleet</span>
    <div class="pub-strip-sep"></div>
    <div class="pub-strip-brands">
        <span class="pub-brand-item">Toyota</span>
        <span class="pub-brand-item">Honda</span>
        <span class="pub-brand-item">Tesla</span>
        <span class="pub-brand-item">BMW</span>
        <span class="pub-brand-item">Audi</span>
        <span class="pub-brand-item">Mercedes</span>
        <span class="pub-brand-item">Ford</span>
        <span class="pub-brand-item">Porsche</span>
    </div>
</div>

<!-- FEATURES -->
<section class="pub-features" id="features">
    <div class="pub-feat">
        <div class="pub-feat-icon">&#9889;</div>
        <div class="pub-feat-title">Instant Booking</div>
        <div class="pub-feat-text">Reserve any vehicle in under two minutes. No paperwork, no hidden fees — pick a car, confirm your details, and drive.</div>
    </div>
    <div class="pub-feat">
        <div class="pub-feat-icon">&#128737;</div>
        <div class="pub-feat-title">Fully Insured</div>
        <div class="pub-feat-text">Every rental includes comprehensive coverage. Focus on the journey ahead — we handle the details.</div>
    </div>
    <div class="pub-feat">
        <div class="pub-feat-icon">&#128205;</div>
        <div class="pub-feat-title">Delivered to You</div>
        <div class="pub-feat-text">We deliver to your home, office, or hotel. Your vehicle arrives fuelled, cleaned, and ready to go.</div>
    </div>
</section>

<!-- CTA BAND -->
<div class="pub-cta-band">
    <h2>Ready to hit the road?</h2>
    <p>Create a free account and browse our fleet in seconds.</p>
    <div class="pub-cta-band-btns">
        <a href="${pageContext.request.contextPath}/register" class="pub-pill pub-pill-solid">
            Create Account &#8250;
        </a>
        <a href="${pageContext.request.contextPath}/login" class="pub-pill pub-pill-ghost">
            Sign In
        </a>
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
                <li><a href="${pageContext.request.contextPath}/login">Sign In</a></li>
                <li><a href="${pageContext.request.contextPath}/register">Register</a></li>
            </ul>
        </div>
        <div>
            <div class="footer-col-title">Account</div>
            <ul class="footer-links">
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
</body>
</html>
