<?php
		include("conn.php");
        header("Access-Control-Allow-Origin: *");
        
        
        
		$user = mysqli_real_escape_string($connection, $_POST['user']);
		$pass = mysqli_real_escape_string($connection, $_POST['password']);
 
		$key = $_POST['key'];
		
		if($key=="z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!"){
		
    		$query = "SELECT * FROM `user` WHERE `userName`='$user' AND `password` = '$pass'";
  		
    		
            $queryResult = mysqli_query($connection, $query);
            
    		if(mysqli_num_rows($queryResult)){
    			echo json_encode('1');
    		}else{
    		    echo json_encode('0');
    		}
		    
		}else{
    echo "<font color=red> Access denied ! </font>";
}
	?>