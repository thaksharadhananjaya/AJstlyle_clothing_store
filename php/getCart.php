<?php
include ("conn.php");
header("Access-Control-Allow-Origin: *");

$customerID = mysqli_real_escape_string($connection, $_POST['customerID']);
$key = $_POST['key'];

if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query= "SELECT `cart`.`productID`, `product`.`name`, `cart`.`size`,`cart`.`color`, `cart`.`qty`, `cart`.`price`, `cart`.`total`, `variant`.image FROM `cart` INNER JOIN `product` ON `product`.`productID`=`cart`.`productID` INNER JOIN `variant` ON `variant`.`productID`=`cart`.`productID` AND `cart`.`color`= `variant`.`color` AND `cart`.`size`=`variant`.`size` WHERE `cart`.`customerID`='$customerID'";
    $queryResult = mysqli_query($connection, $query);
    if (mysqli_num_rows($queryResult)) {
        $results = array();
        while ($fetchdata = $queryResult->fetch_assoc()) {
            $results[] = $fetchdata;
        }
        echo json_encode($results);
    } else {
        echo json_encode("0");
    }
} else {
    echo "<font color=red> Access denied ! </font>";
}
?>