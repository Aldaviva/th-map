<?php

function getDBObject($query, $keyname, $grouping = null){

	$db = require 'db.php';

	$object = array();

	$results = $db->query($query, PDO::FETCH_OBJ);

	if(is_null($grouping)){
		while($result = $results->fetch()){
			if(!isset($object[$result->$keyname])){
				$object[$result->$keyname] = $result;
			} else if(is_object($object[$result->$keyname])){
				$object[$result->$keyname] = array($object[$result->$keyname], $result);
			} else if(is_array($object[$result->$keyname])) {
				$object[$result->$keyname][] = $result;
			}
		}
	} else {
		while($result = $results->fetch()){
			$object[$result->$grouping][$keyname] = $result;
		}
	}

	return json_encode($object);

}

$localize = json_decode(file_get_contents('localization.json'));

?>
