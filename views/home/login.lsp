<html>
<head>
    <title>Lua Server Login Page</title>
    <link rel="stylesheet" type="text/css" href="/metroui/metro-bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="/metroui/metro-bootstrap-responsive.min.css">
    <link rel="stylesheet" type="text/css" href="/metroui/iconFont.min.css">
</head>
<body>
<div class="metro">
    <div class="login">
        <h1>Login to Web App</h1>
        <form method="post" action="/home/login" method="post">
            <div class="fg-red"><?lua print(data or "") ?></div>
            <p><input type="text" name="login" value="" placeholder="Username or Email"></p>
            <p><input type="password" name="password" value="" placeholder="Password"></p>
            <p class="remember_me">
                <label>
                    <input type="checkbox" name="remember_me" id="remember_me">
                    Remember me on this computer
                </label>
            </p>
            <p class="submit"><input type="submit" name="commit" value="Login"></p>
        </form>
    </div>
</div>
</body>
</html>