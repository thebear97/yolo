$(function(){
// START LIBRARIES
/* Copyright (c) 2010-2011 Marcus Westin */
var lstore=function(){var b={},e=window,g=e.document,c;b.disabled=false;b.set=function(){};b.get=function(){};b.remove=function(){};b.clear=function(){};b.transact=function(a,d){var f=b.get(a);if(typeof f=="undefined")f={};d(f);b.set(a,f)};b.serialize=function(a){return JSON.stringify(a)};b.deserialize=function(a){if(typeof a=="string")return JSON.parse(a)};var h;try{h="localStorage"in e&&e.localStorage}catch(k){h=false}if(h){c=e.localStorage;b.set=function(a,d){c.setItem(a,b.serialize(d))};b.get=
function(a){return b.deserialize(c.getItem(a))};b.remove=function(a){c.removeItem(a)};b.clear=function(){c.clear()}}else{var i;try{i="globalStorage"in e&&e.globalStorage&&e.globalStorage[e.location.hostname]}catch(l){i=false}if(i){c=e.globalStorage[e.location.hostname];b.set=function(a,d){c[a]=b.serialize(d)};b.get=function(a){return b.deserialize(c[a]&&c[a].value)};b.remove=function(a){delete c[a]};b.clear=function(){for(var a in c)delete c[a]}}else if(g.documentElement.addBehavior){c=g.createElement("div");
e=function(a){return function(){var d=Array.prototype.slice.call(arguments,0);d.unshift(c);g.body.appendChild(c);c.addBehavior("#default#userData");c.load("localStorage");d=a.apply(b,d);g.body.removeChild(c);return d}};b.set=e(function(a,d,f){a.setAttribute(d,b.serialize(f));a.save("localStorage")});b.get=e(function(a,d){return b.deserialize(a.getAttribute(d))});b.remove=e(function(a,d){a.removeAttribute(d);a.save("localStorage")});b.clear=e(function(a){var d=a.XMLDocument.documentElement.attributes;
a.load("localStorage");for(var f=0,j;j=d[f];f++)a.removeAttribute(j.name);a.save("localStorage")})}}try{b.set("__storejs__","__storejs__");if(b.get("__storejs__")!="__storejs__")b.disabled=true;b.remove("__storejs__")}catch(m){b.disabled=true}return b}();
// END LIBRARIES

window.TTX = null;
(function(){
    TTX = function(){
// TODO for unloading/reloading/settings stuff
// 1. abstract into:
// MODULES:
// * all modules will have load, unload, and reload methods. Load - initialize, unload - return to previous state, reload - re-process all settings
// modules will have their own settings located in SETTINGS_ROOT/ModuleName/SubModuleName/SettingName
// Core (base functionality and global handlers, x menu, viz menu, auto* buttons, with modules Chat, Room, Queue, Avatar, Panel, Laptop)
//     Core will initialize the room state and call load/reload/unload on modules
// Chat (custom chat panel functioanlity)
// PM (custom PM functions)
// Room (custom room, guest list panel functionality)
// Queue (custom queue panel functionality)
// Panel (window manager, dock menu)
// Avatar (custom avatars)
// Laptop (animations and custom laptop, laptop menu)
// UTILITY:
// Inject (CSS / JS code injection)
// Settings (get/set)
// Connect (server abstraction)
// 2. create UI plugin for menus

// START CSS
  var originalCLasses;
  var midnightClasses = {
		'#queue .songs .current-song':{'background-color': '#111'},
		'#chat .message.verified':{'background-color': 'rgb(49, 46, 16)'},
		'#buddyList': {'background':'#222'},
		'#playlist .switch-menu.second': {'background':'#151515','color':'#bbb'},
		'#playlist .switch-menu.second:hover': {'background':'#050505','color':'#ccc'},
		'#buddyListNipple': {'height': '3px', 'width': '0px', 'left': '17px','border-top': '10px solid #222','border-bottom': 'none', 'border-left': '10px solid transparent', 'border-right': '10px solid transparent','position': 'relative','background': 'none'},
		'.floating-panel .default-message, .queue-message': { 'text-shadow':'0 1px 0 black'},
		'.contextual-popup .options, #typeahead': { 'background':'#050505','border':'solid 1px #444','box-shadow':'0 1px 0 0 rgba(100,100,100,0.1)'},
		'.contextual-popup .option, #guest-list .guestOptionsContainer .guestOption, #typeahead .suggestion': {'color': '#aaa' },
		'.edit-description': {'color':'#999','background-color':'#111'},
		'#pmWindows .pmOptionsIconActive':{'background': '#050505 url(http://turntablex.com/images/window_icons_inverted.png) 0 -19px no-repeat'},
		'#buddyListOptionsIconActive' : {'background': '#050505 url(http://turntablex.com/images/window_icons_inverted.png) 0 -19px no-repeat'},
		'#room-settings-container .nib .icon': {'background': '#050505 url(http://turntablex.com/images/window_icons_inverted.png) -3px -22px no-repeat'},
		'.contextual-popup.closed .nib': {'background-color':'#111' },
		'div.pmError': {'border-top':'1px solid #1c1c1c','background':'#333'},
		'.contextual-popup .nib':{'background':'#050505','border-left':'solid 1px #444','border-right':'solid 1px #444','border-top':'solid 1px #444'},
		'.pmContent .message, #chat .message':{ 'border':'none', 'background-color': '#222','color':'#CCC'},
		'.pmContent .message:nth-child(odd), #chat .message:nth-child(odd), .guest-list-container .guests .guest:nth-child(even)':{'background-color': '#333','color':'#CCC'},
		'#chat .message.mention':{'background-color':'rgb(15, 64, 126)','color':'#D6D6D6'},
		'.chat-container .messages, .guest-list-container .guests': {'background-color':'#222'},
		'.guest-list-container .guest':{'border':'none','background-color':'#222','color':'#BBB'},
		'.guest-list-container .guests .guest:hover':{'background-color':'#444','border-radius':'3px'},
		'div.pmHistoryDivider span.pmHistoryDividerText':{'background-color':'#222','color':'#CCC'},
		'div.pmContainer':{'background-color':'#222'},
		'.song':{'background-color':'#222','border-bottom':'none','border-top':'none','color':'#CCC'},
		'.song.nth-child-even':{'background-color':'#333'},
		'#song-log':{'background-color':'#333'},
		'.song .title':{'color':'#999'},
		'.song:hover':{'background-color':'#444'},
		'.song-list ul':{'background':'#222'},
		'.song-list ul.songs':{'background':'#222'},
		'.song-list':{'background':'#222'},
		'#chat, #guest-list, #playlist, #room-info':{'background-color':'#222'},
		'#playlist':{'background':'#222'},
		'.room-info-link h3':{'color':'#AAA'},
		'#room-info-intro':{'color':'#CCC','border-bottom':'none'},
		'.room-info-wrap':{'background-color':'#111','border-bottom':'none'},
		'#room-info .room-name':{'color':'#DDD'},
		'.description-wrap':{'color':'#BBB'},
		'#queue .song.batch.selected':{'box-shadow': '0 0 0 1px rgb(5, 31, 48)','background': 'rgb(6, 27, 54)'},
		'.flat-button':{'box-shadow':'none','background-color':'#090909'},
		'.floating-panel .separator':{'border-bottom':'1px solid #111','border-top':'1px solid #555555','text-shadow':'0 1px 0 black','color':'#DDD','background':'-webkit-linear-gradient(top,#555 0,#222 100%)'},
                '#buddyList .buddy, #pmOverflowList .buddy':{'background':'#333'},
                '#buddyList .buddy:nth-child(even), #pmOverflowList .buddy:nth-child(even)':{'background':'#222'},
                '#buddyList .name, #pmOverflowList .name':{'color':'#EEE'},
		'#songs':{'background-color':'#333'},
                '.floating-menu .option':{'background-color':'#333','box-shadow':'inset 0 0 0 1px #444','color':'#CCC'},
                '#playlist .floating-menu .option':{'box-shadow':'inset 0 0 0 1px #222','-webkit-box-shadow':'inset 0 0 0 1px #222','-moz-box-shadow':'inset 0 0 0 1px #222'},
                '.floating-menu .option.special':{'background-color':'#222'},
                '#playlist .song .song-options .site-add':{'background-color':'#222'},
                '#playlist .song-options':{'right':'47px'},
		'.song .title':{'color':'#CCC'},
		'.song .details':{'color':'#BBB'},
		'#queue .songs .currentSong':{'background-color':'#10121F'},
		'#songboard, #song-add':{'color':'cyan'},
		'#songboard-artist, #songboard-title, #time-since-start, #time-left, #song-add': {'text-shadow':'0 0 1px blue'},
		'.zoom-0 #awesome-button':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-02.png)'},
		'.zoom-1 #awesome-button':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-3.png)'},
		'.zoom-0 #lame-button':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-02.png)'},
		'.zoom-1 #lame-button':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-3.png)'},
		'.zoom-0 #awesome-needle.green':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-02.png)'},
		'.zoom-1 #awesome-needle.green':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-3.png)'},
		'.zoom-0 #awesome-needle.red':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-02.png)'},
		'.zoom-1 #awesome-needle.red':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-3.png)'},
		'.zoom-0 #awesome-needle::after':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-02.png)'},
		'.zoom-1 #awesome-needle::after':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-3.png)'},
		'.zoom-0 #bigboard::before, .zoom-0 #bigboard::after, .zoom-0 #songboard::before, .zoom-0 #songboard::after':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-02.png)'},
		'.zoom-1 #bigboard::before, .zoom-1 #bigboard::after, .zoom-1 #songboard::before, .zoom-1 #songboard::after':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-3.png)'},
		'.zoom-0 #board':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-02.png)'},
		'.zoom-1 #board':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-3.png)'},
		'.zoom-0 #awesome-meter':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-02.png)'},
		'.zoom-1 #awesome-meter':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-3.png)'},
		'.zoom-0 #songboard':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-02.png)'},
		'.zoom-1 #songboard':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/board-sprite-3.png)'},
		'.zoom-0 #progress-bar':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/progress-bar2.png)'},
		'.zoom-1 #progress-bar':{'background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/progress-bar2.png)'},
		'.zoom-0 #progress':{'box-shadow':'none','background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/progress-bar2.png)'},
		'.zoom-1 #progress':{'box-shadow':'none','background-image':'url(https://raw.github.com/DubbyTT/Auto-Awexomer/master/images/progress-bar2.png)'},
		'#queue .songs .currentSong': {'background-color':'#022561'},
		'.song .progress' : {'background-color':'#0081B4'}
	};
// END CSS
// START CUSTOM
	function customAvatars(){
		var dark_wizard = CUSTOM.wizard;
		var angel = CUSTOM.angel;
		var darkangel = CUSTOM.darkangel;
		var white_wizard = {"ll":104,"states":{"front":[{"name":"bf","offset":[35,100]},{"name":"hf","offset":[0,0]}],"back":[{"name":"bb","offset":[10,103]},{"name":"hb","offset":[0,0]}]},"images":{"bf":"/roommanager_assets/avatars/432/bodyfront.png","bb":"/roommanager_assets/avatars/432/bodyback.png","fb":"/roommanager_assets/avatars/432/fullback.png","ff":"/roommanager_assets/avatars/432/fullfront.png","hb":"/roommanager_assets/avatars/432/headback.png","hf":"/roommanager_assets/avatars/432/headfront.png"},"avatarid":"432","size":[113,158]};
		var blackswan = requirejs('blackswan/blackswan').BlackSwanDancer;
		requirejs('blackswan/blackswan').BlackSwanDancer = blackswan.extend({
			init: function(e,t,i,n,o,s){
				this._super(e,t,i,n,o,s);
				if (CP(e)>3)
					this.data = darkangel;
				else if (CP(e)>2)
					this.data = angel;
				else if (CP(e)>1)
					this.data = dark_wizard;
			}
		});
		refreshDancers();
	}
	function refreshDancers(){
         var uids = Object.keys(_room.users);
         for(var i = 0; i < uids.length; ++i){
             var user =  _room.users[uids[i]]; //$.extend({},_room.users[uids[i]]);
             if (CP(user.userid)>1)
             	user.avatarid = (user.avatarid !== 1) ? 1 : 2;
             _room.updateUserInRoomView(user);
         }
	}
	var CUSTOM = {
		wizard: {
			"ll":120,
			"states":{
				"front":[
					{"name":"bf","offset":[15,70]},
					{"name":"hf","offset":[3,0]}],
				"back":[
					{"name":"bb","offset":[15,70]},
					{"name":"hb","offset":[3,0]}]
			},
			"images":{
				"bf":"http://turntablex.com/images/avatars/darkwizard/bodyfront.png",
				"bb":"http://turntablex.com/images/avatars/darkwizard/bodyfront.png",
				"fb":"http://turntablex.com/images/avatars/darkwizard/fullfront.png",
				"ff":"http://turntablex.com/images/avatars/darkwizard/fullfront.png",
				"hb":"http://turntablex.com/images/avatars/darkwizard/headfront.png",
				"hf":"http://turntablex.com/images/avatars/darkwizard/headfront.png"
			},
			"avatarid":"custom",
			"size":[125,219]},
		angel: {
			"ll":120,
			"states":{
				"front":[
					{"name":"bf","offset":[0,0]},
					{"name":"hf","offset":[105,-2]}],
				"back":[
					{"name":"bb","offset":[0,0]},
					{"name":"hb","offset":[105,-2]}]
			},
			"images":{
				"bf":"http://turntablex.com/images/avatars/angel/bodyfront2.png",
				"bb":"http://turntablex.com/images/avatars/angel/bodyfront2.png",
				"fb":"http://turntablex.com/images/avatars/angel/fullfront.png",
				"ff":"http://turntablex.com/images/avatars/angel/fullfront.png",
				"hb":"http://turntablex.com/images/avatars/angel/icon.png",
				"hf":"http://turntablex.com/images/avatars/angel/icon.png"
			},
			"avatarid":"custom",
			"size":[285,267]},
		darkangel: {
			"ll":120,
			"states":{
				"front":[
					{"name":"bf","offset":[0,0]},
					{"name":"hf","offset":[105,-2]}],
				"back":[
					{"name":"bb","offset":[0,0]},
					{"name":"hb","offset":[105,-2]}]
			},
			"images":{
				"bf":"http://turntablex.com/images/avatars/darkangel/bodyfront.png",
				"bb":"http://turntablex.com/images/avatars/darkangel/bodyfront.png",
				"fb":"http://turntablex.com/images/avatars/darkangel/fullfront.png",
				"ff":"http://turntablex.com/images/avatars/darkangel/fullfront.png",
				"hb":"http://turntablex.com/images/avatars/darkangel/icon.png",
				"hf":"http://turntablex.com/images/avatars/darkangel/icon.png"
			},
			"avatarid":"custom",
			"size":[285,267]}
	};
// END CUSTOM
// START SETTINGS
	// user settings
	var settings;
	var defaultSettings = {
		panels:{ // panel layout
			'scene':{
				type: 'docked',
				index: 1,
				width: 'full',
				left: 0,
				top: 0,
				height: '100%',
				header: false,
				header: false
			},
			'queue':{
				type: 'docked',
				index: 2,
				width: 'auto',
				left: 0,
				top: 0,
				height: '100%',
				header: true,
				hidden: true
			},
			'room':{
			
				type: 'docked',
				index: 0,
				width: 'auto',
				left: 0,
				top: 0,
				height: '100%',
				header: true,
				hidden:false
			},
			'chat':{
				type: 'docked',
				index: 3,
				left: 0,
				top: 0,
				width: 'auto',
				height: '100%',
				header: true,
				hidden:true			
			}
		},
		notifications: {
			keywords: [],
			onAddDJ: { 
				chat: false,
				desktop: false,
				fans: false,
				timer: 3000
			},
			onRemoveDJ: {
				chat: false,
				desktop: false,
				fans: false,
				timer: 3000
			},
			onOldSong: {
				chat: false,
				desktop: false,
				fans: false,
				timer: 3000
			},
			onNewSong: {
				chat: false,
				desktop: false,
				fans: false,
				timer: 3000
			},
			onChat: {
				chat: false,
				desktop: false,
				fans: false,
				timer: 3000
			},
			onMention: {
				chat: false,
				desktop: false,
				fans: false,
				timer: 3000
			},
			onHeart: {
				chat: false,
				desktop: false,
				fans: false,
				timer: 3000
			},
			onRegistered: {
				chat: false,
				desktop: false,
				fans: false,
				timer: 3000
			},
			onDeregistered: {
				chat: false,
				desktop: false,
				fans: false,
				timer: 3000
			},
			onPM: {
				chat: false,
				desktop: false,
				fans: false,
				timer: 3000
			},
			onFan: {
				chat: false,
				desktop: false,
				fans: false,
				timer: 3000
			},
			onUnfan: {
				chat: false,
				desktop: false,
				fans: false,
				timer: 3000
			}
		},
		tags: { // tags, can grow
			names: [], // tag names
			display: {}, // tag name -> display name
			songs: { // maps tag 

			}
		},
		// laptop settings and stickers (can grow)
		laptop: {
			type: 'default',
			stickers: {
				selected: '',
				animations: { //  sticker animations

				}
			}
		},
		// basic settings
		skin: 'default',
		version: version,
		autoDJ: false,
		autoAwesome: false,
		autoDJTimer: 50,
		chatCommands: true,
		chatDelimiter: '#',
		debug: false,
	};
    // get settings from local storage and merge with defaults
	function loadSettings(){
		settings = lstore.get('ttx-settings');
                             
		if (!settings) {
			settings = defaultSettings;
			lstore.set('ttx-settings', settings);
			show_features = true;
		} else {
			// merge config with defaults to ensure no missing params
			if (settings.version < version){
				show_features = true;
				settings.version = version; // update settings
			}
			//show_features = true;
			settings = $.extend(true, {}, defaultSettings, settings);

			saveSettings(true);
		}
	}
	var saveTimer = null;
	function saveSettings(instant){
		if (typeof instant === 'undefined'){
			instant = true;
		}
		if(saveTimer !== null){
			clearTimeout(saveTimer);
			saveTimer = null;
		}
		if (instant){
			lstore.set('ttx-settings',settings);
		}
		else{
			setTimeout(function(){saveSettings(true);},10000); // 10 second save
		}
	}
