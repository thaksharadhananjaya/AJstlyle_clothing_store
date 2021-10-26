<?php
include ("conn.php");
header("Access-Control-Allow-Origin: *");

$pass = mysqli_real_escape_string($connection, $_POST['pass']);
$mobile = mysqli_real_escape_string($connection, $_POST['mobile']);
$email = mysqli_real_escape_string($connection, $_POST['email']);
$key = mysqli_real_escape_string($connection,$_POST['key']);
if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query = "INSERT INTO `customer`( `mobile`, `email`, `pass`) VALUES ('$mobile','$email', '$pass');";
    if (mysqli_query($connection, $query)) {
        $queryResult = mysqli_query($connection, "SELECT `customerID` FROM `customer` WHERE `email` = '$email'");
        $results = mysqli_fetch_array($queryResult);
        echo json_encode($results['customerID']);
    } else {
        echo json_encode("-1");
    }
} else {
    echo "<font color=red> Access denied ! </font>";
}
?>