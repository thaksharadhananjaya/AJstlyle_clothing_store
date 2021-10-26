<?php
include ("conn.php");
header("Access-Control-Allow-Origin: *");

$base64_string = $_POST["image"];
$name = $_POST["name"];
$price = $_POST["price"];
$salePrice = $_POST["salePrice"];
$discription = $_POST["discription"];
$category = $_POST["category"];
$varients = $_POST["varient"];
$sizeChart = $_POST["sizeChart"];

$key = $_POST['key'];

if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!")
{

    try
    {

        $outputfile = "/home/u688585976/domains/ajstyle.lk/public_html/uploads/" . $name . ".jpg";
        $filehandler = fopen($outputfile, 'wb');
        if (!$filehandler)
        {
            echo json_encode("-1");
        }
        else
        {
            $data = fwrite($filehandler, base64_decode($base64_string));
            fclose($filehandler);

            $query = "INSERT INTO `product`(`categoryID`, `name`, `price`, `salePrice`, `discription`, `image`) VALUES ('$category','$name','$price','$salePrice','$discription','https://ajstyle.lk/uploads/$name" . ".jpg')";

            if (mysqli_query($connection, $query))
            {

                $queryResult = mysqli_query($connection, "SELECT MAX(`productID`) AS 'id' FROM `product` LIMIT 1");
                $results = mysqli_fetch_array($queryResult);
                $productID = $results["id"];
                $data = json_decode($varients, true);
                
                foreach ($data as $varient)
                {
                    $color = $varient['color'];
                    $size = $varient['size'];
                    $salePrice = $varient['salePrice'];
                    $price = $varient['price'];
                    $qty = $varient['qty'];
                    $image = $varient['image'];
                    $outputfile = "/home/u688585976/domains/ajstyle.lk/public_html/uploads/" . $productID . $color . $size . ".jpg";
                    $filehandler = fopen($outputfile, 'wb');
                    fwrite($filehandler, base64_decode($image));
                    fclose($filehandler);

                    $query = "INSERT INTO `variant`(`productID`, `color`, `size`, `qty`, `price`, `salePrice`, `image`) VALUES ('$productID','$color','$size','$qty','$price','$salePrice','https://ajstyle.lk/uploads/$productID$color$size" . ".jpg')";

                    mysqli_query($connection, $query);

                }
                
                $sizeData = json_decode($sizeChart,true);
                foreach ($sizeData as $size)
                {
                    $data = $size['data'];
                    $isLabel = $size['isLabel'];
                     $query = "INSERT INTO `sizeChart`(`productID`, `data`, `isLabel`) VALUES ('$productID','$data','$isLabel')";

                    mysqli_query($connection, $query);
                }

                echo json_encode($sizeData);
            }
            else
            {
                echo json_encode("-1");
            }

        }
    }
    catch(Exception $e)
    {
        echo json_encode($e);
    }
}
else
{
    echo "<font color=red> Access denied ! </font>";
}
?>