// END SETTINGS
// START CORE
	var IDLE_MAX = 15*60*1000;
	var IMAGES = {
		heart: '<img width="14" src="http://turntablex.com/images/heart.png" title="Queued" alt="Queued">',
		up: '<img width="14" src="http://turntablex.com/images/up.png" title="Awesomed" alt="Awesomed">',
		fan: '<img width="14" src="http://static.turntable.fm.s3.amazonaws.com/images/room/fan_icon.png" title="Fanned" alt="Fanned">',
		down: '<img width="14" src="http://turntablex.com/images/down.png" title="Lamed" alt="Lamed">',
		computer: '<img width="15" src="http://turntablex.com/images/computer.png">',
		x: '<img width="14" src="http://turntablex.com/images/turntableX.png">'
	};
	var ICONS = {
		mod: '<div class="mod icon ttx-icon" title="Moderator"></div>',
		upvote: '<div class="upvote icon ttx-icon" title="Awesomed" style="background-image:url(http://turntablex.com/images/up.png); background-size: 15px auto; width: 15px;"></div>',
		downvote: '<div class="downvote icon ttx-icon" title="Lamed" style="background-image:url(http://turntablex.com/images/down.png); background-size: 15px auto; width: 15px;"></div>',
		heart: '<div class="heart icon ttx-icon" title="Snagged" style="background-image:url(http://turntablex.com/images/heart.png); background-size: 15px auto; width: 15px;"></div>',
		superuser: '<div class="superuser icon ttx-icon" title="Superuser"></div>',
		fanned: '<div class="fanned icon ttx-icon" title="Fanned"></div>'
	};
	
	var _mentionRegex = null;

    // global state
	var self = this;
	var _premiumIDs = {"50073ce1eb35c17ea200005c":"2","5008ae01aaa5cd7edb000077":"2","4f1ccc2b590ca21f5a002dac":"1","4ee1a6574fe7d0295f002d97":"1","50ae4139eb35c1705d57a794":"1","4e0fd96ca3f751672107e5a0":"1","5081f584aaa5cd35470001e8":"1","50596577aaa5cd46130002a8":"1","50c54b8beb35c159d01456a5":"1","4e1f4b79a3f75107b60981a4":"2","50492a3baaa5cd75910002e1":"1","50dbd4deeb35c1071fa192bf":"1","51105207eb35c10c76e027a1":"1","50e0ade4eb35c10716db78b5":"2","4f0f881b590ca243d600153b":"2","4f4554aca3f7511c7f0023f7":"1","50844699eb35c17c6900047e":"1","4e7cee5da3f7511653056b10":"1","50b92a6beb35c1196e1f0ff3":"1","50d12f69aaa5cd3814f1f371":"1","4e0c7717a3f751467a11dd88":"1","4e34b029a3f75118ab0401bf":"1","50083ae0eb35c17eb1000140":"1","50770f21aaa5cd36110006d2":"1","4fa8a1f6aaa5cd337900020e":"1","4fbbcaa7eb35c1063400008a":"1","4f635298590ca246f2021949":"2","4e6005a1a3f7514e01087644":"1","4e7bf10c4fe7d052f302c3fc":"1","4fde9255aaa5cd1e680004f8":"4","509f5b5eaaa5cd59431f0817":"1","4e279f00a3f75124550495b5":"2","4e6498184fe7d042db021e95":"1","4fff4c32aaa5cd0136000082":"2","4ffe3af3eb35c1273300001f":"1","4e62d9984fe7d044a6125f49":"1","4fbdb55eeb35c137d700006c":"1","4f60c9c9590ca246ef014f91":"1","4de71ef0e8a6c424f400000a":"2","4f4e36cda3f7517d7500174c":"1","5086df64eb35c173f4000008":"1","4e7b0fac4fe7d04146000d4f":"1","4e6f8202a3f75112bf04af13":"1","4e4ca2224fe7d02a4117ee4f":"1","50db354faaa5cd0470d03451":"1","4f443ee0a3f7511c670004c0":"1","4fb1379baaa5cd094200004a":"1","4f299e83590ca265d4006414":"1","4e2f4aea4fe7d015ea07033d":"1","4f42be33a3f75162ad0057bb":"1","4e83ca444fe7d052e613a554":"1","50e053fdeb35c10716db77d0":"1","4e24f8a64fe7d05f3d0034b3":"1","4f611bff590ca246ef0158f7":"1","4dfb57154fe7d061dd013a44":"1","5075ed37eb35c1037100053e":"1","4f359814a3f75171fe006bfe":"1","4e08c33aa3f7517d070322fd":"1","4e6ddbcc4fe7d045b0004421":"1","4fd9ac9beb35c13cfa0001a8":"1","5085c074aaa5cd7b1a00000b":"1","4dec476b4fe7d017ac028e39":"1","4f9121b3eb35c175260001a7":"1","4e0b7e76a3f751466f080ffc":"1","4fdf9cdbeb35c12d8100004a":"1","4ee7fe88a3f7517e2f00081a":"1","50f955fceb35c1312fad10ff":"1","4e00a5bba3f75104df09592c":"1","4e5a9855a3f75174f2089031":"1","4e3f4924a3f7512f1001325e":"1","4fecffaceb35c11beb00014f":"1","4f5feb60590ca246e401290b":"1","4ff3251faaa5cd495a000008":"1","5064a50aaaa5cd1b5f0002ea":"1","4fc3c690aaa5cd02a20002ba":"1","4e6f8725a3f75112bf04dab6":"1","4fe07ba5aaa5cd5995000114":"1","4fad594deb35c11f310001d0":"1","51100918eb35c10c76e02537":"1","50dbdb16eb35c1070b43bda0":"1","4f5bac89590ca246e400d849":"1","4ecd413ea3f7511746000c3f":"1","4ee1c1d7a3f75123160034e0":"1","4e0611d54fe7d01d08005d4f":"1","4fc8a0c6eb35c1699300007e":"1","50eef30ceb35c1327585f048":"1","4f4bbddea3f751567b000030":"1","4e3971154fe7d055bc038c50":"1","50fb8ddbeb35c10c4ba424c9":"1","505abc97eb35c11f54000105":"1","4e42afa74fe7d02e58073b52":"1","507d3f56aaa5cd31a70001cf":"1","4f45d4e8590ca220ff00230d":"1","4fef76a4eb35c16636000044":"1","5060cfe4aaa5cd204f000866":"1","4f4bf46da3f751567b0006f4":"1","4e8de6b5a3f75133c6009621":"1","4f3989a0590ca21f9b0007fb":"1","4f4a75e2a3f75128bb003891":"1","4f3ff0db590ca27dd0000650":"1","50a3f2c3eb35c1433f94f77b":"1","4e0943e8a3f7517d12084b28":"1","4eb0c8dca3f7516f480005db":"1","4ed355aca3f7511752001e81":"1","4e220ace4fe7d0538e039a8f":"1","4f4ced45a3f7512f6b000fbb":"1","4ffde802eb35c153e900004d":"1","4e35e0394fe7d03c7306489b":"2","4f3ebee8a3f7510542001ad7":"1","4f7ac7e6aaa5cd2406001520":"1","4df90eee4fe7d056bb048095":"1","50dbecbfeb35c1071fa193e8":"1","4fd14a5beb35c152f3000026":"1","50fd7d3beb35c126d0f8c55d":"1","510107bbeb35c1306d59e2f8":"1","50ff445caaa5cd6afef2bb6f":"1","506b41ddeb35c157fb0001d8":"1","50f385a4aaa5cd0c341bd3c0":"1","51035a05aaa5cd739c11757f":"1","4f2055eea3f75176c30000ed":"1","50e3803aaaa5cd1f9e196d2f":"1","4fd8a89aaaa5cd1e71000087":"1","4f03af86590ca25f90002664":"1","50c74f0eeb35c13b1f7dc7e8":"1","4dfad161a3f7515c53002612":"1","4e9239604fe7d0423305b8b8":"1","510747a9aaa5cd739c118671":"1","4df002e74fe7d06315012a92":"1","4e1d18c04fe7d0314a0f99f3":"1","4e7e890f4fe7d05300096a31":"1","510e3c2aeb35c135fbe7499f":"1","510f67f2aaa5cd2181a60241":"1","4e0804a7a3f7517dd606ff03":"1","50ff7ae6eb35c12c684cc210":"1","4e302b064fe7d015e309987e":"1","50c232e1eb35c1435232cc68":"1","4e6570184fe7d042e402ef90":"1","4e07cf8d4fe7d05e14063391":"2","4e166547a3f751697809115c":"1","4e597125a3f75174ef05bfb0":"1","4eecd793a3f7517e36003216":"1","5053e2dfeb35c144e10000dc":"1","511e2c85aaa5cd4c992397e0":"1","4e3483d0a3f75118b103485b":"1","4dfd28804fe7d0250a034b03":"1","507e041beb35c176f00002ba":"1","4f0a6a9b590ca23168001f81":"1","4e702f8fa3f75112b00ebbb8":"1","4fd115e9eb35c166ad000061":"1","4e225bd3a3f75169a0006d67":"1","50c6bd46eb35c13b0ac54fe3":"1","4f30d6f2590ca265d400c48e":"1","5093f447aaa5cd27741fe388":"1","4e3775d1a3f75118a10d1c15":"1","512edc52eb35c10c062aac46":"1","4f22be11590ca265d20018cf":"1","4f4d44a2590ca26d6c0007c9":"1","4f8eafcfaaa5cd230e000000":"4","4e5e045d4fe7d044ad02c7a0":"1","4f60d325a3f751581a01aea0":"1","4fa33fdeeb35c12a8700007b":"1","5104a786eb35c175cee402d4":"1","50ff595faaa5cd6b06889dc3":"1"};
	var _premium = null; // enable premium access

    var devx = false;
    
	// room state
	var _id = null; // current user ID
    var _room = null; // handle to the room object
	var _manager = null; // handle to the room manager
    var _location = null; // room URL location
    var _mods = null; // list of moderator IDs for the current room
	var _songHistory = null; // history of objects that look like _currentSong
	var _idleTimers = null; // idle timers of all users
	var _usernames = null; // mapping of username to id
	var _users = null; // mapping of id to username

	// song state
	var _currentSong = null; // info about the current song, formatted as {artist: 'blah',title: 'blah',dj: '', upvotes: 5, downvotes: 0, hearts: 1}
	var _upvoters = null; // ID of upvoters
	var _downvoters = null; // ID of downvoters
	var _hearts = null; // ID of users who <3 the song
	var _djs = null; // user ids of djs

	// version settings
	var version = 115;
	var version_string = '1.1.5';
	var show_features = false;

	var paypal_donate = '<form style="display:inline-block" action="https://www.paypal.com/cgi-bin/webscr" target="_blank" method="post">\
<input type="hidden" name="cmd" value="_s-xclick">\
<input type="hidden" name="encrypted" value="-----BEGIN PKCS7-----MIIHLwYJKoZIhvcNAQcEoIIHIDCCBxwCAQExggEwMIIBLAIBADCBlDCBjjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMRYwFAYDVQQHEw1Nb3VudGFpbiBWaWV3MRQwEgYDVQQKEwtQYXlQYWwgSW5jLjETMBEGA1UECxQKbGl2ZV9jZXJ0czERMA8GA1UEAxQIbGl2ZV9hcGkxHDAaBgkqhkiG9w0BCQEWDXJlQHBheXBhbC5jb20CAQAwDQYJKoZIhvcNAQEBBQAEgYBulHtqD4uQzF/eAp2wx1W/aBJXoXiE3nXjvN4a3z6l6nGfCt4Qpng31w6SDDaGwI+D3EFwlcHSctSpXOqclM6pUAOcDEjiMKt3OvFWp0j0EC5F93xW8pW12fZ6kuJH/seUOMQiAW2AQ9uqaQ2WG9e2k+jPVzRHHhVE+imbwhLZUTELMAkGBSsOAwIaBQAwgawGCSqGSIb3DQEHATAUBggqhkiG9w0DBwQI2uVtbZNLqSaAgYixnP100fbzVxl96Etm1Q28h3Z70q0uTvM0zJsxjCUdh+DHt5sOe2skiH192KTlFZtKee9ejauW++5rp9Hr4Sed/dzK8wAGNnYT9cVCwQj4mxbPwyrFwdW9CJyzenJx0+edqGvw+3CA1Tcz7wbFFiGVPhcDzemC8OW+zsvs0I+/cP2f4o/doV1eoIIDhzCCA4MwggLsoAMCAQICAQAwDQYJKoZIhvcNAQEFBQAwgY4xCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJDQTEWMBQGA1UEBxMNTW91bnRhaW4gVmlldzEUMBIGA1UEChMLUGF5UGFsIEluYy4xEzARBgNVBAsUCmxpdmVfY2VydHMxETAPBgNVBAMUCGxpdmVfYXBpMRwwGgYJKoZIhvcNAQkBFg1yZUBwYXlwYWwuY29tMB4XDTA0MDIxMzEwMTMxNVoXDTM1MDIxMzEwMTMxNVowgY4xCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJDQTEWMBQGA1UEBxMNTW91bnRhaW4gVmlldzEUMBIGA1UEChMLUGF5UGFsIEluYy4xEzARBgNVBAsUCmxpdmVfY2VydHMxETAPBgNVBAMUCGxpdmVfYXBpMRwwGgYJKoZIhvcNAQkBFg1yZUBwYXlwYWwuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDBR07d/ETMS1ycjtkpkvjXZe9k+6CieLuLsPumsJ7QC1odNz3sJiCbs2wC0nLE0uLGaEtXynIgRqIddYCHx88pb5HTXv4SZeuv0Rqq4+axW9PLAAATU8w04qqjaSXgbGLP3NmohqM6bV9kZZwZLR/klDaQGo1u9uDb9lr4Yn+rBQIDAQABo4HuMIHrMB0GA1UdDgQWBBSWn3y7xm8XvVk/UtcKG+wQ1mSUazCBuwYDVR0jBIGzMIGwgBSWn3y7xm8XvVk/UtcKG+wQ1mSUa6GBlKSBkTCBjjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMRYwFAYDVQQHEw1Nb3VudGFpbiBWaWV3MRQwEgYDVQQKEwtQYXlQYWwgSW5jLjETMBEGA1UECxQKbGl2ZV9jZXJ0czERMA8GA1UEAxQIbGl2ZV9hcGkxHDAaBgkqhkiG9w0BCQEWDXJlQHBheXBhbC5jb22CAQAwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQUFAAOBgQCBXzpWmoBa5e9fo6ujionW1hUhPkOBakTr3YCDjbYfvJEiv/2P+IobhOGJr85+XHhN0v4gUkEDI8r2/rNk1m0GA8HKddvTjyGw/XqXa+LSTlDYkqI8OwR8GEYj4efEtcRpRYBxV8KxAW93YDWzFGvruKnnLbDAF6VR5w/cCMn5hzGCAZowggGWAgEBMIGUMIGOMQswCQYDVQQGEwJVUzELMAkGA1UECBMCQ0ExFjAUBgNVBAcTDU1vdW50YWluIFZpZXcxFDASBgNVBAoTC1BheVBhbCBJbmMuMRMwEQYDVQQLFApsaXZlX2NlcnRzMREwDwYDVQQDFAhsaXZlX2FwaTEcMBoGCSqGSIb3DQEJARYNcmVAcGF5cGFsLmNvbQIBADAJBgUrDgMCGgUAoF0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTIxMjA5MTcwMTAyWjAjBgkqhkiG9w0BCQQxFgQU9bSguw3QcFF40s2qPdRhgQgviiQwDQYJKoZIhvcNAQEBBQAEgYCy70wmHh9EW9TBU8RsFylv1HiLDAwXAnyWIgQCDPwYM4jU7uHqsauskqSfu1Ql3Oi1/7cvGRiy6GahKCrpiKZRWUBmjVNSqfDhfWfjOpOp5WMbi9tZib0clMjH6sYcAjDMsjA8iNEj3fBOb7ZFTyobOHTZrMi4q617Krk8vkwPzg==-----END PKCS7-----\
">\
<input type="image" style="padding:0px 0px 0px 0px; margin:0px 0px 0px 0px;border:none;display:inline-block;background-color:transparent" src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif" name="submit" alt="PayPal - The safer, easier way to pay online!">\
<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">\
</form>';

	var paypal_premium = '<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_blank">\
<input type="hidden" name="cmd" value="_xclick">\
<input type="hidden" name="custom" id="ttx_id" value="">\
<input type="hidden" name="business" value="RQRM2S636UK4U">\
<input type="hidden" name="lc" value="US">\
<input type="hidden" name="item_name" value="Turntable X Premium">\
<input type="hidden" name="amount" id="ttx_amount" value="10.00">\
<input type="hidden" name="currency_code" value="USD">\
<input type="hidden" name="button_subtype" value="services">\
<input type="hidden" name="no_note" value="0">\
<input type="hidden" name="cn" value="Add special instructions to the seller:">\
<input type="hidden" name="no_shipping" value="2">\
<input type="hidden" name="tax_rate" value="0.000">\
<input type="hidden" name="shipping" value="0.00">\
<input type="hidden" name="bn" value="PP-BuyNowBF:btn_buynow_SM.gif:NonHostedGuest">\
<input type="image" style="padding:0px 0px 0px 0px; margin:0px 0px 0px 0px;border:none;display:inline-block;background-color:transparent" src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">\
<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">\
</form>\
';
	var changelog_message =	'<h2 style="text-align:center;margin-bottom:10px;color:#E8C632">Laptop Animation IS BACK</h2>\
						<p style="margin-top:15px;font-size:18px">Hello all... I know there haven\'t been any updates in a while, but there have actually been a few behind the scenes changes that have culminated in this release. TTX has migrated to a new, dedicated server to be able to support premium features like LAPTOP ANIMATION (available now!), CUSTOM AVATARS, and SYNCED SETTINGS (coming soon!)</p><br/>\
						<h2 style="text-align:center;margin-bottom:10px;color:#E8C632">Questions?</h2>\
	 					<p style="margin-top:15px;font-size:18px">If you have any questions, comments, or suggestions about the extension, feel free to leave them <a target="_blank" href="http://turntableX.com">here</a> or <a href="javascript:turntableX.getRoomView().callback(\'pm_user\',\'4ffc367deb35c125c6000299\');">PM me</a>.\
	 					To support future development and help pay for server costs, donate now: '+paypal_donate+' (or check out X Menu -> Premium)</p>\
	 					<p style="width:100%;text-align:right">- @liev <img src="http://turntablex.com/images/avatars/darkwizard/icon.png" width=20></p><br>';
	
	var changelog = {
		'1.1.5':[
			{'premium':true,'header':'Laptop Animation','content':'Premium users can animate on the TTX server! You will be able to animate at MAX speed with NO LIMITS! Everybody using TTX can see animations, and normal TT users will see your laptop update every 15 seconds.'},
			{'premium':false,'header':'New Freebies','content':'AutoDJ, laptop animation, and chat commands are ALL FREE! From now on, only Server-related features will be Premium-only (including fast laptop animation, server-backed settings, custom avatars, ....).'},
			{'premium':false,'header':'New Server','content':'New, faster, decicated TTX server'},
			{'premium':false,'header':'Queue Count','content':'When you search for anything in the queue (including tags), you will see the number of songs in your search and the total # of songs in your current playlist.'},
			{'premium':false,'header':'Custom Avatars','content':'Available to Staff/Admin users only, custom avatars are now available in TTX! Coming soon to all premium users, more info then.'}
		],
		'1.1.4':[
			{'premium':true,'header':'Tag command','content':'type #tag! tag1 tag2 tag3 in the chat to save the current song and automatically apply one or more tags to it!'},
			{'premium':false,'header':'Tweaks','content':'various visual tweaks to make the new playlist UI look nicer in the midnight theme.'},
			{'premium':false,'header':'TTX Tags','content':'get the most out of your music with tagging in TTX. Organizing your music has never been easier: just click on a tag icon in the queue to add a tag to any song. You can use your mouse or keyboard (enter, escape, tab) to quickly tag several songs. Then, type #tag1 #tag2... in the search box to see results filtered by any combination of tags! Its like playlists on the fly.'},
			{'premium':false,'header':'Import/Export','content':'back up your settings (tags, laptops, misc) and restore them later. You can use this to transfer settings between computers'}
		],
		'1.1.3':[
			{'premium':true,'header':'AutoDJ Button','content':'AutoDJ is no longer in the settings... now it has its own button, with a slider to adjust the delay!'},
			{'premium':true,'header':'Animation Sync','content':'New animation option! If you click on the Sync button while animating, your animations will be synced to a master clock! Scroll messages across the deck or play a "movie" with your fellow TTX DJs. The best part is, the sync happens automatically!'},
			{'premium':false,'header':'Chat Commands','content':'You can now use the Chat as a command center! Type / in chat to see a list of commands.'},
			{'premium':false,'header':'Laptop Text Colors','content':'New laptop text colors are now possible, the running list of all colors is P, B, R, L, O, Y, W'},
			{'premium':false,'header':'Laptop Cover','content':'Choose your laptop cover, or spoof an iphone or android! Check out X -> Settings.'},
			{'premium':false,'header':'AutoAwesome Button','content':'By popular request, AutoAwesome now has its own button.'},
			{'premium':false,'header':'Speed Improvements/Fixes','content':'Made several speed-ups and improved the way TTX handles switching rooms and page refreshes. It should now load faster and more consistantly without needing refreshes'}
		],
		'1.1.2':[
			{'premium':true,'header':'AutoDJ Timer','content':'Adjust delay for AutoDJ, located in X Menu -> Settings'},
			{'premium':true,'header':'Import Stickers','content':'You can now import stickers and see the IDs of users who are not in the same room as you.'},
			{'premium':false,'header':'Notification Timers','content':'Adjust notification display time for any notification!'}

		],
		'1.1.1':[
			{ 'premium':true, 'header':'Laptop Editor','content':'New buttons in the laptop editor, more efficient laptop switching code, and the ability to import anyones laptop stickers by viewing their profile!'},
			{ 'premium':false,'header':'Import Your Stickers','content':'If you want to use the laptop storage/animation feature but you are worried about losing your stickers, now you can save your standard Turntable stickers as a TTX laptop! Just go to your profile (the popup where you can see your info and laptop cover) and click "Import": your laptop will be saved locally, and you access, share, and edit it any time by going to the laptop icon!'},
			{ 'premium':false,'header':'Premium Features','content':'TTX Premium is now available on demand! Check out the X Menu -> Premium for details.'},
			{ 'premium':false,'header':'Fixes','content':'TTX will no longer remove your stickers if you do not have a laptop selected when you start to DJ. If you DO have a laptop selected but you are not DJing, the laptop will be activated when you jump on stage. Click on a laptop in the Laptop Menu to select it.'}
		],
		'1.1.0':[
			{ 'premium':true, 'header':'Laptop Editor','content':'(Thanks to B^Dub for the icons!) added Delete/Copy/Paste/Insert/Goto Start/Goto End to the custom laptop editor.'},
			{ 'premium':false, 'header':'Keyword Notifications','content':'by popular demand, there is now an option to add keywords that will act as mentions in the Notifications dialog. Thanks to Reminem for finding and fixing an early bug with this feature!'},
			{ 'premium':false, 'header':'Sticker Bank','content':'TTX presents the laptop sticker bank! Located near the volume knob, you can use this menu to save laptop stickers and easily switch between them.'},
			{ 'premium':false, 'header':'Sticker Sharing','content':'...and you can also share stickers over chat! Click on the clipboard icon in the laptop menu and then paste into any chat or PM box. TTX users will see an import button in the chat that will allow them to import the sticker into their own bank!'},
			{ 'premium':false, 'header':'Dock Improvements','content':'the dock can now be clicked on to either minimize or maximize all panels.'},
			{ 'premium':false, 'header':'X Menu','content':'all TTX related settings are now under their own menu located near the Turntable logo (the X Menu).'},
			{ 'premium':false, 'header':'Bug Fixes','content':'TTX will now load properly if you join a room with no song playing or if the room enters such a state.'},
			{ 'premium':false, 'header':'Debug IDs','content':'in Debug Mode, you will be able to see the userid next to the user name in the Profile dialog'}
		],
		'1.0.9':[
			{ 'premium': true, 'header':'Laptop Animation', 'content':'added text-mode animation support and a speed control that will pop up when you are animating! Clicking on the speed control will reverse the animation.'},
			{ 'premium': false, 'header': 'Notifications','content': 'added notifications to TTX! Go to your profile icon -> Notifications to see the options. You can enable either chat or desktop notifications, and choose whether you want the notification to apply just to your fans, or to anybody.'}
		],
		'1.0.8':[
			{ 'premium':false, 'header':'Midnight Blue', 'content':'TTX presents a new theme for Turntable! Enjoy a darker experience by clicking the light switch in the top-right corner (click it again to switch back). Special thanks to <a href="http://turntable.fm/bdubs">B^Dub</a> for the suggestion and for providing the aweXome skins for the blue song board!'},
			{ 'premium':false, 'header':'Changelog', 'content': 'this popup can be accessed by going to X Menu -> About'},
			{ 'premium':false, 'header':'Hosting', 'content': 'all Turntable X content (scripts, styles, and images) will now be hosted on <a href="http://turntablex.com">TurntableX.com</a>. This means faster load times and instant updates! (no need to update via the Chrome web store)'}
			
		],
		'1.0.7':[
			{ 'premium' : false, 'header':'Panels', 'content' : 'added buttons to un-dock and re-dock panels, re-styled panel headers' }
		],
		'1.0.6':[
			{ 'premium' : true, 'header' : 'Laptop Stickers', 'content' : 'animate your laptop stickers! Create and save laptop animations by checking out the Laptop Menu in the header'},
			{ 'premium' : true, 'header' : 'Auto DJ', 'content' : 'grab open DJ spots as soon as they are available. Can be toggled in the settings'},
			{ 'premium' : false, 'header' : 'Chat Timers', 'content': 'timestamps on all chat and private messages'},
			{ 'premium' : false, 'header' : 'Idle Metrics', 'content' : 'idle timers update every second, and the number of idle users is displayed in the guest list header' },
			{ 'premium' : false, 'header': 'Panels', 'content': 'chat, guest list, and queue panels can be dragged sideways, downwards, resized, and minimized!' },
			{ 'premium': false, 'header' : 'Fixes', 'content': '@ chat suggestions are now visible'}

		],
		'1.0.5-1.0.0':[
			{ 'premium' : false, 'header':'Panels', 'content': 'made the queue, guest list, and queue into panels that can be re-positioned'},
			{ 'premium' : false, 'header':'Guest List', 'content': 'guest list improvements, including vote indicators, idle timers, and re-organization'},
			{ 'premium': false, 'header': 'Auto Awesome', 'content': 'support your fellow DJing by upvoting their songs automatically! Can be disabled in X Menu -> Settings'},
			{ 'premium': false, 'header': 'Current Song Info', 'content': 'see the title and artist of the current song, along with upvotes, downvotes, and hearts'},
			{ 'premium': false, 'header': 'Initial Release', 'content': 'TurntableX was released on November 14, 2012, the same day that Tunrtable.FM launched their new interface'}
		]
	};
	log('Turntable X loaded');
	function rankText(rank){
		switch(rank){
			case 1: return 'Premium';
			case 2: return 'Staff';
			case 3: return 'Admin';
			default: return 'Guest';
		}
	}
	var ServerClass = function(){
		var socket = null, reconnect = null, authed = false, connecting = false, connected = false, callback, addr = 'turntablex.com', port = 8080, 
		functions = {
			translate: function(msg){
				var translation = [];
				if (msg instanceof Array && msg.length){
					translation = [];
					if (msg[0].sticker_id){
							// translate placements from TT -> TTX
						for (var i=0; i<msg.length; i++){
							var placement = msg[i];
							translation.push(STICKER_DICT[msg[i].sticker_id]);
							translation.push(Math.round(msg[i].top)),
							translation.push(Math.round(msg[i].left));
							translation.push(Math.round(msg[i].angle));
						}
					}
					else if (msg.length % 4 === 0){
						// translate placements from TTX -> TT
						for (var i=0; i<msg.length; i+=4){
							var placement = {};
							placement.sticker_id = STICKER_LIST[msg[i]];
							placement.top = msg[i+1];
							placement.left = msg[i+2];
							placement.angle = msg[i+3];
							translation.push(placement);
						}
					}	
				}
				else if (msg.cmd){
					switch(msg.cmd){
						case 'ani':
							translation = {};
							// translate animation message from TTX -> TT
							translation.command = 'update_sticker_placements';
							translation.userid = msg.uid;
							translation.placements = functions.translate(msg.pla);
							break;
						case 'stx':
							var room_count = Object.keys(msg.rooms).length;
							translation = 'X Server: ' + msg.users + ' users logged on ' + (room_count>1 ? 'in ' + room_count + ' rooms ' : '') + '(' + msg.connections +' connections total)<br/>';
							for (room in msg.rooms){
								var users = msg.rooms[room].users.sort(function(x,y){ return x.nam.toLowerCase() > y.nam.toLowerCase(); });
								translation += '&nbsp;Room ' + room + ': (' + users.length + ' users)<br/>';
								for (var i=0; i<users.length; i++){
									translation += '&nbsp&nbsp;&nbsp;' + users[i].nam + ' (' + users[i].ip + ', ' + rankText(users[i].rnk) + ')<br/>';
								}
							}
							break;
						default:
							break;
					}
					
				}

				return translation;
			},
			socketConnected: function(){
				connected = true;
				console.log('X Server: Connected');
				if (reconnect){
					clearTimeout(reconnect);
					reconnect = null;
				}
				if (callback){
					callback();
					callback=null;
				}
				
			},
			socketReceived: function(evt){
				var ttmsg = {}, msg = {};
				try{msg = JSON.parse(evt.data);}catch(err){}
				switch(msg.stx){
					case 'AOK':
						authed = true;
						console.log('X Server: Authed');
						break;
					default: 
						break;
				}
				switch(msg.cmd){
					case 'ani':
						turntable.dispatchEvent('message',functions.translate(msg));
						break;
					case 'stx':
						addChatMessage('http://turntablex.com/images/turntableX.png',0,'TTX','',functions.translate(msg),'verified');
						break;
					case 'msg':
						addChatMessage('http://turntablex.com/images/turntableX.png',msg.uid,msg.nam,'',msg.txt,'verified');
						break;
					default:
						break;

				}
			},
			socketSetup: function(cb){
				if (connected) cb();
				else if (!socket){
					console.log('X Server: creating socket...');
					callback = cb;
					connecting = true;
					socket = new WebSocket('ws://'+addr+':'+port);
					socket.onopen = functions.socketConnected;
	                socket.onmessage = functions.socketReceived;
	                socket.onclose = functions.socketClosed;
	                socket.onerror = functions.serverDisconnect;
	                if (reconnect === null){
	                	reconnect = setInterval(functions.socketReconnect,5000);
	                }
	                
				}
			},
			socketClosed: function(){
				socket = null;
				connected = false;
				authed = false;
				
				if (reconnect)
					clearTimeout(reconnect);
				reconnect = setInterval(functions.socketReconnect,5000);
			},
			socketReconnect: function(){
				if (!connected){
					console.log('X Server: socket closed! Trying to reconnect...');
					functions.serverRegister(getRoom().roomId);
				}
				
			},
			socketSend: function(msg){
				functions.socketSetup(function(){
					socket.send(JSON.stringify(msg));
				});
			},
			serverRegister: function(roomid){
				var msg = {};
				if (!authed){
					msg.aux = turntable.user.auth;
					msg.nam = turntable.user.displayName;
					msg.uid = turntable.user.id;	
				}
				msg.rid = roomid; 
				msg.cmd = 'reg';
				functions.socketSend(msg);
			},
			serverAnimate: function(frame){
				if (_premium)
					if (!authed)
						functions.serverRegister(_room.roomId);
					else if (connected)
						functions.socketSend({cmd:'ani',pla:functions.translate(frame)});
			},
			serverDeregister: function(){
				functions.socketSend({cmd:'der'});
			},
			serverDisconnect: function(){
				if (connected && socket !== null) socket.close();
			},
			sererBroadcast: function(roomid,message){
				var rank = CP();
				if (rank < 2 || (rank < 3 && !roomid))
					return;
				var msg = {cmd:'msg','txt':message};
				if (roomid) msg.rid = roomid;
				functions.socketSend(msg);

			},
			serverStatus: function(roomid,minimal){
				var rank = CP();
				if (rank < 2 || (rank < 3 && !roomid))
					return;
				var msg = {cmd:'sts'};
				if (roomid) msg.rid = roomid;
				if (minimal) msg.min = 1;
				functions.socketSend(msg);
			}
		};
		return {
			register: functions.serverRegister,
			deregister: functions.serverDeregister,
			animate: functions.serverAnimate,
			disconnect: functions.serverDisconnect,
			status: functions.serverStatus,
			broadcast: functions.serverBroadcast,
			socket: socket
		}
	}, Server = new ServerClass();

	initialize();
	function initialize(){
		//inlineCSS('::-webkit-scrollbar-thumb {background-color: rgba(250,0,0, 0.25);border-radius: 15px;border: none;}');

		// add extra midnight styles
		$('<link id="ttx-midnight-css" rel="stylesheet" type="text/css" href="http://turntablex.com/css/midnight.css" disabled/>').appendTo($('head'));
		// load the settings
		loadSettings();

		// skin/css hacks
	    fixCSS();
		skin();
		window.turntable.playlist = requirejs('playlist');
		window.PMWindow = requirejs('pmwindow');
	    resetRoom(function(){
	    	Server.register(_room.roomId);
		    _premium = CP() > 0; // check premium status
		    if (show_features)
	        	showFeatures();
	      	devCSS();
		    modifyQueue();
		    modifyRoom();
		    initializeUI(); // initialize UI elements
		    resetMods(); // new mods
		    resetDJs(); // new DJs
		    resetUsers(); // new users
		    customAvatars();
		    updateGuests(); // update guest list 
		    updateHeader(); // update header
		    initializeListeners(); // create DOM and Turntable event handlers
		    if (settings.laptop.type !== 'default')
		    	setTimeout(function(){setLaptop(settings.laptop.type);},1000);
	    });
	}
	
	

	function showFeatures(){
		customModal('about');
	}
	function devCSS(){
		if (window.location.hash.indexOf('devx') > -1){
			console.log('Developer Mode enabled');
			$('#header .info').css('background','#111');
			devx = true;
		}
	}
	function fixCSS(){
		cssInject({'.zoom-0 #time-left':{'width':'25px','margin-right':'6px'},
					'.zoom-1 #time-left' : {'width':'25px','margin-right':'6px'},
					'#playlist .song:hover .title, #playlist .song:hover .details, #playlist .song.current-song .title, #playlist .song.current-song .details':{'right':'46px'},
					'#chat .message.mention': {'background-color': 'rgb(105, 213, 255)'},
					'#playlist-display':{'right': '4px','left': '4px','width':'auto'},
					'#playlist .song .goTop' : {'bottom':'auto','top':'5px'},
					'#playlist #queue-view .song .remove' : {'right':'25px','top':'auto','bottom':'5px'},
					'#batch-copy-dropdown':{'margin':'-5px 47px'},
					'#playlist-dropdown':{'left':'5px'},
					'#queue-header .done':{'right':'4px','left':'auto'},
					'.open-options':{'border-radius': '9px','opacity':'.5','background':'#000'},
					'.open-options:hover':{'opacity':'1'},
					'#queue-header .remove':{'right': '0px','left': '2px'},
					'.panel-button':{'right': '66px','left': '43px', 'width':'auto'}});
	}
	function buildMentionRegex(){
		var regexString = '';
		for (var i=0;i<settings.notifications.keywords.length;i++){
			var keyword = settings.notifications.keywords[i].replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1");
			if (keyword.length){
				if (i>0){
					regexString += '|';
				}
				regexString += '(?:\\b'+keyword+'\\b)';
			}
		}
		try{
			if (regexString.length){
				return RegExp(regexString,'i');
			}
			else{
				return null;
			}
		}
		catch(err){
			return null;
		}
	}
	
	function skin(revert){
		revert = revert || false;
		if (settings.skin === 'default'){
			if (!revert || typeof(originalClasses) === 'undefined'){
				return; // nothing to do here
			}
			$('#ttx-midnight-css')[0].disabled = true;
			cssInject(originalClasses);
		}
		else{
			// enable dark css
			$('#ttx-midnight-css')[0].disabled = false;
			originalClasses = cssInject(midnightClasses);
		}
	}
	// reset the state of the room
    function resetRoom(callback){
        _room = null;
    	_manager = null;
        _id = null;
       
        for (var o in turntable){
            if (turntable[o] !== null && turntable[o].roomId){
                _room = turntable[o];
 		    	_id = turntable.user.id;
		    	break;
            }
        }
        if (_room){ // found turntable room
        	_room.recenterRoomView = function(){};
            for (var o in _room){
				if (_room[o] !== null && typeof(_room[o]) !== 'undefined' && _room[o].roomData){
					_manager = _room[o];
					break;
				}
			}
     		if (_manager){
     			_location = window.location.pathname; 
			    $(window).unbind('resize');
			    $(window).bind('resize',onResize).resize();
			    log('Entering room: ' + _location);
			    log(_room);
			    log('Found manager');
			    log(_manager);
			    log('Room id: ' + _room.roomId);
			    log('User id: ' + _id);
			    // set current song
			    newSong();
			    // auto vote and DJ 
		   	 	autoVote();
		    	callback();
            }
            else
                setTimeout(function(){ resetRoom(callback); }, 250);
        }
        else
            setTimeout(function(){ resetRoom(callback); },250);
    }

	// called every time there is a song change
	function resetSong(e){
		_currentSong = {};
		_currentSong.id = e.room.metadata.current_song._id;
		_currentSong.fileId = e.room.metadata.current_song.sourceid;
		_currentSong.title = e.room.metadata.current_song.metadata.song;
		_currentSong.artist = e.room.metadata.current_song.metadata.artist;
		_upvoters = {};
		for (var i = 0; i < e.room.metadata.votelog.length; i++)
			_upvoters[e.room.metadata.votelog[i]] = 1;
		_downvoters = {};
		_hearts = {};
		_currentSong.upvotes = e.room.metadata.votelog.length;
		_currentSong.downvotes = 0; // unknown
		_currentSong.hearts = 0; // unknown
		_currentSong.fans = 0;
		_currentSong.dj = e.room.metadata.current_song.djid;

	}
	// called every time there is a DJ change
	function resetDJs(){
		_djs = {};
		for (var i=0;i<_room.roomData.metadata.djs.length;i++)
			_djs[_room.roomData.metadata.djs[i]] = 1;
	}
	// called when there is a room change
	function resetUsers(){
		var users = _room.users;
		var now = new Date().getTime();
		_usernames = {};
		_users = {};
		_idleTimers = {};
		for (var i in users) {
			// map names to ids
			if (typeof _usernames[ users[i].name ] == 'undefined'){
				_usernames[ users[i].name ] = i;
				_users[ i ] = users[i].name;
				_idleTimers[ i ] = now; // last action
				if (CP(i) > 2){
					_room.userMap[i].images.fullfront = 'http://turntablex.com/images/avatars/angel/fullfront.png';
	             	_room.userMap[i].images.headfront = 'http://turntablex.com/images/avatars/angel/icon.png';
	             	_room.userMap[i].custom_avatar = CUSTOM.angel;
					if (i===_id){
						requirejs('user').images.fullfront = 'http://turntablex.com/images/avatars/angel/fullfront.png';
						requirejs('user').images.headfront = 'http://turntablex.com/images/avatars/angel/icon.png';
						requirejs('user').updateAvatarHead();
					}
				}
				else if (CP(i) > 1){
					_room.userMap[i].images.fullfront = 'http://turntablex.com/images/avatars/darkwizard/fullfront.png';
	             	_room.userMap[i].images.headfront = 'http://turntablex.com/images/avatars/darkwizard/icon.png';
	             	_room.userMap[i].custom_avatar = CUSTOM.wizard;
					if (i===_id){
						requirejs('user').images.fullfront = 'http://turntablex.com/images/avatars/darkwizard/fullfront.png';
						requirejs('user').images.headfront = 'http://turntablex.com/images/avatars/darkwizard/icon.png';
						requirejs('user').updateAvatarHead();
					}
				}
			}
		}
		_room.updateGuestList();
	}
	// called when there is a room change
	function resetMods(){
		_mods = {};
		for (var i=0;i<_room.roomData.metadata.moderator_id.length;i++)
			_mods[_room.roomData.metadata.moderator_id[i]] = 1;
	}
	// reset the state of premium access
    function CP(id){
    	id = id || _id;
    	return parseInt((id in _premiumIDs) ? _premiumIDs[id] : 0);
    }
	function isMod(id){
		return typeof _mods[id] !== 'undefined';
	}
	function isDJ(id){
		return typeof _djs[id] !== 'undefined';
	}
	function isCurrentDJ(id){
		if (_currentSong === null)
			return false;
		return id === _currentSong.dj;
	}
	function isUpvoter(id){
		if (_currentSong === null)
			return false;
		return typeof _upvoters[id] !== 'undefined';
	}
	function isDownvoter(id){
		if (_currentSong === null)
			return false;
		return typeof _downvoters[id] !== 'undefined';
	}
	function isHearter(id){
		if (_currentSong === null)
			return false;
		return typeof _hearts[id] !== 'undefined';
	}
	function isBuddy(id){
		return (turntable.user.buddies.indexOf(id) > -1);
	}
	function isFanOf(id){
		return (turntable.user.fanOf.indexOf(id) > -1);
	}
	// initialize event handlers; this should only be done once
    function initializeListeners(){
    	$(window).on("beforeunload unload", function(){
    		console.log("TurntableX unloaded"); saveSettings();
    		Server.deregister();
    		Server.disconnect();
    	});
        turntable.addEventListener('message',onMessage);
    }
	// new user is added
	function onRegistered(e){
		var now = new Date().getTime();
		for (var i in e.user) {
			var id = e.user[i].userid;
			var name = e.user[i].name;
			if (typeof _usernames[name] === 'undefined'){
				_usernames[name] = id;
				_users[id] = name;
				_idleTimers[id] = now;
			}
			notify('onRegistered',id);
		}
	}
	// new user leaves the room
	function onDeregistered(e){
		for (var i in e.user){
			var id = e.user[i].userid;
			var name = e.user[i].name;
			if (typeof _users[id] !== 'undefined'){
				delete _users[id];
				delete _usernames[name];
				delete _idleTimers[id];
			}
			notify('onDeregistered',id);
		}
	}
	function newSong(){
		if (!_room.roomData.metadata || !_room.roomData.metadata.current_song){
			_currentSong = null;
			return;
		}
		var votelog = _room.roomData.metadata.votelog;
		var currentSong = _room.roomData.metadata.current_song;
		var downvotes = _room.roomData.metadata.downvotes;
		var upvotes = _room.roomData.metadata.upvotes;
		_currentSong = {};
		_currentSong.id = currentSong._id;
		_currentSong.fileId = currentSong.sourceid;
		_currentSong.hearts = 0;
		_currentSong.downvotes = downvotes;
		_currentSong.upvotes = upvotes;
		_currentSong.artist = currentSong.metadata.artist;
		_currentSong.title = currentSong.metadata.song;
		_currentSong.dj = currentSong.djid;
		_currentSong.fans = 0;
		
		_upvoters = {};
		_downvoters = {};
		_hearts = {};
		for (var i=0; i<votelog.length; i++){
			var vote = votelog[i];
			if (vote[1] === 'up')
				_upvoters[vote[0]] = 1;
			else
				_downvoters[vote[0]] = 1;
		}
	}
	
	function importLaptop(e){
		if(typeof $(this).data('laptop') !== 'undefined'){
			var laptopData = $(this).data('laptop');
			var laptopName = $(this).data('name');
			if (settings.laptop.stickers.animations[laptopName]){
				var ok = confirm('You already have a laptop called ' + laptopName + ', do you want to save another copy?');
				if (!ok)
					return;
			}
			while (settings.laptop.stickers.animations[laptopName])
				laptopName = laptopName + '_';
			settings.laptop.stickers.animations[laptopName] = $.extend(true,{},laptopData);
			saveSettings();
			updateLaptops();
			$(this).text('Saved as: '+laptopName).addClass('imported');
		}
	}
	function addProfileInformation(name,id,username,placements){
		name.parent().css({'position':'relative'});
		if (settings.debug)
			name.after('<div class="ttx-user-id">'+id+'</div>');
	
		var laptopName = username + "s Laptop";
		var new_frames = [];
		if (typeof placements === 'undefined')
			new_frames.push([]);
		else
			new_frames.push(placements);
		// create a custom laptop and set the import
		var new_laptop = {
			name: laptopName,
			type: 'custom',
			selected: 1,
			speed: 500,
			text: {
				display: '',
				colors: '',
				colorEachLetter: true,
				tick: 1
			},
			frames: new_frames // one frame with no stickers
		};
		$('<div style="position:absolute;right:0px;top:0px;" data-laptop=\''+JSON.stringify(new_laptop)+ '\' data-name="'+laptopName+'" class="ttx-import">Import</div>').insertAfter(name).click(importLaptop);
		
	}
	function onFan(e){
        if (typeof e.fans === 'undefined'){ // profile update
        	if (e.userid && e.name){
        		// remap user to a name
        		var old_name = _users[e.userid];
        		delete _usernames[old_name];
        		_usernames[e.name] = e.userid;
        		_users[e.userid] = e.name;
        		_idleTimers[e.userid] = util.now();
        	}
            return;
        }
		if (_currentSong !== null && e.userid === _currentSong.dj)// current DJ is getting fanned
			_currentSong.fans += e.fans;	
		if (e.userid === _id){ // you are getting fanned
			if (e.fans > 0)
				notify('onFan',e.fanid);
			else
				notify('onUnfan',_id);
		}
	}
	function onVote(e){
		var data = e.room.metadata.votelog[0];
		var id = data[0];
		var vote = data[1];
		var now = new Date().getTime();
		_currentSong.upvotes = e.room.metadata.upvotes;
		_currentSong.downvotes = e.room.metadata.downvotes;
		if (id === '')
			return;
		var name = _users[id];
		_idleTimers[id] = now;
		if (vote === 'up'){
			if ( typeof(_upvoters[id]) === 'undefined' ) // new upvote
				_upvoters[id] = 1;
			if ( typeof(_downvoters[id]) !== 'undefined' ) // .. used to be a downvote
				delete(_downvoters[id]);
		}
		else{
			if ( typeof(_downvoters[id]) === 'undefined' ) // new downvote
				_downvoters[id] = 1;
			if ( typeof(_upvoters[id]) !== 'undefined' ) // .. used to be an upvote
				delete(_upvoters[id]);
		}
	}
	function notify(type,userid,content){
		content = content || '';
		if (_room.userMap[userid]){
			notifyComplete(type,userid,_room.userMap[userid].name,content);
		}
		else{
			send({api:'user.get_profile',userid:userid},function(e){
				notifyComplete(type,userid,e.name,e.avatarid,content);
			});
		}
	}
	function notifyComplete(type,userid,name,content){
		if (settings.notifications[type]['fans'] && !isFanOf(userid) && type != 'onFan' && type != 'onUnfan' )
			return;
		var desktop = settings.notifications[type]['desktop'];
		var chat = settings.notifications[type]['chat'];
		var delay = settings.notifications[type]['timer'];
		switch(type){
			case 'onHeart':
				if (chat){
					addChatMessage('http://turntablex.com/images/heart.png',userid,name,'has saved the song');
				}
				if (desktop){
					addDesktopNotification('http://turntablex.com/images/heart.png',name,'has saved the song',delay);
				}
			break;
			case 'onFan':
				if (chat){
					addChatMessage('http://static.turntable.fm.s3.amazonaws.com/images/room/fan_icon.png',userid,name,'has fanned you');
				}
				if (desktop){
					addDesktopNotification('http://static.turntable.fm.s3.amazonaws.com/images/room/fan_icon.png',name,'has fanned you',delay);
				}
			break;
			case 'onUnfan':
				if (chat){
					addChatMessage('http://turntablex.com/images/turntableX.png',_id,'someone','has un-fanned you');
				}
				if (desktop){
					addDesktopNotification('http://turntablex.com/images/turntableX.png','someone','has un-fanned you',delay);
				}
			break;
			case 'onAddDJ':
				if (chat){
					addChatMessage(getIcon(userid),userid,name,'is now DJing');
				}
				if (desktop){
					addDesktopNotification(getIcon(userid),name,'is now DJing',delay);
				}
			break;
			case 'onRemoveDJ':
				if (chat){
					addChatMessage(getIcon(userid),userid,name,'is no longer DJing');
				}
				if (desktop){
					addDesktopNotification(getIcon(userid),name,'is no longer DJing',delay);
				}
			break;
			case 'onChat':
				if (desktop){
					addDesktopNotification(getIcon(userid),name+':',content,delay);
				}
			break;
			case 'onMention':
				if (desktop){
					addDesktopNotification(getIcon(userid),name+':',content,delay);
				}
			break;
			case 'onNewSong':
				if (chat){
					addChatMessage('http://turntablex.com/images/turntableX.png',userid,name,'has started playing <b>'+_currentSong.title+'</b> by ' + _currentSong.artist);
				}
				if (desktop){
					addDesktopNotification('http://turntablex.com/images/turntableX.png',name,'has started playing '+_currentSong.title+' by ' + _currentSong.artist,delay);
				}
			break;
			case 'onOldSong':
				if (chat){
					addChatMessage('http://turntablex.com/images/turntableX.png',userid,name,'has finished playing <b>' + _currentSong.title + '</b> by ' + _currentSong.artist + ' (' + _currentSong.upvotes + IMAGES.up + ', ' + _currentSong.downvotes + IMAGES.down + ', ' + _currentSong.hearts + IMAGES.heart + ')');
				}
				if (desktop){
					addDesktopNotification('http://turntablex.com/images/turntableX.png',name,'has finished playing <b>' + _currentSong.title + ' by ' + _currentSong.artist + ' (' + _currentSong.upvotes + '+, ' + _currentSong.downvotes + '-, ' + _currentSong.hearts + '<3)',delay);
				}
			break;
			case 'onRegistered': 	
				if (chat){
					addChatMessage(getIcon(userid),userid,name,'has joined the room');
				}
				if (desktop){
					addDesktopNotification(getIcon(userid),name,'has joined the room',delay);
				}
			break;
			case 'onDeregistered':
				if (chat){
					addChatMessage(getIcon(userid),userid,name,'has left the room');
				}
				if (desktop){
					addDesktopNotification(getIcon(userid),name,'has left the room',delay);
				}
			break;
			case 'onPM':
				if (chat){
					addChatMessage(getIcon(userid),userid,util.emojify(name),'whispers:',util.messageFilter(content));

				}
				if (desktop){
					addDesktopNotification(getIcon(userid),name+' whispers:',content,delay);
				}
			break;
			default:
			break;
		}
	}
	function onHeart(e){
		var now = new Date().getTime();
		if (typeof _hearts[e.userid] === 'undefined'){ // new heart
			_hearts[e.userid] = 1;
			_currentSong.hearts = _currentSong.hearts + 1;
		}
		_idleTimers[e.userid] = now;
		notify('onHeart',e.userid);
	}
	function onChat(e){
		var now = new Date().getTime();
		_idleTimers[e.userid] = now;
		if (_room.isMention(e.text)){
			notify('onMention',e.userid,e.text);
		}
		else{
			notify('onChat',e.userid,e.text);
		}
	}
	var last_pmmed = null;
	function onPM(e){
		var name, id = e.senderid;
		last_pmmed = id;
		notify('onPM',e.senderid,e.text);
	}
	function onRemoveDJ(e){
		var auto = true;
		djIndex = _room.roomData.metadata.djs.indexOf(_id);
		for (var i=0; i<e.user.length;i++){
			var user = e.user[i];
			var name = _users[user.userid];
			if (user.userid === _id){ // you were removed, don't try to DJ
				djIndex = -1; 
				stopAnimation();
				auto = false;
			}
			notify('onRemoveDJ',user.userid);

			delete _djs[user.userid];

		}
		if (auto){
			autoDJ();
		}
	}
	var djIndex = -1;
	function onAddDJ(e){
		for (var i=0; i<e.user.length;i++){
			var user = e.user[i];
			var name = _users[user.userid];

			_djs[user.userid] = 1;
			if (user.userid === _id){
				djIndex = _room.roomData.metadata.djs.indexOf(_id);
				animateLaptop(); // start animation - unless there is nothing selected
				
			}
			notify('onAddDJ',user.userid);
		}
	}
	function getIcon(userid){
		return _room.userMap[userid].images.headfront;
	}
	function onNewSong(e){
		if (_currentSong !== null)
			notify('onOldSong',_currentSong.dj);
		resetSong(e);
		autoVote();
		notify('onNewSong',_currentSong.dj);
	}
	function onNoSong(e){
		if (_currentSong !== null)
			notify('onOldSong',_currentSong.dj);
		_currentSong = null;
		$('#ttx-stats-bar').remove();
	}
	function switchRooms(){
		log('Switching rooms...');
		if (_animate.timer !== null){
			clearTimeout(_animate.timer);
			_animate.timer = null;
		}
		resetRoom(function(){
					Server.register(_room.roomId);
					_premium = CP() > 0; // check premium status
					modifyRoom(); // over-ride room functions
	    			initializeUI(); // initialize UI elements
	    			resetMods(); // new mods
	    			resetDJs(); // new DJs
	    			resetUsers(); // new users
	    			updateGuests(); // update guest list 
					updateHeader(); // update header
		});
	}
	var messagesReceived = 0;
	var clickedRoomChange = false;
    function onMessage(e){
        if (e.hasOwnProperty('msgid'))
        	return;
    	messagesReceived += 1;
    	if (e.command !== 'update_sticker_placements'){
    		log('['+messagesReceived+'] Command: ' + e.command);
	    	log(e);
    	}
    	else{
    		if (e.userid === _id && _animate.lastAnimation !== null){
    			_animate.delay = (util.now() - _animate.lastAnimation + 15*_animate.delay) / 16 ;
    		}
    		return;
    	}
	    if (e.command == 'rem_dj') {
			onRemoveDJ(e); // reset djs
			updateGuests();
	    } else if (e.command == 'add_dj') {
			onAddDJ(e); // reset djs
			updateGuests();
	    } else if (e.command == 'speak' && e.userid) {
			onChat(e);
	    } else if (e.command == 'newsong') {
			onNewSong(e);
			updateHeader(); // reflect change in header
	    } else if (e.command == 'update_votes') {
			onVote(e);
			updateGuests();
			updateHeader(); // reflect vote change in header
	    } else if (e.command == 'nosong'){
	    	onNoSong(e);
	    	updateGuests();
	    } else if (e.command == 'update_user') {
	    	onFan(e);
	    	updateGuests();
	    	updateHeader();
	    }
	    else if (e.command == 'registered') {
	    	if( $('#ttx-panels').length === 0 ){ // room change
				switchRooms();
			}
			else{
				onRegistered(e);
				updateGuests();
			}
	    } else if (e.command == 'snagged') {
            onHeart(e);
			updateHeader();
			updateGuests();
	    } else if (e.command == 'pmmed') {
	    	onPM(e);
        } else if (e.command == 'deregistered'){
			onDeregistered(e);
			updateGuests();
	    }
    }
	// update header (UI)
	function updateHeader(){
		if (_currentSong === null)
			return;
		var header = $('.room .name');
		
		var stats_bar = header.find('#ttx-stats-bar');
		if (stats_bar.length === 0){
			header.html(header.text() + '<div id="ttx-stats-bar">\
									     	<span class="ttx-stats-count" id="ttx-stats-hearts"></span>'+IMAGES.heart+'\
									     	<span class="ttx-stats-count" id="ttx-stats-upvotes"></span>'+IMAGES.up+'\
									     	<span id="ttx-stats-title"></span>\
									     	<div id="ttx-stats-bar-sub">\
									     		<span class="ttx-stats-count" id="ttx-stats-fans"></span>'+IMAGES.fan+'\
									     		<span class="ttx-stats-count" id="ttx-stats-downvotes"></span>'+IMAGES.down+'\
									     		<span id="ttx-stats-artist"></span>\
									     	</div>\
									     </div>');
		}
		$('#ttx-stats-hearts').text(_currentSong.hearts);
		$('#ttx-stats-upvotes').text(_currentSong.upvotes);
		$('#ttx-stats-downvotes').text(_currentSong.downvotes);
		$('#ttx-stats-fans').text(_currentSong.fans);
		$('#ttx-stats-title').text(_currentSong.title).attr('title',_currentSong.title);
		$('#ttx-stats-artist').text('by ' +_currentSong.artist).attr('title',_currentSong.artist);
	}
	function addWidescreen(){
	    // make everything widescreen
	    $('#maindiv').css({minWidth:'1200px'});
	    $('#outer').css({width:'100%',maxWidth:'100%',maxHeight:'100%'});
	    $('#turntable').css({maxHeight:'100%',width:'100%',maxWidth:'100%',height:'auto',top:'0px',bottom:'0px',position:'absolute'});
	    $('#header').css({width:'98%',left:'5px'});
	    $('#header .name').css({right:'195px',left:'110px','overflow':'hidden','text-overflow':'ellipsis','max-width':'100%'});
	    $('#header .total-listeners').css('left','110px');
	    $('#header .favorite').css('left','77px');
	    $('#song-search-input').css({width:'auto',right:'10px'});
	}
	function customModal(type,data){
		// create a base modal
		var node = {};
		util.buildTree(turntable.user.layouts.settingsView(), node);
		var $element = node.modal.$node;
		switch(type){
			case 'tag':
				var name = data;
				var displayName = settings.tags.display[name];
				$element.find('.title').text('Edit Tag: ' + displayName);
				var fields = $element.find('.field.settings');
				var content = '<div>\
									<span>Name:</span><input id="ttx-edit-tag-name" type="text" value="'+displayName+'" style="margin-left:5px;display:inline-block;"></input>\
								<div>';
				fields.html(content);
				$element.find('button.submit').unbind('click').bind('click',function(){
					var newName = properTagName($('#ttx-edit-tag-name').val());
					var properName = newName.toLowerCase();
					if (properName === name){
						settings.tags.display[name] = newName;
						$('#overlay').html('').hide();
						saveSettings();
						return; 
					}
					var ok = confirm("Are you sure you want to rename/merge the tag " + displayName + " into " + newName +"?");
					if (ok){

						var indices = renameTag(name,newName); // oldIndex deleted, newIndex inserted
						var oldEntry = $('#ttx-tag-menu-scrollable .option:eq('+indices[0]+')');
						var selected = oldEntry.hasClass('selected') ? ' selected':'';
						oldEntry.remove();
						if (indices[1] > -1){ // if there was an insert and a delete
							var ops = $('#ttx-tag-menu-scrollable .option');
							if (ops.length === 0 || ops.length <= indices[1]){
								$('#ttx-tag-menu-scrollable').append('<div class="option ttx-menu-item'+selected+'" data-name="'+properName+'">'+newName+'<div class="ttx-menu-edit"></div></div>');
							}
						
							else{
								$('#ttx-tag-menu-scrollable .option:eq('+indices[1]+')').before('<div class="option ttx-menu-item'+selected+'" data-name="'+properName+'">'+newName+'<div class="ttx-menu-edit"></div></div>');
							}
							
						}
						else{ // no insert and delete => some other tag might need to be selected
							if (selected !== ''){
								$('#ttx-tag-menu-scrollable .option:eq('+getTagIndex(newName)+')').addClass('selected');
							}
							fixTagMenu();
						}
						
						$('#overlay').html('').hide();
					}

				});
				$element.find('button.cancel').unbind('click').text('Delete').val('Delete').bind('click',function(){
					// delete me
					var ok = confirm('Are you sure you want to delete this tag?');
					if (ok){
						var index = removeTag(name);
						$('#ttx-tag-menu-scrollable .option:eq('+index+')').remove();
						fixTagMenu();
						$('#overlay').html('').hide();

					}
				});
				break;
			case 'notifications':
				$element.find('.title').text('Notifications');
				var fields = $element.find('.field.settings');
				var subtypes = {'chat':'Chat','desktop':'Desktop','fans':'Fans Only','timer':'Time (s)'};
				var types = { onAddDJ: 'DJ steps up', onRemoveDJ: 'DJ steps down', onOldSong: 'Song ends', onNewSong: 'Song begins', onChat: 'Chat message', onMention: 'Chat mention', onHeart: 'User snag', onRegistered: 'User joins', onDeregistered: 'User leaves', onPM: 'Private msg', onFan: 'New fan', onUnfan: 'Un-fan'};
				$element.find('button.submit').unbind('click').bind('click',function(){
					for (var type in types){
						for (var subtype in subtypes){
							if (subtype === 'timer'){
								var time = parseFloat($('#ttx-notifications-'+type+'-'+subtype).val());
								if (isNaN(time)){
									time = 3000;
								} 
								else{
									time *= 1000;
								}
								settings.notifications[type][subtype] = time;
							}
							else{
								settings.notifications[type][subtype] = $('#ttx-notifications-'+type+'-'+subtype).is(':checked');
							}
							
						}
					}
					settings.notifications.keywords = $('#ttx-notifications-keywords').val().split(/\s*,\s*/);
					_mentionRegex = buildMentionRegex();
					saveSettings();
					$('#overlay').html('').hide();
				});
				var keywords = settings.notifications.keywords.join(', ');
				var content = '<div style="margin-bottom:10px"><span style="width:280px;display:block;">Mention Keywords (comma-separated):</span><textarea style="width:400px;height:40px" id="ttx-notifications-keywords">'+keywords+'</textarea></div>';
				content += '<div style="margin-bottom:10px"><span style="width:100px;display:inline-block;font-weight:bold; text-decoration: underline;text-align:left">Type</span>';
				for (var subtype in subtypes){
					content += '<span style="width:80px;font-weight:bold;display:inline-block;text-decoration:underline;text-align:center;">'+subtypes[subtype]+'</span>';
				}
				content += '</div>';
				for (var type in types){
					content += '<div><span style="display:inline-block;width:100px; text-align:left">'+types[type]+'</span>';
					for (var subtype in subtypes){
						content += '<span style="display:inline-block;width:80px;text-align:center">';
						if (subtype === 'timer'){
							content += '<input type="text" style="width: 28px;height:9px;" id="ttx-notifications-'+type+'-timer" value="'+((settings.notifications[type][subtype])/1000.0)+'">';
						}
						else{
							if (!( (types[type].indexOf('Chat') > -1 && subtype === 'chat') || (types[type].indexOf('fan') > -1 && subtype === 'fans' ) ) ) {
								content += '<input type="checkbox" id="ttx-notifications-'+type+'-'+subtype+'" '+(settings.notifications[type][subtype] ? ' checked="checked"':'')+'>';
							}
						}
						
						content += '</span>';	
					}
					content += '</div>';
				}
				fields.html(content);
				
			break;
			case 'about':
				$element.find('.title').html('TurntableX v'+version_string+'<img width="30" src="http://turntablex.com/images/turntableX.png" style="position:absolute;top:3px">');
				var fields = $element.find('.field.settings');
				var changes = '<h2 style="color:#E8C632;text-align:center;width:100%;margin-top:15px;margin-bottom:15px;">Change Log</h2>';
				for (var v in changelog){
					var version_features = changelog[v];
					changes += '<p style="margin-top:10px;font-weight:bold;font-size:15px;margin-bottom:10px">v'+v+'</p><ul style="margin-left:15px">';
					for (var i=0;i<version_features.length;i++){
						if (version_features[i]['premium']){
							changes += '<li style="margin-bottom:5px;color:#E8C632"><b>(PREMIUM) '+version_features[i]['header']+'</b>: '+version_features[i]['content']+'</li>';
						}
						else{
							changes += '<li style="margin-bottom:5px"><b>'+version_features[i]['header']+'</b>: '+version_features[i]['content']+'</li>';
						}
					}
					changes += '</ul>';
				}

				fields.html(changelog_message + changes);
				$element.find('.buttons').hide();
			break;
			case 'settings':
				$element.find('.title').text('Settings');
				var fields = $element.find('.field.settings');
				$element.find('.buttons').append('<button class="submit" id="ttx-settings-import">Import</button><div id="ttx-settings-export-container" style="height:31px;width:80px;position:relative;display:inline-block"><button class="submit" style="width:100%;height:100%;position:relative" id="ttx-settings-export">Export</button></div>');
				$element.find('button.submit:eq(0)').unbind('click').bind('click',function(){
					if($('#ttx-settings-debug').is(':checked')){
						settings.debug = true;
					}
					else{
						settings.debug = false;
					}

					if($('#ttx-settings-chatcommands').is(':checked')){
						settings.chatCommands = true;
					}
					else{
						settings.chatCommands = false;
					}
					settings.chatDelimiter = $('#ttx-settings-chatdelimiter').val();
					if (typeof settings.chatDelimiter === undefined){
						settings.chatDelimiter = defaultSettings.chatDelimiter; // default
					}
					settings.laptop.type = $('#ttx-laptop-select option:selected').val();
					if (settings.laptop.type !== 'default'){
						setLaptop(settings.laptop.type);
					}
					
					saveSettings();
					$('#overlay').html('').hide();
				});
				var content = '<div>\
									<span style="display:inline-block; width: 120px; font-size:14px;">\
										Debug Mode:\
						     		</span>\
						     		<input type="checkbox" id="ttx-settings-debug" '+ (settings.debug === true ? 'checked="checked"' : '') + '/>\
					     		</div>\
					     		<div>\
					     			<span style="display:inline-block; width: 120px; font-size:14px;">\
					     				Chat Commands:\
					     			</span>\
					     			<input type="checkbox" id="ttx-settings-chatcommands" '+ (settings.chatCommands === true ? 'checked="checked"' : '') + '/>\
					     			&nbsp;<span>command delimiter: </span><input type="text" style="width:30px;line-height:10px;height:10px;" id="ttx-settings-chatdelimiter" value="' + (settings.chatDelimiter) +'"/>\
					     		</div>\
					     		<div>\
					     			<span style="display:inline-block; width: 120px; font-size:14px;">\
					     				Laptop:\
					     			</span>\
					     			<select id="ttx-laptop-select">\
					     				<option value="default" '+(settings.laptop.type === 'default' ? 'selected="selected"' : '') +'>default</option>\
					     				<option value="mac" '+(settings.laptop.type === 'mac' ? 'selected="selected"' : '') +'>mac</option>\
					     				<option value="pc" '+(settings.laptop.type === 'pc' ? 'selected="selected"' : '') +'>PC</option>\
					     				<option value="linux" '+(settings.laptop.type === 'linux' ? 'selected="selected"' : '') +'>linux</option>\
					     				<option value="chrome" '+(settings.laptop.type === 'chrome' ? 'selected="selected"' : '') +'>chrome</option>\
					     				<option value="android" '+(settings.laptop.type === 'android' ? 'selected="selected"' : '') +'>android</option>\
					     				<option value="iphone" '+(settings.laptop.type === 'iphone' ? 'selected="selected"' : '') +'>iphone</option>\
					     			</select>\
					     		</div>';

				
				fields.html(content);

				break;
			case 'premium':
				$element.find('.title').text('TurntableX Premium');
			
				var fields = $element.find('.field.settings');
				var content = '';
				var premium = CP();
				if (premium > 2){
					content += '<h2 style="text-align:right;color:#E8C632;padding-bottom:20px;">Status: ADMIN</h2>';
				}
				else if (premium > 1){
					content += '<h2 style="text-align:right;color:#E8C632;padding-bottom:20px;">Status: STAFF</h2>';
				}
				else if (premium > 0){
					content += '<h2 style="text-align:right;color:#E8C632;padding-bottom:20px;">Status: Enabled!</h2>';
					
				}
				else{
					content += '<h2 style="padding-bottom:20px;color:#222;text-align:right;">Status: Not Enabled</h2>';
				}

				content += '<h2 style="text-align:center;margin-bottom:10px;">What is Premium?</h1>';
				content += '<p>Premium is a feature pack that includes several exclusive features such as Auto-DJ and Laptop Animation. To check out the full list of features, you can view the change log by going to X Menu -> About.</p>';
				content += '<h2 style="text-align:center;margin-bottom:10px;margin-top:15px">How do I get Premium features?</h1>';
				content += '<p>You can get Premium by donating 10$ or more to TurntableX here via PayPal:</p><br><div style="text-align:center">'+paypal_premium+'</div><br/><p>If you apply for any discounts, they will be applied automatically but will need to be verified manually. If you apply for a free copy of Premium, send me a PM or e-mail me (see X Menu -> About for discounts and promotions). If you have already donated but you did not know about Premium and would like to get it, contact me at admin@turntablex.com. </p>';
				content += '<h2 style="text-align:center;margin-bottom:10px;margin-top:15px">How does it work?</h1>';
				content += '<p>As soon as your donation is verified by PayPal, you will be added to the TurntableX Premium database, and you will be able to access Premium features as soon as you refresh the page! You will be able to use Premium features from any computer, as long as you log in with the same Turntable account. If you have any trouble, you can always e-mail me and I will make sure you can get Premium working ASAP.</p>';
				content += '<h2 style="text-align:center;margin-bottom:10px;margin-top:15px">Why should I get it?</h1>';
				content += '<p>If you get Premium, you will be able to enjoy some sweet features like laptop animation - share and create visual animations with your friends. You will also be supporting the extension and the development of future features, such as a Queue Manager (re-vamped Queue with built-in tagging), Chat Commands (send PMs and view user stats right from the chat), and Laptop Queue (queue up your animations)!</p>';
				$element.find('.buttons').hide();
				fields.html(content);
				break;
			default:
			break;
		}
		
		node.modal.show();
		if (type=== 'notifications'){
			for (var type in types){
				$('#ttx-notifications-'+type+'-desktop').click(requestNotificationPermission);
			}
		}
		if($('#ttx-settings-export').length){
			var clipboard = new ZeroClipboard.Client();
			
			var text = 'XMSG!' + btoa(JSON.stringify(settings));
			
			clipboard.setText(text);
	    	clipboard.glue('ttx-settings-export',$('#ttx-settings-export-container')[0]);
	    	clipboard.addEventListener('mousedown',function(){
				setTimeout(function(){alert('Settings copied to clipboard!');},500);
	    	});
	    	
		}
		$('#ttx-settings-import').click(function(){
			if ($('#ttx-settings-import-content').length){
				// import settings
				var message = $('#ttx-settings-import-content').val();
				var decoded = JSON.parse(atob(message.slice(5)));
				if (typeof decoded !== 'undefined'){
					settings = decoded;
					saveSettings();
					window.location.reload();
				
				}
				return false;
			}

			$element.find('.field.settings').html('Paste the import and click Import again (your page will refresh automatically):<br/><br/><textarea id="ttx-settings-import-content" cols=50 rows=25></textarea>');
			$element.find('.buttons').children().not('#ttx-settings-import').hide();
		});
		$('#ttx_id').val(_id); // add user ID for premium
	}
	// grab the DJ spot
	function autoDJ(time){
		time = time || settings.autoDJTimer;
		setTimeout(function(){
			if (settings.autoDJ && _room.roomData.metadata.max_djs > _room.roomData.metadata.djs.length ){
				_manager.callback('become_dj');
			}
		},time);
	}
	var autoVoteTimer = null;
	function autoVote(time,vote) {
		vote = vote || 'up';
		if (typeof time === 'undefined'){ // autovote
			if (settings.autoAwesome === false){
				if (autoVoteTimer){
					clearTimeout(autoVoteTimer);
					autoVoteTimer = null;
				}
				return;
			}
			time = randomDelay(5,10);
		}
		if (autoVoteTimer) {
			clearTimeout(autoVoteTimer);
			autoVoteTimer = null;
		}
		if (_currentSong === null)
			return;
		// cast vote at a random delay
		autoVoteTimer = setTimeout(function() {
			// need some safety measures
			var f = $.sha1(_room.roomId + vote + _currentSong.id);
			var d = $.sha1(Math.random() + "");
			var e = $.sha1(Math.random() + "");
			// trigger upvote
			send({
				api: 'room.vote',
				roomid: _room.roomId,
				section: _room.section,
				val: vote,
				vh: f,
				th: d,
				ph: e
			},function(e){console.log(e);});

		}, time);
	}
	function modifyRoom(){
		// chat over-ride
		_room.addUserToMap = function (e) {
        	e.fanof = -1 !== $.inArray(e.userid, turntable.user.fanOf), e.isBuddy = -1 !== $.inArray(e.userid, turntable.user.buddies), this.userMap[e.userid] = e;
        	if (CP(e.userid) > 3){
        		e.images.headfront = 'http://turntablex.com/images/avatars/darkangel/icon.png';
        		e.images.fullfront = 'http://turntablex.com/images/avatars/darkangel/fullfront.png';
        	}
					else if (CP(e.userid) > 2){
        		e.images.headfront = 'http://turntablex.com/images/avatars/angel/icon.png';
        		e.images.fullfront = 'http://turntablex.com/images/avatars/angel/fullfront.png';
        	}
        	else if (CP(e.userid) > 1){
        		e.images.headfront = 'http://turntablex.com/images/avatars/darkwizard/icon.png';
        		e.images.fullfront = 'http://turntablex.com/images/avatars/darkwizard/fullfront.png';
        	}

        };
		_room.appendMessage = function (d) {
            var f = _room.nodes.chatLog,
                c = $(f);
            if (!_room.emptyMessageRemoved) {
                c.find(".default-message").remove();
                _room.emptyMessageRemoved = true;
            }
            _room.checkChatScroll();
            d.find('.ttx-import').click(importLaptop); // import laptop
            if (d.find('.textContainer').length > 0 && d.find('.ttx-chat-timer').length === 0){
				var now = new Date();
				$('<div class="ttx-chat-timer" style="position: absolute; top: 6px; right: 6px; height:12px; font-size: 11px">'+format_time(now)+'</div>').appendTo(d);
			}
            c.append(d);
            _room.updateChatScroll();
            var e = $(f).find(".message");
            if (e.length > 500) {
                e = e.slice(0, 2);
                var b = e.first().outerHeight(true) + e.last().outerHeight(true);
                e.remove();
                if (!_room.chatScrollBottom) {
                    f.scrollTop -= b;
                }
            }
        };
        _room.appendChatMessage = function (f, e, i, c) {
            var d, b = false;
            if (_room.lastChatSpeakerid === f) {
                d = _room.$lastChatMessage;
            } else {
                d = $(util.buildTree(Room.layouts.chatMessage));
                var h;
                if (e == "TURNTABLE") {
                    h = "url(http://static.turntable.fm/roommanager_assets/props/loudspeaker.png)";
                } else {
                    h = "url(" + _room.userMap[f].images.headfront + ")";
                }
                d.find(".avatar").css("background-image", h);
                d.find(".speaker").text(e).data("userid", f);
                b = true;
                _room.lastChatSpeakerid = f;
                _room.$lastChatMessage = d;
            }
            var g = $(util.buildTree(["div.text"]));
            i = util.stripComboDiacritics(i);

            g.html(util.messageFilter(i));
            if (c) {
                d.addClass(c);
            }
            if (b) {
                d.find(".textContainer").append(g);
                _room.appendMessage(d);
            } else {
                _room.checkChatScroll();
                d.find(".textContainer").append(g);
                _room.updateChatScroll();
            }
        }
		var o = requirejs('user');
		var s = requirejs('pmwindow');
		s.prototype.addPMText = function (e, t, n, r) {
                var a, l, u = "/me " === e.substr(0, 4),
                    d = !1;

                if (u) this.lastSpeakerName = null, d = !0, 
                a = $(util.buildTree(s.layouts.pmStatus({}))), 
                a.find(".text").html(util.messageFilter(e.substr(3))),
                a.find(".text .ttx-import").click(importLaptop),
                a.find(".subject").text(t ? o.displayName : this.otherUserName);

                else {
                    var c = "",
                        h = this.lastSpeakerName;
                    t ? (this.lastSpeakerName = c = "Me", l = o.images.headfront) :(this.lastSpeakerName = c = this.otherUserName, l = this.otherUser.images.headfront), null !== h && h === this.lastSpeakerName ? a = this.$lastPMMessage : (a = $(util.buildTree(s.layouts.pm(c, n))),d = !0,this.$lastPMMessage = a,a.find(".avatar").css("background-image", "url(" + l + ")"));
                    var p = $(util.buildTree(["div.text"])).html(util.messageFilter(e));
                    p.find('.ttx-import').click(importLaptop); // import laptop
                    a.find(".textContainer").append(p);
                     if (!r && a.find('.ttx-chat-timer').length === 0){
						var now = new Date();
						$('<div class="ttx-chat-timer" style="position: absolute; top: 6px; right: 6px; height:12px; font-size: 11px">'+format_time(now)+'</div>').appendTo(a);
					}
                }
                var f = r ? $(this.nodes.history) : $(this.nodes.content);
                d && f.append(a), this.redraw(), t || $(this.nodes.container).find("textarea:focus").length || r || ($(this.nodes.header).addClass("newMessage"), this.isOverflow && ($("div#pmOverflowIcon").addClass("newMessage"), $(this.nodes.overflowListItem).addClass("newMessage")), this.playDing(), $(this.nodes.container).one("click", $.proxy(function () {
                    $(this.nodes.header).removeClass("newMessage")
                }, this)))
            };
		var blp = requirejs('buddylistpm');
		if (!blp.prototype._addBuddy){
			blp.prototype._addBuddy = blp.prototype.addBuddy;
			blp.prototype.addBuddy = function(e,t){
				if (CP(e.userid)>3){
					e.images.fullfront = 'http://turntablex.com/images/avatars/darkangel/fullfront.png';
					e.images.headfront = 'http://turntablex.com/images/avatars/darkangel/icon.png';
				}
				else if (CP(e.userid)>2){
					e.images.fullfront = 'http://turntablex.com/images/avatars/angel/fullfront.png';
					e.images.headfront = 'http://turntablex.com/images/avatars/angel/icon.png';
				}
				else if (CP(e.userid)>1){
					e.images.fullfront = 'http://turntablex.com/images/avatars/darkwizard/fullfront.png';
					e.images.headfront = 'http://turntablex.com/images/avatars/darkwizard/icon.png';
				}
				this._addBuddy(e,t);

			};
		}
		_mentionRegex = buildMentionRegex();
		_room.isMention = function(content){
			var name = turntable.user.displayName.toLowerCase();
            if (name[0] == "@")
                name = name.slice(1);
            var status;
            if (content)
            	status = content.toLowerCase().indexOf('@' + name) >= 0;
            if (!status && _mentionRegex !== null)
            	status = _mentionRegex.test(content);
            return status;
		};
		if (typeof _room._showChatMessage === 'undefined'){
			_room._showChatMessage = _room.showChatMessage; // save a copy
		}
		
		util.messageFilter = function(message){
			if (message[0] === 'X' && message.match(/^XMSG!./) !== null){
				try{
					var encoded = message.substring(5);
					var decoded = atob(encoded);
					var laptopSettings = JSON.parse(decoded);
					if (laptopSettings){
						for (var p in laptopSettings){
							if (laptopSettings.hasOwnProperty(p)){
								return '<button data-laptop=\''+JSON.stringify(laptopSettings[p])+'\' data-name="'+p+'" class="ttx-import">Import: '+p+'</button>';
							}
						}
					}
				}
				catch(Exception){
					return 'TTX: Error decoding message';
				}
			}
			return util.emojify(util.linkify(util.safeText(util.memeify(message))));
		}
		// setupprofileoverlay
		_room.setupProfileOverlay = function(e,t){
			 if (e.success) {
	            var n = {};
	            util.buildTree(requirejs('room').layouts.profileView(e), n);
	            var o = n.modal.$node,
	                s = o.find("canvas.laptop");
	            if (t.success) {
	                var r = s[0].getContext("2d"),
	                    a = e.laptop;
	                a in {
	                    iphone: 1,
	                    android: 1
	                } && (a = "mac"), requirejs('sticker').drawLaptopCanvas(e.userid, r, .5, a)
	            } else s.hide();
	            addProfileInformation(o.find('.name'),e.userid,e.name,t.placements);
	            var l = o.find(".acl"), cp = CP(e.userid);
	            if (cp > 1){
					if(cp === 4) o.find('.avatar img').attr('src','http://turntablex.com/images/avatars/darkangel/fullfront.png');
					else if(cp === 3) o.find('.avatar img').attr('src','http://turntablex.com/images/avatars/angel/fullfront.png');
					else if(cp === 2) o.find('.avatar img').attr('src','http://turntablex.com/images/avatars/darkwizard/fullfront.png');
					var extra = CP(e.userid) > 2 ? 'Admin' : 'Staff';

					if (e.acl > 0){
						e.verified = 'superuser';
					}
					if (e.verified) e.verified += ', '+IMAGES.x+' TTX '+extra
					else e.verified = IMAGES.x + ' TTX ' + extra;
					l.html(e.verified);
				}
	            else{
	            	e.verified ? l.text("Verified " + e.verified) : e.acl > 1 ? l.text("gatekeeper") : e.acl > 0 && l.text("superuser");
	            }
	            var u = o.find(".twitter");
	            e.twitter ? u.attr("href", "http://twitter.com/" + e.twitter) : u.hide();
	            var d = o.find(".facebook");
	            e.facebook ? d.attr("href", e.facebook) : d.hide();
	            var c = o.find(".website");
	            e.website || c.hide(), e.twitter || e.facebook || e.website ? c.html(util.linkify(util.safeText(c.html()))) : o.find(".web-links").remove();
	            var h = o.find(".about");
	            e.about ? h.find(".profileText").html(util.brText(util.linkify(util.safeText(e.about)))) : h.hide();
	            var p = o.find(".topartists");
	            e.topartists ? p.find(".profileText").html(util.brText(util.linkify(util.safeText(e.topartists)))) : p.hide();
	            var f = o.find(".hangout");
	            e.hangout ? f.find(".profileText").html(util.brText(util.linkify(util.safeText(e.hangout)))) : f.hide(), n.modal.show()
	        }
   	 	};
	}
	function addAdvancedSettings(){
	    var advancedSettings = $('#ttx-settings-menu');
	    if (advancedSettings.length === 0){
	    	var advancedSettingsTemplate = '<div class="dropdown-container" id="ttx-settings-menu">\
	    		<div id="ttx-settings-button">\
	    			<div class="x-head" style="background-image: url(http://turntablex.com/images/turntableX.png);"></div>\
	    		</div>\
	    		<ul class="floating-menu down" id="ttx-settings-dropdown">\
	    			<li class="option" id="ttx-advanced">Settings</li>\
	    			<li class="option" id="ttx-notifications">Notifications</li>\
	    			<li class="option" id="ttx-premium">Premium</li>\
	    			<li class="option" id="ttx-about">About</li>\
	    		</ul>\
	    	</div>';
	    	$('#header').append(advancedSettingsTemplate);
	    	$('#ttx-advanced').click(function(){
	    		customModal('settings');
	    	});
	    	$('#ttx-about').click(function(){
	    		showFeatures();
	    	});
	    	$('#ttx-notifications').click(function(){
	    		customModal('notifications');
	    	});
	    	$('#ttx-premium').click(function(){
	    		customModal('premium');
	    	});
	    	$('#ttx-settings-menu').mouseover(function(){
	    		if (dockhover){
	    			clearTimeout(dockhover);
	    			dockhover = null;
	    		}
	    		$('#ttx-dock-').removeClass('hover');
	    		$('#ttx-autodj-container').removeClass('hover');
	    		$(this).addClass('hover');
	    	}).mouseout(function(){
				var self = $(this);
				dockhover = setTimeout(function(){ self.removeClass('hover'); },600);
			});
	    }
	    $('#layout-option').remove(); // remove the layout option
	}
	function toggleAutoDJ(e){
		settings.autoDJ = !settings.autoDJ;
		if(settings.autoDJ){
			autoDJ(0);
			$('#ttx-autodj-label').html(msFormat(settings.autoDJTimer));
			$('#ttx-autodj-container').addClass('hover');
		}
		else{
			$('#ttx-autodj-label').html('OFF');
			$('#ttx-autodj-container').removeClass('hover');
			if(dockhover){
				clearTimeout(dockhover);
				dockhover = null;
			}
		}
		saveSettings();
		$(this).toggleClass('active');
		e.preventDefault();
	}
	function toggleAutobop(e){
		settings.autoAwesome = !settings.autoAwesome;
		if(settings.autoAwesome){
			autoVote(0);
		}
		saveSettings();
		$(this).toggleClass('active');
		e.preventDefault();
	}
	function requestNotificationPermission(){
		
	    if(!window.webkitNotifications || (window.webkitNotifications.checkPermission() == 0))
	       return;
	    window.webkitNotifications.requestPermission();
	
	}
	function addDesktopNotification(icon, title, message, delay){
		
		
		var note = window.webkitNotifications.createNotification(icon,title,message);
	
		note.ondisplay = function() {
			setTimeout(function() {
				note.cancel();
			}, delay);
		};
		note.show();
	}
	function addAutoButtons(){
		if ($('#ttx-auto-buttons').length === 0){
			$('#header .info').append('<ul class="header-well-buttons" id="ttx-auto-buttons">\
    										<li class="dropdown-container ttx-tooltip" original-title="Toggle Auto-Awesome" id="ttx-autobop-container">\
    											<div class="header-well-button" id="ttx-autobop-button"/>\
    										</li>\
    					     			</ul>');
			var autoDJcontent = '<li class="dropdown-container ttx-tooltip" original-title="Toggle Auto-DJ" id="ttx-autodj-container">\
												<div id="ttx-autodj-label"></div>\
    											<div class="header-well-button" id="ttx-autodj-button"/>\
    											<ul class="floating-menu down" id="ttx-autodj-menu">\
													<div id="ttx-autodj-slider">\
														<div id="ttx-autodj-knob" style="top:18px;"></div>\
														<div id="ttx-autodj-fill" style="height:87px;">\
														</div>\
													</div>\
												</ul>\
    										</li>';
    		var autoDJoffset = settings.autoDJTimer / 50;
			$('#ttx-autobop-container').after(autoDJcontent).tipsy({gravity:'n',opacity:1,fade:true});
			$('#ttx-autodj-container').tipsy({gravity:'w',fade:true,opacity:1});
			$('#ttx-autodj-label').unbind('click');
			if(settings.autoDJ){ // only premium can auto-dj
				$('#ttx-autodj-button').addClass('active');
				$('#ttx-autodj-label').html(msFormat(settings.autoDJTimer));
			}
			else
				$('#ttx-autodj-label').html('OFF');
			if (settings.autoAwesome)
				$('#ttx-autobop-button').addClass('active');
			$('#ttx-autodj-knob').css('top',autoDJoffset+'px');
			$('#ttx-autodj-fill').css('height',(105-autoDJoffset)+'px');
			$('#ttx-autodj-container').mouseover(function(){
				if (!$('#ttx-autodj-button').hasClass('active'))
					return;
				if (dockhover){
					clearTimeout(dockhover);
					dockhover = null;
				}
				$(this).addClass('hover');
				$('#ttx-dock-').removeClass('hover');
				$('#ttx-settings-menu').removeClass('hover');
			}).mouseout(function(){
				var self = $(this);
				dockhover = setTimeout(function(){ self.removeClass('hover'); },600);
			});
			$('#ttx-autobop-button').click(toggleAutobop);
			$('#ttx-autodj-button').click(toggleAutoDJ);
			$('#ttx-autodj-knob').draggable({containment:$('#ttx-autodj-slider'),axis:'y',drag:function(ev,ui){
				var offset = ui.position.top;
				// 0 => max speed (0.10s)
				// 99 => min speed (5.10s)
				// 100 => off
				var displaySpeed;
				if (offset < 0){
					offset = 0;
				}
				settings.autoDJTimer = 50*Math.round(offset);
				saveSettings();
				displaySpeed = msFormat(settings.autoDJTimer);
				$('#ttx-autodj-label').text(displaySpeed);
				$('#ttx-autodj-fill').css('height',(105-ui.position.top)+'px');
				
			}});
		}
		
	}
	function addLightSwitch(){
		$('#header .info').css('right','230px');
		$('#switch-room').css('right','110px');
		$('#header .userauthContainer').css('right','50px').after('<div style="position:absolute;top:15px;right:10px;"><div class="header-well-button" id="ttx-light-switch"/></div>');
		if (settings.skin === 'default')
			$('#ttx-light-switch').addClass('active');
		$('#ttx-light-switch').click(function(){
			$(this).toggleClass('active');
			if ($(this).hasClass('active')){ // we are reseting to default
				settings.skin = 'default';
				skin(true);
			}
			else{ // we are changing to dark
				settings.skin = 'midnight';
				skin();
			}
			saveSettings();
		});
	}

	var updateTimer = null;
	// perform graphical manipulation
    function initializeUI(){
		if (updateTimer)
			clearTimeout(updateTimer);
		updateTimer = setInterval(function(){updateGuestsIdle();},500);
		addChatCommands(); // 
		addWidescreen(); // make it widescreen
		addPanels(); // create the room/info panels
		addAdvancedSettings(); // create the advanced settings menu entry
		addLaptopSettings(); // create the laptop settings button
		addLightSwitch(); // add the light switch (skin change)
		addAutoButtons(); // add autobop and autodj buttons
		$(window).resize(); // trigger resize
    }

