<?php

if(!isset($db)){
	try {
		$db = new PDO('pgsql:', 'map', '!map!');
	} catch (PDOException $e) {
		die("Could not connect to database");
	}
}

return $db;


?>
