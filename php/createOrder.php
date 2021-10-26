<?php
include ("conn.php");
header("Access-Control-Allow-Origin: *");

$customerID = mysqli_real_escape_string($connection, $_POST['customerID']);
$name = mysqli_real_escape_string($connection, $_POST['name']);
$total = mysqli_real_escape_string($connection, $_POST['total']);
$city = mysqli_real_escape_string($connection, $_POST['city']);
$mobile = mysqli_real_escape_string($connection, $_POST['mobile']);
$district = mysqli_real_escape_string($connection, $_POST['district']);
$address = mysqli_real_escape_string($connection, $_POST['address']);
$date = mysqli_real_escape_string($connection, $_POST['date']);
$key = mysqli_real_escape_string($connection, $_POST['key']);

if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
   $query= "SELECT `productID`,`size`,`color`,`qty`,`price` FROM `cart` WHERE `customerID`='$customerID'";
    $queryResults = mysqli_query($connection, $query);
    if (mysqli_num_rows($queryResults)) {
        $isAbl=true;
        while ($fetchdata = $queryResults->fetch_assoc()) {
            $cartQty=$fetchdata['qty'];
            $productID=$fetchdata['productID'];
            $color=$fetchdata['color'];
            $size=$fetchdata['size'];
            
            $query="SELECT (`qty`-$cartQty) AS 'Availble' FROM `variant` WHERE `productID`='$productID' AND `size`='$size' AND `color`='$color'";
            $queryResult = mysqli_query($connection, $query);
             $results = mysqli_fetch_array($queryResult);

             if($results<1){
                 $isAbl = false;
                 break;
             }
             
        }
        if($isAbl){
            mysqli_query($connection, "INSERT INTO `order`(`customerID`, `total`, `name`, `address`, `city`, `district`, `mobile`, `date`) VALUES ('$customerID', '$total', '$name', '$address', '$city','$district', '$mobile','$date')");
            $queryResult = mysqli_query($connection, "SELECT MAX(`orderID`) AS 'orderID' FROM `order`");
             $result = mysqli_fetch_array($queryResult);
             $orderID=$result['orderID'];
             $query= "SELECT `productID`,`size`,`color`,`qty`,`price` FROM `cart` WHERE `customerID`='$customerID'";
    $queryResults = mysqli_query($connection, $query);
            while ($fetchdata = $queryResults->fetch_assoc()) {
                $qty = $fetchdata['qty'];
                $productID = $fetchdata['productID'];
                $color  =$fetchdata['color'];
                $size = $fetchdata['size'];
                $price =$fetchdata['price'];
                
                mysqli_query($connection, "UPDATE `variant` SET `qty` = `qty`- $qty WHERE `productID`='$productID' AND `size`='$size' AND `color`='$color'");
                
                $query="INSERT INTO `orderProduct`(`orderID`, `productID`, `size`, `color`, `qty`, `price`) VALUES ('$orderID', '$productID', '$size', '$color', '$qty', '$price')";
                mysqli_query($connection, $query);
            }
            
            mysqli_query($connection, "DELETE FROM `cart` WHERE `customerID`='$customerID'");
            echo json_encode("1");  
        }else{
          echo json_encode("0");  
        }
        
    } else {
        echo json_encode("-1");
    }
} else {
    header("Location: www.ajstyle.lk/php");
exit();
}
?>