/*  LightAlert, version 1.1.4
 *  (c) 2008 Jason, Liu Cha Shian (json.liu@gmail.com)
 *
 *  LightAlert is freely distributable under the terms of an MIT-style license.
 *  Please refrain from removing this header
 *
/*--------------------------------------------------------------------------*/
var LightAlert = function (obj){
	this.fadetimer = null;
	this.browser = this.getBrowser();
	this.setting = this.setup(obj);
	this.body = parent.document.getElementsByTagName("body")[0];
	this.lightalert = this.createBox();
	this.overlay = {};
	this.init(obj);
}

LightAlert.prototype = {
	init: function(obj){
		THIS = this;
		this.overlay = this.displayOverlay(); //overlay
		this.displayMessage(obj); //box
		this.addEvent(window, "resize", function(){ THIS.getScroll() });
	},

	getBrowser: function(){
		b = navigator.userAgent.toLowerCase();
		if (b.indexOf('opera')!=-1) return 'opera';
		else if (b.indexOf('msie 7')!=-1) return 'ie7';
		else if (b.indexOf('msie')!=-1)  return 'ie6';
		else if (b.indexOf('safari')!=-1) return 'safari';
		else if (b.indexOf('gecko')!=-1)  return 'gecko';
	},

	setup: function(pars){
		var obj = {};
		obj.interval = 50;
		obj.show = pars.show || "0";
		obj.fade = pars.fade || "1";
		obj.fadein = 0; // 100 = n
		obj.fadetime = 1000; // half seconds
		obj.fadestep = 25;
		obj.pause = 30000; //pause 5 seconds before fading out
		obj.overlayOpac = 65;
		obj.font =  pars.font || "bold 15px Trebuchet MS";
		obj.position = this.browser == "ie6" ? "absolute" : "fixed";
		obj.bgcolor = pars.bgcolor || "#FFF";
		obj.border = pars.border || "1px solid #CCC";
		obj.icon = pars.icon || "http://i270.photobucket.com/albums/jj85/horiyochi/exclaim.gif";
		obj.w = pars.w || "300";
		obj.padding = "15px 15px 15px 59px";
		obj.bwidth = this.getBrowserWidth();
		return obj;
	},

	createBox: function(){
		box = document.createElement("div");
		box.style.font = this.setting.font;
		box.style.padding = this.setting.padding;
		box.style.width = this.setting.w+"px";
		box.style.left = (this.setting.bwidth - this.setting.w) /2+"px";
		box.style.top = 0;
		box.style.position = this.setting.position;
		box.style.background = this.setting.bgcolor; //+" url("+this.setting.icon+") no-repeat 1em";
		box.style.border = this.setting.border;
		box.onclick = function(){THIS .destroy();}
		if (this.setting.fadein < 100){
			if (this.isIE())
				box.style.filter = "alpha(opacity="+this.setting.fadein+")";
			else
				box.style.opacity= this.setting.fadein / 100;
		}
		return box;
	},

	displayOverlay: function(){
		THIS = this;
		overlay = document.createElement("div");
		overlay.style.position = this.setting.position;
		overlay.style.backgroundColor = "#000";

		if (this.isIE())
			overlay.style.filter = "alpha(opacity="+this.setting.overlayOpac+")";
		else
			overlay.style.opacity= this.setting.overlayOpac/100;

		overlay.style.width = this.setting.bwidth+"px";
		overlay.style.height = this.getBrowserHeight()+"px";
		if (this.browser == "ie6"){
			overlay.style.height = Math.max(document.documentElement.clientHeight,document.body.scrollHeight) + 30;
		}
		overlay.style.left = 0;
		overlay.style.top = 0;
		overlay.onclick = function(){
			THIS.destroy();
		}
		this.body.appendChild(overlay);
		return overlay;
	},

	displayMessage: function(obj){
		var msg;
		if (typeof(obj) == "string")
			msg = obj;
		if (typeof(obj) == "object")
			msg = obj.msg;

		msg = typeof(msg) == "undefined" ? "//Syntax Error: msg is not defined" : msg;

		this.lightalert.innerHTML = msg;
		this.body.appendChild(this.lightalert);
		//realign to middle
		box.style.top = (this.getBrowserHeight() - this.lightalert.clientHeight) / 2 +"px";
		this.fadeIn();
	},

	fadeIn: function(){
		THIS = this;
		if (this.setting.fadein < 100 && this.setting.fade=="1"){
			this.setting.fadein += this.setting.fadestep;
			if (this.isIE()) {
				this.lightalert.style.filter = "alpha(opacity="+this.setting.fadein+")";
			}else{
				this.lightalert.style.opacity=this.setting.fadein/100;
			}
			this.fadetimer = setTimeout(function(){THIS.fadeIn()},this.setting.interval);
		}else{
			if (this.setting.fade=="0"){
				if (this.isIE())
					this.lightalert.style.filter = 100;
				else
					this.lightalert.style.opacity=1;
			}
			clearTimeout(this.fadetimer);
			if (this.setting.show == "0")
				setTimeout(function(){THIS.fadeOut()},this.setting.pause);
		}
	},

	fadeOut: function(){
		THIS = this;
		if (this.setting.fadein > 0 && this.setting.fade=="1"){
			this.setting.fadein -= this.setting.fadestep;
			if (this.isIE()) {
				this.lightalert.style.filter = "alpha(opacity="+this.setting.fadein+")";
			}else{
				this.lightalert.style.opacity=this.setting.fadein/100;
			}
			this.fadetimer = setTimeout(function(){THIS.fadeOut()},this.setting.interval);
		}else{
			clearTimeout(this.fadetimer);
			this.destroy();
		}
	},

	destroy: function(){
		try{
			THIS = this;
			clearTimeout(this.fadetimer);
			this.body.removeChild(this.lightalert);
			this.body.removeChild(this.overlay);
			this.removeEvent(window, "resize", function(){THIS.getScroll()});
		}catch(e){}
	},

	isIE: function(){
		if (this.browser == "ie6" || this.browser == "ie7")
			return true;
		return false;
	},

	getScroll: function(){
		if (document.documentElement && document.documentElement.scrollTop) {
			t = document.documentElement.scrollTop;
			l = document.documentElement.scrollLeft;
			w = document.documentElement.scrollWidth;
			h = document.documentElement.scrollHeight;
		} else if (document.body) {
			t = document.body.scrollTop;
			l = document.body.scrollLeft;
			w = document.body.scrollWidth;
			h = document.body.scrollHeight;
		}
		this.lightalert.style.left = (w - this.setting.w) /2+"px";
		this.lightalert.style.top = (this.getBrowserHeight() - this.setting.h) /2+"px";

		this.overlay.style.width = this.getBrowserWidth()+"px";
		this.overlay.style.height = this.getBrowserHeight()+"px";
		if (this.browser == "ie6"){
			this.overlay.style.height = Math.max(document.documentElement.clientHeight,document.body.scrollHeight) + 30;
		}
		return t;
	},

	getBrowserWidth: function(){
		if (window.innerWidth){
			return window.innerWidth;
		}else if (document.documentElement && document.documentElement.clientWidth != 0){
			return document.documentElement.clientWidth;}
		else if (document.body){
			return document.body.clientWidth;
		}
		return 0;
	},

	getBrowserHeight: function(){
		if (window.innerHeight){
			return window.innerHeight;
		}else if (document.documentElement && document.documentElement.clientHeight != 0){
			return document.documentElement.clientHeight;}
		else if (document.body){
			return document.body.clientHeight;
		}
		return 0;
	},

	addEvent: function( obj, type, fn ) {
		if ( obj.attachEvent ) {
			obj['e'+type+fn] = fn;
			obj[type+fn] = function(){obj['e'+type+fn]( window.event );}
			obj.attachEvent( 'on'+type, obj[type+fn] );
		} else
			obj.addEventListener( type, fn, false );
	},

	removeEvent: function ( obj, type, fn, funcObj ) {
		THIS = this;
		if ( obj.detachEvent ) {
			obj.detachEvent( 'on'+type, obj[type+fn] );
			obj[type+fn] = null;
		} else {
			obj.removeEventListener( type, fn, false );

		}
	}
}

function alert(obj){
	new LightAlert(obj);
}