<?php

function getIp()
{
    if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
    } else {
        $ip = $_SERVER['REMOTE_ADDR'];
    }
    return $ip;
}
$ip = getIp();
echo "IP: $ip<br><br>";
if ($ip == '127.0.0.1') {
    echo 'MneTakNeNravitc9';
}