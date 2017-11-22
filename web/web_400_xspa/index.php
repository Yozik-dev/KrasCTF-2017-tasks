<html>
<head>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/jquery-ui.min.css">
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>

<div class="container">

    <div class="row justify-content-center">
        <div class="col-md-auto">
            <h2>Отправьте открытку другу</h2>
        </div>
    </div>

    <div class="row">
        <div class="col-md-auto">
            <h4>Выберите открытку</h4>
        </div>
    </div>

    <div class="row">
        <div class="col"><a href="redirecter.php?url=./landings/piramid.html"><div class="card"><img src="img/heops1.jpg" alt=""></div></a></div>
        <div class="col"><a href="redirecter.php?url=./landings/nil.html"><div class="card"><img src="img/nil.jpg" alt=""></div></a></div>
        <div class="col"><a href="redirecter.php?url=./landings/kair.html"><div class="card"><img src="img/kair.jpg" alt=""></div></a></div>
        <div class="col"><a href="redirecter.php?url=./landings/mayak.html"><div class="card"><img src="img/mayak.png" alt=""></div></a></div>
    </div>

    <hr>

    <div class="row">
        <div class="col">
            <h4>Проверьте возможность отправки</h4>
            <input id="autocomplete-address" class="form-control" type="text" size="100" placeholder="Полный автозаполняемый адрес"/>
        </div>
    </div>
</div>

<script src="scripts/jquery.min.js"></script>
<script src="scripts/jquery-ui.min.js"></script>
<script src="scripts/code.js"></script>
</body>
</html>