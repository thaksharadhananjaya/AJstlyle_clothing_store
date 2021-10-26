<?php
		include("conn.php");
		$productID = $_POST['productID'];
		$size = $_POST['size'];
		$color = $_POST['color'];
		
		$key = $_POST['key'];
		
		if($key=="z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!"){
		
    		$query = "SELECT * FROM `variant` WHERE `productID`='$productID' AND `color` = '$color' AND `size` = '$size'";
    		
    		
    		
            $queryResult = mysqli_query($connection, $query);
            
    		if(mysqli_num_rows($queryResult)){
                $results = array();
    			while ($fetchdata=$queryResult->fetch_assoc()) {	
    				$results[] = $fetchdata;
    			}
    			echo json_encode($results);
    		}else{
    		    echo json_encode("0");
		    }
		    
		}else{
		    echo "<font color=red> Access denied ! </font>";
		}
	?>