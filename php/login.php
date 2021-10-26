<?php
include ("conn.php");
header("Access-Control-Allow-Origin: *");

$user = mysqli_real_escape_string($connection, $_POST['user']);
$pass = mysqli_real_escape_string($connection, $_POST['pass']);
$key = mysqli_real_escape_string($connection, $_POST['key']);

if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query = "SELECT * FROM `customer` WHERE `email`='$user' AND `pass` = '$pass'";
    $queryResult = mysqli_query($connection, $query);
    if (mysqli_num_rows($queryResult)) {
        $results = mysqli_fetch_array($queryResult);
        echo json_encode($results);
    } else {
        echo json_encode('0');
    }
} else {
 
header("Location: www.ajstyle.lk/php");
exit();

}
?>