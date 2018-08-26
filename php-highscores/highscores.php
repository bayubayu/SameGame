<?php 
/**
 * ...
 * @author     : Bayu Rizaldhan Rayes
 * web         : http://www.bayubayu.com
 * email       : rizald_ray@yahoo.com
 * 
 * Description : Game Main Class
 * 
 */
 
// compare function for sorting
function cmp($a,$b) {
	if ($a[score] == $b[score]) { return 0; }
	return ($a[score]<$b[score])?1:-1;
	
}

// Generate Key using playername, score and gamename
function generate_key($score,$playername,$gamename) {
	return ( (((int)$score+12)*0.6) + (strlen($playername.$gamename) *12) );
}

	// get parameters
	$gamename = $_GET["gamename"];
	$score = $_GET["score"];
	$action = $_GET["action"];
	$playername = $_GET["playername"];
	$key = $_GET["key"];
	
	// validation
	$error_message = "";
	$valid_key = false;
	
	//generate key
	$generated_key = generate_key($score,$playername,$gamename);
	
	// check validation
	if (isset($playername) && isset($score) && ($generated_key == $key)) { 
		$valid_key = true; 
	} else { 
		echo "not valid key"; 
	}
	
	$score_file = $gamename.".score.php";
	$max_score = 12;
	
	$file = null;
	$scorefile = "";
	
	//open file
	if (file_exists($score_file)) {
		$file = fopen($score_file,"r");
		$scorefile = fread($file,filesize($score_file));
		
		$scoredata = json_decode($scorefile,true);
		
	} else {
		if ($valid_key) {
			$file = fopen($score_file,"w");
			$default_score_data = array('maxscore'=>$max_score,'scores'=>array());
			$scoredata_json = json_encode($default_score_data);
			fputs($file,$scoredata_json);
			
			$scoredata = $default_score_data;
		} else {
			return 0;
		}
	}
	if (isset($scoredata["scores"])) {
		
	}
	
	// check duplicated data & set score as integer
	for ($i = 0; $i < count($scoredata["scores"]); $i++) {
			if (($scoredata["scores"][$i][score] == $score) && ($scoredata["scores"][$i][name] == $playername)) {
				$valid_key = false;
			}
		$scoredata["scores"][$i][score] = (int)$scoredata["scores"][$i][score];
	}
	
	//add new data
	if ($action == "insert") {
		if ($valid_key) {
			array_push($scoredata["scores"],array('name'=>$playername,'score'=>(int)$score));
		} else {
			$error_message = "Entry not added,";
		}
	}
	// sort data
	usort($scoredata["scores"],"cmp");
	$scoredata["maxscore"] = $max_score;
	$scoredata["scores"] = array_slice($scoredata["scores"],0,$max_score);
	$scoredata_json = json_encode($scoredata);	
	
	// write
	if ($valid_key) {
		$file = fopen($score_file,"w");
		fputs($file,$scoredata_json);
	} else { 
	}
		
	fclose($file);
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
	<title><?php echo $gamename; ?> High Score</title>
	<style>
		body,table { font-family:Verdana; font-size:12px; background:#003333; color:#ffffff; }
		#container { width:450px; margin:0px auto; }
		table.highscore { 
			border:solid 1px #000000; 
			width:100%;
		}
		table.highscore td,table.highscore th { 
			border:solid 1px #000000; 
			background:#1D7185;
			padding:6px;
		}
		table.highscore th { background:#FF9900; }
		.error-message { 
			background:Yellow; 
			border:solid 1px #000000; 
			padding:6px; 
			margin:6px; 
			color:#000000;
		}
	</style>
</head>
<body>
<div id="container">
	<h1>
		<?php echo $gamename; ?>
	</h1>
	<?php if (strlen($error_message) > 0 ) { ?>
		<div class="error-message">
			<?php echo $error_message; ?>
		</div>
	<?php } ?>
	<table class="highscore" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th>No</th>
				<th>Player Name</th>
				<th>Score</th>
			</tr>
		</thead>
		<tbody>
			<?php for ($i = 0; $i < count($scoredata["scores"]); $i++) { ?>	
				<tr>
					<td><?php echo $i+1; ?></td>
					<td><?php echo $scoredata["scores"][$i][name]; ?></td>
					<td><?php echo $scoredata["scores"][$i][score]; ?></td>
				</tr>
			<?php } ?>

		</tbody>
	</table>
</div>
</body>
</html>