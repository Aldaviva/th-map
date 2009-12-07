/*function notice(str){
	if(opera){
		opera.postError(str);
	} else {
		alert(str);
	}
}*/

function localize(id){
	var arguments = Array.prototype.slice.call(arguments);
	var str = localization[id] || "** Missing string **";
	var requiredSlots = 0;
	str.scan('_', function(){requiredSlots++;});
	if(arguments.length - 1 != requiredSlots){
		return "** Bad string **";
	}

	arguments.slice(1).each(function(x){
		str = str.sub('_', x);
	});
	return str;
}

Array.prototype.sentenceJoin = function(delim){
	if(this.length == 0){
		return '';
	} else if(this.length == 1){
		return this[0];
	} else if(this.length == 2){
		return this[0]+" and "+this[1];
	} else {
		return this.slice(0,-1).join(delim)+", and "+this[this.length-1];
	}
}