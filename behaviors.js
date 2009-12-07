var behaviors = { //the ids here are the titles, not names, of objects
	/*'room998': {
		'JACUZZI': function(){
			notice('You clicked a pool');
		},
		'EGG CHAIR': function(){
			flags.achievements['eggchair'].increment();
		},
		'AUTOMATIC SLIDING DOORS': function(){
			RoomManager.leaveRoom.bind(RoomManager)();
		}
	},
	'room999': {
		//no behaviors defined for this room yet
	},
	'floor9': {
		'BAR': function(){
			notice('Hallway sprite is working.');
		}
	},*/
	'floor2': {
		'WHITEDOOR': function(){
			RoomManager.lookAtObject.bind(RoomManager)('WHITEDOOR');
			flags.achievements['whitedoor'].increment.bind(flags.achievements['whitedoor'])();
		}
	},
	'room206A': {
		/*'ABBIE': function(){
			/if(!flags.achievements['allaccess'].isAchieved()){
				setPaneContent('talk', 'Abbie', "Hi, I'm ABBIE. I'm the president of TECH HOUSE.<br />You want a 101 KEY? Sure, it'll just cost a $20 deposit. Here you go!", '');
				setMoney(getMoney() - 20);
				flags.achievements['allaccess'].increment.bind(flags.achievements['allaccess']).delay(2);
			} else {
				setPaneContent('talk', 'Abbie', "Enjoy your visit to TECH HOUSE!", '');
			}
		},*/
		'DOOR': function(){
			RoomManager.leaveRoom.bind(RoomManager)();
		}/*,
		'_leave': function(){
			setPaneContent('go', 'Leave', "As you step out of Abbie's room at "+(new Date())+", you shut the door behind you.", '');
		}*/
	},
	'room206B': {
		'RED PORTAL': function(){
			RoomManager.leaveRoom.bind(RoomManager)();
		},
		'_enter': function(){
			flags.achievements['portals'].increment.bind(flags.achievements['portals']).delay(1);
			//get the portal achievement
		},
		'_leave': function(){
			flags.achievements['portals'].increment.bind(flags.achievements['portals']).delay(1);
		},
		'MICROWAVE': function(){
			if(!flags.achievements['microwave'].isAchieved.bind(flags.achievements['microwave'])()){
				setPaneContent('USE', 'Microwave', "When you stick a light bulb in the microwave, it glows brighter than anything you've ever seen, brighter than the sun! Duck, and cover! Luckily, you shut if off before thirty seconds are up, so the lightbulb doesn't detonate.", 'microwave_lightbulb.jpg');
				flags.achievements['microwave'].increment.bind(flags.achievements['microwave'])();
			} else {
				setPaneContent('USE', 'Microwave', 'It seems to be a bit scorched. Wonder why that is...', 'microwave.jpg');
			}
		}
	},
	'room207': {
		'DOOR': function(){
			RoomManager.leaveRoom.bind(RoomManager)();
		}
	},
	'room209': {
		'DOOR': function(){
			RoomManager.leaveRoom.bind(RoomManager)();
		}
	},
	'room210': {
		'DOOR': function(){
			RoomManager.leaveRoom.bind(RoomManager)();
		}
	},
	'room211': {
		'DOOR': function(){
			RoomManager.leaveRoom.bind(RoomManager)();
		}
	},
	'room214': {
		'DOOR': function(){
			RoomManager.leaveRoom.bind(RoomManager)();
		}
	},
	/*'room101': {
		'DOOR': function(){
			RoomManager.leaveRoom.bind(RoomManager)();
		},
		'_enter': function(){
			setPaneContent('go', 'Room', 'You entered the lounge at '+(new Date())+" o'clock.", '');
		}
	},*/
	'stareAtKenny': function(){
		if(flags.achievements['stare'].isAchieved.bind(flags.achievements['stare'])()){
			notice('You have already lost the staring contest. No rematches.');
		} else {
			setPaneContent('STARE', 'STAREDOWN SLAUGHTER', 'You notice that Kenny has locked your eyes in his intense gaze. You decide to give him a taste of his own medicine, so you lay on the ogle. This only serves to raise the stakes, and Kenny\'s eyeballs nearly bulge out of his face as he drills his stare into you. Your stomach twists, and you get the feeling that he is in fact examining your very soul. This though makes you blink, leaving Kenny the victor.', '');
			flags.achievements['stare'].increment.bind(flags.achievements['stare']).delay(2);
		}
		return false;
	}
};

function activeClick(identifier){
	var split = identifier.split('-', 2);
	var parentid = split[0];
	var activeSpriteName = split[1].toUpperCase();

	var verb;
	if(behaviors[parentid] && typeof behaviors[parentid][activeSpriteName] == 'function'){
		verb = 'use';
	} else {
		verb = 'look';
	}
	
	Scrollback.add.bind(Scrollback)(verb + " " + activeSpriteName, true);

	RoomManager.useOrLookAtObject.bind(RoomManager)(activeSpriteName);

	return false;

}

function handlePrompt(event){

	try {
		var element = event.findElement();

		if(event.keyCode == Event.KEY_RETURN){
			
			if(element.present()){
				var sentence = element.getValue().strip().toLowerCase();
				var firstWord = sentence.match(/\w+/)[0];
				var otherWords = sentence.substr(firstWord.length+1).strip().toUpperCase();


				var currentRoom = RoomManager.currentRoom;

				if(sentence == 'showmethemoney'){
					setMoney(65535);
					notice.defer('Cheat Enabled');

				} else if(firstWord == 'use'){
					RoomManager.useOrLookAtObject.bind(RoomManager).defer(otherWords);

				} else if(firstWord == 'look' && otherWords){
					RoomManager.lookAtObject.bind(RoomManager).defer(otherWords);

				} else if(sentence == 'look'){
					RoomManager.lookAtRoom.bind(RoomManager).defer();

				} else if(currentRoom != null){
					if(sentence == 'leave'){
						RoomManager.leaveRoom.bind(RoomManager).defer();

					} else {
						throw "Unknown command.";
					}
				} else { 
					if(firstWord == 'enter' || firstWord == 'go'){
						var personName = otherWords.match(/(.+?)'s room/i);
						var room;
						if(null != personName){
							room = people[personName[1]];
						} else {
							room = otherWords.replace(/(ROOM\W+)?/i,'');
						}
						RoomManager.enterRoom.bind(RoomManager).defer(room);

					} else if(firstWord == 'floor'){
						RoomManager.changeFloor.bind(RoomManager).defer(otherWords);

					} else {
						throw "Unknown command.";
					}
				}

				Scrollback.add(sentence, true);
				element.clear();
				
			}

		} else if(event.keyCode == Event.KEY_UP){
			element.setValue(Scrollback.getLastUserCmd.bind(Scrollback)(1));
		} else if(event.keyCode == Event.KEY_DOWN){
			element.setValue(Scrollback.getLastUserCmd.bind(Scrollback)(-1));
		}

		//make typing sound! :)

	} catch(exception){
		notice(exception, true);
		element.clear();
	}

	
}

function setPaneContent(mode, title, description, img){
	$$('#pane .top .content')[0].update(mode);

	var parent = $$('#pane .middle .content')[0];

	parent.down('h1').update(title);

	if(img){
		parent.down('img.photo').show().setAttribute('src', 'photos/'+img);
	} else {
		parent.down('img.photo').hide();
	}

	parent.down('.description').update(description);
}

var money = 0;
function setMoney(dollars){
	$('money').update(new Number(dollars));
	money = dollars;
}

function getMoney(){
	return money;
}