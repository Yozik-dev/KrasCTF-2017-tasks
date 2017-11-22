<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title></title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>
<div id="main">
    <!--<div class="row">
         <div class="col-md-4">
             <form class="form-horizontal" role="form" method="get" action="index.php">
                 <div class="form-group">
                 <br><br><br><br><br>
                 <label for="inputPassword" class="col-sm-2 control-label">Id</label>
                     <div class="col-sm-6">
                         <input type="text" name="id" class="form-control" id="inputText" placeholder="Id">
                     </div>
                 </div>
                 <button type="submit" class="btn btn-warning ">Отправить</button>
             </form>
         </div>
     </div> -->

    <?php
    $mysqli = new mysqli("localhost", "root", "", "krasctf");

    if ($mysqli->connect_errno) {
        printf("Не удалось подключиться: %s\n", $mysqli->connect_error);
        exit();
    }

    if (isset($_GET['id'])) {
        $id = $_GET['id'];

        if (preg_match('/\s/', $id)) // Фильтрация
            exit('<p><b>Неверный Id!</p>'); //Это сообщение нужно, чтобы запутать;
        if (preg_match('/[\'"]/', $id))
            exit('<p><b>Неверный Id!</p>!');
        if (preg_match('/[\/\\\\]/', $id))
            exit('<p><b>Неверный Id!</p>');

        $result = $mysqli->query("SELECT id,name FROM users WHERE id = $id");

        if ($result) {
            while ($ob = $result->fetch_object()) {
                echo "<p><b>Имя: </b> $ob->name</p>";
            }
        }

        if (!$result->num_rows and $id != NULL) {
            echo "<p><b>Неверный Id!</p>";
        }
    }
    $mysqli->close();

    ?>
</div>
</body>
</html>