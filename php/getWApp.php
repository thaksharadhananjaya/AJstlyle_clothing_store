<?php
include ("conn.php");

$key = $_POST['key'];

if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query = "SELECT `whatsapp` FROM `settings` LIMIT 1";
   
    $queryResult = mysqli_query($connection, $query);

        $results = mysqli_fetch_array($queryResult);
        echo json_encode($results['whatsapp']);
    
} else {
    echo "<font color=red> Access denied ! </font>";
}
?>