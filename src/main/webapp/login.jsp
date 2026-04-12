<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Modern Login Page</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/login.css">
</head>
<body>

<div class="container">
    <div class="left">
        <div class="left-text">
            <h1>Welcome Back</h1>
            <p>Timex Inspired UI</p>
        </div>
    </div>

    <div class="right">
        <div class="tabs">
            <button class="active" onclick="showForm('login')">Login</button>
            <button onclick="showForm('request')">Request</button>
        </div>

        <form id="login" class="active">
            <input type="email" placeholder="Email" required>
            <input type="password" placeholder="Password" required>
            <button class="submit">Login</button>
        </form>

        <form id="request">
            <input type="text" placeholder="Full Name" required>
            <input type="email" placeholder="Email" required>
            <input type="text" placeholder="Request Type" required>
            <button class="submit">Submit Request</button>
        </form>
    </div>
</div>

<script>
function showForm(type){
    document.querySelectorAll('form').forEach(f=>f.classList.remove('active'));
    document.querySelectorAll('.tabs button').forEach(b=>b.classList.remove('active'));

    document.getElementById(type).classList.add('active');
    event.target.classList.add('active');
}
</script>

</body>
</html>