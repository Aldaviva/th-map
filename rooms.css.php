<?php
	header('Content-type: text/css');

	$db = require 'db.php';

	foreach($db->query('SELECT id, x, y, width, height FROM Rooms') as $room){
		echo "#room{$room['id']} {
	width: {$room['width']}px;
	height: {$room['height']}px;
	left: {$room['x']}px;
	top: {$room['y']}px;
}\n\n";
	}

	foreach($db->query('SELECT id, floorx, floory, width, height FROM Floors;') as $floor){
		echo "#floor{$floor['id']} .floorsprite {
	top: {$floor['floory']}px;
	left: {$floor['floorx']}px;
}

#floor{$floor['id']} {
	width: {$floor['width']}px;
	height: {$floor['height']}px;
	/*margin-top: -".floor($floor['height']/2)."px;
	margin-left: -".floor(($floor['width']+340)/2)."px;*/
	/* turn back on for centering */
}\n\n";
	}
	
?>

.room, #middle .floor, .floorsprite, .floor_foreground {
	position: absolute;
}

#middle .floor {
	padding-right: 340px;
	/*top: 50%;
	left: 50%;*/
	/*turn back on for centering*/
}

.floor_dimexit {
	background-color: rgba(2,22,38,0.667);
	position: fixed;
}