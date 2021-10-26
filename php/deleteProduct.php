<?php
include ("conn.php");
header("Access-Control-Allow-Origin: *");

$productID = mysqli_real_escape_string($connection, $_POST['productID']);
;
$key = mysqli_real_escape_string($connection,$_POST['key']);
if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query = "DELETE FROM `product` WHERE `productID` = '$productID'";
    mysqli_query($connection, $query);
    
    $query = "DELETE FROM `variant` WHERE `productID`= '$productID'";
    mysqli_query($connection, $query);
    
    $query = "DELETE FROM `sizeChart` WHERE `productID`= '$productID'";
    mysqli_query($connection, $query);
    
} else {
    echo "<font color=red> Access denied ! </font>";
}
?>