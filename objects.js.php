<?php

header('Content-type: text/javascript');
$db = require 'db.php';
require_once 'library.php';



//echo "var floorNumbers = [".implode(',',$db->query('SELECT DISTINCT id/100 FROM rooms')->fetchAll(PDO::FETCH_COLUMN,0))."];\n";
echo "var floorNumbers = [".implode(',',$db->query('SELECT id FROM floors')->fetchAll(PDO::FETCH_COLUMN,0))."];\n";

echo "\nvar floors = new Object();\n";
foreach($db->query('SELECT id, floorx, floory, width, height, description, largesrc, rooms FROM floors LEFT JOIN (SELECT floor, array_agg(id) AS rooms FROM rooms GROUP BY floor) AS subquery ON floors.id = subquery.floor;', PDO::FETCH_OBJ) as $result){
	$id = $result->id;
	echo "floors['{$result->id}'] = ";
	$result->rooms = explode(',',trim($result->rooms ,'{}'));
	unset($result->id);
	echo json_encode($result);
	echo ";\n";

	echo "floors['$id'].activesprites = new Object();\n";
	foreach($db->query("SELECT x, y, title, name, description, largesrc FROM activesprites WHERE inroom = false AND parentid = '$id';", PDO::FETCH_OBJ) as $subresult){
		echo "floors['$id'].activesprites['".strtoupper($subresult->title)."'] = ";
		//unset($subresult->parentid);
		unset($subresult->title);
		echo json_encode($subresult);
		echo ";\n";
	}
}

echo "\nvar rooms = new Object();\n";
foreach($db->query('SELECT * FROM rooms', PDO::FETCH_OBJ) as $result){
	echo "rooms['{$result->id}'] = ";
	unset($result->id);
//	$result->description = str_replace('\u2019', "'", $result->description);
//	$result->description = utf8_decode($result->description);
	//echo "*THE DESCRIPTION IS ";
//	print_r($result);
	echo json_encode($result);
	echo ";\n";
}


$results = $db->query('SELECT parentid, activesprites.x, activesprites.y, activesprites.floor, name, title, activesprites.description, activesprites.largesrc FROM rooms INNER JOIN activesprites ON rooms.id = activesprites.parentid WHERE activesprites.inroom ORDER BY parentid ASC, activesprites.x ASC', PDO::FETCH_OBJ);

$parentid = '';
while($result = $results->fetch()){
	if($parentid != $result->parentid){
		echo "rooms['{$result->parentid}'].activesprites = new Object();\n";

		$parentid = $result->parentid;
	}

	echo "rooms['{$result->parentid}'].activesprites['".strtoupper($result->title)."'] = ";
	unset($result->parentid);
	unset($result->title);
	echo json_encode($result);
	echo ";\n";
}


echo "\nvar people = new Object();\n";
$results = $db->query('SELECT name, roomid FROM people LEFT JOIN rooms ON people.roomid = rooms.id;');
while($result = $results->fetch()){
	echo "people['".strtoupper($result['name'])."'] = '{$result['roomid']}';\n";
}

?>
