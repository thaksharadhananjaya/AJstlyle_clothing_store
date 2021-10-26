<?php
include ("conn.php");
header("Access-Control-Allow-Origin: *");

$customerID = mysqli_real_escape_string($connection, $_POST['customerID']);
$productID = mysqli_real_escape_string($connection, $_POST['productID']);
$size = mysqli_real_escape_string($connection, $_POST['size']);
$color = mysqli_real_escape_string($connection, $_POST['color']);
$key = mysqli_real_escape_string($connection, $_POST['key']);

if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query= "DELETE FROM `cart` WHERE `customerID` = '$customerID' AND `productID` = '$productID' AND `size`='$size' AND `color`= '$color'";
    if(mysqli_query($connection, $query)){
        echo json_encode('1');
    }else{
        echo json_encode('0');
    }
   
} else {
   header("Location: www.ajstyle.lk/php");
exit();
}
?>