<?php
include ("conn.php");

$customerID = mysqli_real_escape_string($connection, $_POST['customerID']);
$key = mysqli_real_escape_string($connection,$_POST['key']);

if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query = "SELECT SUM(`price`*`qty`) AS 'total' FROM `cart` WHERE `customerID` = '$customerID'";
    $queryResult = mysqli_query($connection, $query);
    if (mysqli_num_rows($queryResult)) {
        $results = mysqli_fetch_array($queryResult);
        echo json_encode($results['total']);
    } else {
        echo json_encode("0");
    }
} else {
    echo "<font color=red> Access denied ! </font>";
}
?>