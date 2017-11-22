<?php

include "functions.php";

if (isset($_GET['url'])) {
    $content = Get($_GET['url']);
    if (!$content) {
        echo 'error';
        exit;
    }
    $file_name = rand(1000, 9999) . rand(1000, 9999) . rand(1000, 9999);
    file_put_contents('./runtime/' . $file_name, $content);
    if (isset($_GET['partner'])) {
        $partner = $_GET['partner']; //TODO load partner
    } else {
        $partner = GetRandomPronounceableWord(10);
    }
    header("Location: ./redirecter.php?$partner=$file_name");
} else {
    $keys = array_keys($_GET);
    foreach ($keys as $key) {
        if (strlen($key) === 10 && $_GET[$key]) {
            //TODO save lid to partner
            echo file_get_contents('./runtime/' . $_GET[$key]);
            break;
        }
    }
}