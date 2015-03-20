<?lua local p = print ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">

    <title><?lua p(title or "") ?></title>
    <!-- Bootstrap core CSS -->
    <link href="/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom styles for this template -->
    <link href="/style/site.css" rel="stylesheet">
</head>

<body>

<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="/"><span class="glyphicon glyphicon-flag" aria-hidden="true"></span> Lua Server</a>
        </div>
        <div id="navbar" class="collapse navbar-collapse navbar-right">
            <ul class="nav navbar-nav">
                <li class="<?lua p(title=='Home' and 'active' or '') ?>"><a href="/"><span class="glyphicon glyphicon-home" aria-hidden="true"></span> Home</a></li>
                <li class="<?lua p(title=='About' and 'active' or '') ?>"><a href="/home/about"><span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span> About</a></li>
                <li class="<?lua p(title=='Contact' and 'active' or '') ?>"><a href="/home/contact"><span class="glyphicon glyphicon-send" aria-hidden="true"></span> Contact</a></li>
                <li class="<?lua p(title=='Login' and 'active' or '') ?> dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><span class="glyphicon glyphicon-globe" aria-hidden="true"></span> Account<span class="caret"></span></a>
                    <ul class="dropdown-menu" role="menu">
                        <?lua if Username then ?>
                            <li class="dropdown-header">Currently logged in as <?lua p(Username or "") ?></li>
                            <li class="divider"></li>
                            <li><a href="/home/logout"><span class="glyphicon glyphicon-log-out" aria-hidden="true"></span> Log Out</a></li>
                        <?lua else ?>
                            <li><a href="/home/login"><span class="glyphicon glyphicon-log-in" aria-hidden="true"></span> Log In</a></li>
                        <?lua end ?>
                    </ul>
                </li>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
</nav>

<div class="container">

    <div class="starter-template">
        <h1><?lua p(heading or "") ?></h1>
        <p class="lead"><?lua RenderBody() ?></p>
    </div>

</div>
<script src="/scripts/jquery.min.js"></script>
<script src="/bootstrap/js/bootstrap.min.js"></script>
<!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
</body>
</html>
