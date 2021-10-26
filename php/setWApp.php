<?php
include ("conn.php");
header("Access-Control-Allow-Origin: *");

$num = mysqli_real_escape_string($connection, $_POST['wapp']);;
$key = mysqli_real_escape_string($connection,$_POST['key']);
if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
   $query = "UPDATE `settings` SET `whatsapp`= '$num'";
    if (mysqli_query($connection, $query)) {
         echo json_encode("1");
    } else {
        echo json_encode("-1");
    }
} else {
    echo "<font color=red> Access denied ! </font>";
}
?>