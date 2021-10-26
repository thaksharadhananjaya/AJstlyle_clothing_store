<?php
header("Access-Control-Allow-Origin: *");
include ("conn.php");

$isSale = $_POST['isSale'];
$search = $_POST['search'];
$page = $_POST['page'];
$category = $_POST['category'];
$key = $_POST['key'];

if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query = "SELECT * FROM `product` WHERE `salePrice` = `price` LIMIT $page, 15";
    if (isset($search)) {
        $query = "SELECT * FROM `product` WHERE `name` LIKE '%$search%' LIMIT $page, 15";
    }
    if (isset($isSale)) {
        $query = "SELECT * FROM `product` WHERE `salePrice`< `price` LIMIT $page, 15";
    }
    if (isset($category)) {
        $query = "SELECT * FROM `product` WHERE `categoryID` = '$category' LIMIT $page, 15";
    }
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