// END CORE

// START ROOM
	function updateGuestsIdle(){
		var $idles = $('#guest-list .guestIdle');
		if (!$idles.length){
			updateGuests();
			return;
		}
		$idles.each(function(){
			var id = $(this).data('user');
			if (!id){
				return;
			}
			var idleText = formatTimeDelta(_idleTimers[id]);
			if (idleText){
				$(this).html(idleText);
			}
		});
	
	}
	// update guest list (UI)
	var guestsTimer = null;
	function updateGuests(){
		if (guestsTimer !== null) {
			clearTimeout(guestsTimer);
			guestsTimer = null;
		}
		// attempt to repaint the DOM in 50 ms unless cancelled
		guestsTimer = setTimeout(function() {
			// get the current time
			var now = new Date().getTime();
			// update the chat box
			var guest_container = $('.guest-list-container .guests');
			var guests = $('.guest-list-container .guest');
			var hasBuddies = false;
			var idles = 0;
			var all_icons = {'heart':1,'upvote':1,'downvote':1};
			guests.each(function() {
				var $this = $(this);
				var $name = $this.find('.guestName');
				var username = $name.text();
				if (typeof _usernames[username] != 'undefined') {
					var user_id = _usernames[username];
					// update extra classes and idle time
					var curIcons = {};
					var extrasClass = ' ';
					var iconDiv = $this.find('.icons');
					if (isCurrentDJ(user_id)){
						extrasClass = extrasClass + ' isCurrentDJ';
					}
					if (isHearter(user_id)){
						extrasClass = extrasClass + ' isHearter';
						curIcons['heart'] = 1;
					}
					if (isUpvoter(user_id)){
						extrasClass = extrasClass + ' isUpvoter';
						curIcons['upvote'] = 1;
					}
					if (isDownvoter(user_id)){
						extrasClass = extrasClass + ' isDownvoter';
						curIcons['downvote'] = 1;
					}
					for (var icon in all_icons){
						if (typeof curIcons[icon] === 'undefined')
							iconDiv.find('.ttx-icon.'+icon).remove();
						else
							if (iconDiv.find('.ttx-icon.'+icon).length === 0)
								iconDiv.append(ICONS[icon]);
					}
					$this.removeClass('isUpvoter isDownvoter isHearter isIdle isCurrentDJ').addClass(extrasClass);
					if (now - _idleTimers[user_id] > IDLE_MAX){
						extrasClass = extrasClass + ' isIdle';
						idles += 1;
					}
					var idle = $this.find('.guestIdle');
					var idleText = formatTimeDelta(_idleTimers[user_id]);
					if (idle.length)
						idle.html(idleText);
					else
						$name.after('<div class="guestIdle" data-user="'+user_id+'" style="position: absolute; bottom: 0px; right: 25px; width: 50px; height: 28px; line-height: 28px; overflow: hidden; text-align: right">' + idleText + '</div>');
				}
			});
			if (idles >= 0){
				if ($('#ttx-afk-users').length === 0){
					var guestList = $('#guest-list');
					guestList.find('.title').css({'text-align':'right','margin-right':'10px'});
					$('#totalUsers').after($('<span id="ttx-afk-users"> (' + idles + ' AFK)</span>'));
				}
				else{
					$('#ttx-afk-users').text(' (' + idles + ' AFK)');
				}
			}
		},100);
	}
