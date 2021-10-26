<?php
include ("conn.php");
header("Access-Control-Allow-Origin: *");

$customerID = mysqli_real_escape_string($connection, $_POST['customerID']);
$key = $_POST['key'];

if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $queryResult = mysqli_query($connection, "SELECT SUM(`qty`) AS 'num' FROM `cart` WHERE `customerID` ='$customerID'");
    $results = mysqli_fetch_array($queryResult);
    echo json_encode($results['num']);
} else {
    echo "<font color=red> Access denied ! </font>";
}
?>