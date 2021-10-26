<?php
		include("conn.php");
		$productID = $_POST['productID'];
		
		$key = $_POST['key'];
		
		if($key=="z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!"){
		
    		$query = "SELECT `data` FROM `sizeChart` WHERE `productID`='$productID' ORDER BY `isLabel` DESC";
    		
    		
    		
            $queryResult = mysqli_query($connection, $query);
            
    		if(mysqli_num_rows($queryResult)){
                $results = array();
    			while ($fetchdata=$queryResult->fetch_assoc()) {	
    				$results[] = $fetchdata;
    			}
    			echo json_encode($results);
    		}
		    
		}else{
		    echo "<font color=red> Access denied ! </font>";
		}
	?>