// END ROOM
// START PANEL
	var _panels;
	function onResize(){
		var width = 0;
		$('#ttx-panels .ttx-panel').each(function(){
			if ($(this).hasClass('full') === false){
				width += ($(this).width()+PANEL_PADDING);
			}
		});
		var sceneWidth = $('#ttx-panels').width() - width - PANEL_PADDING - 25;
		
		$('#ttx-panels-scene').css({width: sceneWidth+'px'});
		$('#scene').css({width:'1468px',height:'100%',left:'auto',right:'50%',top:'50%',marginTop:'-300px',marginLeft:'0px',marginRight:'-734px'})
	}
	// docking a floating panel back into the dock
	function onPanelDock(e){
		var panelName, panel = $(this).parents('.ttx-panel');
		if(panel.attr('id') === 'right-panel'){
			panelName = 'chat';
		}
		else{
			panelName = panel.attr('id').replace('ttx-panels-','');
		}
		if (panel.hasClass('float')){ // redocking
			// fix settings
			settings.panels[panelName].type = 'docked';
			settings.panels[panelName].height = '100%';
			settings.panels[panelName].left = 0;
			settings.panels[panelName].right = 0;
			settings.panels[panelName].top = 0;
			settings.panels[panelName].bottom = 0;
			// push it into the dock
			var target = null;
			$('#ttx-panels .ttx-panel').each(function(){
				if (target === null && $(this).offset().left < panel.offset().left && panel.offset().left < $(this).offset().left + $(this).width() ){
					target = $(this);	
				} 	
			});
			if (target === null){ // add it into the dock at the end
				panel.appendTo($('#ttx-panels'));
			}
			else{
				if (panel.offset().left - target.offset().left < target.offset().left + target.width() - ( panel.offset().left + panel.width() ) ){
					target.before(panel.detach());
				}
				else{
					target.after(panel.detach());
				}
			}
			panel.removeClass('float').draggable('destroy').resizable('destroy').resizable(dockedPanelResizable).css({'height':'100%','position':'relative','top':'0px','bottom':'0px','left':'0px','right':'0px'});
			// remove from float manager
			delete _panels['float'][panelName];
			
		}
		else{ // undocking

			settings.panels[panelName].type = 'float';
			settings.panels[panelName].height = '500px';
			settings.panels[panelName].right = 0;
			settings.panels[panelName].left = panel.offset().left;
			settings.panels[panelName].top = 200;
			settings.panels[panelName].bottom = 0;
			
			panel.addClass('float').resizable('destroy').resizable(floatingPanelResizable).draggable(floatingPanelDraggable).css({'height':'500px','position':'absolute','top':'200px','bottom':'auto','left':settings.panels[panelName].left + 'px', 'right':'auto'}).appendTo($('.roomView'));
		}
		// reset dock manager
		_panels.dock = [];
		$('#ttx-panels .ttx-panel').each(function(){
			var name;
			if ($(this).attr('id')==='right-panel'){
				name = 'chat';
			}
			else{
				name = $(this).attr('id').replace('ttx-panels-','');
			}
			_panels.dock.push(name);
		});
		$(window).resize();
		saveSettings();
	}
	function onPanelMinimize(e){
		e.preventDefault();
		e.stopPropagation();

		var panelName, panel = $(this).parents('.ttx-panel');
		if(panel.attr('id') === 'right-panel'){
			panelName = 'chat';
		}
		else{
			panelName = panel.attr('id').replace('ttx-panels-','');
		}


		// add panel entry to the dock
		$('#ttx-dock-menu').append($('<li class="option">'+panelName+'</li>').click(onPanelMaximize));
		var fixDock = false;
		if (panelName in _panels['float']){ // float panel
			delete _panels['float'][panelName];
		}
		else{
			fixDock = true;
		}
		if(panelName === 'chat'){
			$('#right-panel').addClass('hidden').detach().appendTo($('.roomView'));
		}
		else{
			$('#ttx-panels-'+panelName).addClass('hidden').detach().appendTo($('.roomView'));
		}
		$(window).resize();
		
		settings.panels[panelName].hidden = true;
		_panels.hidden[panelName] = 1;
		var hiddens = numHiddenPanels();
		if (fixDock){
			_panels.dock = [];
			$('#ttx-panels .ttx-panel').each(function(){
				var name;
				if ($(this).attr('id')==='right-panel'){
					name = 'chat';
				}
				else{
					name = $(this).attr('id').replace('ttx-panels-','');
				}
				_panels.dock.push(name);
			});
		}
	
		$('#ttx-dock').removeClass('empty');
		$('#ttx-dock-menu').css('visibility','visible');
		$('.ttx-dock-count').text(hiddens);
		saveSettings();
	}
	var floatingPanelDraggable = { 'containment': '#ttx-panels', 'handle': '.floating-panel-tab', 'stop': onFloatingPanelDrag };
	var floatingPanelResizable = { 'handles':'n, e, w, s, ne, sw, se, nw','stop': onFloatingPanelResize };
	var dockedPanelResizable = {'stop': onDockedPanelResize, 'handles':'e'};
	
	function onFloatingPanelDrag(event,ui){
		var name, id = $(this).attr('id');
		if (id === 'right-panel'){
			name = 'chat';
			scrollChat();
		}
		else{
			name = id.replace('ttx-panels-','');
		}
		if (ui.position.top >= 65){
			settings.panels[name].top = ui.position.top;
		}
		else{
			settings.panels[name].top = 65;
			$(this).css('top','65px');
		}
		settings.panels[name].left = ui.position.left;
		saveSettings();
	}
	function onFloatingPanelResize(event,ui){ 
		var name, id = $(this).attr('id');
		if (id === 'right-panel'){
			name = 'chat';
			scrollChat();
		}
		else{
			name = id.replace('ttx-panels-','');
		}
		settings.panels[name].width = ui.size.width;
		settings.panels[name].height = ui.size.height + 'px';
		settings.panels[name].top = $(this).offset().top;
		if (settings.panels[name].top < 65){
			settings.panels[name].top = 65;
			$(this).css('top','65px');
		}
		settings.panels[name].left = $(this).offset().left;
		saveSettings();
	}
	function onDockedPanelResize(event,ui){
		var name, id = $(this).attr('id');
		if (id === 'right-panel'){
			name = 'chat';
		}
		else{
			name = id.replace('ttx-panels-','');
		}
		$(this).css({'height':'100%','bottom':'0px','top':'0px'});
		settings.panels[name].width = ui.size.width;
		saveSettings();
	}
	
	function onPanelStop(event,ui){
		if (ui.item.parent().attr('id') !== 'ttx-panels'){ // dock -> floating
			if (ui.offset.top <= 0.25 * $('#ttx-panels').height()){
				
				ui.item.css({'height':'100%','position':'relative','top':'0px','left':'0px'}).prependTo($('#ttx-panels'));
				_panels.dock = [];
				$('#ttx-panels .ttx-panel').each(function(){
					var name;
					if ($(this).attr('id')==='right-panel'){
						name = 'chat';
					}
					else{
						name = $(this).attr('id').replace('ttx-panels-','');
					}
					_panels.dock.push(name);
					settings.panels[name].index = $(this).index();
				});
				saveSettings();
				return;
			}
			ui.item.addClass('float').css({top:ui.placeholder.css('top'),left:ui.placeholder.css('left'),position:'absolute',width:ui.placeholder.width()+'px',height:'300px'}).draggable(floatingPanelDraggable).resizable('destroy').resizable(floatingPanelResizable);
			var id = ui.item.attr('id');
			var name;
			if (id === 'right-panel'){
				name = 'chat';
			}
			else{
				name = id.replace('ttx-panels-','');
			}
			_panels['float'][name] = 1;
			// reset dock
			_panels['dock'] = [];
			var docked = $('#ttx-panels > *');
			for (var i=0;i<docked.length;i++){
				var panel_name;
				if (docked[i].id === 'right-panel'){
					panel_name = 'chat';
				}
				else{
					panel_name = docked[i].id.replace('ttx-panels-','');
				}
				_panels['dock'].push(panel_name);
			}	
			settings.panels[name].left = parseInt(ui.item.css('left'));
			settings.panels[name].top = parseInt(ui.item.css('top'));
			settings.panels[name].type = 'float';
			settings.panels[name].height = '300px';
			settings.panels[name].width = ui.item.width();
			saveSettings();
		}
		
		$(window).resize();
	}
	// during dock sort
	function onPanelMove(event,ui){
		if (ui.offset.top > 0.25 * $('#ttx-panels').height()){
			ui.helper.data('originalHeight',ui.helper.height());
			ui.helper.css('height','300px');
			var placeholder = $(this).find('.placeholder');
			if (placeholder.length){
				placeholder.detach().appendTo('.roomView');
				placeholder.css({position:'absolute',left:ui.offset.left,top:ui.offset.top});
			}
			else{
				placeholder = $('.roomView .placeholder');
				placeholder.css({left:ui.offset.left,top:ui.offset.top});
			}
			ui.helper.detach().appendTo('.roomView');
	
			$(this).sortable('refresh');
			
		}
		else{
			ui.helper.css('height','100%').detach().appendTo('#ttx-panels');
			ui.placeholder.css({left:'0px',top:'0px',position:'relative'});
		}
		$(window).resize();
	}
	function onPanelReorder(event,ui){
		var new_dock = [];
		if (ui.item.attr('id')==='right-panel'){
			scrollChat();
		}
		$(this).children().each(function(){
			var name;
			if($(this).attr('id') === 'right-panel'){
				name = 'chat';
			}
			else{
				name = $(this).attr('id').replace('ttx-panels-','');
			}
			settings.panels[name].index = $(this).index(); // update the index
			new_dock.push(name);
		});
		_panels.dock = new_dock;
		saveSettings();
	}
	function numHiddenPanels(){
		var hiddens = 0;
		for (var i in _panels.hidden){
			if (_panels.hidden.hasOwnProperty(i) && _panels.hidden[i] === 1){
				hiddens += 1;
			}
		}
		return hiddens;
	}
	function onPanelMaximize(){
		var name = $(this).text();
		var type = settings.panels[name].type;
		var container;
		var panel;

		if(name === 'chat'){
			panel = $('#right-panel');	
		}
		else{
			panel = $('#ttx-panels-'+name);
		}

		settings.panels[name].hidden = false;
		if (type === 'docked'){
			container = $('#ttx-panels');
			var index = settings.panels[name].index;
			if (index >= _panels.dock.length){ // append to the end
				$('#ttx-panels').children().last().after(panel.detach());
				settings.panels[name].index = _panels.dock.length;
			}
			else { // put it in place and increment the others
				container.find('.ttx-panel').each(function(){
					var panel_name;
					if ($(this).attr('id')==='right-panel'){
						panel_name = 'chat';
					}
					else{
						panel_name = $(this).attr('id').replace('ttx-panels-','');
					}
					var my_index = $(this).index();
					if (my_index === index){
						$(this).before(panel.detach());
						settings.panels[name].index = my_index;
						my_index += 1; // incremenet by 1 
					}
					settings.panels[panel_name].index = my_index;
				});
			}
			panel.removeClass('hidden').mousedown().mouseup();

			// refresh the dock
			_panels.dock = [];
			$('#ttx-panels > *').each(function(){
				var panel_name;
				if ($(this).attr('id') === 'right-panel'){
					panel_name = 'chat';
				}
				else{
					panel_name = $(this).attr('id').replace('ttx-panels-','');
				}
				_panels.dock.push(panel_name);
			});
			
			
			$(window).resize();
		}
		else{ 
			container = $('.roomView');
			_panels['float'][name] = 1;
			panel.removeClass('hidden').appendTo(container).mousedown().mouseup();
		}
		if (name === 'chat'){
			scrollChat();
		}
		
		delete _panels.hidden[name];
		var hiddens = numHiddenPanels();
		if (numHiddenPanels() === 0){
			$('#ttx-dock').addClass('empty');
			$('#ttx-dock-menu').css('visibility','hidden');
		}
		else{
			$('#ttx-dock').removeClass('empty');
			$('#ttx-dock-menu').css('visibility','visible');
		}
		$('.ttx-dock-count').text(hiddens);
		saveSettings();
		
		$('#ttx-dock-').removeClass('hover');
		$(this).remove();
	}

	var dockhover;
	var PANEL_PADDING = 5; // pad by 5 px
	var PANEL_WIDTH = 265; // default width for a panel
	function addPanels(){
	    $('[id="ding-menu"]').css('z-index',999);
	    _panels = { 'dock': [], 'float': {}, 'hidden': {}, 'nodes': {} };
	    
		for (var i in settings.panels){
			if(!settings.panels.hasOwnProperty(i)){
				continue;
			}
			if (settings.panels[i].hidden === true){
				_panels.hidden[i] = 1;
			}
			else if (settings.panels[i].type === 'docked'){
				_panels.dock.push({index:settings.panels[i].index, name:i});
			}
			else{
				_panels['float'][i] = 1;
			}
		}
		_panels.dock.sort(function(a,b){
			return a.index >= b.index;
		});
		for (var i=0;i<_panels.dock.length;i++){
			_panels.dock[i] = _panels.dock[i].name;
		}
		var hiddens = numHiddenPanels();

 	    // add dock area in header
	    $('#header .info').css('left','200px');
	    $('#header .logo').after('<div id="ttx-dock-">\
	    <div class="dropdown-container" id="ttx-dock-container">\
		<div id="ttx-dock">\
			<span class="ttx-dock-count">'+hiddens+'</span>\
		</div>\
		<ul class="floating-menu down" id="ttx-dock-menu">\
		</ul>\
	    </div>\
	    </div>');
	    $('#ttx-dock').mouseover(function(){
			var $dockCount = $(this).find('.ttx-dock-count').addClass('hover');
			
			if ($(this).hasClass('empty')){
				$dockCount.text('\u25B2');
			}
			else{
				$dockCount.text('\u25BC');
			}
		}).mouseout(function(){
			var $dockCount = $(this).find('.ttx-dock-count').removeClass('hover');
			
			$dockCount.text(numHiddenPanels());

		}).css('cursor','pointer').click(function(){
			if ($(this).hasClass('empty')){
				// suck up all windows
				$('.ttx-controls-minimize').click();
			}
			else{
				// spit out all windows
				$('#ttx-dock-menu').children().click();
			}
			$(this).trigger('mouseover');
		});

	    $('#ttx-dock-').mouseover(function(){
			if (dockhover){
				clearTimeout(dockhover);
				dockhover = null;
			}
			$('#ttx-settings-menu').removeClass('hover');
			$('#ttx-autodj-container').removeClass('hover');
			$(this).addClass('hover');
		}).mouseout(function(){
			var self = $(this);
			dockhover = setTimeout(function(){ self.removeClass('hover'); },600);
		});
	    if (hiddens > 0){
	    	for (var i in _panels.hidden){
	    		if(_panels.hidden.hasOwnProperty(i)){
	    			$('<li class="option">'+i+'</li>').click(onPanelMaximize).appendTo('#ttx-dock-menu');
	    		}
			}
			$('#ttx-dock').removeClass('empty');
			$('#ttx-dock-menu').css('visibility','visible');
	    }
	    else{
		$('#ttx-dock').addClass('empty');
	    	$('#ttx-dock-menu').css('visibility','hidden');
	    }
	    $('.ttx-dock-count').text(hiddens);

		// fix up chat
	    var rightPanel = $('#right-panel').css({'right':'auto','top':settings.panels.chat.top+'px','bottom':'0px','height':settings.panels.chat.height,'marginLeft':'5px','width':(settings.panels.chat.width === 'auto' ? PANEL_WIDTH : settings.panels.chat.width)+'px','left':settings.panels.chat.left+'px','float':'left','position':(settings.panels.chat.type==='docked'? 'relative':'absolute'),'marginRight':'0px'}).addClass('ttx-panel');
	    $('#chat-input').css({width:'auto',right:'5px'});
	    $('.chat-container').addClass('selected').css({width:'100%'}).unbind('click')
	    .find('.tab-icon').css('background-position','0px 0px');
	    _panels['nodes']['chat'] = rightPanel;

	    $('#left-panel').hide();

	    // add a panel around the scene
	    if ($('#ttx-panels-scene').length===0){
	    	rightPanel.before('<div id="ttx-panels-scene" class="ttx-panel full no-header" style="position:relative;margin-left:5px;overflow:hidden;float:left;height:100%;width:100px;"></div>');
	    }
	    _panels['nodes']['scene'] = $('#ttx-panels-scene');

	    $('#scene').css({width:'1468px',height:'100%',left:'auto',right:'50%',top:'50%',marginTop:'-300px',marginLeft:'0px',marginRight:'-734px'}).appendTo($('#ttx-panels-scene'));
	    
	    // add a panel around the room
	    if ($("#ttx-panels-room").length===0){
	    	 rightPanel.before('<div id="ttx-panels-room" class="floating-panel ttx-panel" style="left:'+settings.panels.room.left+'px;position:'+(settings.panels.room.type==='docked' ? 'relative':'absolute')+';margin-left:5px;overflow:hidden;float:left;height:'+settings.panels.room.height+';top:'+settings.panels.room.top+'px;width:'+(settings.panels.room.width === 'auto' ? PANEL_WIDTH : settings.panels.room.width)+'px;"><ul id="ttx-panels-room-tabs"></ul></div>');
	    }
	    _panels['nodes']['room'] = $('#ttx-panels-room');

	    $('#room-info-container').css({width:'100%'}).addClass('selected').appendTo("#ttx-panels-room-tabs")
	    .find('.tab-icon').css('background-position','0px -31px');
	    
	    // add a panel around the queue
	    if ($("#ttx-panels-queue").length===0){
	    	 $('#right-panel').before('<div id="ttx-panels-queue" class="floating-panel ttx-panel" style="left:'+settings.panels.queue.left+'px;position:'+(settings.panels.queue.type==='docked' ? 'relative':'absolute')+';margin-left:5px;overflow:hidden;float:left;height:'+settings.panels.queue.height+';top:'+settings.panels.queue.top+'px;width:'+(settings.panels.queue.width === 'auto' ? PANEL_WIDTH : settings.panels.queue.width)+'px;"><ul id="ttx-panels-queue-tabs"></ul></div>');
	    }
	    _panels['nodes']['queue'] = $('#ttx-panels-queue');

	    $('#playlist-container').css({width:'100%'}).addClass('selected').appendTo('#ttx-panels-queue-tabs');
	    $('#playlist-container')
  	    .find('.tab-icon').css('background-position','0px -15px');
	    

	    
	    var tabs = $('.floating-panel-tab').removeClass('left-divider').css({'background': '-webkit-linear-gradient(top,#999 0,#777 100%)','border-top-left-radius':'5px','border-top-right-radius':'5px',width:'100%'});
	    
	    tabs.append($('<div class="ttx-controls"><div class="ttx-controls-dock"></div><div class="ttx-controls-minimize"></div></div>'));
	    $('.ttx-controls-minimize').click(onPanelMinimize);
	    $('.ttx-controls-dock').click(onPanelDock);
	    tabs.css({'box-shadow': 'inset 0 1px 0 0 rgba(255, 255, 255, 0.25),inset 0 -1px 0 0 #222',
	    'background': '-moz-linear-gradient(top,#999 0,#777 100%)',
	    'cursor': 'pointer',
            'border-right': 'solid 1px #444'})
	    .find('h2').css('color','#323232');

	   
	    if ( settings.panels.chat.hidden ){
	    	rightPanel.addClass('hidden');
	    }
	    if ( settings.panels.chat.type === 'float' ){
	    	rightPanel.addClass('float');
	    }
	    if ( settings.panels.room.hidden){
	    	_panels['nodes']['room'].addClass('hidden');
        }
        if ( settings.panels.room.type === 'float'){
        	_panels['nodes']['room'].addClass('float');
        }
    	if (settings.panels.queue.hidden){
 			_panels['nodes']['queue'].addClass('hidden');
    	}
    	if (settings.panels.queue.type === 'float'){
    		_panels['nodes']['queue'].addClass('float');	
    	}
	    if ($('#ttx-panels').length === 0){
			var panels = $('<div id="ttx-panels" style="position:absolute;left:0px;right:0px;top:65px;bottom:35px;overflow:hidden;"/>');
			rightPanel.before(panels);
			panels = $('#ttx-panels');
			var floating_panels = $('.roomView');

			$('.ttx-panel').each(function(){
				$(this).mousedown(function(){
					$(this).parent().parent().find('.ttx-panel').removeClass('ttx-panel-focus');
					if ($(this).attr('id') !== 'ttx-panels-scene')
						$(this).addClass('ttx-panel-focus');
				});
			
				if($(this).hasClass('float')){ // add to floating panels
					$(this).appendTo(floating_panels);
					try{
						$(this).resizable(floatingPanelResizable).draggable(floatingPanelDraggable).resizable('option','minWidth',PANEL_WIDTH).resizable('option','minHeight',PANEL_WIDTH);
					}

					catch(err){}
				}
			});
			for (var i=0;i<_panels.dock.length;i++){
				var tgt, name = _panels.dock[i];
				tgt = _panels['nodes'][name];
				tgt.appendTo(panels);
				try{
					tgt.resizable(dockedPanelResizable).resizable('option','minWidth',PANEL_WIDTH).resizable('option','handles','e');
				}
				catch(err){}
			}
			$('#ttx-panels').sortable({ update:onPanelStop, sort:onPanelMove, appendTo:document.body,revert:100,placeholder:'placeholder',tolerance:'intersect',scroll:false,handle:'.floating-panel-tab',start:function(event,ui){ var width = ui.helper.width(); $(this).find('.placeholder').width(width); },stop:onPanelReorder}); $(window).resize();
	    }
	}
