<?php

header('Content-type: text/javascript');

$errors = array();
ini_set('display_errors', false);

$filenames = array(
	'library.js'
	,'console.js'
	,'flags.js'
	,'achievements.js.php'
	,'behaviors.js'
	,'objects.js.php'
	,'roommanager.js'
	,'init.js'
	,'localization.json'
);

echo "// This is a combination of ".implode(', ', $filenames)." generated at ".time()."\n";

foreach($filenames as $filename){
	echo
"


/**
 * $filename
 */

";

	if(!include($filename)){
		$errors[] = $filename;
	}
}

if(!empty($errors)){
	echo "\n\nalert(\"Javascript files not found:\\n".implode('\n', array_map('addslashes', $errors))."\");";
}

restore_error_handler();

?>
