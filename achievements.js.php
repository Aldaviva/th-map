<?php
header('Content-type: text/javascript');
require_once 'library.php';

$db = require 'db.php';

$results = $db->query('SELECT * FROM Achievements;', PDO::FETCH_OBJ);

$output = array();

while($result = $results->fetch()){
	$output[] = '"'.$result->id.'": new Achievement('.json_encode($result).')';
}

echo 'flags.achievements= {'.implode(",\n", $output).'};';

?>

function Achievement(args) {
	this.id = args.id;
	this.name = args.name;
	this.maxProgress = args.maxprogress;

	var progress = 0;
	var haveSeenSuccessMessage = false;

	this.increment = function(){

		if(!this.isAchieved()){
			progress++;
		}
		if(this.isAchieved() && !haveSeenSuccessMessage){
			this.notify('Achievement unlocked', '');
			haveSeenSuccessMessage = true;
		} else if(!this.isAchieved()) {
			this.notify('Making progress', progress+'/'+this.maxProgress);
		}
	}

	this.isAchieved = function(){
		return progress == this.maxProgress;
	}

	this.notify = function(leftmessage, rightmessage){
		Notifier.notify({
			title: this.name,
			leftmessage: leftmessage,
			rightmessage: rightmessage,
			icon: 'sprites/achievements/'+this.id+'.svg'
		});
	}
}