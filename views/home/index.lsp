<?lua local p=print ?>
<html>
<head>
    <title><?lua p(title) ?></title>
    <link rel="stylesheet" type="text/css" href="/metroui/metro-bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="/metroui/metro-bootstrap-responsive.min.css">
    <link rel="stylesheet" type="text/css" href="/metroui/iconFont.min.css">
    <script src="/scripts/jquery.min.js"></script>
</head>
<body>
    <div class="metro">
    <h1><?lua p(heading) ?></h1>
    <?lua
        p("<ul>")
        for _,link in ipairs(myData) do
            p("<li><a href='"..link.href.."'>"..link.text.."</a></li>")
        end
        p("</ul>")
    ?>
    <p>Username: <?lua p(username) ?></p>
    </div>
</body>
</html>
