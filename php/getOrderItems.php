<?php
header("Access-Control-Allow-Origin: *");
include ("conn.php");

$orderID = $_POST['orderID'];

$key = $_POST['key'];

if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query = "SELECT `product`.`name`, `orderProduct`.`size`,`orderProduct`.`color`, `orderProduct`.`qty`, ROUND(`orderProduct`.`price`,2) AS 'price', ROUND(`orderProduct`.`qty`*`orderProduct`.`price`,2) AS 'total', `variant`.`image`, `orderProduct`.`status` FROM `orderProduct` INNER JOIN `product` ON `orderProduct`.`productID`=`product`.`productID` INNER JOIN `variant` ON `orderProduct`.`productID` = `variant`.`productID` WHERE `orderProduct`.`orderID`='$orderID' AND `variant`.`color`=`orderProduct`.`color` AND `variant`.`size`=`orderProduct`.`size`";
   
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