<?php
include ("conn.php");
header("Access-Control-Allow-Origin: *");

$categoryID = mysqli_real_escape_string($connection, $_POST['categoryID']);
;
$key = mysqli_real_escape_string($connection,$_POST['key']);
if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query = "DELETE FROM `category` WHERE `categoryID` = '$categoryID'";
    mysqli_query($connection, $query);
    
    $query = "UPDATE `product` SET `categoryID`='1' WHERE `categoryID` = '$categoryID'";
    mysqli_query($connection, $query);
    
} else {
    echo "<font color=red> Access denied ! </font>";
}
?>