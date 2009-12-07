var flags = {
	testFlag: false,
	have101key: false
}

var Notifier = {
	queue: new Array(),
	isNotifying: false,
	timeToShow: 5,
	timeToFadeIn: 1,
	timeToFadeOut: 1,
	timeWhenBlank: 1,

	/**
	 * notifyParams: object with keys title, leftmessage, rightmessage, icon (relative to site root)
	 */
	notify: function(notifyParams){
		this.queue.push(notifyParams);
		if(!this.isNotifying){
			this.showNext();
		}
	},

	showNext: function(){
		if(this.queue.length == 0){
			this.isNotifying = false;
		} else {
			this.isNotifying = true;
			var notifyParams = this.queue.shift();

			var notifier = $('notifier');
			notifier.down('h1').update(notifyParams.title);
			notifier.down('.subtext1').update(notifyParams.leftmessage);
			notifier.down('.subtext2').update(notifyParams.rightmessage);
			//notifier.down('object').replace('<object data="'+notifyParams.icon+'" type="image/svg+xml"></object>');

			new Effect.Morph('notifier', {
				style: {
					height: '123px'
				},
				duration: this.timeToFadeIn,
				transition: Effect.Transitions.fi
			});

			//Don't touch this
			//There be dragons
			((function(){
				new Effect.Morph('notifier', {
					style: {
						height: '0px'
					},
					delay: this.timeToFadeIn+this.timeToShow, //.5 to fade in, 5 to stay
					duration: this.timeToFadeOut, //.5 to fade out
					transition: Effect.Transitions.fi
				});
				this.showNext.bind(this).delay(this.timeToFadeIn+this.timeToShow+this.timeToFadeOut+this.timeWhenBlank);
			}).bind(this))();
		}
	}
};

