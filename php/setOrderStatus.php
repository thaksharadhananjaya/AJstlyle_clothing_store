<?php
include ("conn.php");
header("Access-Control-Allow-Origin: *");

$status = mysqli_real_escape_string($connection, $_POST['status']);
$orderID = mysqli_real_escape_string($connection, $_POST['orderID']);

$key = mysqli_real_escape_string($connection,$_POST['key']);
if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query = "UPDATE `order` SET `status`= '$status' WHERE `orderID` = '$orderID'";
    if (mysqli_query($connection, $query)) {
         echo json_encode("1");
    } else {
        echo json_encode("-1");
    }
} else {
    echo "<font color=red> Access denied ! </font>";
}
?>