<?php
	header('Content-type: text/css');

	$db = require 'db.php';

	$sprites = $db->query('SELECT parentid, name, x, y, inroom FROM Sprites;');

	foreach($sprites as $sprite){
		$prefix = ($sprite['inroom']) ? "room" : "floor";
		echo
"#$prefix{$sprite['parentid']}-{$sprite['name']} {
	margin-left: {$sprite['x']}px;
	margin-top: {$sprite['y']}px;
}\n\n";
	}
?>

.sprite {
	position: absolute;
}