<?php
		include("conn.php");
		header("Access-Control-Allow-Origin: *");
		
		$email = mysqli_real_escape_string($connection, $_POST['email']);
		$pass = mysqli_real_escape_string($connection, $_POST['pass']);

		$key = $_POST['key'];
		
		if($key=="z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!"){
		
		$query = "UPDATE `customer` SET `pass`= '$pass' WHERE `email` = '$email'";

    	   if(mysqli_query($connection,$query)){
    	      

                    echo json_encode("1");

                
            }else{
                echo json_encode("0");
            }
		
}else{
    echo "<font color=red> Access denied ! </font>";
}
	?>