// END PANELS
// START CHAT
	function scrollChat(){
		var messages= $('#chat .messages');
		messages.scrollTop(messages.prop('scrollHeight'));
	}
	function handleWhois(id,loud){
		loud = loud || false;
		var message;

		send({api:'user.get_profile',userid:id},function(ev){

			if (ev.name){
				var member_days = Math.floor((util.now() - ev.created*1000) / (3600*1000*24));
				message = ev.name + ' (' + id + '): ' + ev.points + ' points, ' + ev.fans + ' fans, member for ' + member_days + ' days.';
				if (loud){
					send({api:'room.speak',roomid:_room.roomId,text:message});
				}
				else{
					message += '<br>Type "' + settings.chatDelimiter + 'profile ' + ev.name + '" for more information.';
					addChatMessage('http://turntablex.com/images/turntableX.png',0,'TurntableX','(Whois '+ev.name+'?)',message);
				}
				
			}
			else{
				message = 'Could not find user with id: '+id+'!';
				addChatMessage('http://turntablex.com/images/turntableX.png',0,'TurntableX','(Whois)',message);
				
			}
			
		});
		
	}

	var chat_commands = {
		'status':{
			'usage':'status',
			'help':'Display TTX/system information.',
			'action':function(args){

			}
		},
		'users.room':{
			'usage':'users.room',
			'help':'[Staff Only] Get a list of all TTX users in the current room, optionally filtered by integer rank.',
			'action':function(args){
				Server.status(_room.roomId);
			}
		},
		'users.all':{
			'usage':'users.all [minimal]',
			'help':'[Admin Only] Get a list of all TTX users on the site, optionally filtered by integer rank.',
			'action':function(args){
				if (args.length > 1 && args[1] === 'minimal')
					Server.status(null,1); // all, minimal
				else
					Server.status();
			}
		},
		'broadcast.all':{
			'usage':'broadcast.all [msg]',
			'help':'[Admin Only] Broadcast a message to all TTX users on the site.',
			'action':function(args){
				args = args.slice(1);
				Server.broadcast(null,args.join(' '));
			}
		},
		'broadcast.room':{
			'usage':'broadcast.room [msg]',
			'help':'[Staff Only] Broadcast a message to all TTX users in your room.',
			'action':function(args){
				args = args.slice(1);
				Server.broadcast(_room.roomId,args.join(' '));
			}
		},
		'fan':{
			'usage':'fan [userid|@username]',
			'help':'Fan a user.',
			'action':function(args){
				
			}
		},
		'unfan':{
			'usage':'unfan [userid|@username]',
				'help':'Fan a user.',
				'action':function(args){
				
			}
		},
		'tag':{
			'usage':'tag [tag1 tag2 ...]',
			'help':'Snag the song and tag it at the same time, with 1 or more comma-separated tags.',
			'action':function(args){
				if(_currentSong === null){
					addChatMessage('http://turntablex.com/images/turntableX.png',0,'TurntableX','(PM)','There is no song playing!');
					return;
				}
				var id = _currentSong.id;
				if (!turntable.playlist.queue.contains(id)){
					_manager.callback("add_song_to", "queue"); // add song to queue
				}
				args = args.slice(1);
				var argsDict = filterTags(args);
				// add the tags to the song
				$('#ttx-close-tags').click();
				addTags(id,argsDict);
				var tags = '#'+args.join(', #');
				addChatMessage('http://turntablex.com/images/turntableX.png',0,'TurntableX','(Tags)','You <3ed and tagged <b>'+_currentSong.title+'</b> with <b>' + tags+'</b>');
				var song = turntable.playlist.queue.renderedItems[id];
				if (typeof song !== 'undefined'){
					song.$node.addClass('set'); // mark the song as tagged
				}
			}
		},
		'tag!':{
			'usage':'tag! [tag1 tag2 ...]',
			'help':'Snag the song and tag it at the same time, display tags to chat',
			'action':function(args){
				if(_currentSong === null){
					addChatMessage('http://turntablex.com/images/turntableX.png',0,'TurntableX','(PM)','There is no song playing!');
					return;
				}
				var id = _currentSong.id;
				if (!turntable.playlist.queue.contains(id)){
					_manager.callback("add_song_to", "queue"); // add song to queue
				}
				args = args.slice(1);
				var argsDict = filterTags(args);
				// add the tags to the song
				send({api:'room.speak',roomid:_room.roomId,text:'/me <3 this (#'+args.join(', #')+')' });
				$('#ttx-close-tags').click();
				addTags(id,argsDict);

				var song = turntable.playlist.queue.renderedItems[id];
				if (typeof song !== 'undefined'){
					song.$node.addClass('set'); // mark the song as tagged
				}
			}
		},
		'pm':{
			'usage':'pm [userid|@username] [message]',
			'help':'Send a PM to any user.',
			'action':function(args){
				var message, user;
				if (args.length < 2){
					handleChatCommand('help pm');
				}
				else if (args.length === 2){
					if (args[1].match('^[0-9a-fA-F]{24}$')) {
						_manager.callback('pm_user',args[1]);
					}
					else{
						addChatMessage('http://turntablex.com/images/turntableX.png',0,'TurntableX','(PM)','Invalid userid!');
					}
				}
				else{
					user = args[1];
					message = args.slice(2).join(' ');
					send({api:'pm.send',receiverid:user,text:message});
					send({api:'user.get_profile',userid:user},function(ev){
						if (ev.name){
							addChatMessage(getIcon(_id),_id,'You','whisper to <b>' + ev.name + '</b>:',util.messageFilter(message));
						}
						else{
							addChatMessage('http://turntablex.com/images/turntableX.png',0,'TurntableX','(PM)','There is no user with id: ' + user + '!');
						}
					});
					
				}

			}
		},
		'awesome':{
			'usage':'awesome',
			'help':'Upvote the current song.',
			'action':function(args){
				autoVote(0);
			}
		},
		'lame':{
			'usage':'lame',
			'help':'Lame the current song.',
			'action':function(args){
				autoVote(0,'down');
				$('#lame-button').addClass('selected');
			}
		},
		'r':{
			'usage':'r [message]',
			'help': 'Reply to your last PM.',
			'action': function(args){
				if (args.length < 2){
					handleChatCommand('help r');
					return;
				}
				var message;
				if (last_pmmed === null){
					message = 'Nobody has PMed you!';
					addChatMessage('http://turntablex.com/images/turntableX.png',0,'TurntableX','(Reply)',message);
				}
				else{
					args = args.slice(1).join(' ');

					send({api:'pm.send',receiverid:last_pmmed,text:args});
					send({api:'user.get_profile',userid:last_pmmed},function(ev){
						if (ev.name){
							addChatMessage(getIcon(_id),_id,'You','reply to <b>' + util.emojify(ev.name) + '</b>:',args);
						}
					});
					
				}
			}
		},
		'help':{
			'usage':'help [command]',
			'help':'Learn more about a command, or see the full list of commands.',
			'action': function(args){
				var message;
				if (args.length === 1){
					message = 'Command delimiter: ' + settings.chatDelimiter + ', ';
					message += 'available commands: ';
					var first = true;
					for (var command in chat_commands){
						if (first){
							first = false;
						}
						else{
							message += ', ';
						}
						message += command;
					}
					message += '.<br>Type "'+settings.chatDelimiter+'help [command]" to learn more about any of those commands.';
					addChatMessage('http://turntablex.com/images/turntableX.png',0,'TurntableX','(Help)',message);
				}
				else{
					args = args.slice(1).join(' ');
					if (chat_commands[args]){
						message = 'Usage: ' + chat_commands[args]['usage'];
						message += '<br/>' + chat_commands[args]['help'];
						addChatMessage('http://turntablex.com/images/turntableX.png',0,'TurntableX','(Help)',message);
					}
					else{
						addChatMessage('http://turntablex.com/images/turntableX.png',0,'TurntableX','(Help)','No such command: ' + args);
					}
					
				}
			}
		},
		'whois':{
			'usage':'whois [userid|username]',
			'help':'Display information about a user.',
			'action':function(args){
				var message;

				if (args.length === 1){ // view your own stats
					handleWhois(_id);
				}
				else{
					args = args.slice(1);
					var user = args.join(' ');
					if (user.match('^[0-9a-fA-F]{24}$')){
						// id
						handleWhois(user);
					}
					else{
						if (user[0] === '@' && user.slice(1) in _usernames)
							user = user.slice(1);
						// name - look up id then get profile
						send({api:'user.get_id',name:user},function(ev){
							if (ev.userid){
								handleWhois(ev.userid);
							}
							else{
								var error = 'Could not find user named '+user+'!';
								addChatMessage('http://turntablex.com/images/turntableX.png',0,'TurntableX','(Whois)',error);
							}
						});
					}
				}
			}
		},
		'whois!':{
			'usage':'whois! [userid|username]',
			'help':'Display information about a user, announce to the chat.',
			'action':function(args){
				var message;

				if (args.length === 1){ // view your own stats
					handleWhois(_id);
				}
				else{
					args = args.slice(1);
					var user = args.join(' ');
					if (user.match('^[0-9a-fA-F]{24}$')){
						// id
						handleWhois(user,true);
					}
					else{

						if (user[0] === '@' && user.slice(1) in _usernames)
							user = user.slice(1);
						
						// name - look up id then get profile
						send({api:'user.get_id',name:user},function(ev){
							if (ev.userid){
								handleWhois(ev.userid,true);
							}
							else{
								var error = 'Could not find user named '+user+'!';
								addChatMessage('http://turntablex.com/images/turntableX.png',0,'TurntableX','(Whois)',error);
							}
						});
					}
				}
			}
		},
		'profile':{
			'usage':'profile [userid|username]',
			'help':'View a user\'s profile.',
			'action':function(args){
				if (args.length === 1){ // view your own profile
					_manager.callback('profile',_id);
				}
				else{
					args = args.slice(1);
					var user = args.join(' ');
					if (user.match('^[0-9a-fA-F]{24}$')){
						// id
						_manager.callback('profile',user);
					}
					else{
						if (user[0] === '@' && user.slice(1) in _usernames)
							user = user.slice(1);
						// name - look up id then get profile
						send({api:'user.get_id',name:user},function(ev){
							if (ev.userid){
								_manager.callback('profile',ev.userid);
							}
							else{
								var error = 'Could not find user named '+user+'!';
								addChatMessage('http://turntablex.com/images/turntableX.png',0,'TurntableX','(Profile)',error);
							}
						});
					}
				}
				
			}
		}
	};
	function handleChatCommand(c){
		var commandSplit = c.split(' ');
		var command = commandSplit[0].toLowerCase();
		if (typeof chat_commands[command] !== 'undefined'){
			if (!_premium && command !== 'help' && command !== 'profile'){
				addChatMessage('http://turntablex.com/images/turntableX.png',0,'TurntableX','(Help)','This is a Premium feature! See X -> Premium for details.');
			}
			else{
				chat_commands[command]['action'](commandSplit);
			}
		}
		else{
			handleChatCommand('help'); // display usage
		}
	}
	function addChatCommands(){
		var chatInput = $('#chat-input');
		chatInput.unbind('keydown').bind('keydown',function(ev){
			var key = ev.charCode || ev.keyCode;
			var chatMessage = $(this).val();

			if (key === 13 && chatMessage.match('^' + settings.chatDelimiter) && settings.chatCommands){
				$(this)[0].value = '';
				$(this).trigger('autosize');
				_room.cancelTypeahead();
				ev.preventDefault();
				var delimiterRegex = new RegExp('^'+settings.chatDelimiter);
				handleChatCommand(chatMessage.replace(delimiterRegex,''));
				return false;
			}
			else{
				return _room.chatKeyDownListener(ev);
			}
		});
	}
	// add a message to the chat	
	function addChatMessage(image,speakerid,speaker,afterSpeaker,content,classes){
		afterSpeaker = afterSpeaker || '';
		content = content || '';
		classes = classes || 'notification';
		var chatContainer = $('#chat .messages');
		var avatar = $('<div class="avatar" style="background-image: url('+image+');"></div>');
		var speaker = $('<div class="speaker" style="display:inline-block">'+speaker+'</div>');
		var afterSpeaker = $('<div class="afterSpeaker" style="display:inline; margin-left:3px">'+afterSpeaker+'</div>');
		var text = $('<div class="text">' + content + '</div>');
		var textContainer = $('<div class="textContainer"></div>');
		textContainer.append(text);
		var newMessage = $('<div class="message '+classes+'"></div>');
		newMessage.append(avatar);
		newMessage.append(speaker);
		newMessage.append(afterSpeaker);
		newMessage.append(textContainer);
		_room.checkChatScroll();
		newMessage.appendTo(chatContainer);
		newMessage.find('.ttx-import').click(importLaptop);
		_room.updateChatScroll();
		_room.lastChatSpeakerid = null;
		if (speakerid.length > 0){
			newMessage.find('.speaker').data('userid',speakerid);
		}	
	}
