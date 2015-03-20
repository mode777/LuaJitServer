<?lua UseLayout("/views/_layout/layout.lsp") ?>
<div>
    <div class="panel panel-primary">
        <div class="panel-heading" >
            <h2 class="panel-title">Log In</h2>
        </div>
        <div class="panel-body">
            <form class="form-signin" method="post" action="/home/login">
                <label for="username" class="sr-only">Username</label>
                <input name="login" type="text" id="username" class="form-control" placeholder="Username" required autofocus>
                <label for="password" class="sr-only">Password</label>
                <input name="password" type="password" id="password" class="form-control" placeholder="Password" required>
                <div class="checkbox">
                    <label>
                        <input type="checkbox" value="remember-me"> Remember me
                    </label>
                </div>
                <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
            </form>
        </div>
    </div>
</div>
