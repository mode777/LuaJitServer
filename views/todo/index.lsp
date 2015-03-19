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
    <script>
        var data = <?lua Helpers.json(items) ?>
    </script>
    <div class="metro">
    <h1>ToDo List</h1>
    <?lua for i,item in ipairs(items) do ?>
      <div class="panel">
          <div class="panel-header <?lua p(not item.done and "bg-red" or "bg-lime") ?>">
             <?lua p(item.title) ?>
          </div>
          <div class="panel-content">
              <?lua p(item.desc) ?><div style="float:right;"><div class="button" onclick=""><?lua p(item.done and "Remove" or "Mark done") ?></div></div>
          </div>
      </div>
    <?lua end ?>
    </div>
</body>
</html>
