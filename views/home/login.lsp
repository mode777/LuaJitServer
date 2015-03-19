<?lua UseLayout("/views/_layout/layout.lsp") ?>
<div class="login">
    <form method="post" action="/home/login" method="post">
        <div class="fg-red"><?lua print(message or "") ?></div>
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