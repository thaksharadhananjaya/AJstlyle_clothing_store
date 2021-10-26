<?php
include ("conn.php");
header("Access-Control-Allow-Origin: *");

$customerID = mysqli_real_escape_string($connection, $_POST['customerID']);
$productID = mysqli_real_escape_string($connection, $_POST['productID']);
$size = mysqli_real_escape_string($connection, $_POST['size']);
$color = mysqli_real_escape_string($connection, $_POST['color']);
$qty = mysqli_real_escape_string($connection, $_POST['qty']);
$price = mysqli_real_escape_string($connection, $_POST['price']);
$date = mysqli_real_escape_string($connection, $_POST['date']);
$total = $price * $qty;
$key = $_POST['key'];

if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query = mysqli_query($connection, "SELECT (`qty`-$qty) AS 'Availble' FROM `variant` WHERE `productID`='$productID' AND `size`='$size' AND `color`='$color'");
    $results = mysqli_fetch_array($query);
    if ($results['Availble'] > 0) {
        $query = "INSERT INTO `cart`(`customerID`, `productID`, `size`, `color`, `qty`, `price`, `total`, `date`) VALUES ('$customerID', '$productID', '$size', '$color', '$qty', '$price', '$total', '$date')";
        if (mysqli_query($connection, $query)) {
            
            $queryResult = mysqli_query($connection, "SELECT SUM(`qty`) AS 'num' FROM `cart` WHERE `customerID` ='$customerID'");
            $results = mysqli_fetch_array($queryResult);
            echo json_encode($results['num']);
        } else {
           
            $query = "UPDATE `cart` SET `qty`=`qty`+$qty, `total`=`total`+$total WHERE `customerID` = '$customerID' AND `productID`='$productID' AND `size`='$size' AND `color`='$color'";
            if (mysqli_query($connection, $query)) {
                $queryResult = mysqli_query($connection, "SELECT SUM(`qty`) AS 'num' FROM `cart` WHERE `customerID` ='$customerID'");
                $results = mysqli_fetch_array($queryResult);
                echo json_encode($results['num']);
            } else {
                echo json_encode("-1");
            }
        }
    } else {
        echo json_encode("0");
    }
} else {
    echo "<font color=red> Access denied ! </font>";
}
?>