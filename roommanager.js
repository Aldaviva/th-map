var RoomManager = {

	currentRoom: null, //in a hallway
	currentFloor: 2,
	isRoomFocused: false,
	busy: false,

	enterRoom: function(target){
		var scrollDuration = 0.25;
		var scrollX, scrollY, roomPos, roomDiv;

		if(this.busy) return;
		this.busy = true;
		if(!this._isValidRoomNo(target)){
			notice(localize('room404', target));
		} else if(this.currentRoom == target){
			notice(localize('roomsame'));
		} else if(this._getFloorFromRoomNo(target) != this.currentFloor){
			notice(localize('floorDifferent', target));
		} else if(rooms[target].locked){
			notice(localize('roomLocked', target));
			setPaneContent('GO', 'Room '+target, rooms[target].description, rooms[target].largesrc);

			roomDiv = $('room'+target);
			roomPos = roomDiv.cumulativeOffset();
			scrollX = (roomPos[0] + (roomDiv.getWidth() - document.viewport.getWidth())/2).round();
			scrollY = (roomPos[1] + (roomDiv.getHeight() - document.body.clientHeight)/2).round();
			scrollTo(scrollX, scrollY);

		} else {
			this.currentRoom = target;
			this._toggleRoomToForeground(target);
			
			roomDiv = $('room'+this.currentRoom);

//			Effect.ScrollTo('room'+this.currentRoom, {duration: scrollDuration});
			roomPos = roomDiv.cumulativeOffset();
			scrollX = (roomPos[0] + roomDiv.getWidth()/2 - (document.viewport.getWidth() - $('pane').getWidth())/2).round();
			scrollY = (roomPos[1] + roomDiv.getHeight()/2 - document.body.clientHeight/2).round();
			scrollTo(scrollX, scrollY);
			

			var dimexit = $('floor'+this.currentFloor).down('.floor_dimexit');
			dimexit.appear({transition: Effect.Transitions.fi, delay: scrollDuration});

			$('floorchooser').fade({transition: Effect.Transitions.fi, delay: scrollDuration});

			var frontWall = $('room'+this.currentRoom+'-frontwall');
			if(frontWall != null){
				frontWall.fade({transition: Effect.Transitions.fi, delay: scrollDuration});
			}
			
			notice(localize('roomEnter', target));

			//this.lookAtRoom.bind(this)('Go');
			if(behaviors['room'+this.currentRoom] && behaviors['room'+this.currentRoom]._enter){
				behaviors['room'+this.currentRoom]._enter();
			} else {
				this.lookAtRoom.bind(this)('Go');
			}
			
		}
		(function(){this.busy = false;}).bind(this).delay(1);
	},

	leaveRoom: function(){
		if(this.busy) return;
		this.busy = true;
		if(this.currentRoom != null){
			notice(localize('roomLeave', this.currentRoom));

			var dimexit = $('floor'+this.currentFloor).down('.floor_dimexit');
			dimexit.fade({transition: Effect.Transitions.fi});

			var frontWall = $('room'+this.currentRoom+'-frontwall');
			if(frontWall != null){
				frontWall.appear({transition: Effect.Transitions.fi});
			}

			$('floorchooser').appear({transition: Effect.Transitions.fi});

			this._toggleRoomToForeground.bind(this, this.currentRoom).delay(0.5);
			if(behaviors['room'+this.currentRoom] && behaviors['room'+this.currentRoom]._leave){
				behaviors['room'+this.currentRoom]._leave();
				this.currentRoom = null;

			} else {
				this.currentRoom = null;
				this.lookAtRoom.bind(this)('Go');
			}

		}
		(function(){this.busy = false;}).bind(this).delay(1);
	},

	changeFloor: function(target){
		if(!this._isValidFloorNo(target)){
			notice(localize('floor404', target));
		} else if(target == this.currentFloor){
			notice(localize('floorSame', target));
		} else {
			var oldFloor = this.currentFloor;

			this.currentFloor = target;

			new Effect.Fade('floor'+oldFloor, {
				duration: 2,
				transition: Effect.Transitions.fi
			});

			new Effect.Appear('floor'+this.currentFloor, {
				duration: 0.75,
				delay: 1,
				transition: Effect.Transitions.fi
			});


			this._updateFloorChooser.bind(this)();

			notice(localize('floorEnter', target));

			this.lookAtRoom.bind(this)('Go');
		}
	},

	lookAtRoom: function(mode){
		if(typeof mode == 'undefined'){
			mode = 'Look';
		}
		var description;
		if(this.currentRoom != null){
			description = rooms[this.currentRoom].description + "<br />";
			if(rooms[this.currentRoom].activesprites)
			description += localize('look', Object.keys(rooms[this.currentRoom].activesprites).sentenceJoin(", "));
			setPaneContent(mode, 'Room '+this.currentRoom, description, rooms[this.currentRoom].largesrc);
//			setPaneContent('Look', 'Room '+this.currentRoom, localize('look', Object.keys(rooms[this.currentRoom].activesprites).join(", ")), '');
		} else {
			//you are in a hallway. you see doors to rooms 1, 2, 3, ...
			//you see objects in the hallway foo, bar, ...
			description = floors[this.currentFloor].description + "<br />";
			description += localize('look', Object.keys(floors[this.currentFloor].activesprites).sentenceJoin(", "));
			description += localize('lookFloor', floors[this.currentFloor].rooms.sentenceJoin(", "));
			setPaneContent(mode, 'Floor '+this.currentFloor, description, floors[this.currentFloor].largesrc);
		}
	},

	lookAtObject: function(objName, mode){
		if(typeof mode == 'undefined'){
			mode = 'Look';
		}
		if(this.currentRoom != null){
			if(rooms[this.currentRoom] && rooms[this.currentRoom].activesprites[objName]){
				var description = rooms[this.currentRoom].activesprites[objName].description;
				if(behaviors['room'+this.currentRoom].interactions && behaviors['room'+this.currentRoom].interactions[objName.toLowerCase()]){
					$H(behaviors['room'+this.currentRoom].interactions[objName.toLowerCase()]).each(function(pair){
						description += "<br /><a href='#' onclick='behaviors[\"room"+this.currentRoom+"\"][\""+pair.value+"\"](); return false;'>"+pair.key+"</a>";
					}, this);
				}
				setPaneContent(
					mode,
					objName,
					description,
					rooms[this.currentRoom].activesprites[objName].largesrc
				);
			} else {
				notice(localize('item404', objName));
			}
		} else {
			if(floors[this.currentFloor].activesprites[objName]){
				setPaneContent(
					mode,
					objName,
					floors[this.currentFloor].activesprites[objName].description,
					floors[this.currentFloor].activesprites[objName].largesrc
				);
			} else {
				notice(localize('item404', objName));
			}
			//TODO if object has a description, show it
		}
	},

	useOrLookAtObject: function(objName){
		if(this.currentRoom != null){
			if(behaviors['room'+this.currentRoom][objName]){
				behaviors['room'+this.currentRoom][objName]();
			} else {
				this.lookAtObject(objName);
			}
		} else {
			if(behaviors['floor'+this.currentFloor][objName]){
				behaviors['floor'+this.currentFloor][objName]();
			} else {
				this.lookAtObject(objName);
			}
			//TODO: if hallway sprite has a behavior, run it.
			// otherwise, show its description
		}
	},

	_updateFloorChooser: function(){
		$('floorchooser').select('.floor').each(function(el){
			var floorno = el.retrieve('floorno');
			var src = 'gfx/floorchooser-'+floorno;
			if(this.currentFloor == floorno){
				src += '_active.png';
			} else {
				src += '.png';
			}
			el.down('img').setAttribute('src', src);
		}, this);
	},

	_getFloorFromRoomNo: function(roomno){
		return rooms[roomno].floor;
	},
	
	_isValidRoomNo: function(roomno){
		return Object.keys(rooms).include(roomno);
	},

	_isValidFloorNo: function(floorno){
		return floorNumbers.include(floorno);
	},

	_toggleRoomToForeground: function(roomno){
		var id = 'room'+roomno;
		var myroom;

		if(this.isRoomFocused){
			myroom = $(id).remove();
			$('placeholder').replace(myroom);

		} else {
			var placeholder = new Element('div', {id: 'placeholder'});
			var container = $(id).next('.floor_foreground');
			myroom = $(id).replace(placeholder);
			container.insert({bottom: myroom});
		}
		this.isRoomFocused = !this.isRoomFocused;
	},

	_disappearObject: function(objName){
		//TODO: incomplete
		if(this.currentRoom != null){

		} else {

		}
	}

}