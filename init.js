document.observe('dom:loaded', domLoaded);
Event.observe(window, 'load', windowLoaded);

function domLoaded(){

	/*
	 * Set up text box listener
	 */

	$('prompt').observe('keypress', handlePrompt).focus();

	/*
	 * Set up money counter
	 */ 
	
	setMoney(21);
 
	/*
	 * Set up floor chooser
	 */
	var floorchooser = $('floorchooser');
	floorNumbers.each(function(floorno){
		var activeString = RoomManager.currentFloor == floorno ? '_active' : '';
		var buttonID = 'floorchooser-'+floorno;
		floorchooser.insert('<a href="#" id="'+buttonID+'" class="floor"><img src="gfx/floorchooser-'+floorno+activeString+'.png" alt="" /></a>');
		var buttonObj = $(buttonID);
		buttonObj.store('floorno', floorno);
		buttonObj.onclick = function(){
			var floorno = this.retrieve('floorno');
			Scrollback.add.bind(Scrollback)('floor '+floorno);
			RoomManager.changeFloor.bind(RoomManager)(floorno);
			return false;
		};
	});

	/**
	 * Set up floors
	 */

	$('middle').childElements().filter(function(el){
		return el.id != 'floor'+RoomManager.currentFloor;
	}).invoke('hide');


	/**
	 * Set up Noticer
	 */

	Noticer.init();
	Scrollback.init();

	/*
	 * Define custom effects transition functions
	 */

	Effect.Transitions.fi = function(pos){
		if(pos<1 && pos>0){
			return 1-(1/Math.pow(pos+1, 9));
		} else if(pos==0){
			return 0;
		} else {
			return 1;
		}
	}

	Effect.Transitions.reversefi = function(pos){
		if(pos<1 && pos>0){
			return -(1/Math.pow(-pos-1, 9));
		} else if(pos==0){
			return 1;
		} else {
			return 0;
		}
	}
}

function windowLoaded(){

	$('middle').show();

	//flags.achievements['patience'].increment.bind(flags.achievements['patience']).delay(2);
}


//this variable will be set to the contents of localization.json by all.js.php
var localization = 