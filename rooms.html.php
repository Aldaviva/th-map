<?php 

$db = require 'db.php';

//foreach($db->query('SELECT DISTINCT id/100 AS floor FROM rooms ORDER BY floor ASC;', PDO::FETCH_COLUMN, 0) as $floor){
foreach($db->query('SELECT id FROM floors ORDER BY id ASC;', PDO::FETCH_COLUMN, 0) as $floor){

	echo "<div class='floor' id='floor$floor'>\n";

	echo "\t<img src='sprites/floor$floor/floor.png' class='floorsprite' />\n";

	$queryRoom = $db->prepare('SELECT id, zorder FROM rooms WHERE floor = ? ORDER BY zorder ASC;');
	$queryRoom->execute(array($floor));

	foreach($queryRoom as $room){

		echo "\t<div class='room' id='room{$room['id']}'>\n";

		$querySprites = $db->prepare('SELECT src, name FROM sprites WHERE parentid = ? AND inroom ORDER BY zorder ASC;');
		$querySprites->execute(array($room['id']));

		foreach($querySprites as $sprite){

			echo "\t\t<img src='sprites/{$sprite['src']}' id='room{$room['id']}-{$sprite['name']}' class='sprite' />\n";

		}

		echo "\t\t<img src='gfx/transparent.png' class='transparent' usemap='#room{$room['id']}-imagemap' />\n";

		echo "\t\t<map name='room{$room['id']}-imagemap' />\n";

		$queryActiveSprites = $db->prepare('SELECT name, title, hotspots, x, y FROM ActiveSprites WHERE parentid = ? AND inroom ORDER BY zorder DESC;');
		$queryActiveSprites->execute(array($room['id']));

		foreach($queryActiveSprites as $activeSprite){
			$hotspot = offsetHotspot($activeSprite['hotspots'], $activeSprite['x'], $activeSprite['y']);
			echo "\t\t\t<area coords='$hotspot' shape='poly' onclick=\"return activeClick('room{$room['id']}-{$activeSprite['title']}')\" href='#' alt='' />\n";
		}

		echo "\t\t</map>\n";

		echo "\t</div>\n";

	}

	$queryHallwaySprites = $db->prepare('SELECT name, src FROM sprites WHERE parentid = ? AND NOT inroom ORDER BY zorder ASC;');
	$queryHallwaySprites->execute(array($floor));

	foreach($queryHallwaySprites as $hallwaySprite){
		echo "\t<img src='sprites/{$hallwaySprite['src']}' id='floor$floor-{$hallwaySprite['name']}' class='sprite' />\n";
	}

	echo "\t<img src='gfx/transparent.png' class='transparent' usemap='#floor$floor-imagemap' />\n";

	echo "\t<map name='floor$floor-imagemap' />\n";

	$queryActiveHallwaySprites = $db->prepare('SELECT name, title, hotspots, x, y FROM ActiveSprites WHERE parentid = ? AND NOT inroom ORDER BY zorder DESC;');
	$queryActiveHallwaySprites->execute(array($floor));

	foreach($queryActiveHallwaySprites as $activeHallwaySprite){
		$hotspot = offsetHotspot($activeHallwaySprite['hotspots'], $activeHallwaySprite['x'], $activeHallwaySprite['y']);
		echo "\t\t<area coords='$hotspot' shape='poly' onclick=\"return activeClick('floor$floor-{$activeHallwaySprite['title']}')\" href='#' alt='' />\n";
	}

	$queryRoomHotspots = $db->prepare('SELECT id, x, y, floor, hotspots FROM Rooms WHERE floor = ? ORDER BY zorder DESC;');
	$queryRoomHotspots->execute(array($floor));

	foreach($queryRoomHotspots as $queryRoomHotspot){
		$hotspot = offsetHotspot($queryRoomHotspot['hotspots'], $queryRoomHotspot['x'], $queryRoomHotspot['y']);
		echo "\t\t<area coords='$hotspot' shape='poly' onclick=\"Scrollback.add.bind(Scrollback)('go room {$queryRoomHotspot['id']}');RoomManager.enterRoom.bind(RoomManager)('{$queryRoomHotspot['id']}');return false;\" href='#' alt='' />\n";
	}

	echo "\t</map>\n";

	echo "\t<div class='floor_dimexit' style='display: none'></div>\n"; //style defined here so Prototype can change this value

	echo "\t<div class='floor_foreground'></div>\n";

	echo "</div>\n";

}


/**
 * Given an array of coordinates (x1,y1,x2,y2,...) for a hotspot, shift the hotspot by a given amount
 * @param string $hotspotString
 * @param int $x Add this amount to x values
 * @param int $y Add this amount to y values
 * @return string
 */
function offsetHotspot($hotspotString, $x, $y){
	$hotspotString = trim($hotspotString, '{}');
	if(empty($hotspotString)){
		return '';
	}
	$array = explode(',', $hotspotString);
	$result = array();
	for($i=0; $i<count($array); $i++){
		if($i%2 == 0){ //even
			$result[] = $array[$i] + $x;
		} else { //odd
			$result[] = $array[$i] + $y;
		}
	}
	$result = implode(',', $result);
	return $result;
}


?>