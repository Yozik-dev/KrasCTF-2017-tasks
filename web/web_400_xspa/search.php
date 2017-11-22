<?php

include "functions.php";

if (isset($_GET['term'])) {
    echo json_encode(Autocomplete($_GET['term']));
}