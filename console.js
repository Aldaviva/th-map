var Noticer = {

	noticerEl: null,

	timeToShow: 4, //seconds

	currentEffect: null,

	vanishTimer: null,

	noticeDone: function(){
		if(this.currentEffect == null){
			this.currentEffect = new Effect.Fade(this.noticerEl, {
				transition: Effect.Transitions.fi,
				duration: 2,
				afterFinish: (function(){
					this.currentEffect = null;
					}).bind(this)
			});
		}
		
	},

	notice: function(str, isError){

		if(!isError){
			Scrollback.add(str, false);
		}

		if(this.currentEffect != null){
			this.currentEffect.cancel();
			this.currentEffect = null;
		}

		if(this.vanishTimer != null){
			window.clearTimeout(this.vanishTimer);
			this.vanishTimer = null;
		}

		this._setText(str);
		
		this.currentEffect = new Effect.Appear(this.noticerEl, {
			transition: Effect.Transitions.fi,
			duration: 0.5,
			afterFinish: (function(){
				this.currentEffect = null;
				this.vanishTimer = this.noticeDone.bind(this).delay(this.timeToShow);
				}).bind(this)
		});
		
	},

	init: function(){
		this.noticerEl = $('noticer');
		
		this.noticerEl.hide();
		this.noticerEl.observe('click', Noticer.noticeDone.bind(this));
	},

	_setText: function(str){
		this.noticerEl.down('.content').update(str);
	}

}

var Scrollback = {

	scrollbackArray: new Array(),

	displayLimit: 6,
	
	scrollback: null,

	nthLast: 0,

	init: function(){
		this.scrollback = $('scrollback');
		$$('.bottom')[0].observe('click', function(){
			$('prompt').focus();
		});
	},

	add: function(str, isUserCmd){
		if(typeof isUserCmd == 'undefined'){
			isUserCmd = true;
		}
		this.scrollbackArray.push({str: str, isUserCmd: isUserCmd});
		this._updateScrollback();
		this.nthLast = 0;
	},

	getLastUserCmd: function(nthLastOffset){
		this.nthLast += nthLastOffset;
		if(this.nthLast < 1){
			this.nthLast = 0;
			return '';
		}
		
		var tempNthLast = this.nthLast;
		for(var i=this.scrollbackArray.length-1; i >= 0; i--){
			var item = this.scrollbackArray[i];
			//alert('item = scrollbackArray['+i+'] = '+item.str);
			if(item.isUserCmd){
				if(tempNthLast == 1){
					return item.str;
				} else {
					tempNthLast--;
				}
			}
		}
		return this.getLastUserCmd(-1);
	},

	_updateScrollback: function(){

		this.scrollback.childElements().invoke('remove');

//		var maxHeight = (new Number(this.scrollback.getStyle('max-height').sub('px', '')) + 8 - 1); // oh god hax 8 is the padding
		var maxHeight = 97;

		var content;
		var itemsWritten = 0;
		var length = this.scrollbackArray.length;
		while(itemsWritten < length){
//		while(itemsWritten < this.displayLimit && itemsWritten < length){

			var item = this.scrollbackArray[length-itemsWritten-1];

			content = new Element('div');

			if(item.isUserCmd){
				content.addClassName('userCmd');
				content.update("» "+item.str);
			} else {
				content.addClassName('systemResponse');
				content.update(item.str);
			}

			this.scrollback.insert({top: content});

			if(this.scrollback.getHeight() > maxHeight){
				//opera.postError('pruning since '+this.scrollback.getHeight() + ' > '+maxHeight);
				this.scrollback.down().remove();
				return;
			} else {
				//opera.postError('not pruning: '+this.scrollback.getHeight() + ' <= '+maxHeight);
			}

			itemsWritten++;

		}

	}


};

function notice(str, isError){
	if(typeof isError == 'undefined'){
		isError = false;
	}
	Noticer.notice.bind(Noticer)(str, isError);
}