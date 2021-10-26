<?php
include ("conn.php");
header("Access-Control-Allow-Origin: *");

$name = mysqli_real_escape_string($connection, $_POST['name']);
$user = mysqli_real_escape_string($connection, $_POST['user']);
$city = mysqli_real_escape_string($connection, $_POST['city']);
$district = mysqli_real_escape_string($connection, $_POST['district']);
$address = mysqli_real_escape_string($connection, $_POST['address']);

$key = $_POST['key'];
if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query = "UPDATE `customer` SET `name`= '$name',`city`= '$city', `district`= '$district' ,`address`= '$address' WHERE `customerID` = '$user'";
    if (mysqli_query($connection, $query)) {
        echo json_encode("1");
    } else {
        echo json_encode("0");
    }
} else {
    header("Location: www.ajstyle.lk/php");
exit();
}
?>