// END CHAT

	
// QUEUE
	function addTags(id,newTags){
		if (Object.keys(newTags).length === 0){
			return;
		}
		// add multiple tags to a song id
		var names = settings.tags.names;
		var display = settings.tags.display;
		var resort = false;
		var seen = {};
		for (var tag in newTags){
			if (tag === '' || typeof seen[tag] !== 'undefined'){ // invalid tag
				continue;
			}
			seen[tag] = 1;
			if (typeof settings.tags.songs[id] === 'undefined'){
				settings.tags.songs[id] = {};
			}
			settings.tags.songs[id][tag] = 1;
			if (typeof display[tag] === 'undefined'){ // tag doesnt exist, add it in
				settings.tags.names.push(tag);
				settings.tags.display[tag] = newTags[tag];
				resort = true;
			}
		}
		if (resort){
			settings.tags.names.sort();
		}
		saveSettings();
		if ($('#ttx-tag-menu').length){
			rerenderTagMenu();
		}
	}
	function properTagName(name){
		return name.replace(/[^A-Za-z0-9]/g,'');
	}
	function removeTag(name){
		var index = getTagIndex(name);
		settings.tags.names.splice(index, 1);
		delete settings.tags.display[name];
		var to_delete = {};
		for (var song in settings.tags.songs){
			var tags = settings.tags.songs[song];
			if (typeof tags[name] !== 'undefined'){
				delete tags[name];
				if (Object.keys(tags).length === 0){
					to_delete[song] = 1;
				}
			}
		}
		if (Object.keys(to_delete).length){
			// prepare song menu for deleting
			$('#playlist .songs .song').each(function(){
				if(typeof to_delete[$(this).data('songData').fileId] !== 'undefined'){
					$(this).removeClass('set');
				}
			});
			for (var song in to_delete){ // prune songs
				delete settings.tags.songs[song]; // this song has no more tags
			}
		}
		

		saveSettings();
		return index;
	}
	function renameTag(name,newName){
		var results = [];
		var index = getTagIndex(name);
		results.push(index);
		settings.tags.names.splice(index, 1); // remove old tag
		delete settings.tags.display[name];
		var newKey = newName.toLowerCase();
		var newIndex = newTagIndex(newKey);
		results.push(newIndex);
		if (newIndex >= 0){ // dest tag does not exist, splice it in
			if (newIndex === settings.tags.names.length){
				settings.tags.names.push(newKey);
				
			}
			else{
				settings.tags.names.splice(newIndex,0,newKey);

			}
			settings.tags.display[newKey] = newName;
		}

		for (var song in settings.tags.songs){
			var tags = settings.tags.songs[song];
			if (typeof tags[name] !== 'undefined'){ // has old tag
				delete tags[name]; // remove old tag
				tags[newKey] = 1; // set new tag
			}
		}
	
		saveSettings();
		return results;

	}
	function getTagIndex(name){

		for (var i=0; i<settings.tags.names.length; i++){
			var curName = settings.tags.names[i];
			if (name === curName){
				return i;
			}
		}
		// haven't returned yet - add to the end
		return -1;
	}
	function newTagIndex(name){
		// returns a new spot for the tag in tags.names or -1 if the tag already exists
		name = name.toLowerCase();
		for (var i=0; i<settings.tags.names.length; i++){
			var curName = settings.tags.names[i].toLowerCase();
			if (name === curName){
				return -1;
			}
			if (name < curName){
				return i;
			}
		}
		// haven't returned yet - add to the end
		return settings.tags.names.length;
	}
	function fixTagMenu(){
		var SONG_HEIGHT = 48;
		var MENU_OPTION_HEIGHT = 31;
		var scrollable = $('#ttx-tag-menu-scrollable');
		var menu = $("#ttx-tag-menu");
		var queueContainer = $('#songs');
		var addTagButton = menu.data('button');
		var songContainer = menu.data('songContainer');
		
		var menuHeight =menu.outerHeight();

		var songOffset = songContainer.offset();

	
		var queueOffset = queueContainer.offset();
		var queueHeight = queueContainer.height(); 
		
		var scrollableHeight = scrollable.children().length * MENU_OPTION_HEIGHT;
		var overflow, scrollHeight;

		if (menuHeight > queueHeight-5){
			menuHeight = queueHeight;
			scrollHeight = (queueHeight-SONG_HEIGHT) + 'px';
			overflow = 'auto';
		}
		else{
			scrollHeight = '100%';
			overflow = 'visible';
		}
		scrollable.css({'max-height':scrollHeight,'overflow-y':overflow});
	
		var offsetTop = Math.round((SONG_HEIGHT-menuHeight)/2);
	
		var originalOffsetTop = offsetTop;
		if (offsetTop + songOffset.top < queueOffset.top){ // top is too high
			offsetTop = queueOffset.top - songOffset.top;
		}
		else if (offsetTop + songOffset.top + menuHeight > queueOffset.top + queueHeight ){ // bottom is too low
			offsetTop = queueOffset.top + queueHeight - songOffset.top - menuHeight;
		}
		menu.find('#ttx-tag-menu-arrow').css({'margin-top':(-10+(originalOffsetTop-offsetTop))+'px'});
		menu.css({'top':offsetTop + 'px', 'right':'45px'});
		
	}
	function populateTagMenu(){ // create tag menu from settings
		var tag_menu = '<div id="ttx-tag-menu" style="display:none" class="floating-menu"><div id="ttx-tag-menu-arrow"></div><div style="position:relative; height: 25px;" class="option special"><input type="text" id="ttx-new-tag" placeholder="type a tag"></input><div id="ttx-close-tags"></div></div>';
		tag_menu += populateTagMenuScrollable() + '</div>';
		
		return tag_menu;
	}
	function populateTagMenuScrollable(){
		var content = '<div id="ttx-tag-menu-scrollable"><div>';
		for (var i=0;i<settings.tags.names.length;i++){
			var tag_name = settings.tags.names[i];
			content += '<div class="option ttx-menu-item" data-name="'+tag_name+'">'+settings.tags.display[tag_name]+'<div class="ttx-menu-edit"></div></div>';
		}
		content += '</div></div>';
		return content;
	}
	function createTagMenu(songContainer){
		var tag_menu = populateTagMenu();
		songContainer.append(tag_menu);
		
		var menu = $('#ttx-tag-menu');
	
		menu.data('song',null);
		menu.data('songContainer',songContainer);
		menu.data('button',songContainer.find('.addTag:eq(0)'));
		

		var scrollable = $('#ttx-tag-menu-scrollable');

		$('#ttx-close-tags').click(function(ev){
			turntable.playlist.queue.locked = false;
			turntable.playlist.queue.tagging = false;
			turntable.playlist.queue.$songs.removeClass('tagging');
			$('#ttx-new-tag input').blur();
			var button = menu.data('button');
			if (typeof button !== 'undefined'){
				button.removeClass('selected');
			}
			var song = menu.data('songContainer');
			if (typeof song !== 'undefined'){
				song.removeClass('selected');
			}
			menu.data('song',null).hide();
			return false;
		});
		$('#ttx-new-tag').keydown(function(ev){
			var key = ev.charCode || ev.keyCode;
			if (key === 13){
				
				var newTagName = properTagName($(this).val());

				if (newTagName.length === 0){
					return; // invalid, do nothing
				}
				var properName = newTagName.toLowerCase();
				var index = getTagIndex(properName);
				if (index > -1){
					// already exists, toggle the tag
					scrollable.find('.option:eq('+index+')').click();					
					$(this).val('');
					return;
				}
				// add new tag

				var newIndex = newTagIndex(properName);
				if (newIndex === settings.tags.names.length){
					// insert at the end
					settings.tags.names.push(properName);
					$('<div class="option ttx-menu-item" data-name="'+properName+'">'+newTagName+'<div class="ttx-menu-edit"></div></div>').appendTo(scrollable.children(':first')).click(); // select this tag
				}
				else{
					settings.tags.names.splice(newIndex, 0, properName);
					$('<div class="option ttx-menu-item" data-name="'+properName+'">'+newTagName+'<div class="ttx-menu-edit"></div></div>').insertBefore(scrollable.children(':first').find('.option:eq('+newIndex+')')).click(); // select this tag
				}
				settings.tags.display[properName] = newTagName;
				$(this).val(''); // empty self
				fixTagMenu();
				saveSettings(false);
			}
			else if (key === 9){
				ev.preventDefault();
				ev.stopPropagation();
				var songC = menu.data('songContainer');
				var queueContainer = $('#queue');
				var songs = $('#songs');

				if (ev.shiftKey){
					if (menu.offset().top - 100 >= queueContainer.offset().top){
						if (songs.scrollTop() >= 48){
							songs.scrollTop(songs.scrollTop()-48);
						}
						
					}
					// go back one song

					songC.prev().mouseenter().find('.addTag').click();

				}
				else{
					if (menu.offset().top + menu.height() + 48 <= queueContainer.offset().top+queueContainer.height()){
						songs.scrollTop(songs.scrollTop()+48);
					}
					// go forward one song
					songC.next().mouseenter().find('.addTag').click();
				}

				return false;
			}
			else if (key === 27){
				// close the menu
				$('#ttx-close-tags').click();
				return;
			}
		});
		menu.find('.special').click(function(e){e.preventDefault;return false;});
		scrollable.on('click','.ttx-menu-edit',function(ev){
			// edit this tag
			customModal('tag',$(this).closest('.option').data('name'));
			ev.preventDefault();
			return false;
		});
		scrollable.on('click','.option',function(ev){
			ev.preventDefault();
			if($(this).hasClass('special')){
				return false;
			}
			else{
				var songId = menu.data('song');
				var tagId = $(this).data('name');
				if (typeof songId === 'undefined' || typeof tagId === 'undefined'){
					return;
				}
				// toggle tag selection
				$(this).toggleClass('selected');
				if ($(this).hasClass('selected')){
					// add tag to song
					if (typeof settings.tags.songs[songId] === 'undefined'){
						settings.tags.songs[songId] = {};
					}
					settings.tags.songs[songId][tagId] = 1;
					menu.data('songContainer').addClass('set');
				}
				else{
					// remove tag from song
					delete settings.tags.songs[songId][tagId];
					if (Object.keys(settings.tags.songs[songId]).length === 0){
						menu.data('songContainer').removeClass('set');
						delete settings.tags.songs[songId];
					} 
				}

				saveSettings(false); // apply setting
			}
			return false;
		});
		return menu;
	}
	function rerenderTagMenu(){ // populate
		var menu = $('#ttx-tag-menu');
		if (!menu.length){
			menu = createTagMenu($('#playlist .song:eq(0)'));
			return; // create it
		}
		var song = menu.data('song');
		
		var scrollable = $('#ttx-tag-menu-scrollable');
		scrollable.replaceWith(populateTagMenuScrollable());

		// select tags for this song
		scrollable.find('.option').each(function(){
			var tagId = $(this).data('name');
			if (typeof settings.tags.songs[song] === 'undefined' || typeof settings.tags.songs[song][tagId] === 'undefined'){
				$(this).removeClass('selected');
			}
			else{
				$(this).addClass('selected');
			}
		});
		if (typeof song !== 'undefined' && song !== null){
			fixTagMenu();
		}
	}
	function filterTags(args){
		var dict = {};
		for (var i=0;i<args.length;i++){
			var proper = properTagName(args[i]);
			dict[proper.toLowerCase()] = proper;	
			args[i] = proper;
		}
		return dict;
	}
	function toggleTagMenu(ev,addTagButton){
	
		var displayTime = 150;
		if(ev.which) {
	        displayTime = 350;

	    }
	     ev.stopPropagation();
	        ev.preventDefault();
		// get song data from tag button
		var songContainer = addTagButton.closest('.song');
		var songData = songContainer.data('songData');
		if (typeof songData === 'undefined'){
			return;
		}
		var songId = songData.fileId;
		
		// build menu if necessary
		var menu = $('#ttx-tag-menu');
		var scrollable;

		if (menu.length === 0){
			menu = createTagMenu(songContainer);
		}
		
		scrollable = $('#ttx-tag-menu-scrollable');
		var currentMenuSong = menu.data('song');
		if (typeof currentMenuSong !== 'undefined' && currentMenuSong !== null){
			if (currentMenuSong === songId){ // close the menu
				$('#ttx-close-tags').click();
				return;
			}
			else{ // re-position the menu to another button
				menu.data('songContainer').removeClass('selected'); // remove selected
				menu.data('button').removeClass('selected'); // remove selected
				menu.data('song',songId);
				menu.data('songContainer',songContainer);
				menu.data('button',addTagButton);
				songContainer.append(menu);
			}
		}
		else{
			// first time menu will be shown
			menu.data('song',songId);
			menu.data('songContainer',songContainer);
			menu.data('button',addTagButton);
			songContainer.append(menu);
		}
		
	

		// show the menu, lock queue re-order
		turntable.playlist.queue.locked = true;
		turntable.playlist.queue.tagging = true;
		turntable.playlist.queue.$songs.addClass('tagging');
		$('#playlist .song-options').hide();
		songContainer.addClass('selected');
		
		
		// set the tag menu data to point to the current song / current button
		
		var scrollable = $('#ttx-tag-menu-scrollable');
		// select tags for this song
		scrollable.find('.option').each(function(){
			var tagId = $(this).data('name');
			if (typeof settings.tags.songs[songId] === 'undefined' || typeof settings.tags.songs[songId][tagId] === 'undefined'){
				$(this).removeClass('selected');
			}
			else{
				$(this).addClass('selected');
			}
			
		});
		
		// position and show the tag menu
		menu.css({'opacity':0,'display':'block'});

		fixTagMenu();
		if (displayTime){
			menu.fadeTo(displayTime,1,function(){
				menu.find('#ttx-new-tag').focus();
			});
		}
		else{
			menu.show().css('opacity',1).find('#ttx-new-tag').focus();
		}
		
		

	}
	function fixTags(){
		settings.tags.names = [];
		for (key in settings.tags.display){
			settings.tags.names.push(key);

		}
		settings.tags.names.sort();
		saveSettings();
		
	}
	function modifyQueue(){
		if (settings.tags.names.length === 0 && Object.keys(settings.tags.display).length !== 0){
			// regenerate names
			for (key in settings.tags.display){
				settings.tags.names.push(key);

			}
			settings.tags.names.sort();
			saveSettings();
		}
		turntable.playlist.layouts.songView = function (f, d, a) {
	        var e = f.metadata,
	            c = [],
	            b = e.artist + "\u2022 " + util.prettyTime(e.length);
	       
	        if (a !== undefined && a % 2 === 0) {
	            c.push(".nth-child-even");
	        }
	        var tagClass = (typeof settings.tags.songs[f.fileId] === 'undefined' || Object.keys(settings.tags.songs[f.fileId]).length === 0) ? '':'.set';
	        return	["li.song" + tagClass + c.join(""), {
			            data: {
			                songData: f
			            },
			            style: ((d !== undefined) ? {
			                top: d
			           		} : {}),
			        	}, 
				        ["div.progress-bar", ["div.progress"]],
				        ["div.vinyl"],
				        ["div.thumb", {
				            style: {
				                "background-image": (e.coverart ? "url(" + e.coverart + ")" : "")
				            }
				        }],
				        ["div.playSample"],
				        ["div.pauseSample"],
				        ["div.title", {
				            	title: e.song
				        	},
				     	e.song],
				     	["div.details", {
				        	    title: b
				        	},
				        	["span", e.artist, ["span.divider", " \u2022 "], util.prettyTime(e.length)]
				        ],
				        ["div.go-top"],
				        ["div.open-options"],
				        ["div.checkbox"],
				        ["div.goBottom"],
				        ["div.addTag" + tagClass],
				        ["div.tagMessage"]
			        ];
	    };
	    if (typeof turntable.playlist.queue !== 'undefined'){
	    	// modify song redraw layout
	    	turntable.playlist.queue.attributes.songConstructor = turntable.playlist.layouts.songView;
	    	
	    	// add event handlers for add tag and send to bottom
	    	$('#playlist .songs').on("click", ".goBottom", function (h) {
		            if (turntable.playlist.queue.locked) {
			            return;
		            }
		            var f = $(h.target).closest(".song"),
		                g = f.data("songData").fileId,
		                d = turntable.playlist.queue.attributes.songids.indexOf(g),
		                pos = turntable.playlist.queue.attributes.songids.length - 1;
		            turntable.playlist.reorder(d, pos).done($.proxy(function () {
		                this.reorderBySongid(g, pos);
		                if (turntable.playlist.isFiltering) {
		                    turntable.playlist.savedScrollPosition = 0;
		                }
		            },turntable.playlist.queue));
		        }).on("click",".addTag",function(ev){
		        	toggleTagMenu(ev,$(ev.target)); 
		        	ev.preventDefault();
		        	return false;
		        }).on("click",".song",function(ev){
		        	if(turntable.playlist.queue.tagging){
		        		$(this).find('.addTag').click();
		        	}
		        });
	    	// trigger re-rendering
	    	turntable.playlist.queue.setFilter([]);
	    	turntable.playlist.queue.clearFilter();
	    }
	    turntable.playlist.parseFilter =  function (c) {
	 
	        var d = new RegExp(/(\balbum|\bartist|\bduration|\btitle|#):?(.*?)(?=\balbum:|\bartist:|\bduration:|\btitle:|#|$)/);
	        var a = {};
	        while (true) {
	            var b = d.exec(c);
	            if (b == null) {
	                break;
	            }
	            if (b[1] == '#'){

	            	if (typeof (a['tags']) === 'undefined'){
	            		a['tags'] = [];
	            	}
	            	a['tags'].push(properTagName(b[2]).toLowerCase());
	            }
	            else if (b[1] == "duration") {
	                a[b[1]] = $.trim(b[2]);
	            } else {
	                a[b[1]] = new RegExp($.trim(b[2]).replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&"), "i");
	            }
	            c = c.replace(b[0], "");
	        }
	        if (c != null) {
	            a.all = c;
	        } else {
	            a.all = "";
	        }
	        return a;
	    };
	    turntable.playlist.filterQueue = function (k) {
	        if (k && k.length > 0) {
	            var g = this.parseFilter(k);
	            $('#ttx-close-tags').click();
	            var u = g.all.split(/\s+/g),
	                f = $.map(u, function (i) {
	                    return new RegExp(i.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&"), "i");
	                });
	            var v = {}, q = 0,
	                a = this.queue.attributes.songids,
	                e = u.length;
	            for (var r = 0, s = a.length; r < s; r++) {
	                var m = a[r],
	                    l = this.songsByFid[m].metadata,
	                    t = l.song,
	                    d = l.artist,
	                    n = l.album,
	                    c = l.length,
	                    tags = settings.tags.songs[m];
	                    if (typeof tags === 'undefined'){
	                    	tags = {};
	                    }
	                    h = true;
	                for (var p = 0; p < e; p++) {
	                    var b = f[p];
	                    if (!b.test(t) && !b.test(d) && !b.test(n)) {
	                        h = false;
	                        break;
	                    }
	                }
	                if (h && g.hasOwnProperty("artist")) {
	                    if (!g.artist.test(d)) {
	                        h = false;
	                    }
	                }
	                if (h && g.hasOwnProperty("title")) {
	                    if (!g.title.test(t)) {
	                        h = false;
	                    }
	                }
	                if (h && g.hasOwnProperty("album")) {
	                    if (!g.album.test(n)) {
	                        h = false;
	                    }
	                }
	                if (h && g.hasOwnProperty("duration")) {
	                    var o = parseInt(g.duration.split(":")[0]);
	                    if (!isNaN(o)) {
	                        if (c < o * 60 || c > (o + 1) * 60) {
	                            h = false;
	                        }
	                    }
	                }
	                if (h && g.hasOwnProperty("tags")){
	                	var searchTags = g['tags'];
	                	
	                	for (var i=0;i<searchTags.length;i++){
	                		var searchTag = searchTags[i];
	                		var tagLength = Object.keys(tags).length;
	                		if (searchTag === 'untagged'){
		                		if (tagLength > 0){
		                			h = false; // we want untagged, this song is tagged
		                			break;
		                		}
		                	}
		                	else if (searchTag === 'tagged'){
		                		if (tagLength === 0){
		                			h = false; // we want tagged, this song is untagged
		                			break;
		                		}
		                	} 
		                	else{
		                		if (typeof tags[searchTag] === 'undefined'){
		                			h = false; // we want a specific tag that doesnt exist
		                		}
		                	}
	                	}
	                	
	                	
	                }
	                if (h) {
	                    v[m] = true;
	                    q++;
	                }
	            }
	            this.queue.setFilter(v);
	            this.queue.$title.find('.text').text(q + ' of ' + a.length +  ' songs from your queue');
	            this.queue.showTitle();
	            if (this.currentPreviewid && !v[this.currentPreviewid]) {
	                this.previewStop();
	            }
	            turntable.playlist.notifyGAOfFilter(k, q);
	        } else {
	            this.queue.clearFilter();
	            this.queue.hideTitle();
	            if (this.currentPreviewid && !this.queue.contains(this.currentPreviewid)) {
	                this.previewStop();
	            }
	        }
	    };
	    
	}
// END QUEUE

// START UTILITY
	
	function format_time(t){
		var hh = t.getHours();
		var mm = t.getMinutes();
		var ss = t.getSeconds();
		if (hh < 10) {hh = "0"+hh;}
		if (mm < 10) {mm = "0"+mm;}
		if (ss < 10) {ss = "0"+ss;}
		return hh+":"+mm+":"+ss;
	}
	function msFormat(ms){
		var addZero = '';
		var seconds = ms / 1000.0;
		if (ms % 100 === 0){
			addZero = '0';
		}
		if (ms % 1000 === 0){
			addZero = '.00';
		}
		return seconds + addZero + 's';
	}
	function inlineCSS( css_code ) {
		var div = document.createElement( "div" );
		div.innerHTML = "<style>" + css_code + "</style>";
		document.body.appendChild(div.childNodes[0]);
	}
	function send(data,callback){
		var msg,
		defer = $.Deferred();
		var now = util.now();
		
		if (data.api == "room.now") {
			defer.resolved();
			callback();
			return defer.promise();
		}
		data.msgid = turntable.messageId;
		turntable.messageId += 1;
		data.clientid = turntable.clientId;
		if (turntable.user.id && !data.userid) {
			data.userid = turntable.user.id;
			data.userauth = turntable.user.auth;
		}
		msg = JSON.stringify(data);
		turntable.whenSocketConnected(function () {
			turntable.socket.send(msg);
			turntable.socketKeepAlive(true);
			turntable.pendingCalls.push({
				msgid: data.msgid,
				handler: callback,
				deferred: defer,
				time: util.now()
			});
		});
		return defer.promise();
	}
    
    function getRoom(){
    	return _room;
    }
    function getRoomView(){
    	return _manager;
    }
	function mod(a,b){
		return ((a%b)+b)%b;
	}
	function gcd(a, b){
	    // Euclidean algorithm
	    var t;
	    while (b != 0){
	        t = b;
	        b = a % b;
	        a = t;
	    }
	    return a;
	}
	function lcm(a, b){
	    return (a * b / gcd(a, b));
	}
	function random_item(obj) {
		    var temp_key, keys = [];
		    for(temp_key in obj) {
		       if(obj.hasOwnProperty(temp_key)) {
		           keys.push(temp_key);
		       }
		    }
		    return obj[keys[Math.floor(Math.random() * keys.length)]];
	}
	

	function randomDelay(min, max) {
			min = min || 2;
			max = max || 70;
			return (Math.random() * max + min) * 1000;
	}

	function matchCSS(data){
		var ss = document.styleSheets;
		var results = [];
		for (var i=0;i<ss.length;i++){
			var rules = ss[i].cssRules || ss[i].rules;
			if (!rules){
				continue;
			}
			for (var j=0; j<rules.length; j++){
				if (!(rules[j].selectorText)){
					continue;
				}
				if (rules[j].selectorText.indexOf(data) > -1){
					results.push(rules[j].selectorText);
				}
			}
		}
		return results;
	}
    function cssInject(data){
        var ss = document.styleSheets;
        var original = {}; // call cssInject(original) to revert to previous state
        for (var i=0; i<ss.length; i++){
            var rules = ss[i].cssRules || ss[i].rules;
            if (!rules){
            	continue;
            }
            for (var j=0; j<rules.length; j++){
                if (!(rules[j].selectorText))
                    continue;
                var selector = rules[j].selectorText;
                var style = rules[j].style;
                if (data[selector]){ // this rule matches!
                    original[selector] = {};
                    for (prop in data[selector]){
                        var new_value = data[selector][prop];
                        original[selector][prop] = style[prop];
                        style[prop] = new_value;
                    }
                }
            }
        }
        return original;
    }
	function formatTimeDelta(date) {
			var curdate = new Date().getTime();
			curdate = Math.round(curdate / 1000);
			if (!date.length) date = date.toString();
			if (date.length == 10) date = parseInt(date);
			else if (date.length == 13) date = parseInt(parseInt(date) / 1000);
			else date = Math.round(Date.parse(date) / 1000);
			var diff = Math.abs(date - curdate);
			// get minutes
			if ((diff / 60) >= 1) {
				var min = Math.floor(diff / 60);
				var sec = diff - (min * 60);
			} else {
				var min = '00';
				var sec = diff;
			}

			min = min.toString();
			sec = sec.toString();
			if (min.length < 2) {
				min = '0' + min;
			}
			if (sec.length < 2) {
				sec = '0' + sec;
			}
			return min + ':' + sec;
	}
	
    function log(message){
        if (window.console && (!settings || settings.debug) ){
            window.console.log(message);
        }
    }
    function reset(){

    }
    function syncNow(){
		return Math.floor(turntable.serverNow()*1000);
	}
// END UTILITY

// LAPTOP
	var LETTER_WIDTH = 170;
	var STICKER_LIMIT = 20;
	var DEFAULT_COLOR = 'R';
	var COLOR_MAP = {
		'B': '4f86fdede77989117e000003',
        'P': '4f86fe84e77989117e000008',
        'R': '4f86fe33e77989117e000006',
        'O': '4f86fd32e77989117e000001',
        'Y': '4f86fea8e77989117e000009',
        'L': '4f86fd27e77989117e000000',
        'W': '4f86fe15e77989117e000005'

	};
	var LETTER_MAP = {
			'A': [{top: 218, left: -54, angle: 102},{top: 65, left: -22, angle: 102},{top: 65, left: 12, angle: 78},{top: 218, left: 45, angle: 78},{top: 197, left: 0, angle: 0}],
			'B': [{top: 214, left: -69, angle:90},{top: 65, left: -69, angle: 90},{top: 38, left: -3, angle: 30},{top:112,left:-2,angle:330},{top:179,left:-3,angle:30},{top:249,left:-2,angle:330}],
			'C': [{top: 141, left: -69,angle: 90},{top:253,left:-3,angle:30},{top:36,left:-3,angle:330}],
			'D': [{top:214,left:-66,angle:90},{top:65,left:-66,angle:90},{top:253,left:-3,angle:330},{top:36,left:-3,angle:30},{top:141,left:60,angle:90}],
			'E': [{top:214,left:-66,angle:90},{top:65,left:-66,angle:90},{top:0,left:0,angle:0},{top:144,left:0,angle:0},{top:280,left:0,angle:0}],
			'F': [{top:214,left:-66,angle:90},{top:65,left:-66,angle:90},{top:0,left:0,angle:0},{top:144,left:0,angle:0}],
			'G': [{top:141,left:-69,angle:90},{top:253,left:-3,angle:30},{top:36,left:-3,angle:330},{top:255,left:60,angle:90},{top:184,left:54,angle:0}],
			'H': [{top:214,left:-66,angle:90},{top:65,left:-66,angle:90},{top:144,left:0,angle:0},{top:214,left:60,angle:90},{top:65,left:60,angle:90}],
			'I': [{top:214,left:-3,angle:90},{top:65,left:-3,angle:90}],
			'J': [{top:0,left:0,angle:0},{top:93,left:15,angle:90},{top:230,left:-20,angle:-50}],
			'K': [{top:214,left:-66,angle:90},{top:65,left:-66,angle:90},{top:51,left:22,angle:315},{top:234,left:19,angle:45}],
			'L': [{top:214,left:-66,angle:90},{top:65,left:-66,angle:90},{top:280,left:0,angle:0}],
			'M': [{top:214,left:-66,angle:90},{top:65,left:-66,angle:90},{top:65,left:60,angle:90},{top:214,left:60,angle:90},{top:60,left:-37,angle:60},{top:60,left:37,angle:-60}],
			'N': [{top:214,left:-66,angle:90},{top:65,left:-66,angle:90},{top:65,left:60,angle:90},{top:214,left:60,angle:90},{top:72,left:-37,angle:65},{top:217,left:29,angle:65}],
			'O': [{top:67,left:30,angle:65},{top:215,left:-39,angle:65},{top:67,left:-39,angle:115},{top:215,left:30,angle:115}],
			'P': [{top: 214, left: -69, angle:90},{top: 65, left: -69, angle: 90},{top: 38, left: -3, angle: 30},{top:112,left:-2,angle:330}],
			'Q': [{top:67,left:30,angle:65},{top:215,left:-39,angle:65},{top:67,left:-39,angle:115},{top:215,left:30,angle:115},{top:215,left:30,angle:65}],
			'R': [{top: 214, left: -69, angle:90},{top: 65, left: -69, angle: 90},{top: 38, left: -3, angle: 30},{top:112,left:-2,angle:330},{top:236,left:8,angle:45}],
			'S': [{top:36,left:-6,angle:330},{top:137,left:-9,angle:46},{top:242,left:-6,angle:330}],
			'T': [{top:214,left:-3,angle:90},{top:65,left:-3,angle:90},{top:0,left:0,angle:0}],
			'U': [{top:214,left:-66,angle:90},{top:65,left:-66,angle:90},{top:280,left:0,angle:0},{top:214,left:60,angle:90},{top:65,left:60,angle:90}],
			'V': [{top: 218, left: 12, angle: 102},{top: 65, left: 45, angle: 102},{top: 65, left: -54, angle: 78},{top: 218, left: -22, angle: 78}],
			'W': [{top:214,left:-66,angle:90},{top:65,left:-66,angle:90},{top:65,left:60,angle:90},{top:214,left:60,angle:90},{top:225,left:31,angle:60},{top:225,left:-26,angle:-60}],
			'X': [{top:67,left:-38,angle:65},{top:215,left:29,angle:65},{top:67,left:29,angle:115},{top:215,left:-38,angle:115}],
			'Y': [{top:67,left:-38,angle:65},{top:67,left:30,angle:115},{top:214,left:-3,angle:90}],
			'Z': [{top:0,left:0,angle:0},{top:280,left:0,angle:0},{top:67,left:30,angle:115},{top:215,left:-39,angle:115}],
			'0': [{top:214,left:-66,angle:90},{top:65,left:-66,angle:90},{top:214,left:60,angle:90},{top:65,left:60,angle:90},{top:0,left:0,angle:0},{top:280,left:0,angle:0}],
			'1': [{top:214,left:-3,angle:90},{top:65,left:-3,angle:90},{top:32,left:-21,angle:299}],
			'2': [{top:214,left:-66,angle:90},{top:65,left:60,angle:90},{top:0,left:0,angle:0},{top:144,left:0,angle:0},{top:280,left:0,angle:0}],
			'3': [{top:214,left:60,angle:90},{top:65,left:60,angle:90},{top:0,left:0,angle:0},{top:144,left:0,angle:0},{top:280,left:0,angle:0}],
			'4': [{top:65,left:-66,angle:90},{top:144,left:0,angle:0},{top:214,left:60,angle:90},{top:65,left:60,angle:90}],
			'5': [{top:214,left:60,angle:90},{top:65,left:-66,angle:90},{top:0,left:0,angle:0},{top:144,left:0,angle:0},{top:280,left:0,angle:0}],
			'6': [{top:214,left:-66,angle:90},{top:214,left:60,angle:90},{top:65,left:-66,angle:90},{top:0,left:0,angle:0},{top:144,left:0,angle:0},{top:280,left:0,angle:0}],
			'7': [{top:0,left:0,angle:0},{top:214,left:60,angle:90},{top:65,left:60,angle:90}],
			'8': [{top:65,left:60,angle:90},{top:214,left:-66,angle:90},{top:214,left:60,angle:90},{top:65,left:-66,angle:90},{top:0,left:0,angle:0},{top:144,left:0,angle:0},{top:280,left:0,angle:0}],
			'9': [{top:65,left:60,angle:90},{top:214,left:60,angle:90},{top:65,left:-66,angle:90},{top:0,left:0,angle:0},{top:144,left:0,angle:0},{top:280,left:0,angle:0}],
			' ': [],
			'/': [{top:67,left:30,angle:115},{top:215,left:-39,angle:115}],
			'\\': [{top:67,left:-38,angle:65},{top:215,left:29,angle:65}],
			',': [{top:315,left:-3,angle:110}],
			'.': [{top:344,left:-3,angle:90}],
			'!': [{top:344,left:-3,angle:90},{top:160,left:-3,angle:90},{top:10,left:-3,angle:90}],
			'_': [{top:280,left:0,angle:0}],
			'+': [{top:144,left:0,angle:0},{top:144,left:0,angle:90}],
			'-': [{top:144,left:0,angle:0}],
			'=': [{top:110,left:0,angle:0},{top:180,left:0,angle:0}],
			'^': [{top:67,left:-39,angle:115},{top:67,left:29,angle:65}],
			'<': [{top:177,left:5,angle:30},{top:109,left:5,angle:330}],
			'>': [{top:109,left:5,angle:30},{top:177,left:5,angle:330}],
			"'": [{top:-30,left:-3,angle:100}],
			'"': [{top:-30,left:-33,angle:100},{top:-30,left:27,angle:100}],
			'*': [{top:144,left:0,angle:0},{top:144,left:0,angle:90},{top:144,left:0,angle:45},{top:144,left:0,angle:135}],
			'$': [{top:36,left:-6,angle:330},{top:137,left:-9,angle:46},{top:242,left:-6,angle:330},{top:214,left:-3,angle:90},{top:65,left:-3,angle:90}],
			'#': [{top:115,left:0,angle:0},{top:175,left:0,angle:0},{top:145,left:-30,angle:90},{top:145,left:30,angle:90}],
			'|': [{top:214,left:-3,angle:90},{top:65,left:-3,angle:90}]
	};
	var STICKER_LIST = ['4f873b32af173a2903816e52','4f86febfe77989117e00000a',"4f86fd27e77989117e000000","4f86fd3ee77989117e000002","4f86fe5de77989117e000007","4f86fd32e77989117e000001","4f86fe06e77989117e000004","4f86fe33e77989117e000006","4f86fea8e77989117e000009","4f86fe84e77989117e000008","4f86fe15e77989117e000005","4f86fdede77989117e000003"];
	var STICKER_DICT = {};
	for (var i=0;i<STICKER_LIST.length;i++) STICKER_DICT[STICKER_LIST[i]] = i;
	var STICKER_MAP = {
		'4f873b32af173a2903816e52': {
			url: "https://s3.amazonaws.com/static.turntable.fm/roommanager_assets/stickers/reddit.png",
			height: 125,
			width: 90,
			name: 'reddit'
		},
		'4f86febfe77989117e00000a': {
			url: "https://s3.amazonaws.com/static.turntable.fm/roommanager_assets/stickers/twitter.png",
			height: 76,
			width: 90,
			name: 'twitter'
		},
		"4f86fd27e77989117e000000": {
			url: "https://s3.amazonaws.com/static.turntable.fm/roommanager_assets/stickers/codecademy.png",
			height: 46,
			width: 186,
			name: 'codecademy'
		},
		"4f86fd3ee77989117e000002": {
			url: "https://s3.amazonaws.com/static.turntable.fm/roommanager_assets/stickers/facebook.png",
			height: 65,
			width: 67,
			name: 'facebook'
		},
		"4f86fe5de77989117e000007": {
			url: "https://s3.amazonaws.com/static.turntable.fm/roommanager_assets/stickers/stackoverflow.png",
			height: 66,
			width: 226,
			name: 'stackoverflow'
		},
		"4f86fd32e77989117e000001": {
			url: "https://s3.amazonaws.com/static.turntable.fm/roommanager_assets/stickers/etsy.png",
			height: 65,
			width: 110,
			name: 'etsy'
		},
		"4f86fe06e77989117e000004": {
			url: "https://s3.amazonaws.com/static.turntable.fm/roommanager_assets/stickers/github.png",
			height: 122,
			width: 135,
			name: 'github'
		},
		"4f86fe33e77989117e000006": {
			url: "https://s3.amazonaws.com/static.turntable.fm/roommanager_assets/stickers/pinterest.png",
			height: 49,
			width: 165,
			name: 'pinterest'
		},
		"4f86fea8e77989117e000009": {
			url: "https://s3.amazonaws.com/static.turntable.fm/roommanager_assets/stickers/turntable.png",
			height: 89,
			width: 139,
			name: 'turntable'
		},
		"4f86fe84e77989117e000008": {
			url: "https://s3.amazonaws.com/static.turntable.fm/roommanager_assets/stickers/stickybits.png",
			height: 53,
			width: 167,
			name: 'stickybits'
		},
		"4f86fe15e77989117e000005": {
			url: "https://s3.amazonaws.com/static.turntable.fm/roommanager_assets/stickers/meetup.png",
			height: 75,
			width: 104,
			name: 'meetup'
		},
		"4f86fdede77989117e000003": {
			url: "https://s3.amazonaws.com/static.turntable.fm/roommanager_assets/stickers/foursquare.png",
			height: 56,
			width: 176,
			name: 'foursquare'
		}
	
	};
	var _animate = {
		offset:0,
		timer:null,
		speed:1000,
		reverse:false,
		lastAnimation:null,
		lastAnimationTT:null,
		sync:false,
		delay:0,
		cache:null,
	};
	var laptopMenuHover = null;

	// add a laptop settings item
	function addLaptopSettings(){
        if ($('#ttx-laptop-menu-container').length === 0){
        	
			updateLaptops();
	    	
	    	$('#ttx-laptop-menu-button').parent().mouseover(function(){
				if (laptopMenuHover !== null){
					clearTimeout(laptopMenuHover);
					laptopMenuHover = null;
				}
				$(this).addClass('hover');
				$('#ttx-laptop-speed-button').parent().removeClass('hover');
				//$('.header-well-buttons').not('#ttx-laptop-menu-container').find('.dropdown-container').removeClass('hover').find('.header-well-dropdown').hide();
			}).mouseout(function(){
				var self = $(this);
				laptopMenuHover = setTimeout(function(){ self.removeClass('hover'); },600);
			});
			
			
			$('.header-well-buttons').not('#ttx-laptop-menu-container').mouseover(function(){
				if (laptopMenuHover !== null){
					clearTimeout(laptopMenuHover);	
					laptopMenuHover = null;
				}	
				$('#ttx-laptop-menu-button').parent().removeClass('hover');
				$('#ttx-laptop-speed-button').parent().removeClass('hover');
			});
			
        }
        else{
        	updateLaptops();
        }
	}
	function toggleSync(){
		_animate.sync = !_animate.sync;
		$(this).toggleClass('active');
	}
	// hide speed dial, stop animation timer
	function stopAnimation(){
		if (_animate.timer !== null){
			clearTimeout(_animate.timer);
			_animate.timer = null;
		}
		_animate.lastAnimation = null;
		updateLaptopStickers([]);
		hideLaptopSpeedDial();
		$('#ttx-laptop-menu-container').removeClass('active');
	}
	// toggle reverse
	function reverseAnimation(){
		_animate.reverse = !_animate.reverse;
		if (_animate.reverse){
			$('#ttx-laptop-speed-button').addClass('reverse');
		}
		else{
			$('#ttx-laptop-speed-button').removeClass('reverse');
		}
	}
	// called every time we should reset animation
	function animateLaptop(){
		var selection = settings.laptop.stickers.selected;
		var selectedAnimation = settings.laptop.stickers.animations[selection];
		_animate.offset = 0;
		if (selectedAnimation && isDJ(_id)){
			if (_animate.timer !== null){
				clearTimeout(_animate.timer);
				_animate.timer = null;
			}
			addLaptopSpeedDial();
			$('#ttx-laptop-menu-container').addClass('active');
			animateLaptopLoop(100);
		}

	}
	function animateLaptopLoop(speed){
		var delay, now, frameDelay, effectiveFrame, effectiveLength, animation, adjustFrame;
		speed = speed || _animate.speed;
		if (speed === 0){
			_animate.timer = setTimeout(function(){
				animateLaptopLoop();
			},100);
		}
		else{
			animation = settings.laptop.stickers.animations[settings.laptop.stickers.selected]; // lock in the animation
			reversed = _animate.reverse ? -1:1;
			if (_animate.sync){
				// 1. adjust time-to-render to a modular clock = speed (ms)
				now = syncNow();
				delay = _animate.speed - (now % _animate.speed); // offset to next tick that we should animate on (next tick happens on now+delay)
				frameDelay = delay;
				// 2. adjust for latency
				delay -= _animate.delay;
				while (delay < 0){
					delay += _animate.speed; // if we can't make the next tick, try the one after
					frameDelay += _animate.speed; // next frame also
				}
				// get effective length and effective frame to render
				if (animation.type === 'text'){
					var doubleLen = 2*animation.text.display.length;
					var tick = animation.text.tick;
					adjustFrame = reversed * Math.round((djIndex*(6/tick)));
					effectiveLength = lcm(doubleLen,tick)/gcd(doubleLen,tick);
				}
				else{
					adjustFrame = 0;
					effectiveLength = animation.frames.length; 
				}
				// 3. adjust offset to a modular clock =  speed * frames.length (ms) once the delay is found
				effectiveFrame = ( (now+frameDelay) % (_animate.speed * effectiveLength) ) / _animate.speed;
				// add extra adjustment
				effectiveFrame = mod(effectiveFrame + adjustFrame,effectiveLength);
				if (_animate.reverse){
					effectiveFrame = (effectiveLength - effectiveFrame - 1); // invert for reversed
				}
				_animate.offset = effectiveFrame;
			} 
			else
				delay = speed;
			_animate.timer = setTimeout(function(){			
				var animationLength;
				if (animation.type === 'text'){
					var textIndex, colorIndex;
					var doubleLen = 2*animation.text.display.length;
					var tick = animation.text.tick;
					animationLength = lcm(doubleLen,tick)/gcd(doubleLen,tick);
					textIndex =  (_animate.offset * animation.text.tick) % (2 * animation.text.display.length);
					if (animation.text.colorEachLetter || typeof (adjustFrame) === 'undefined'){
						colorIndex = _animate.offset % animation.text.colors.length;
					}
					else{
						colorIndex = mod(_animate.offset - adjustFrame,effectiveLength) % animation.text.colors.length;
					}
					renderStickerText('live',animation,textIndex,colorIndex);
				}
				else{
					updateLaptopStickers(animation.frames[_animate.offset]);
					animationLength = animation.frames.length;
				}
				if (!_animate.sync)
					_animate.offset = mod(_animate.offset + reversed,animationLength); // advance to next frame
				
				animateLaptopLoop();	
			}, delay);
		}
	}

	function updateLaptopStickers(new_placements){
		var cached = true;
		if (_animate.cache !== null){
			if (_animate.cache.length === new_placements.length){
				for (var i=0;i<_animate.cache.length;i++){
					if (!( _animate.cache[i].sticker_id === new_placements[i].sticker_id && _animate.cache[i].angle === new_placements[i].angle && _animate.cache[i].top === new_placements[i].top && _animate.cache[i].left === new_placements[i].left )){
						cached = false;
						break;
					}
				}
			}
			else
				cached = false;
		}
		else
			cached = false;
		if (cached) // new_placements == last_placements
			return;
		var now = util.now();
		if (_animate.lastAnimationTT === null || now - _animate.lastAnimationTT > 15*1000){
			send({
				api: 'sticker.place',
				placements: new_placements,
				is_dj: true,
				roomid: _room.roomId
			});
			_animate.lastAnimationTT = now;
		}
		_animate.lastAnimation = now;
		Server.animate(new_placements);
		_animate.cache = $.extend(true,[],new_placements);

		
	}
	function addLaptopSpeedDial(){
		if ($('#ttx-laptop-menu').length === 0)
			updateLaptops();
		if ($('#ttx-laptop-speed-dropdown').length){
			$('#ttx-laptop-sync-dropdown').insertBefore($('#ttx-laptop-menu').parent()).show();
			$('#ttx-laptop-speed-dropdown').insertBefore($('#ttx-laptop-menu').parent()).show();
		}
		else{
			var speedSlider = '<li class="dropdown-container" id="ttx-laptop-speed-dropdown">\
								<div id="ttx-laptop-speed-label">1.00s</div>\
								<div class="header-well-button" title="Animation Speed" id="ttx-laptop-speed-button"/>\
								<ul class="floating-menu down" id="ttx-laptop-speed-menu">\
									<div id="ttx-laptop-speed-slider">\
										<div id="ttx-laptop-speed-knob" style="top:18px;"></div>\
										<div id="ttx-laptop-speed-fill" style="height:87px;">\
										</div>\
									</div>\
								</ul>\
							</li>';
		 	var syncButton = '<li class="dropdown-container" id="ttx-laptop-sync-dropdown">\
								<div class="header-well-button" title="Animation Sync" id="ttx-laptop-sync-button"/>\
							</li>';

			$('#ttx-laptop-menu').parent().before(syncButton).before(speedSlider);
			$('#ttx-laptop-sync-button').click(toggleSync);
			$('#ttx-laptop-speed-button').parent().mouseover(function(){
				if (laptopMenuHover){
					clearTimeout(laptopMenuHover);
					laptopMenuHover = null;
				}
				$(this).addClass('hover');
				$('#ttx-laptop-menu-button').parent().removeClass('hover');
				$('.header-well-buttons').not('#ttx-laptop-menu-container').find('.dropdown-container').removeClass('hover').find('.header-well-dropdown').hide();
			}).mouseout(function(){
				var self = $(this);
				laptopMenuHover = setTimeout(function(){ self.removeClass('hover'); },600);
			});

			// add speed controls
			$('#ttx-laptop-speed-button').click(reverseAnimation);
			$('#ttx-laptop-speed-knob').draggable({containment:$('#ttx-laptop-speed-slider'),axis:'y',drag:function(ev,ui){
				var offset = ui.position.top;
				// 0 => max speed (0.10s)
				// 99 => min speed (5.10s)
				// 100 => off
				var displaySpeed;
				if (offset === 100){
					_animate.speed = 0;
					displaySpeed = '0.00s';
				}
				else{
					if (offset < 0){
						offset = 0;
					}
					offset = Math.round(offset);
					_animate.speed = 10*(10+offset*5);
					displaySpeed = msFormat(_animate.speed);
					//_animate.speed += 15000; // + 15 seconds
				}
				$('#ttx-laptop-speed-label').text(displaySpeed);
				$('#ttx-laptop-speed-fill').css('height',(105-ui.position.top)+'px');
			}});
		}
	}
	function hideLaptopSpeedDial(){
		$('#ttx-laptop-speed-dropdown').hide().appendTo($('body'));
		$('#ttx-laptop-sync-dropdown').hide().appendTo($('body'));
	}
	
	// update the laptop dropdown
    function updateLaptops(){
		
    	var laptops = settings.laptop.stickers.animations;
    	var selected = settings.laptop.stickers.selected;
        var now = util.now();
    	var laptopDivs = '';
    	var count = 0;
    	var toDelete = [];
    	for (var i in laptops){
    		if (typeof laptops[i].frames === 'undefined'){
    			if (selected === i){
    				settings.laptop.stickers.selected = '';
    			}
    			continue;
    		}
    		count++;
    		laptopDivs += '<li id="ttx-menu-item'+count+'-'+now+'" class="option ttx-menu-item' + (i === selected ? ' selected' : '') + '"><span class="ttx-menu-name">' + i + '</span><div class="ttx-menu-edit"></div></li>';
    	}
    	
    	
    	var content = '<li class="ttx-menu-item option special add" style="margin-bottom: 2px;text-align:center;">New Laptop</li><li id="ttx-laptop-menu-scrollable"><ul>' + laptopDivs + '</ul></li>';
    	if ( $('#ttx-laptop-menu-container').length === 0){
    		$('#volume-control').before('<ul class="header-well-buttons" id="ttx-laptop-menu-container">\
    										<li class="dropdown-container">\
    											<div class="header-well-button" id="ttx-laptop-menu-button"/>\
    											<ul class="floating-menu down" id="ttx-laptop-menu">'+content+'</ul>\
    										</li>\
    					     			</ul>');
    	}
    	else{
    		$('#ttx-laptop-menu').html(content);
    	}
    	
    	$('#ttx-laptop-menu .ttx-menu-edit').click(function(e){
    		e.preventDefault();
    		e.stopPropagation();
    		var animation = $(this).parent().find('.ttx-menu-name').text();
    		if (settings.laptop.stickers.animations[animation]){
    			settings.laptop.stickers.animations[animation].name = animation; // fix name
    			customStickerEditor(animation);
    		}
    	});
    	$('#ttx-laptop-menu .ttx-menu-item').click(function(e){
    		if ($(this).hasClass('add')){ // popup laptop dialog
    			customStickerEditor();
    			return;
			}
			var name = $(this).find('.ttx-menu-name').text();
			if ($(this).hasClass('selected')){
				$(this).removeClass('selected');
				settings.laptop.stickers.selected = '';
				saveSettings();
				stopAnimation(); 
			}
			else{
				$(this).parent().children().removeClass('selected');
	        	$(this).addClass('selected');
	        	if( settings.laptop.stickers.animations[name] ){ // if its a valid animation
					settings.laptop.stickers.selected = name;
					saveSettings();
	        		animateLaptop(); // start animation
				}
			}
    	});
    }
	


	// preview stickers
	function previewStickers(laptopView,newLaptopAnimation){
		var laptopView = laptopView || $('#laptopView');
		if (newLaptopAnimation.type === 'custom'){ // custom
			if (newLaptopAnimation.selected === newLaptopAnimation.frames.length){ // loop back around
				_editor.timer = setTimeout(function(){ 
					$('#ttx-laptop-start').click();
					previewStickers(laptopView,newLaptopAnimation);
				}, 250);
			}
			else{
				_editor.timer = setTimeout(function(){
					$('#ttx-laptop-scroll-right').click();
					previewStickers(laptopView,newLaptopAnimation);
				}, 250);
			}
			
		}
		else{ // text
			var preview_color_index = 0;
			var preview_text_index = 0;
			ticks = newLaptopAnimation.text.tick;
			text_len = 2*newLaptopAnimation.text.display.length;
			color_len = newLaptopAnimation.text.colors.length;			
			_editor.timer = setInterval(function(){
				renderStickerText(laptopView,newLaptopAnimation,preview_text_index,preview_color_index);
				preview_text_index = ((preview_text_index+ticks) % text_len);
				if (newLaptopAnimation.text.colorEachLetter){
					odd = (preview_text_index % 2) === 1;
					preview_color_index = ((preview_color_index+Math.floor((ticks + (odd?1:0))/2)) % color_len);
				}
				else{
					preview_color_index = ((preview_color_index + 1) % color_len);
				}
			},250);
		}
	}
	// paste the stickers into the current frame
	function pasteStickers(laptop,frame){
		renderStickers(laptop,frame);
	}
	// copy stickers and return a frame
	function copyStickers(laptop){
		var result = [];
		var count = 0;
		laptop.children().each(function(){ // loop over each sticker and save to the array
			if (count === 20){ // only copy the first 20 stickers
				return;
			}
			var stickerDiv = $(this);
			var sticker_id = $(this).data('sticker_id');
			var angle = $(this).data('angle');
			var left = parseInt($(this).css('left').replace(/px/,''));
			var top = parseInt($(this).css('top').replace(/px/,''));
			result.push({sticker_id:sticker_id,angle:angle,left:left,top:top});
			count += 1;
		});
		return result;
	}
	// save a frame of stickers to the animation
	function saveStickers(laptop,animation,selected){
		animation.frames[selected] = copyStickers(laptop);
	}
	// clear a frame of stickers
	function clearStickers(laptop){
		laptop.children().each(function(){ 
			if (typeof $(this).attr('id') !== 'undefined'){ // has id => generated by TTX, remove the normal way
				$(this).remove();
			}
			else{ // needs to removed with the bounding box
				$(this).mouseover(); $('#boundingBoxX').mouseup();	
			}
			
		}); // remove all current stickers
		setTimeout(function(){$('#laptopScreen .boundingBox').hide()},100);
	}

	// render a frame of stickers (editor)
	function renderStickers(laptop,placements){
		if (laptop === 'live'){
			updateLaptopStickers(placements);
			return;
		}
		clearStickers(laptop);
		for (var i=0; i<placements.length; i++){
			// create a div of the sticker
			var sticker = placements[i];
			var stickerID = sticker.sticker_id;
			var stickerData = STICKER_MAP[stickerID];
			var stickerDiv = '<div id="ttxSticker'+i+'" class="sticker" style="background-image:url('+stickerData.url+'); height: '+stickerData.height+'px; width: '+stickerData.width+'px; top: '+sticker.top+'px; left: '+sticker.left+'px; -webkit-transform: rotate('+sticker.angle+'deg); background-position: initial initial; background-repeat: initial initial;"></div>';
			// add the sticker to the laptop view
			laptop.append(stickerDiv);
			// add jquery data for bounding box
			$('#ttxSticker'+i).data('angle',sticker.angle);
			$('#ttxSticker'+i).data('sticker_id',stickerID);
		}
	}
	// render sticker text (editor)
	function renderStickerText(laptop,animation,start_index,color_index){
			start_index = (typeof start_index !== 'undefined') ? start_index : 0;
			color_index = (typeof color_index !== 'undefined') ? color_index : 0;
			var full_color_text = animation.text.colors.toUpperCase();
			var full_text = animation.text.display.toUpperCase();
			var text = full_text.substring(Math.floor(start_index/2));
			var color_text = full_color_text.substring(color_index);
            var offset = 0;
            if (start_index % 2 === 1){ 
                offset = -1*(LETTER_WIDTH/2)
            }
			var letter_limit = (offset === 0 ? 3 : 4); // limit of 3-4 letters
			var text_len = text.length;
			var full_len = full_text.length;
			if (full_len === 0){
				renderStickers(laptop,[]);
				return;
			}
			var c = 0;
			while (text_len < 4){
				// loop around and get characters from the front
				text = text + full_text.charAt(c)
				text_len = text.length
				c = ((c+1) % full_len);
			}
			var color_text_len = color_text.length;
			var full_color_text_len = full_color_text.length;
			if (full_color_text_len === 0){
				full_color_text = DEFAULT_COLOR; // default color		
			}
			c = 0;
			if (animation.text.colorEachLetter){ // add colors by looping around
				while (color_text_len < 4){
					color_text = color_text + full_color_text.charAt(c);
					color_text_len = color_text.length;
					c = ((c+1) % full_color_text_len);
				}
			}
			var stickers_placed = 0;
			var letters_placed = 0; 

			var new_placements = [];
			for (var i = 0; i < text_len; i++){
				var color = (animation.text.colorEachLetter ? color_text[i]:color_text[0]);
				if (typeof COLOR_MAP[color] !== 'undefined')
					color = COLOR_MAP[color];
				else
					color = random_item(COLOR_MAP);	
				var c = text.charAt(i);
				var map_placements = LETTER_MAP[c];
				var placements = [];
				if (typeof map_placements !== 'undefined'){
                    if (i==0 && offset !== 0){ // offset + first letter, only use stickers with rightmost point.x > LETTER_WIDTH/2
						for(var m = 0; m < map_placements.length; m+=1){
							mp = map_placements[m];
							if (mp.left+(LETTER_WIDTH/2)*(1 + Math.cos(mp.angle*Math.PI/180)) > (LETTER_WIDTH/2)-7)
								placements.push({left:mp.left,top:mp.top,angle:mp.angle});
						}
					}
					else if (i==3){ // placing 4th letter (offset), only use stickers with leftmost point.x < LETTER_WIDTH/2
						for(var m = 0; m < map_placements.length; m+=1){
							mp = map_placements[m];
							if (mp.left+(LETTER_WIDTH/2)*(1 - Math.cos(mp.angle*Math.PI/180)) < (LETTER_WIDTH/2)+7)
								placements.push({left:mp.left,top:mp.top,angle:mp.angle});
						}
					}
					else{
						placements = map_placements;
					}
					if (stickers_placed + placements.length > STICKER_LIMIT || letters_placed > letter_limit){
						break;
					}
					for (var p = 0;  p<placements.length; p+=1){
						var place = placements[p];
						var new_place = {};
						$.extend(new_place,place,{sticker_id:color});
						new_place.left = new_place.left + offset + (LETTER_WIDTH * letters_placed);
						new_placements.push(new_place);
					}
					stickers_placed += placements.length;
					letters_placed += 1;
				}
			}
			renderStickers(laptop,new_placements);
			
	}
	var stickerWaitTimer = null;
	function customStickerEditor(animation){
		if (stickerWaitTimer === null){
			requirejs('sticker').showEditor();
			stickerWaitTimer = setTimeout(customStickerEditorComplete(animation),250);
		}
		else{ // deal with double click
			setTimeout(function(){
				if(stickerWaitTimer === null){
					clearTimeout(stickerWaitTimer);
					stickerWaitTimer = null;
				}
			},10000);
		}
	}
	var _editor = {
		copy: null,
		timer: null
	};
	function customStickerEditorComplete(animation){
		if($('#stickerModal').is(':visible')){

			var modal = $('#stickerModal');
			var originalAnimation, newAnimation, laptop, frameCounter, picker, laptopView, boundingBox;

			animation = animation || null;
			if (animation === null){ // new animation
				newAnimation = {
					name: '',
					type: 'custom',
					speed: 500,
					text: {
						display: '',
						colors: '',
						colorEachLetter: true,
						tick: 1
					},
					frames: [[]] // one frame with no stickers
				};
				modal.find('.title').text('Create a New Laptop');
			}
			else{ // edit an existing animation
				originalAnimation = settings.laptop.stickers.animations[animation];
				newAnimation = $.extend(true,{},originalAnimation);
				modal.find('.title').text('Edit Your Laptop');
			}
			// save important elements
			laptop = modal.find('#laptop');
			frameCounter = modal.find('h3:contains("Your Stickers")');
			picker = modal.find('#picker');
			laptopView = modal.find('#laptopView');
			boundingBox = laptop.find('.boundingBox');
			modal.find('#remainingCount').hide();
			frameCounter.prependTo(laptop).css({'width':'708px','text-align':'center','z-index':110,'position':'absolute','top':'5px','left':'0px'});

			newAnimation.selected = 1;
			if (animation !== null){ // render the old stickers
				if (newAnimation.type === 'text'){
					renderStickerText(laptopView,newAnimation);
				}
				else{
					renderStickers(laptopView,newAnimation.frames[newAnimation.selected-1]);
				}
			}
			else{
				clearStickers(laptopView);
			}
			// add general laptop settings
			laptop.before('<div id="ttx-laptop-settings" style="width:100%; padding-bottom:40px">\
					<div><div style="display:inline-block; margin: 8px; width:80px">Name:</div><input style="width: 300px; height:10px; position:relative;" id="ttx-laptop-name" type="text" value="'+newAnimation.name+'"/></div>\
					<div><div style="display:inline-block; margin: 8px; width:80px">Animation:</div><input name="ttx-laptop-animation" style="margin-right:5px" type="radio" value="text" '+(newAnimation.type === 'text' ? 'checked':'')+'/>text<input name="ttx-laptop-animation" type="radio" style="margin-left:12px; margin-right:5px" value="custom" '+(newAnimation.type === 'custom' ? 'checked':'')+'/>custom</div>\
					</div>');

			$('<div id="ttx-laptop-scroll-left" title="Previous Frame" class="ttx-laptop-editor-button inactive"></div>').appendTo(laptop);
			$('<div id="ttx-laptop-scroll-right" title="Next Frame" class="ttx-laptop-editor-button inactive"></div>').appendTo(laptop);
			$('<div id="ttx-laptop-cut" title="Cut Frame" class="ttx-laptop-editor-button inactive"></div>').appendTo(laptop);
			$('<div id="ttx-laptop-copy" title="Copy Frame" class="ttx-laptop-editor-button"></div>').appendTo(laptop);
			$('<div id="ttx-laptop-paste" title="Paste Frame" class="ttx-laptop-editor-button inactive"></div>').appendTo(laptop);
			$('<div id="ttx-laptop-insert" title="Insert Frame" class="ttx-laptop-editor-button"></div>').appendTo(laptop);
			$('<div id="ttx-laptop-start" title="First Frame" class="ttx-laptop-editor-button inactive"></div>').appendTo(laptop);
			$('<div id="ttx-laptop-end" title="Last Frame" class="ttx-laptop-editor-button inactive"></div>').appendTo(laptop);

		
			if (_editor.copy !== null){
				$('#ttx-laptop-paste').removeClass('inactive');
			}
			if (newAnimation.frames.length > 1){
				$('#ttx-laptop-scroll-right,#ttx-laptop-end,#ttx-laptop-cut').removeClass('inactive');
			}
			var save_button = '<div id="ttx-laptop-save" class="ttx-laptop-editor-button" title="Save"><div style="width:100%;height:100%;" id="ttx-laptop-clip"></div></div>';
			var preview_button = '<div class="ttx-laptop-editor-button" title="Preview" id="ttx-laptop-preview"></div>';
			var delete_button = '<div class="ttx-laptop-editor-button" title="Delete" id="ttx-laptop-delete"></div>';

			var top_buttons = modal.find('.buttons').css({position:'absolute',top:'15px',right:'15px'});
			if (originalAnimation === null){
				// no delete
				top_buttons.html(preview_button+save_button);
			}
			else{
				top_buttons.html(preview_button+save_button+delete_button);
			}
			// add laptop text settings
			picker.before('<div id="ttx-laptop-text-settings" style="display:none; margin-bottom:10px; width:100%; padding-top:10px;">\
					<div><div style="display:inline-block; margin: 8px; width:80px">Text:</div><input style="width: 300px; height:10px; position:relative; margin-right:10px" id="ttx-laptop-text" type="text" value="'+newAnimation.text.display+'"/>tick number: <input type="text" id="ttx-laptop-tick" style="width:30px;height:10px;" value="'+ newAnimation.text.tick +'"/></div>\
					<div><div style="display:inline-block; margin: 8px; width:80px">Colors:</div><input style="width: 300px; height:10px; position:relative; margin-right:10px" id="ttx-laptop-colors" type="text" value="'+newAnimation.text.colors+'"/>each letter: <input type="checkbox" id="ttx-laptop-color-each" '+ (newAnimation.text.colorEachLetter ? 'checked="checked"':'') + '</div>\
					</div>');
					
			if (newAnimation.type==='text'){
				$('#ttx-laptop-text-settings').show();
			}
			$('#ttx-laptop-delete').bind('click',function(){
					var answer = confirm('Are you sure you want to delete laptop ' + animation +'?');
					if (answer === true){
						$('#overlay').html('').hide();
						delete settings.laptop.stickers.animations[animation];
						updateLaptops();
						saveSettings();
					}
				});
			$('#ttx-laptop-preview').click(function(){
				if (_editor.timer === null){
					if (newAnimation.type === 'custom'){
						saveStickers(laptopView,newAnimation,newAnimation.selected-1);
						$('#ttx-laptop-start').click();
						previewStickers(laptopView,newAnimation);
					}
					else{
						newAnimation.text.colors = $('#ttx-laptop-colors').val();
						newAnimation.text.display = $('#ttx-laptop-text').val();
						newAnimation.text.tick = parseInt($('#ttx-laptop-tick').val());
						if (isNaN(newAnimation.text.tick)){
							newAnimation.text.tick = 3;
						}
						newAnimation.text.colorEachLetter = $('#ttx-laptop-color-each').is(':checked');
						previewStickers(laptopView,newAnimation);
					}
					$(this).addClass('stop');
				}
				else{
					clearTimeout(_editor.timer);
					_editor.timer = null;
					$(this).removeClass('stop');
				}

			});
			if (_editor.timer !== null){
				$('#ttx-laptop-preview').addClass('stop');
			}

			// zero clipboard setup
			var clipboard = new ZeroClipboard.Client();
			clipboard.setCSSEffects(true);
	    	clipboard.glue('ttx-laptop-clip','ttx-laptop-save');
	    	clipboard.addEventListener('mouseDown',function(){
	    		var name = $('#ttx-laptop-name').val();
				if (name === ''){
					alert('Please pick a name for your new laptop!');
					return;
				}
				if (animation !== null && name != animation && name !== ''){
					var answer = confirm('You were editing laptop ' + animation + ', do you want to change the name to ' + name + '?');
					if(!answer){
						return;
					}
					if (settings.laptop.stickers.animations[name]){
						alert('You already have a laptop called ' + name + '! Delete it first');
						return;
					}
					delete settings.laptop.stickers.animations[animation];
				}
				

				saveStickers(laptopView,newAnimation,newAnimation.selected-1); // save current frame's stickers
				
				newAnimation.text.colors = $('#ttx-laptop-colors').val();
				newAnimation.text.display = $('#ttx-laptop-text').val();
				newAnimation.text.tick = parseInt($('#ttx-laptop-tick').val());
				if (isNaN(newAnimation.text.tick)){
					newAnimation.text.tick = 3;
				}
				newAnimation.text.colorEachLetter = $('#ttx-laptop-color-each').is(':checked');
				// save text settings
				newAnimation.name = name;
				settings.laptop.stickers.animations[name] = newAnimation;

				var clipObject = {};
				clipObject[name] = newAnimation;
				var clipText = 'XMSG!' + btoa(JSON.stringify(clipObject));
				clipboard.setText(clipText);
    		
    			setTimeout(function(){alert('The laptop "' + name + '" has been saved and copied to your clipboard. Try pasting it into a PM!');},500);

				//$('#overlay').html('').hide();
				updateLaptops(); // update menu 
				saveSettings(); // save
	    	});

			$('#remainingCount').hide();
			if (newAnimation.type === 'text'){ // hide the custom-only items
				$('#picker').hide();
				
				$('.ttx-laptop-editor-button').not('#ttx-laptop-preview,#ttx-laptop-save,#ttx-laptop-delete').hide();
		
				frameCounter.hide();
			}
			else{ // hide the text-only items
				$('#ttx-laptop-text-settings').hide();
			}
			
			$('input[name="ttx-laptop-animation"]',$('#ttx-laptop-settings')).change(function(e){
				var new_type = $(this).val();
				newAnimation.type = new_type;
				if (new_type === 'text'){
					$('#picker').hide();
					
					$('.ttx-laptop-editor-button').not('#ttx-laptop-preview,#ttx-laptop-save,#ttx-laptop-delete').hide();
					frameCounter.hide();
					
					$('#ttx-laptop-text-settings').show();

					newAnimation.text.colors = $('#ttx-laptop-colors').val();
					newAnimation.text.display = $('#ttx-laptop-text').val();
					newAnimation.text.tick = parseInt($('#ttx-laptop-tick').val());
					if (isNaN(newAnimation.text.tick)){
						newAnimation.text.tick = 3;
					}
					newAnimation.text.colorEachLetter = $('#ttx-laptop-color-each').is(':checked');
					renderStickerText(laptopView,newAnimation);
				}
				else{
					$('#picker').show();
				
					$('.ttx-laptop-editor-button').show();
					frameCounter.show();
					
					$('#ttx-laptop-text-settings').hide();
					renderStickers(laptopView,newAnimation.frames[newAnimation.selected-1]);
				}
			});
			
			
			$('#ttx-laptop-copy').click(function(e){
				_editor.copy = copyStickers(laptopView);
				$('#ttx-laptop-paste').removeClass('inactive');
			});
			$('#ttx-laptop-paste').click(function(e){
				if($(this).hasClass('inactive')){
					return;
				}
				if (_editor.copy !== null){
					pasteStickers(laptopView,_editor.copy);
				}
				
			});
			$('#ttx-laptop-insert').click(function(e){
				saveStickers(laptopView,newAnimation,newAnimation.selected-1); // save the stickers to the current frame

				if (newAnimation.selected === newAnimation.frames.length){ // add new frame to the end
					newAnimation.frames.push([]);
				}
				else{ // add new frame to the middle
					var framesAfter = newAnimation.frames.slice(newAnimation.selected);
					var framesBefore = newAnimation.frames.slice(0,newAnimation.selected);
					framesBefore.push([]);
					
					newAnimation.frames = framesBefore.concat(framesAfter);

				}
				newAnimation.selected += 1;
				clearStickers(laptopView); // blank frame
				frameCounter.text('Frame '+ newAnimation.selected +' of '+newAnimation.frames.length); // update frame counter
				$('#ttx-laptop-cut,#ttx-laptop-start,#ttx-laptop-scroll-left').removeClass('inactive'); // delete/move left is no longer inactive
			});

			$('#ttx-laptop-cut').click(function(e){
				$('#ttx-laptop-copy').click(); // copy the stickers

				var numFrames = newAnimation.frames.length;
				var selected = newAnimation.selected;
				if (numFrames === 1){
					return;
				}
				if (numFrames === 2){
					$(this).addClass('inactive');
					$('#ttx-laptop-start,#ttx-laptop-end,#ttx-laptop-scroll-left,#ttx-laptop-scroll-right').addClass('inactive');
				}
				if (selected === numFrames){
					newAnimation.selected -= 1;
					newAnimation.frames.pop();
				}
				else{ 
					newAnimation.frames = newAnimation.frames.slice(0,newAnimation.selected-1).concat(newAnimation.frames.slice(newAnimation.selected));
				}

				renderStickers(laptopView,newAnimation.frames[newAnimation.selected-1]);
				frameCounter.text('Frame '+ newAnimation.selected +' of '+newAnimation.frames.length); // update frame counter
			});
			$('#ttx-laptop-scroll-right').click(function(e){ // add a new frame / move to the right
				if ($(this).hasClass('inactive')){
					return;
				}
				saveStickers(laptopView,newAnimation,newAnimation.selected-1); // save the stickers to the current frame
				newAnimation.selected += 1; // update the current frame counter
				renderStickers(laptopView,newAnimation.frames[newAnimation.selected-1]); // remove old stickers and render new stickers
				if (newAnimation.selected === newAnimation.frames.length){
					$(this).addClass('inactive'); // disable right scroller, this is the last frame
					$('#ttx-laptop-end').addClass('inactive');
				}
				frameCounter.text('Frame '+ newAnimation.selected +' of '+newAnimation.frames.length); // update frame counter
				$('#ttx-laptop-scroll-left,#ttx-laptop-start').removeClass('inactive'); // enable left scroller since we just moved up a frame
			}).mouseover(function(){ boundingBox.hide(); });
			$('#ttx-laptop-scroll-left').click(function(e){
				if ($(this).hasClass('inactive')){
					return;
				}
				saveStickers(laptopView,newAnimation,newAnimation.selected-1);
				newAnimation.selected -= 1;
				renderStickers(laptopView,newAnimation.frames[newAnimation.selected-1]);
				if (newAnimation.selected === 1){
					$(this).addClass('inactive'); // disable left scroller, this is the first frame
					$('#ttx-laptop-start').addClass('inactive');
				}
				frameCounter.text('Frame ' + newAnimation.selected+' of '+newAnimation.frames.length); // update frame counter
				$('#ttx-laptop-scroll-right,#ttx-laptop-end').removeClass('inactive'); // enable right scroller since we just moved down a frame
			}).mouseover(function(){ boundingBox.hide(); });
			$('#ttx-laptop-start').click(function(e){
				saveStickers(laptopView,newAnimation,newAnimation.selected-1);
				$(this).addClass('inactive');
				$('#ttx-laptop-scroll-left').addClass('inactive');
				if (newAnimation.frames.length > 1){
					$('#ttx-laptop-end').removeClass('inactive');
					$('#ttx-laptop-scroll-right').removeClass('inactive');
				}
				
				newAnimation.selected = 1;
				renderStickers(laptopView,newAnimation.frames[newAnimation.selected-1]);
				frameCounter.text('Frame ' + newAnimation.selected +' of '+newAnimation.frames.length);
			});
			$('#ttx-laptop-end').click(function(e){
				saveStickers(laptopView,newAnimation,newAnimation.selected-1);
				$(this).addClass('inactive');
				$('#ttx-laptop-scroll-right').addClass('inactive');
				if (newAnimation.frames.length > 1){
					$('#ttx-laptop-start').removeClass('inactive');
					$('#ttx-laptop-scroll-left').removeClass('inactive');
				}

				newAnimation.selected = newAnimation.frames.length;
				renderStickers(laptopView,newAnimation.frames[newAnimation.selected-1]);
				frameCounter.text('Frame ' + newAnimation.selected +' of '+newAnimation.frames.length);
			});

			// update the text for the frame counter
		    frameCounter.text('Frame ' + newAnimation.selected +' of '+newAnimation.frames.length);
		    stickerWaitTimer = null;
		}
		else{
			setTimeout(function(){customStickerEditorComplete(animation)},50);
		}
	}

	function setLaptop(laptop){
        send({api:'user.modify',laptop:laptop});
    }
// END LAPTOP
	
	return {
		'send' : send,
		'getRoom' : getRoom,
		'getRoomView': getRoomView,
		'matchCSS': matchCSS,
		'Server':Server
	}
}
})();

turntableX = new TTX();
});
