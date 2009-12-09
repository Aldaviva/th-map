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
		interactions: {
			abbie: {'Can I have a 101 key, please?': 'getKey'}
		},
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
		},
		'getKey': function(){
			if(!flags.achievements['allaccess'].isAchieved()){
				setPaneContent('talk', 'Abbie', "Hi, I'm ABBIE. I'm the president of TECH HOUSE.<br />You want a 101 KEY? Sure, it'll just cost a $20 deposit. Here you go!", '');
				setMoney(getMoney() - 20);
				flags.achievements['allaccess'].increment.bind(flags.achievements['allaccess']).delay(2);
			} else {
				setPaneContent('talk', 'Abbie', "Enjoy your visit to TECH HOUSE!", '');
			}
		}/*,
		}
		'_leave': function(){
			setPaneContent('go', 'Leave', "As you step out of Abbie's room at "+(new Date())+", you shut the door behind you.", '');
		}*/
	},
	'room206B': {
		interactions: {
			microwave: {'Stick LIGHTBULB in MICROWAVE and set to 30 SECONDS.': 'usemicrowave'}
		},
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
		'usemicrowave': function(){
			if(!flags.achievements['microwave'].isAchieved.bind(flags.achievements['microwave'])()){
				setPaneContent('USE', 'Microwave', "When you stick a light bulb in the microwave, it glows brighter than anything you've ever seen, brighter than the sun! Duck, and cover! Luckily, you shut if off before thirty seconds are up, so the lightbulb doesn't detonate.", 'microwave_lightbulb.jpg');
				flags.achievements['microwave'].increment.bind(flags.achievements['microwave'])();
			} else {
				//setPaneContent('LOOK', 'Microwave', rooms['206B'].activesprites['MICROWAVE'].description, 'microwave.jpg');
				notice('You already wasted one of her LIGHTBULBS.');
				RoomManager.lookAtObject.bind(RoomManager)('MICROWAVE', 'LOOK');
			}
		}
	},
	'room207': {
		interactions: {
			nathan: {'I challenge you to a duel!': 'duel'}
		},
		'DOOR': function(){
			RoomManager.leaveRoom.bind(RoomManager)();
		},
		'duel': function(){
			if(!flags.achievements['duel'].isAchieved.bind(flags.achievements['duel'])()){
				setPaneContent('DUEL', 'Nerf Gun Duel of Honor', "The sun rises over the barren, gritty wasteland of HARKNESS 207 to find two pistoleros locked in a DUEL OF HONOR. GUNSLINGER NATHAN shifts his weight and pulls his battered fedora low over his cunning, bloodshot eyes. You dig your boots into the hard-packed dirt and spit out the cactus meat you were chewing. The VULTURES circle.<br /> Your arm tenses. You can do this. Your whole life lead up to this moment. The decision is made. You go for your trusty NERF GUN.<br /> You see movement, then your vision is filled with hot white. As your sight returns to you, you see that an orange nerf dart is stuck to your CHEAP PLASTIC SHERIFF'S STAR. As it stops wobbling, you notice that someone wrote your name on the dart shaft with a SHARPIE. NATHAN returns his modified NERF MAVERICK SIX-SHOOTER to his holster and pulls his fedora even farther down over his eyes.<br /> \"I like you, kid. Maybe one day, you'll be somebody.\"", '');
				flags.achievements['duel'].increment.bind(flags.achievements['duel']).delay(4);
			} else {
				RoomManager.lookAtObject.bind(RoomManager)('TV', 'LOOK');
			}
		}
	},
	'room209': {
		interactions: {
			robert: {
				'I\'m really excited to be using Gmail instead of Brown Exchange!': 'facepalm',
				'I\'m thinking about trying to learn C. What\'s the best compiler money can buy?': 'facepalm',
				'Whoops, I actually meant to visit JON\'S ROOM. Sorry to bother you.': 'facepalm',
				'What\'s all this about magical girls?': 'facepalm',
				'This game is terrible, Robert.': 'facepalm'
			}
		},
		'DOOR': function(){
			RoomManager.leaveRoom.bind(RoomManager)();
		},
		'facepalm': function(){
			flags.achievements['facepalm'].increment.bind(flags.achievements['facepalm']).delay(2);
			setPaneContent('TALK', 'Robert', "Robert hangs his head, ashamed for you.", 'robert_facepalm.jpg');
		}
	},
	'room210': {
		'DOOR': function(){
			RoomManager.leaveRoom.bind(RoomManager)();
		}
	},
	'room211': {
		interactions: {
			'jon': {'Play Team Fortress 2': 'tf2'}
		},
		'DOOR': function(){
			RoomManager.leaveRoom.bind(RoomManager)();
		},
		'tf2': function(){
			if(!flags.achievements['tf2'].isAchieved.bind(flags.achievements['tf2'])()){
				setPaneContent('USE', 'Team Fortress 2', "Jon offers to let you play Team Fortress 2. You sit down at his computer and begin playing on a server. You're not quite sure how this works, but you seem to be in the enemy's base, killing their dudes. Some of these guys are on fire, and others are large angry Russian men, screaming at the top of their lungs about sandwiches as they run around punching everything with oversized boxing gloves. Soon, the angry Russians have punched out all of your blood. When you die, you hear a fanfare, signaling that an Achievement has been Unlocked.", '');
				flags.achievements['tf2'].increment.bind(flags.achievements['tf2']).delay(2);
			} else {
				notice("That's enough TF2 for one day.");
			}
		}
	},
	'room214': {
		interactions: {
			kenny: {'Stare him down': 'stare'}
		},
		'DOOR': function(){
			RoomManager.leaveRoom.bind(RoomManager)();
		},
		'TV': function(){
			if(!flags.achievements['topgear'].isAchieved.bind(flags.achievements['topgear'])()){
				setPaneContent('USE', 'Watch Top Gear', "You sit down and watch and episode of TOP GEAR.<br />TDH2 is a vessel that delivers Top Gear episodes to Tech House members. Sit a spell and partake in the cutting edge of cocking about. Cheer as the Renault Robin Space Shuttle plunges into the English countryside. Revel as TDH2's SOUND SYSTEM blasts the sweet cry of twelve roaring cylinders into your eardrums. Snicker as James May, Richard Hammond, and Jeremy Clarkson try to construct stretch limousines but end up make fools of themselves.", 'tv.jpg');
				flags.achievements['topgear'].increment.bind(flags.achievements['topgear']).delay(4);
			} else {
				RoomManager.lookAtObject.bind(RoomManager)('TV', 'LOOK');
			}
		},
		'stare': function(){
			if(flags.achievements['stare'].isAchieved.bind(flags.achievements['stare'])()){
				notice('You have already lost the staring contest. No rematches.');
			} else {
				setPaneContent('STARE', 'STAREDOWN SLAUGHTER', 'You notice that Kenny has locked your eyes in his intense gaze. You decide to give him a taste of his own medicine, so you lay on the ogle. This only serves to raise the stakes, and Kenny\'s eyeballs nearly bulge out of his face as he drills his stare into you. Your stomach twists, and you get the feeling that he is in fact examining your very soul. This though makes you blink, leaving Kenny the victor.', '');
				flags.achievements['stare'].increment.bind(flags.achievements['stare']).delay(2);
			}
		}
	}
	/*'room101': {
		'DOOR': function(){
			RoomManager.leaveRoom.bind(RoomManager)();
		},
		'_enter': function(){
			setPaneContent('go', 'Room', 'You entered the lounge at '+(new Date())+" o'clock.", '');
		}
	},*/
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

	parent.down('.description').update('');
	description = "<p>"+description.gsub("<br />", "</p><p>")+"</p>";
	Element.update.defer(parent.down('.description'), description);
}

var money = 0;
function setMoney(dollars){
	$('money').update(new Number(dollars));
	money = dollars;
}

function getMoney(){
	return money;
}