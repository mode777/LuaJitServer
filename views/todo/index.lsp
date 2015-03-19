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
    <h1>ToDo List</h1>
    <?lua
        for i,v in ipairs(items) do
            p("<div>")
            p(v.title)
            p("</div>")
        end
    ?>
    <p>Username: <?lua p(username) ?></p>
    </div>
</body>
</html>
