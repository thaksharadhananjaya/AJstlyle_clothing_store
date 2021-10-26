<?php
include ("conn.php");
header("Access-Control-Allow-Origin: *");
$otp = rand(1000, 9999);
$email =  $_POST['email'];;
$key =  $_POST['key'];

if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!")
{

    $result = mysqli_query($connection, "SELECT * FROM customer WHERE email='$email'");

    if (mysqli_num_rows($result) <= 0)
    {
        echo json_encode("0");
    }
    else
    {

        $to = $email;
        $subject = "AJStyle - Reset Password";

        $message = "<h3>We received a request to reset your password</h3>";
        $message .= "<center><div style='width:100px; border: 1px solid black; background-color: black; color: white;text-align: center;'><h1>$otp</h1></div></center>";

        $header = "From:recovery@ajstyle.lk \r\n";
        $header .= "MIME-Version: 1.0\r\n";
        $header .= "Content-type: text/html\r\n";
        $retval = mail($to, $subject, $message, $header);
        echo json_encode($otp);
    }
}else
{
    echo "<font color=red> Access denied ! </font>";
}


?>
