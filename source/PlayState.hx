package;

import openfl.ui.KeyLocation;
import openfl.events.Event;
import haxe.EnumTools;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import Replay.Ana;
import Replay.Analysis;
#if cpp
import webm.WebmPlayer;
#end
import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.utils.Assets as OpenFlAssets;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;


import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

import flash.system.System;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var weekScore:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var bfAccess:Boyfriend;
	public static var sicks:Int = 0;
	public static var mania:Int = 0;
	public static var maniaToChange:Int = 0;
	public static var campaignMisses:Int = 0;
	public static var seenCutscene:Bool = false;
	public static var deathCounter:Int = 0;
	public static var keyAmmo:Array<Int> = [4, 6, 9, 5, 7, 8, 1, 2, 3];
	private var ctrTime:Float = 0;
	var songEnded:Bool = false;
	var shadow1:FlxSprite;
	var isCameraOnForcedPos:Bool = false;
	var crasher:Character;
/*	#if (haxe >= "4.0.0")
	public var boyfriendMap:Map<String, Boyfriend> = new Map();
	public var dadMap:Map<String, Character> = new Map();
	public var gfMap:Map<String, Character> = new Map();
	#else
	public var boyfriendMap:Map<String, Boyfriend> = new Map<String, Boyfriend>();
	public var dadMap:Map<String, Character> = new Map<String, Character>();
	public var gfMap:Map<String, Character> = new Map<String, Character>();
	#end*/
	public var timeTxt:String;
	var shadow2:FlxSprite;
	public var maxHealth:Float = 0;

	public static var songPosBG:FlxSprite;
	public var visibleCombos:Array<FlxSprite> = [];
	public static var songPosBar:FlxBar;
	public var eventNotes:Array<Dynamic> = [];

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;
	var s_ending:Bool = false;
	var jumpScare:FlxSprite;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public var originalX:Float;

	public static var maskMouseHud:FlxTypedGroup<FlxSprite>;
	public static var maskCollGroup:FlxTypedGroup<MASKcoll>;
	public static var maskTrailGroup:FlxTypedGroup<FlxTrail>; //FUCK.
	public static var maskFxGroup:FlxTypedGroup<FlxSprite>;
	var isMonoDead:Bool = false;

	private var cutTime:Float;
	private var shaggyT:FlxTrail;
	private var notice:FlxText;
	private var nShadow:FlxText;

	var funneEffect:FlxSprite;
	var burst:FlxSprite;
	var rock:FlxSprite;
	var gf_rock:FlxSprite;
	var doorFrame:FlxSprite;
	var songPercent:Float = 0;

	public static var arrowSliced:Array<Bool> = [false, false, false, false, false, false, false, false, false]; //leak :)

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	private var maskFollowPos:FlxObject;

	var tb_x = 60;
	var tb_y = 410;
	var tb_fx = -510 + 40;
	var tb_fy = 320;
	var tb_rx = 200 - 55;
	var jx:Int;

	var curr_char:Int;
	var curr_dial:Int;
	var dropText:FlxText;
	var tbox:FlxSprite;
	var talk:Int;
	var tb_appear:Int;
	var dcd:Int;
	var fimage:String;
	var fsprite:FlxSprite;
	var fside:Int;
	var black:FlxSprite;
	var dchar:Array<String>;
	var dface:Array<String>;
	var dside:Array<Int>;
	var tb_open:Bool = false;

	var afterAction:String = 'countdown';
	private var updateTime:Bool = false;

	var textIndex = 'example';

	var vc_sfx:FlxSound;

	var legs:FlxSprite;
	var legT:FlxTrail;

	//cum
	var camLerp:Float = 1;
	var bgDim:FlxSprite;
	var fullDim = false;
	var noticeTime = 0;
	var dimGo:Bool = false;

	//funkin lua???
	//var luaArray:Array<FunkinLua> = [];

	//cutscenxs
	var sEnding = 'none';

	//bgggg
	public static var bgTarget = 0;
	public var backgroundGroup:FlxTypedGroup<FlxSprite>;
	public static var bgEdit = false;

	//zephyrus ete zeph
	var zeph:FlxSprite;
	var zephScreen:FlxSprite;
	var zephState:Int = 0;
	var zephAddX:Float = 0;
	var zephAddY:Float = 0;
	var zLockX:Float = 0;
	var zLockY:Float = 0;

	public var notes:FlxTypedGroup<Note>;
	var noteSplashes:FlxTypedGroup<NoteSplash>;
	public var songMisses:Int = 0;
	private var unspawnNotes:Array<Note> = [];
	private var sDir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	private var bfsDir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	var replacableTypeList:Array<Int> = [3,4,7]; //note types do wanna hit
	var nonReplacableTypeList:Array<Int> = [1,2,6]; //note types you dont wanna hit

	var maskFollow:FlxPoint;

	private static var prevMaskFollow:FlxPoint;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	var grace:Bool = false;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	public static var misses:Int = 0;
	public static var campaignGoods:Int = 0;
	public static var campaignBads:Int = 0;
	public static var campaignShits:Int = 0;
	public var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;
	public static var usedPractice:Bool = false;
	public static var changedDifficulty:Bool = false;
	public static var cpuControlled:Bool = false;


	var hudArrows:Array<FlxSprite>;
	var hudArrXPos:Array<Float>;
	var hudArrYPos:Array<Float>;

	var hold:Array<Bool>;
	var press:Array<Bool>;
	var release:Array<Bool>;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var overhealthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	public var camSustains:FlxCamera;
	public var camNotes:FlxCamera;
	public var cannotDie = false;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;
	var idleToBeat:Bool = true; // change if bf and dad would idle to the beat of the song
	var idleBeat:Int = 2; // how frequently bf and dad would play their idle animation(1 - every beat, 2 - every 2 beats and so on)

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var heyTimer:Float;

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	public var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;
	var startedCountdown:Bool = false;

	var maniaChanged:Bool = false;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;
//	public var boyfriendGroup:FlxTypedGroup<Boyfriend>;
	public var backGroup:FlxTypedGroup<FlxTrail>;
//	public var dadGroup:FlxTypedGroup<Character>;
//	public var gfGroup:FlxTypedGroup<Character>;

	public static var daPixelZoom:Float = 6;

	public var currentSection:SwagSection;

	public static var theFunne:Bool = true;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Dynamic> = [];
	private var saveJudge:Array<String> = [];
	private var replayAna:Analysis = new Analysis(); // replay analysis

	public static var highestCombo:Int = 0;

	private var executeModchart = false;
	public static var startTime = 0.0;
	public var foregroundGroup:FlxTypedGroup<FlxSprite>;
	var halloweenWhite:BGSprite;

	var unowning:Bool = false;

	//P2 CHARACTER STUFF
	private var dad2:Character;
	var exDad:Bool = false;
	var songLengthTime:Float = 0; //used to display how much of the song is left next to song name on green bar. yes ported straight from psych. suprised there isn't a "kade * psych" yet.

	public var BF_X:Float = 770;
	public var BF_Y:Float = 450;
	public var DAD_X:Float = 100;
	public var DAD_Y:Float = 100;
	public var GF_X:Float = 400;
	public var GF_Y:Float = 130;
	public var celebiLayer:FlxTypedGroup<FlxSprite>;
	var psyshockParticle:Character;	
	var pendulum:Pendulum;
	var tranceThing:FlxSprite;
	var tranceDeathScreen:FlxSprite;
	var pendulumShadow:FlxTypedGroup<FlxSprite>;
	var trance:Float = 0;

	var tranceActive:Bool = false;
	var tranceDrain:Bool = false;
	var tranceSound:FlxSound;
	var tranceCanKill:Bool = true;
	var pendulumDrain:Bool = true;
	var psyshockCooldown:Int = 80;
	var psyshocking:Bool = false;
	var keyboardTimer:Int = 8;
	var keyboard:FlxSprite;

	//Handles the new epic mega sexy cam code that i've done
	private var camFollow:FlxPoint;
	private var camFollowPos:FlxObject;
	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;

	//some expurgation stuff

	public var hank:FlxSprite;
	public var hexError:FlxSprite;
	public var terminateError:FlxSprite;

	var cover:FlxSprite = new FlxSprite(-180,755).loadGraphic(Paths.image('fourth/cover','shared'));
	var hole:FlxSprite = new FlxSprite(50,530).loadGraphic(Paths.image('fourth/Spawnhole_Ground_BACK','shared'));
	var converHole:FlxSprite = new FlxSprite(7,578).loadGraphic(Paths.image('fourth/Spawnhole_Ground_COVER','shared'));

	var tstatic:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('fourth/TrickyStatic','shared'), true, 320, 180);
	var tStaticSound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("staticSound","shared"));

	var totalDamageTaken:Float = 0;
	var shouldBeDead:Bool = false;
	var interupt = false;
	var grabbed = false;

	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }
	public function destroyObject(object:FlxBasic) { object.destroy(); }

	override public function create()
	{
		rotCam = false;
		camera.angle = 0;

		//this fixed a bug where leaving a stage while rotation was on, would continue rotation in another song.

		FlxG.mouse.visible = false;
		instance = this;
		
		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		if (!isStoryMode)
		{
			sicks = 0;
			bads = 0;
			shits = 0;
			goods = 0;
		}
		misses = 0;

		repPresses = 0;
		repReleases = 0;

		if (SONG.song.toLowerCase() == 'live-on' || SONG.song.toLowerCase() == 'big-shot' || SONG.song.toLowerCase() == 'whats-bugged' || SONG.song.toLowerCase() == 'infinite-songs' || SONG.song.toLowerCase() == 'sweet-sauce' || SONG.song.toLowerCase() == 'loca' || SONG.song.toLowerCase() == 'godalovania'|| SONG.song.toLowerCase() == 'expurgation' )
			{
				if (!FlxG.save.data.unlockedExtra)
				{
					#if debug
					#else
					fullDim = true;
					isStoryMode = false;
					#end
				}
				else {
					trace('u actually got here :)');
				}
			}

		if (SONG.song == 'Talladega' && FlxG.save.data.p_partsGiven < 5)
			{
				#if debug
				#else
				fullDim = true;
				isStoryMode = false;
				#end
			}


		PlayStateChangeables.useDownscroll = FlxG.save.data.downscroll;
		PlayStateChangeables.safeFrames = FlxG.save.data.frames;
		PlayStateChangeables.scrollSpeed = FlxG.save.data.scrollSpeed;
		PlayStateChangeables.botPlay = FlxG.save.data.botplay;
		PlayStateChangeables.Optimize = FlxG.save.data.optimize;
		PlayStateChangeables.zoom = FlxG.save.data.zoom;
		PlayStateChangeables.bothSide = FlxG.save.data.bothSide;
		PlayStateChangeables.flip = FlxG.save.data.flip;
		PlayStateChangeables.randomNotes = FlxG.save.data.randomNotes;
		PlayStateChangeables.randomSection = FlxG.save.data.randomSection;
		PlayStateChangeables.randomMania = FlxG.save.data.randomMania;
		PlayStateChangeables.randomNoteTypes = FlxG.save.data.randomNoteTypes;

		if (SONG.song.toLowerCase() == 'paradoxial') PlayStateChangeables.Optimize = false;

		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}
		
		removedVideo = false;

		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase  + "/modchart"));
		if (executeModchart)
			PlayStateChangeables.Optimize = false;
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart"));


		noteSplashes = new FlxTypedGroup<NoteSplash>();
		var daSplash = new NoteSplash(100, 100, 0);
		daSplash.alpha = 0;
		noteSplashes.add(daSplash);


		#if windows
		// Making difficulty text for Discord Rich Presence.
		storyDifficultyText = CoolUtil.ShaggydifficultyFromInt(storyDifficulty);

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camSustains = new FlxCamera();
		camSustains.bgColor.alpha = 0;
		camNotes = new FlxCamera();
		camNotes.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camSustains);
		FlxG.cameras.add(camNotes);

		camHUD.zoom = PlayStateChangeables.zoom;

		FlxCamera.defaultCameras = [camGame];

		//ar testimagine = camGame.x;

		persistentUpdate = true;
		persistentDraw = true;

		mania = SONG.mania;

		if (PlayStateChangeables.bothSide)
			mania = 5;
		else if (FlxG.save.data.mania != 0 && PlayStateChangeables.randomNotes)
			mania = FlxG.save.data.mania;

		maniaToChange = mania;

		Note.scaleSwitch = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial', 'tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + PlayStateChangeables.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + PlayStateChangeables.botPlay);
	
		//dialogue shit
		switch (songLowercase)
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'suck my clit or you die.'];
			case 'power-link':
				//the text to appear;
				dialogue = [
					"Hey.",
					"I've come to this mansion to accept your\ntraining.",
					"Sure thing man!",
					"So, how will we train?",
					"I'll channel some power through a regular\nsong battle.",
					"Won't feel any different from singing\nnormally as power cannalization has\nno feeling.",
					"...",
					"I just wanna beat that kid. will this\nhelp me do that?", //This house is a mess, there ain't nothing u can do but sing! I hope yo dog isn't fuckin dead tho
					"This will give you more control over \nvoice-direction correlation",
					"I can sense that you've got great singing\nspeed already.",
					"With this you'll be like, unstoppable!",
					"Heh",
					"But first, show me what you've got.",
					"Let's do this!"
				];
				//the sprites to go along with text (n for no change)
				dface = [
						"f_matt", "n",
						"f_sh",
						"f_matt",
						"f_sh_smug", "f_sh",
						"f_matt", "f_matt_down",
						"f_sh_ser", "f_sh", "f_sh_smug",
						"f_matt",
						"f_sh_smug",
						"f_matt_up"
						];
				//the sides of the faces (1=left, -1=right and flipped)
				dside = [-1, -1, 1, -1, 1, 1, -1, -1, 1, 1, 1, -1, 1, -1];
			case 'revenge':
				//the text to appear;
				dialogue = [
					"Hello again punk",
					"Remember me?",
					"beep boop",
					"Now you'll see how it feels",
					"There's no way you can win this time.",
					"bap",
					"Oh you funkin' bet!"
				];
				//the sprites to go along with text (n for no change)
				dface = [
						"f_matt_down", "n",
						"f_bf",
						"f_matt_ang", "f_matt_down",
						"f_bf_burn",
						"f_matt_up"
						];
				//the sides of the faces (1=left, -1=right and flipped)
				dside = [1, 1, -1, 1, 1, -1, 1];
			case 'final-destination':
				//the text to appear;
				dialogue = [
					"GOD DAMN IT!!!!",
					"Hey, like, what's wrong dude?",
					"I CAN'T! I CAN'T BEAT THIS PIECE\nOF SHIT!!!!!",
					"That's a bit rude...",
					"There's no point in getting angry. this guy\nis physically unable to loose",//4
					"...",
					"...what?",
					"'That kid' is boyfriend.",
					"Every single being\nin this universe that has challenged him\nwas defeated and stuff",
					"That's because any time he looses a battle\nhe dies.",
					"!!!",
					"But death does not mean end to him, every\ntime he dies he is given the choice to\nreset time to a certain state",
					"That means that from our perspective, there\nis no possible outcome in which the flow\nof time continues after he's defeated",
					"What the hell",
					"I've been fighting for nothing?",//14
					"Your power has increased drastically.\nI wouldn't call that nothing man",
					"Hey, I'll tell you what.",
					"We can't beat him but we can sure as\nheck give him a challenge.",
					"You wanna sing together?",
					"Yeah man! with my power and your speed,\nhe's bound to have a bad time.",
					"If that makes you feel better of course...",
					"You know what? Let's do this!"
				];
				//the sprites to go along with text (n for no change)
				dface = [
						"f_matt_ang",
						"f_sh_con",
						"f_matt_ang",
						"f_sh_con", "f_sh_ser",
						"f_matt_down", "n",
						"f_sh_ser", "n", "n",
						"f_matt",
						"f_sh_smug", "f_sh_smug",
						"f_matt_down", "f_matt_ang",
						"f_sh_smug", "f_sh", "f_sh_smug",
						"f_matt",
						"f_sh_smug", "f_sh_ser",
						"f_matt_up",
						];
				//the sides of the faces (1=left, -1=right and flipped)
				dside = [1, -1, 1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, 1];
				exDad = true;
				s_ending = true;
			default:
				var lowercaseSong:String = SONG.song.toLowerCase();
				var file:String = Paths.txt(lowercaseSong + '/' + lowercaseSong + 'Dialogue');
				if (OpenFlAssets.exists(file)) {
					dialogue = CoolUtil.coolTextFile(file);
				}
		}

		switch(SONG.song.toLowerCase())
		{
			case 'b-side-final-destination' | 'final-destination god':
				exDad = true;
		}

		if (exDad)
		{
			switch(SONG.song.toLowerCase()) //im dumb. could have used like 1 line of code for this but not rn.
			{
				case 'final-destination god':
					Main.god = true;
				default:
					Main.god = false;
			}
		}

		//defaults if no stage was found in chart

		var isSolo:Bool = false; //kinda sad.
		var stageCheck:String = 'stage';

		if (SONG.song.toLowerCase() == 'live-on') {stageCheck = 'lost'; SONG.stage = 'lost';}
		
		if (SONG.stage == null) {
			switch(storyWeek)
			{
				case 2: stageCheck = 'halloween';
				case 3: stageCheck = 'philly';
				case 4: stageCheck = 'limo';
				case 5: if (songLowercase == 'winter-horrorland') {stageCheck = 'mallEvil';} else {stageCheck = 'mall';}
				case 6: if (songLowercase == 'thorns') {stageCheck = 'schoolEvil';} else {stageCheck = 'school';}
				//i should check if its stage (but this is when none is found in chart anyway)
			}
		} else {stageCheck = SONG.stage;}

		if (!PlayStateChangeables.Optimize)
		{

		switch(stageCheck)
		{
			case 'halloween': 
			{
				curStage = 'spooky';
				halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('halloween_bg','week2');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = FlxG.save.data.antialiasing;
				add(halloweenBG);

				isHalloween = true;
			}
			case 'philly': 
					{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					if(FlxG.save.data.distractions){
						add(phillyCityLights);
					}

					for (i in 0...5)
					{
							var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
							light.scrollFactor.set(0.3, 0.3);
							light.visible = false;
							light.setGraphicSize(Std.int(light.width * 0.85));
							light.updateHitbox();
							light.antialiasing = FlxG.save.data.antialiasing;
							phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain','week3'));
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train','week3'));
					if(FlxG.save.data.distractions){
						add(phillyTrain);
					}

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes','week3'));
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street','week3'));
					add(street);
			}
			case 'limo':
			{
					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset','week4'));
					skyBG.scrollFactor.set(0.1, 0.1);
					skyBG.antialiasing = FlxG.save.data.antialiasing;
					add(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo','week4');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					bgLimo.antialiasing = FlxG.save.data.antialiasing;
					add(bgLimo);
					if(FlxG.save.data.distractions){
						grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						add(grpLimoDancers);
	
						for (i in 0...5)
						{
								var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
								dancer.scrollFactor.set(0.4, 0.4);
								grpLimoDancers.add(dancer);
						}
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay','week4'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive','week4');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = FlxG.save.data.antialiasing;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol','week4'));
					fastCar.antialiasing = FlxG.save.data.antialiasing;
					// add(limo);
			}
			case 'mall':
			{
					curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls','week5'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop','week5');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = FlxG.save.data.antialiasing;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(upperBoppers);
					}


					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator','week5'));
					bgEscalator.antialiasing = FlxG.save.data.antialiasing;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree','week5'));
					tree.antialiasing = FlxG.save.data.antialiasing;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);

					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop','week5');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = FlxG.save.data.antialiasing;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bottomBoppers);
					}


					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow','week5'));
					fgSnow.active = false;
					fgSnow.antialiasing = FlxG.save.data.antialiasing;
					add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa','week5');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = FlxG.save.data.antialiasing;
					if(FlxG.save.data.distractions){
						add(santa);
					}
			}
			case 'mallEvil':
			{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG','week5'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree','week5'));
					evilTree.antialiasing = FlxG.save.data.antialiasing;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow",'week5'));
						evilSnow.antialiasing = FlxG.save.data.antialiasing;
					add(evilSnow);
					}
			case 'school':
			{
					curStage = 'school';

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky','week6'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool','week6'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet','week6'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack','week6'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees','week6');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals','week6');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (songLowercase == 'roses')
						{
							if(FlxG.save.data.distractions){
								bgGirls.getScared();
							}
						}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bgGirls);
					}
			}
			case 'schoolEvil':
			{
					curStage = 'schoolEvil';

					if (!PlayStateChangeables.Optimize)
						{
							var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
							var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);
						}

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool','week6');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);

					/* 
							var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
							bg.scale.set(6, 6);
							// bg.setGraphicSize(Std.int(bg.width * 6));
							// bg.updateHitbox();
							add(bg);
							var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
							fg.scale.set(6, 6);
							// fg.setGraphicSize(Std.int(fg.width * 6));
							// fg.updateHitbox();
							add(fg);
							wiggleShit.effectType = WiggleEffectType.DREAMY;
							wiggleShit.waveAmplitude = 0.01;
							wiggleShit.waveFrequency = 60;
							wiggleShit.waveSpeed = 0.8;
						*/

					// bg.shader = wiggleShit.shader;
					// fg.shader = wiggleShit.shader;

					/* 
								var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
								var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
								// Using scale since setGraphicSize() doesnt work???
								waveSprite.scale.set(6, 6);
								waveSpriteFG.scale.set(6, 6);
								waveSprite.setPosition(posX, posY);
								waveSpriteFG.setPosition(posX, posY);
								waveSprite.scrollFactor.set(0.7, 0.8);
								waveSpriteFG.scrollFactor.set(0.9, 0.8);
								// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
								// waveSprite.updateHitbox();
								// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
								// waveSpriteFG.updateHitbox();
								add(waveSprite);
								add(waveSpriteFG);
						*/
			}
			case 'stage':
				{
						defaultCamZoom = 0.9;
						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
						bg.antialiasing = FlxG.save.data.antialiasing;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);
	
						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = FlxG.save.data.antialiasing;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
	
						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = FlxG.save.data.antialiasing;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;
	
						add(stageCurtains);
				}
			case 'solo-bf':
			default:
					trace('uh oh, we gota a problem :(');
			}
		}

		switch (SONG.song.toLowerCase())
		{
			case 'where-are-you' | 'eruption' | 'kaio-ken' | 'whats-new' | 'blast' | 'super-saiyan' | 'overflow' | 'power-link' | 'whats-bugged' | 'sweet-sauce' | 'ultra-instinct':
				defaultCamZoom = 0.9;
				curStage = 'mansion';
				var bg:FlxSprite = new FlxSprite(-400, -160).loadGraphic(Paths.image('bg_lemon'));
				bg.setGraphicSize(Std.int(bg.width * 1.5));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.95, 0.95);
				bg.active = false;
				add(bg);
				case 'revenge' | 'final-destination' | 'b-side-final-destination' | 'final-destination god': 
					//dad.powerup = true;
					defaultCamZoom = 0.9;
					curStage = 'boxing';
					var bg:FlxSprite = new FlxSprite(-400, -220).loadGraphic(Paths.image('bg_boxn'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.8, 0.8);
					bg.active = false;
					add(bg);
	
					var bg_r:FlxSprite = new FlxSprite(-810, -380).loadGraphic(Paths.image('bg_boxr'));
					bg_r.antialiasing = true;
					bg_r.scrollFactor.set(1, 1);
					bg_r.active = false;
					add(bg_r);
	
					if (SONG.song.toLowerCase() == 'final-destination')
					{
						shadow1 = new FlxSprite(0, -20).loadGraphic(Paths.image('shadows'));
						shadow1.scrollFactor.set();
						shadow1.antialiasing = true;
						shadow1.alpha = 0;
	
						shadow2 = new FlxSprite(0, -20).loadGraphic(Paths.image('shadows'));
						shadow2.scrollFactor.set();
						shadow2.antialiasing = true;
						shadow2.alpha = 0;
					}
			case 'god-eater' | 'godalovania':
				defaultCamZoom = 0.65;
				curStage = 'sky';

				var sky = new FlxSprite(-850, -850);
				sky.frames = Paths.getSparrowAtlas('god_bg');
				sky.animation.addByPrefix('sky', "bg", 30);
				sky.setGraphicSize(Std.int(sky.width * 0.8));
				sky.animation.play('sky');
				sky.scrollFactor.set(0.1, 0.1);
				sky.antialiasing = true;
				add(sky);

				var bgcloud = new FlxSprite(-850, -1250);
				bgcloud.frames = Paths.getSparrowAtlas('god_bg');
				bgcloud.animation.addByPrefix('c', "cloud_smol", 30);
				//bgcloud.setGraphicSize(Std.int(bgcloud.width * 0.8));
				bgcloud.animation.play('c');
				bgcloud.scrollFactor.set(0.3, 0.3);
				bgcloud.antialiasing = true;
				add(bgcloud);

				add(new MansionDebris(300, -800, 'norm', 0.4, 1, 0, 1));
				add(new MansionDebris(600, -300, 'tiny', 0.4, 1.5, 0, 1));
				add(new MansionDebris(-150, -400, 'spike', 0.4, 1.1, 0, 1));
				add(new MansionDebris(-750, -850, 'small', 0.4, 1.5, 0, 1));

				/*
				add(new MansionDebris(-300, -1700, 'norm', 0.5, 1, 0, 1));
				add(new MansionDebris(-600, -1100, 'tiny', 0.5, 1.5, 0, 1));
				add(new MansionDebris(900, -1850, 'spike', 0.5, 1.2, 0, 1));
				add(new MansionDebris(1500, -1300, 'small', 0.5, 1.5, 0, 1));
				*/

				add(new MansionDebris(-300, -1700, 'norm', 0.75, 1, 0, 1));
				add(new MansionDebris(-1000, -1750, 'rect', 0.75, 2, 0, 1));
				add(new MansionDebris(-600, -1100, 'tiny', 0.75, 1.5, 0, 1));
				add(new MansionDebris(900, -1850, 'spike', 0.75, 1.2, 0, 1));
				add(new MansionDebris(1500, -1300, 'small', 0.75, 1.5, 0, 1));
				add(new MansionDebris(-600, -800, 'spike', 0.75, 1.3, 0, 1));
				add(new MansionDebris(-1000, -900, 'small', 0.75, 1.7, 0, 1));

				var fgcloud = new FlxSprite(-1150, -2900);
				fgcloud.frames = Paths.getSparrowAtlas('god_bg');
				fgcloud.animation.addByPrefix('c', "cloud_big", 30);
				//bgcloud.setGraphicSize(Std.int(bgcloud.width * 0.8));
				fgcloud.animation.play('c');
				fgcloud.scrollFactor.set(0.9, 0.9);
				fgcloud.antialiasing = true;
				add(fgcloud);

				var bg:FlxSprite = new FlxSprite(-400, -160).loadGraphic(Paths.image('bg_lemon'));
				bg.setGraphicSize(Std.int(bg.width * 1.5));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.95, 0.95);
				bg.active = false;
				add(bg);

				var techo = new FlxSprite(0, -20);
				techo.frames = Paths.getSparrowAtlas('god_bg');
				techo.animation.addByPrefix('r', "broken_techo", 30);
				techo.setGraphicSize(Std.int(techo.frameWidth * 1.5));
				techo.animation.play('r');
				techo.scrollFactor.set(0.95, 0.95);
				techo.antialiasing = true;
				add(techo);

				gf_rock = new FlxSprite(20, 20);
				gf_rock.frames = Paths.getSparrowAtlas('god_bg');
				gf_rock.animation.addByPrefix('rock', "gf_rock", 30);
				gf_rock.animation.play('rock');
				gf_rock.scrollFactor.set(0.8, 0.8);
				gf_rock.antialiasing = true;
				add(gf_rock);

				rock = new FlxSprite(20, 20);
				rock.frames = Paths.getSparrowAtlas('god_bg');
				rock.animation.addByPrefix('rock', "rock", 30);
				rock.animation.play('rock');
				rock.scrollFactor.set(1, 1);
				rock.antialiasing = true;
				add(rock);

				//god eater legs
				legs = new FlxSprite(-850, -850);
				legs.frames = Paths.getSparrowAtlas('characters/pshaggy');
				legs.animation.addByPrefix('legs', "solo_legs", 30);
				legs.animation.play('legs');
				legs.antialiasing = true;
				legs.updateHitbox();
				legs.offset.set(legs.frameWidth / 2, 10);
				legs.alpha = 0;
			case 'astral-calamity' | 'talladega' | 'infinite-songs' | 'big-shot' | 'no-help':
				defaultCamZoom = 0.56;
				if (SONG.song == 'Talladega' || SONG.song == 'No') defaultCamZoom = 0.6;

				curStage = 'lava';

				var bgbg:BGElement = new BGElement('WBG/BGBG', -1940, -1112, 0.5, 1, 0);
				add(bgbg);

				var lavaLimits:BGElement = new BGElement('WBG/LavaLimits', -1770, 168, 0.55, 1, 1);
				add(lavaLimits);

				var bgSpikes:BGElement = new BGElement('WBG/BGSpikes', 112, -36, 0.6, 1, 2);
				add(bgSpikes);

				var spikes:BGElement = new BGElement('WBG/Spikes', -1186, -234, 0.8, 1, 3);
				add(spikes);

				var ground:BGElement = new BGElement('WBG/Ground', -1320, 590, 1, 1, 4);
				add(ground);
			case 'soothing-power' | 'thunderstorm' | 'dissasembler' | 'paradoxial':
				defaultCamZoom = 0.8;
				curStage = 'out';

				var sky:BGElement = new BGElement('OBG/sky', -1204, -456, 0.15, 1, 0);
				add(sky);

				var clouds:BGElement = new BGElement('OBG/clouds', -988, -260, 0.25, 1, 1);
				add(clouds);

				var backMount:BGElement = new BGElement('OBG/backmount', -700, -40, 0.4, 1, 2);
				add(backMount);

				var middleMount:BGElement = new BGElement('OBG/middlemount', -240, 200, 0.6, 1, 3);
				add(middleMount);

				var ground:BGElement = new BGElement('OBG/ground', -660, 624, 1, 1, 4);
				add(ground);
			case 'live-on' | 'switched':
				//lmfao
				curStage = 'solo';
				if (SONG.song.toLowerCase() == 'switched')
					isSolo = true;
			case 'expurgation':
				//trace("line 538");
				defaultCamZoom = 0.55;
				curStage = 'auditorHell';
	
				tstatic.antialiasing = true;
				tstatic.scrollFactor.set(0,0);
				tstatic.setGraphicSize(Std.int(tstatic.width * 8.3));
				tstatic.animation.add('static', [0, 1, 2], 24, true);
				tstatic.animation.play('static');
	
				tstatic.alpha = 0;
	
				var bg:FlxSprite = new FlxSprite(-10, -10).loadGraphic(Paths.image('fourth/bg','shared'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 4));
				add(bg);
	
				hole.antialiasing = true;
				hole.scrollFactor.set(0.9, 0.9);
						
				converHole.antialiasing = true;
				converHole.scrollFactor.set(0.9, 0.9);
				converHole.setGraphicSize(Std.int(converHole.width * 1.3));
				hole.setGraphicSize(Std.int(hole.width * 1.55));
	
				cover.antialiasing = true;
				cover.scrollFactor.set(0.9, 0.9);
				cover.setGraphicSize(Std.int(cover.width * 1.55));
	
				var energyWall:FlxSprite = new FlxSprite(1350,-690).loadGraphic(Paths.image("fourth/Energywall","shared"));
				energyWall.antialiasing = true;
				energyWall.scrollFactor.set(0.9, 0.9);
				add(energyWall);
				
				var stageFront:FlxSprite = new FlxSprite(-350, -355).loadGraphic(Paths.image('fourth/daBackground','shared'));
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.55));
				add(stageFront);
	
				/*hexError = new FlxSprite(0,0).loadGraphic(Paths.image('fourth/hexError', 'shared'));
				hexError.antialiasing = true;
				hexError.scrollFactor.set(0.9, 0.9);
				hexError.setGraphicSize(Std.int(stageFront.width * 1));
				add(hexError);*/
				//code ripped straight from hex v.s. whitty cause of laziness
				// hexError = new FlxSprite('fourth/hexError','shared'); beta add code lol
			case 'loca':
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
						bg.antialiasing = FlxG.save.data.antialiasing;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);
	
						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = FlxG.save.data.antialiasing;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
	
						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = FlxG.save.data.antialiasing;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;
	
						add(stageCurtains);
			default:
				/*defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:BGSprite = new BGSprite('stageback', -600, -200, 0.9, 0.9);
				add(bg);

				var stageFront:BGSprite = new BGSprite('stagefront', -650, 600, 0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				add(stageFront);

				if(!ClientPrefs.lowQuality) {
					var stageLight:BGSprite = new BGSprite('stage_light', -125, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					add(stageLight);
					var stageLight:BGSprite = new BGSprite('stage_light', 1225, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					stageLight.flipX = true;
					add(stageLight);

					var stageCurtains:BGSprite = new BGSprite('stagecurtains', -500, -300, 1.3, 1.3);
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					add(stageCurtains);
				}*/
		}

		celebiLayer = new FlxTypedGroup<FlxSprite>();
		add(celebiLayer);

		backgroundGroup = new FlxTypedGroup<FlxSprite>();
		add(backgroundGroup);

		//defaults if no gf was found in chart
		var gfCheck:String = 'gf';
		
		if (SONG.gfVersion == null) {
			switch(storyWeek)
			{
				case 4: gfCheck = 'gf-car';
				case 5: gfCheck = 'gf-christmas';
				case 6: gfCheck = 'gf-pixel';
			}
		} else {gfCheck = SONG.gfVersion;}

		var curGf:String = '';
		switch (gfCheck)
		{
			case 'gf-car':
				curGf = 'gf-car';
			case 'gf-christmas':
				curGf = 'gf-christmas';
			case 'gf-pixel':
				curGf = 'gf-pixel';
			default:
				curGf = 'gf';
		}

	//	boyfriendGroup = new FlxTypedGroup<Boyfriend>();
	//	dadGroup = new FlxTypedGroup<Character>();
	//	gfGroup = new FlxTypedGroup<Character>();
		
		gf = new Character(GF_X, GF_Y, curGf);
		gf.scrollFactor.set(0.95, 0.95);

		if (isSolo)
			gf.visible = false;
		if (isSolo)
			gf.active = false;

		if (SONG.song.toLowerCase() == 'live-on') {gf.active = false; gf.visible = false;} //optimizes performace by disabiling update on sprite.
	//	gfGroup.add(gf);

		var dadxoffset:Float = 0;
		var dadyoffset:Float = 0;
		var bfxoffset:Float = 0;
		var bfyoffset:Float = 0;
		if (PlayStateChangeables.flip)
		{
			dad = new Character(BF_X, BF_Y, SONG.player1, true);
			if (exDad)
			{
				switch(SONG.song.toLowerCase())
				{
					case 'final-destination god':
						dad2 = new Character(280, 100, "god_shaggy");
					case 'b-side-final-destination':
						dad2 = new Character(280, 100, "shaggy-orange");
					default:
						dad2 = new Character(280, 100, "rshaggy");
				}
			}
			scoob = new Character(9000, 290, 'scooby', false);
			boyfriend = new Boyfriend(DAD_X, DAD_Y, SONG.player2, false);
		}
		else
		{
			dad = new Character(DAD_X, DAD_Y, SONG.player2, false);
			if (exDad)
			{
				switch(SONG.song.toLowerCase())
				{
					case 'final-destination god':
						dad2 = new Character(280, 100, "god_shaggy");
					case 'b-side-final-destination':
						dad2 = new Character(280, 100, "shaggy-orange");
					default:
						dad2 = new Character(280, 100, "rshaggy");
				}
			}
			scoob = new Character(9000, 290, 'scooby', false);
			boyfriend = new Boyfriend(BF_X, BF_Y, SONG.player1, true);
			//
		}

		if (SONG.song.toLowerCase() != 'live-on') 
			bfAccess = boyfriend;

		if (SONG.song.toLowerCase() == 'live-on') {boyfriend.active = false; boyfriend.visible = false;}

		if (isSolo) {dad.x = boyfriend.x; dad.y = boyfriend.y; dad.visible = false; dad.active = false;}
	//	boyfriendGroup.add(boyfriend);
	//	dadGroup.add(dad);

		var dadcharacter:String = SONG.player2;


		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);
		if (PlayStateChangeables.flip)
			camPos.set(boyfriend.getGraphicMidpoint().x, boyfriend.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'dshaggy':
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dadyoffset += 200;
			case "monster":
				dadyoffset += 100;
			case 'monster-christmas':
				dadyoffset += 130;
			case 'dad':
				camPos.x += 400;
			case 'shaggy' | 'sshaggy':
				camPos.x += 400;
			case 'matt':
				dad.y += 320;
				camPos.set(dad.getGraphicMidpoint().x - 300, dad.getGraphicMidpoint().y - 100);
				if (Main.god) dad.x -= 30;
			case 'pico':
				camPos.x += 600;
				dadyoffset += 300;
			case 'parents-christmas':
				dadxoffset -= 500;
			case 'senpai':
				dadxoffset += 150;
				dadyoffset += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dadxoffset += 150;
				dadyoffset += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				if (FlxG.save.data.distractions)
					{
						// trailArea.scrollFactor.set();
						if (!PlayStateChangeables.Optimize)
						{
							var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
							// evilTrail.changeValuesEnabled(false, false, false, false);
							// evilTrail.changeGraphic()
							add(evilTrail);
						}
						// evilTrail.scrollFactor.set(1.1, 1.1);
					}
				dadxoffset -= 150;
				dadyoffset += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}


		if (FlxG.save.data.p_partsGiven >= 5 && SONG.player2 != 'zshaggy' && !FlxG.save.data.ending[2] && isStoryMode)
			{
				zeph = new FlxSprite().loadGraphic(Paths.image('MASK/zephyrus', 'shared'));
				zeph.updateHitbox();
				zeph.antialiasing = true;
				zeph.x = -2000;
				zephScreen = new FlxSprite().makeGraphic(4000, 4000, FlxColor.BLACK);
				zephScreen.scrollFactor.set(0, 0);
			}


		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				bfyoffset -= 220;
				bfxoffset += 260;
				if(FlxG.save.data.distractions){
					resetFastCar();
					add(fastCar);
				}

			case 'mall':
				bfxoffset += 200;

			case 'mallEvil':
				bfxoffset += 320;
				dadyoffset -= 80;
			case 'school':
				bfxoffset += 200;
				bfyoffset += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				bfxoffset += 200;
				bfyoffset += 220;
				gf.x += 180;
				gf.y += 300;
			case 'lava':
				BF_X += 350;
				BF_Y += 60;
				DAD_X -= 400;
				DAD_Y -= 400;
				if (SONG.player2 != 'wbshaggy')
				{
					DAD_Y += 400;
				}
			case 'out':
				BF_X += 300;
				BF_Y += 10;
				GF_X += 70;
				DAD_X -= 100;
		}
		if (PlayStateChangeables.flip)
		{
			boyfriend.x += dadxoffset;
			boyfriend.y += dadyoffset;
			dad.x += bfxoffset;
			dad.y += bfyoffset;
		}
		else
		{
			dad.x += dadxoffset;
			dad.y += dadyoffset;
			boyfriend.x += bfxoffset;
			boyfriend.y += bfyoffset;
		}

		if (SONG.player2 == 'sshaggy')
			{
				shaggyT = new FlxTrail(dad, null, 3, 6, 0.3, 0.002);
				shaggyT.visible = false;
				add(shaggyT);
				camLerp = 2;
			}
			else if (SONG.player2 == 'pshaggy')
			{
				shaggyT = new FlxTrail(dad, null, 5, 7, 0.3, 0.001);
				add(shaggyT);
	
				legT = new FlxTrail(legs, null, 5, 7, 0.3, 0.001);
				add(legT);
			}
	
			doorFrame = new FlxSprite(-160, 160).loadGraphic(Paths.image('doorframe'));
			doorFrame.updateHitbox();
			doorFrame.setGraphicSize(1);
			doorFrame.alpha = 0;
			doorFrame.antialiasing = true;
			doorFrame.scrollFactor.set(1, 1);
			doorFrame.active = false;
			add(doorFrame);

			var isNotPara:Bool = false;

			if (SONG.song.toLowerCase() != 'paradoxial') isNotPara = true;

			if (!isNotPara) {
			maskMouseHud = new FlxTypedGroup<FlxSprite>();
			add(maskMouseHud);

			maskCollGroup = new FlxTypedGroup<MASKcoll>();
			add(maskCollGroup);
			}

		if (!PlayStateChangeables.Optimize)
		{
			add(gf);
			if (!FlxG.save.data.p_maskGot[4] && SONG.song.toLowerCase() == 'paradoxial') {
				maskObj = new MASKcoll(5, gf.getMidpoint().x - 200, gf.getMidpoint().y, 0);
				maskObj.y += 500;
				maskCollGroup.add(maskObj);
				maskObj.alpha = 0;
			}
			// Shitty layering but whatev it works LOL
			if (curStage == 'limo')
				add(limo);

			if (exDad) add(dad2);
			add(dad);
			add(boyfriend);
		}

		//1565

		add(scoob);

		bgDim = new FlxSprite().makeGraphic(4000, 4000, FlxColor.BLACK);
		bgDim.scrollFactor.set(0);
		bgDim.screenCenter();
		bgDim.alpha = 0;
		add(bgDim);
		
		maskTrailGroup = new FlxTypedGroup<FlxTrail>();
		add(maskTrailGroup);

		maskFxGroup = new FlxTypedGroup<FlxSprite>();
		add(maskFxGroup);

		//maskCollGroup = new FlxTypedGroup<MASKcoll>();
		//add(maskCollGroup);

		foregroundGroup = new FlxTypedGroup<FlxSprite>();
		add(foregroundGroup);

		if(curStage == 'spooky') {
			add(halloweenWhite);
		}


		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			// FlxG.watch.addQuick('Queued',inputsQueued);

			PlayStateChangeables.useDownscroll = rep.replay.isDownscroll;
			PlayStateChangeables.safeFrames = rep.replay.sf;
			PlayStateChangeables.botPlay = true;
		}

		trace('uh ' + PlayStateChangeables.safeFrames);

	//	var dialogueTest:String = 'beta test';

		trace("SF CALC: " + Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

		var doof:DialogueBoxPsych = new DialogueBoxPsych(dialogue, SONG.song);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (PlayStateChangeables.useDownscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		if (isNotPara) {
		maskMouseHud = new FlxTypedGroup<FlxSprite>();
		add(maskMouseHud);

		maskCollGroup = new FlxTypedGroup<MASKcoll>();
			add(maskCollGroup);
		}

		add(noteSplashes);
		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		camFollow = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);

		snapCamFollowToPos(camPos.x, camPos.y);
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		if (prevCamFollowPos != null)
		{
			camFollowPos = prevCamFollowPos;
			prevCamFollowPos = null;
		}
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.focusOn(camFollow);

		/*for(i in unspawnNotes)
			{
				var dunceNote:Note = i;
				notes.add(dunceNote);
				if (executeModchart)
				{
					if (!dunceNote.isSustainNote)
						dunceNote.cameras = [camNotes];
					else
						dunceNote.cameras = [camSustains];
				}
				else
				{
					dunceNote.cameras = [camHUD];
				}
			}
	
			if (startTime != 0)
				{
					var toBeRemoved = [];
					for(i in 0...notes.members.length)
					{
						var dunceNote:Note = notes.members[i];
		
						if (dunceNote.strumTime - startTime <= 0)
							toBeRemoved.push(dunceNote);
						else 
						{
							if (PlayStateChangeables.useDownscroll)
							{
								if (dunceNote.mustPress)
									dunceNote.y = (playerStrums.members[Math.floor(Math.abs(dunceNote.noteData))].y
										+ 0.45 * (startTime - dunceNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) - dunceNote.noteYOff;
								else
									dunceNote.y = (strumLineNotes.members[Math.floor(Math.abs(dunceNote.noteData))].y
										+ 0.45 * (startTime - dunceNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) - dunceNote.noteYOff;
							}
							else
							{
								if (dunceNote.mustPress)
									dunceNote.y = (playerStrums.members[Math.floor(Math.abs(dunceNote.noteData))].y
										- 0.45 * (startTime - dunceNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) + dunceNote.noteYOff;
								else
									dunceNote.y = (strumLineNotes.members[Math.floor(Math.abs(dunceNote.noteData))].y
										- 0.45 * (startTime - dunceNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) + dunceNote.noteYOff;
							}
						}
					}
		
					for(i in toBeRemoved)
						notes.members.remove(i);
				}*/

		trace('generated');

		// add(strumLine);

	//	FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow);

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
	//	timeTxt = "Finding Time.";

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (PlayStateChangeables.useDownscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);

				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5),songPosBG.y,0,SONG.song + ' | Time Left: ' + timeTxt + ' or ' + Std.string(songLength - Conductor.songPosition), 16);
				if (PlayStateChangeables.useDownscroll)
					songName.y -= 3;
				songName.x -= 10;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (PlayStateChangeables.useDownscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		if (!PlayStateChangeables.flip)
			{
				healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
				'health', 0, 2);
				healthBar.scrollFactor.set();
				healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
			}
			else
			{
				healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, LEFT_TO_RIGHT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
				'health', 0, 2);
				healthBar.scrollFactor.set();
				healthBar.createFilledBar(0xFF66FF33, 0xFFFF0000);
			}
		// healthBar
		add(healthBar);

		overhealthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
		'health', 2.2, 4);
		overhealthBar.scrollFactor.set();
		overhealthBar.createFilledBar(0x00000000, 0xFFFFFF00);
		// healthBar
		add(overhealthBar);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " - " + CoolUtil.ShaggydifficultyFromInt(storyDifficulty) + (Main.watermarks ? " | KE " + MainMenuState.kadeEngineVer : ""), 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (PlayStateChangeables.useDownscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);

		scoreTxt.screenCenter(X);

		originalX = scoreTxt.x;


		scoreTxt.scrollFactor.set();
		
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);

		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.borderSize = 4;
		replayTxt.borderQuality = 2;
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		botPlayState.borderSize = 4;
		botPlayState.borderQuality = 2;
		if(PlayStateChangeables.botPlay && !loadRep) add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		var icnChar:String;

		switch (SONG.song.toLowerCase())
		{
			case 'b-side-final-destination':
				icnChar = 'shaggymatt-bside';
			case 'final-destination god' | 'final-destination':
				icnChar = 'both';
				if (Main.god) icnChar = 'shaggymattgod';
			default:
				icnChar = SONG.player2;
		}

		iconP2 = new HealthIcon(icnChar, false);
		iconP2.y = healthBar.y - (iconP2.height / 2) - iconP2.offsetY;
		add(iconP2);

		noteSplashes.cameras = [camNotes];
		strumLineNotes.cameras = [camNotes];
		notes.cameras = [camNotes];
		healthBar.cameras = [camHUD];
		overhealthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		updateTime = true;
		
		trace('starting');

		if (isStoryMode)
		{
			switch (StringTools.replace(curSong," ", "-").toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow);
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					trace('your on freeplay');
			}
		}

		var daSong:String = curSong.toLowerCase();

		/*psyshockParticle = new Character(0, 0, 'hypno');
		psyshockParticle.playAnim("psyshock particle", true);
		psyshockParticle.alpha = 0;
		add(psyshockParticle);*/

		switch (SONG.song.toLowerCase()) {
			case 'live-on':
				healthBar.alpha = 0;
				healthBarBG.alpha = 0;
				iconP1.alpha = 0;
				iconP2.alpha = 0;
				scoreTxt.alpha = 0;
				songPosBar.alpha = 0;
				songPosBG.alpha = 0;
				dad.visible = false;

				// jumpscare
				jumpScare = new FlxSprite().loadGraphic(Paths.image('lostSilver/Gold_Jumpscare', 'shared'));
				jumpScare.setGraphicSize(Std.int(FlxG.width * jumpscareSizeInterval), Std.int(FlxG.height * jumpscareSizeInterval));
				jumpScare.updateHitbox();
				jumpScare.screenCenter();
				add(jumpScare);

				jumpScare.setGraphicSize(Std.int(FlxG.width * jumpscareSizeInterval), Std.int(FlxG.height * jumpscareSizeInterval));
				jumpScare.updateHitbox();
				jumpScare.screenCenter();

				jumpScare.visible = false;
				jumpScare.cameras = [camHUD];
		}
		if (isStoryMode)
		{
			switch (daSong)
			{	
				case 'where-are-you':
					textIndex = '1-pre-whereareyou';
					schoolIntro(1);
				case 'eruption':
					sEnding = 'here we go';
					textIndex = '2-pre-eruption';
					schoolIntro(0);
				case 'kaio-ken':
					//sEnding = 'week1 end';
					startCountdown();
				case 'whats-new':
					textIndex = '5-pre-whatsnew';
					sEnding = 'post whats new';
					schoolIntro(1);
				case 'blast':
					sEnding = 'post blast';
					startCountdown();

					if (!FlxG.save.data.p_maskGot[0])
					{
						maskObj = new MASKcoll(1, boyfriend.x - 200, -300, 0);
						maskCollGroup.add(maskObj);
					}
				case 'super-saiyan':
					sEnding = 'week2 end';
					startCountdown();
				case 'god-eater':
					sEnding = 'finale end';
					if (!Main.skipDes)
					{
						godIntro();
						Main.skipDes = true;
					}
					else
					{
						godCutEnd = true;
						godMoveGf = true;
						godMoveSh = true;
						new FlxTimer().start(1, function(tmr:FlxTimer)
						{
							startCountdown();
						});
					}
				case 'soothing-power':
					if (Main.skipDes)
					{
						startCountdown();
					}
					else
					{
						dad.playAnim('sit', true);
						camFollow.x -= 300;
						Main.skipDes = true;
						textIndex = 'upd/1';
						afterAction = 'stand up';
						schoolIntro(2);
					}
				case 'thunderstorm':
					if (Main.skipDes)
					{
						startCountdown();
					}
					else
					{
						Main.skipDes = true;
						textIndex = 'upd/2';
						schoolIntro(0);
					}
				case 'dissasembler':
					sEnding = 'last goodbye';
					if (Main.skipDes)
					{
						startCountdown();
					}
					else
					{
						Main.skipDes = true;
						textIndex = 'upd/3';
						schoolIntro(0);
					}
					if (!FlxG.save.data.p_maskGot[2])
					{
						maskObj = new MASKcoll(3, 0, 0, 0, camFollowPos, camHUD);
						maskObj.cameras = [camHUD];
						maskCollGroup.add(maskObj);
					}
				case 'astral-calamity':
					if (FlxG.save.data.p_partsGiven < 5 || FlxG.save.data.ending[2])
					{
						sEnding = 'wb ending';
						if (Main.skipDes)
						{
							startCountdown();
						}
						else
						{
							Main.skipDes = true;
							textIndex = 'upd/wb1';
							schoolIntro(1);
						}
					}
					else
					{
						textIndex = 'upd/zeph1';
						afterAction = 'possess';
						//sEnding = 'wb ending';
						schoolIntro(1);
					}
				case 'talladega':
					sEnding = 'zeph ending';
					if (Main.skipDes)
					{
						startCountdown();
					}
					else
					{
						camFollow.y -= 200;
						camFollowPos.y = camFollow.y;
						Main.skipDes = true;
						textIndex = 'upd/zeph2';
						new FlxTimer().start(2, function(tmr:FlxTimer)
						{
							FlxG.sound.playMusic(Paths.music('zephyrus'));
						});
						afterAction = "zephyrus";
						schoolIntro(2);
					}
				case "power-link":
					if (!Main.skipDes)
					{
						schoolIntro(1);
						Main.skipDes = true;
					}
					else
					{
						startCountdown();
					}
				case 'paradoxial':
					if (!FlxG.save.data.p_maskGot[4]) {
				//		maskObj = new MASKcoll(5, gf.getMidpoint().x - 100, gf.getMidpoint().y, 0);
				//		maskCollGroup.add(maskObj);
				//		maskObj.alpha = 1;
					}
						startCountdown();
				default:
					startCountdown();
			}
			seenCutscene = true;
		} else {
			var cs = curSong.toLowerCase();

			switch (cs)
			{		
				case 'god-eater':
					godCutEnd = true;
					godMoveGf = true;
					godMoveSh = true;
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						startCountdown();
					});
				case 'blast':
					if (!FlxG.save.data.p_maskGot[0])
					{
						maskObj = new MASKcoll(1, boyfriend.x - 200, -300, 0);
						maskCollGroup.add(maskObj);
					}
					startCountdown();
				case 'dissasembler':
					if (!FlxG.save.data.p_maskGot[2])
					{
						maskObj = new MASKcoll(3, 0, 0, 0, camFollowPos, camHUD);
						maskObj.cameras = [camHUD];
						maskCollGroup.add(maskObj);
					}
					startCountdown();
				case 'talladega':
					if (FlxG.save.data.ending[2])
					{
						startCountdown();
					} 
				case 'paradoxial':
					if (!FlxG.save.data.p_maskGot[4]) {
					//	maskObj = new MASKcoll(5, gf.getMidpoint().x - 100, gf.getMidpoint().y, 0);
			//		maskCollGroup.add(maskObj);
			//			maskObj.alpha = 1;
					}
						startCountdown();
				default:
					startCountdown();
			}
		}

		if (SONG.song.toLowerCase()=='talladega' && !isStoryMode)
			startCountdown();

		if (!loadRep)
			rep = new Replay("na");

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,handleInput);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, releaseInput);

		super.create();
	}

	function schoolIntro(btrans:Int):Void
		{
			var readFrom:Array<Dynamic> = TextData.getText(textIndex);
			dialogue = readFrom[0];
			dchar = readFrom[1];
			dface = readFrom[2];
			dside = readFrom[3];
	
			black = new FlxSprite(-500, -400).makeGraphic(FlxG.width * 4, FlxG.height * 4, FlxColor.BLACK);
			black.scrollFactor.set();
			add(black);
	
			var dim:FlxSprite = new FlxSprite(-500, -400).makeGraphic(FlxG.width * 4, FlxG.height * 4, FlxColor.WHITE);
			dim.alpha = 0;
			dim.scrollFactor.set();
			add(dim);
	
			if (black.alpha == 1)
			{
				dropText = new FlxText(140, tb_y + 25, 2000, "", 32);
				curr_char = 0;
				curr_dial = 0;
				talk = 1;
				tb_appear = 0;
				tbox = new FlxSprite(tb_x, tb_y, Paths.image('TextBox'));
				fimage = dchar[0] + '_' + dface[0];
				faceRender();
				fsprite.alpha = 0;
				tbox.alpha = 0;
				dcd = 7;
	
				if (btrans == 0)
				{
					dcd = 2;
					black.alpha = 0;
				}
				else if (btrans == 2)
				{
					dcd = 11;
				}
			}
			var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
			red.scrollFactor.set();
	
			if (!tb_open)
			{
				tb_open = true;
				new FlxTimer().start(0.2, function(tmr:FlxTimer)
				{
					black.alpha -= 0.15;
					dcd --;
					if (dcd == 0)
					{
						tb_appear = 1;
					}
					tmr.reset(0.3);
				});
				if (talk == 1 || tbox.alpha >= 0)
				{
					new FlxTimer().start(0.03, function(ap_dp:FlxTimer)
					{
						
						if (tb_appear == 1)
						{
							if (tbox.alpha < 1)
							{
								tbox.alpha += 0.1;
							}
						}
						else
						{
							if (tbox.alpha > 0)
							{
								tbox.alpha -= 0.1;
							}
						}
						dropText.alpha = tbox.alpha;
						fsprite.alpha = tbox.alpha;
						dim.alpha = tbox.alpha / 2;
						ap_dp.reset(0.05);
					});
					var writing = dialogue[curr_dial];
					new FlxTimer().start(0.025, function(tmr2:FlxTimer)
					{
						if (talk == 1)
						{
							var newtxt = dialogue[curr_dial].substr(0, curr_char);
							var charat = dialogue[curr_dial].substr(curr_char - 1, 1);
							if (curr_char <= dialogue[curr_dial].length && tb_appear == 1)
							{
								if (charat != ' ')
								{
									vc_sfx = FlxG.sound.load(TextData.vcSound(dchar[curr_dial], dface[curr_dial]));
									vc_sfx.play();
								}
								curr_char ++;
							}
	
							//portraitLeft.loadGraphic(Paths.image('logo'), false, 500, 200, false);
							//portraitLeft.setGraphicSize(200);
	
							fsprite.updateHitbox();
							fsprite.scrollFactor.set();
							if (dside[curr_dial] == -1)
							{
								fsprite.flipX = true;
							}
							add(fsprite);
	
							tbox.updateHitbox();
							tbox.scrollFactor.set();
							add(tbox);
	
							dropText.text = newtxt;
							dropText.font = 'Pixel Arial 11 Bold';
							dropText.color = 0x00000000;
							dropText.scrollFactor.set();
							add(dropText);
						}
						tmr2.reset(0.025);
					});
	
					new FlxTimer().start(0.001, function(prs:FlxTimer)
					{
						var skip:Bool = false;
						if (textIndex == 'cs/scooby_hold_talk' && curr_dial == 6 && curr_char >= 16)
						{
							skip = true;
						}
						if (FlxG.keys.justReleased.ANY || skip)
						{
							if ((curr_char <= dialogue[curr_dial].length) && !skip)
							{
								curr_char = dialogue[curr_dial].length;
							}
							else
							{
								curr_char = 0;
								curr_dial ++;
								if (curr_dial >= dialogue.length)
								{
									if (cs_reset)
									{
										if (skip)
										{
											tbox.alpha = 0;
										}
										cs_wait = false;
										cs_time ++;
									}
									else
									{
										switch afterAction
										{
											case 'countdown':
												startCountdown();
											case 'transform':
												superShaggy();
											case 'end song':
												endSong();
											case 'possess':
												FlxG.sound.playMusic(Paths.music('possess'));
												zephState = 1;
											case 'zephyrus':
												FlxG.sound.music.fadeOut(1, 0);
												new FlxTimer().start(1, function(cock:FlxTimer)
												{
													startCountdown();
												});
											case 'stand up':
												dad.playAnim('standUP', true);
												new FlxTimer().start(1, function(cock:FlxTimer)
												{
													startCountdown();
												});
											case 'wb bye':
												wb_state = 1;
											case 'zeph bye':
												new FlxTimer().start(1, function(cock:FlxTimer)
												{
													dad.alpha = 0;
													zend_state = 1;
												});
	
										}
									}
									talk = 0;
									dropText.alpha = 0;
									curr_dial = 0;
									tb_appear = 0;
								}
								else
								{
									if (textIndex == 'cs/sh_bye' && curr_dial == 3)
									{
										cs_mus.stop();
									}
									fimage = dchar[curr_dial] + '_' + dface[curr_dial];
									if (fimage != "n")
									{
										fsprite.destroy();
										faceRender();
										fsprite.flipX = false;
										if (dside[curr_dial] == -1)
										{
											fsprite.flipX = true;
										}
									}
								}
							}
						}
						prs.reset(0.001 / (FlxG.elapsed / (1/60)));
					});
				}
			}
		}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	var keys = [false, false, false, false, false, false, false, false, false];

	function startCountdown():Void
	{
		inCutscene = false;

		var enemyAlpha:Float = 1;
		var playerAlpha:Float = 1;
		if (SONG.song.toLowerCase() == 'live-on') {
			enemyAlpha = 0;
			playerAlpha = 0;
		}
		generateStaticArrows(0, enemyAlpha);
		generateStaticArrows(1, playerAlpha);

		switch(mania) //moved it here because i can lol
		{
			case 0: 
				keys = [false, false, false, false];
			case 1: 
				keys = [false, false, false, false, false, false];
			case 2: 
				keys = [false, false, false, false, false, false, false, false, false];
			case 3: 
				keys = [false, false, false, false, false];
			case 4: 
				keys = [false, false, false, false, false, false, false];
			case 5: 
				keys = [false, false, false, false, false, false, false, false];
			case 6: 
				keys = [false];
			case 7: 
				keys = [false, false];
			case 8: 
				keys = [false, false, false];
		}
	
		


		#if windows
		// pre lowercasing the song name (startCountdown)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[songLowercase]);
		}
		#end
		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;
		
		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			if (exDad) dad2.dance();
			boyfriend.dance();

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);

		if (SONG.song.toLowerCase() == 'expurgation') // start the grem time
			{
				new FlxTimer().start(25, function(tmr:FlxTimer) {
					if (curStep < 2400)
					{
						if (canPause && !paused && health >= 1.5 && !grabbed)
							doGremlin(40,3);
						trace('checka ' + health);
						tmr.reset(25);
					}
				});
			}
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;
	var songTimer:Float = 0;

	private function getKey(charCode:Int):String
	{
		for (key => value in FlxKey.fromStringMap)
		{
			if (charCode == value)
				return key;
		}
		return null;
	}
	



	private function releaseInput(evt:KeyboardEvent):Void // handles releases
	{
		@:privateAccess
		var key = FlxKey.toStringMap.get(evt.keyCode);

		var binds:Array<String> = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
		var data = -1;
		switch(maniaToChange)
		{
			case 0: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys // why the fuck are arrow keys hardcoded it fucking breaks the controls with extra keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 1: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, FlxG.save.data.L2Bind, FlxG.save.data.D1Bind, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 3;
					case 40:
						data = 4;
					case 39:
						data = 5;
				}
			case 2: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N4Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 3: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.N4Bind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 3;
					case 39:
						data = 4;
				}
			case 4: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind,FlxG.save.data.N4Bind, FlxG.save.data.L2Bind, FlxG.save.data.D1Bind, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 4;
					case 40:
						data = 5;
					case 39:
						data = 6;
				}
			case 5: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 4;
					case 40:
						data = 5;
					case 38:
						data = 6;
					case 39:
						data = 7;
				}
			case 6: 
				binds = [FlxG.save.data.N4Bind];
			case 7: 
				binds = [FlxG.save.data.leftBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys 
				{
					case 37:
						data = 0;
					case 39:
						data = 1;
				}

			case 8: 
				binds = [FlxG.save.data.leftBind, FlxG.save.data.N4Bind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys 
				{
					case 37:
						data = 0;
					case 39:
						data = 2;
				}
			case 10: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind, null, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 11: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.D1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, null, FlxG.save.data.L2Bind, null, null, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 1;
					case 39:
						data = 8;
				}
			case 12: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N4Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 13: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 14: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.D1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, FlxG.save.data.N4Bind, FlxG.save.data.L2Bind, null, null, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 1;
					case 39:
						data = 8;
				}
			case 15: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, null, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 16: 
				binds = [null, null, null, null, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 4;
					case 39:
						data = 8;
				}
			case 17: 
				binds = [FlxG.save.data.leftBind, null, null, FlxG.save.data.rightBind, null, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 18: 
				binds = [FlxG.save.data.leftBind, null, null, FlxG.save.data.rightBind, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
		}

		


		for (i in 0...binds.length) // binds
		{
			if (binds[i].toLowerCase() == key.toLowerCase())
				data = i;
		}

		if (data == -1)
			return;

		keys[data] = false;
	}

	public var closestNotes:Array<Note> = [];

	private function handleInput(evt:KeyboardEvent):Void { // this actually handles press inputs

		if (PlayStateChangeables.botPlay || loadRep || paused)
			return;

		// first convert it from openfl to a flixel key code
		// then use FlxKey to get the key's name based off of the FlxKey dictionary
		// this makes it work for special characters

		@:privateAccess
		var key = FlxKey.toStringMap.get(evt.keyCode);
		var data = -1;
		var binds:Array<String> = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
		switch(maniaToChange)
		{
			case 0: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys // why the fuck are arrow keys hardcoded it fucking breaks the controls with extra keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 1: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, FlxG.save.data.L2Bind, FlxG.save.data.D1Bind, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 3;
					case 40:
						data = 4;
					case 39:
						data = 5;
				}
			case 2: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N4Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 3: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.N4Bind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 3;
					case 39:
						data = 4;
				}
			case 4: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind,FlxG.save.data.N4Bind, FlxG.save.data.L2Bind, FlxG.save.data.D1Bind, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 4;
					case 40:
						data = 5;
					case 39:
						data = 6;
				}
			case 5: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 4;
					case 40:
						data = 5;
					case 38:
						data = 6;
					case 39:
						data = 7;
				}
			case 6: 
				binds = [FlxG.save.data.N4Bind];
			case 7: 
				binds = [FlxG.save.data.leftBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys 
				{
					case 37:
						data = 0;
					case 39:
						data = 1;
				}

			case 8: 
				binds = [FlxG.save.data.leftBind, FlxG.save.data.N4Bind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys 
				{
					case 37:
						data = 0;
					case 39:
						data = 2;
				}
			case 10: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind, null, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 11: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.D1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, null, FlxG.save.data.L2Bind, null, null, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 1;
					case 39:
						data = 8;
				}
			case 12: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N4Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 13: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 14: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.D1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, FlxG.save.data.N4Bind, FlxG.save.data.L2Bind, null, null, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 1;
					case 39:
						data = 8;
				}
			case 15: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, null, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 16: 
				binds = [null, null, null, null, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 4;
					case 39:
						data = 8;
				}
			case 17: 
				binds = [FlxG.save.data.leftBind, null, null, FlxG.save.data.rightBind, null, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 18: 
				binds = [FlxG.save.data.leftBind, null, null, FlxG.save.data.rightBind, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}

		}

			for (i in 0...binds.length) // binds
				{
					if (binds[i].toLowerCase() == key.toLowerCase())
						data = i;
				}
				if (data == -1)
				{
					//trace("couldn't find a keybind with the code " + key); //this is kinda annoying.
					return;
				}
				if (keys[data])
				{
					//trace("ur already holding " + key); //this is too.
					return;
				}
		
				keys[data] = true;
		
				var ana = new Ana(Conductor.songPosition, null, false, "miss", data);
		
				var dataNotes = [];
				for(i in closestNotes)
					if (i.noteData == data)
						dataNotes.push(i);

				
				if (!FlxG.save.data.gthm)
				{
					if (dataNotes.length != 0)
						{
							var coolNote = null;
				
							for (i in dataNotes)
								if (!i.isSustainNote)
								{
									coolNote = i;
									break;
								}
				
							if (coolNote == null) // Note is null, which means it's probably a sustain note. Update will handle this (HOPEFULLY???)
							{
								return;
							}
				
							if (dataNotes.length > 1) // stacked notes or really close ones
							{
								for (i in 0...dataNotes.length)
								{
									if (i == 0) // skip the first note
										continue;
				
									var note = dataNotes[i];
				
									if (!note.isSustainNote && (note.strumTime - coolNote.strumTime) < 2)
									{
										trace('found a stacked/really close note ' + (note.strumTime - coolNote.strumTime));
										// just fuckin remove it since it's a stacked note and shouldn't be there
										note.kill();
										notes.remove(note, true);
										note.destroy();
									}
								}
							}
				
							goodNoteHit(coolNote);
							var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
							ana.hit = true;
							ana.hitJudge = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));
							ana.nearestNote = [coolNote.strumTime, coolNote.noteData, coolNote.sustainLength];
						
						}
					else if (!FlxG.save.data.ghost && songStarted && !grace)
						{
							noteMiss(data, null);
							ana.hit = false;
							ana.hitJudge = "shit";
							ana.nearestNote = [];
							//health -= 0.20;
						}
				}
		
	}

	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		if (SONG.song.toLowerCase() == 'live-on') {
		//	dad.animation.play('fadeIn', true);
			dad.visible = true;
			
			//healthBar.alpha = 0.4;
			//healthBarBG.alpha = 0.4;
			//iconP1.alpha = 0;
			//iconP2.alpha = 0.4;
			//scoreTxt.alpha = 0.4;
		}

		if (FlxG.save.data.noteSplash)
			{
				switch (mania)
				{
					case 0: 
						NoteSplash.colors = ['purple', 'blue', 'green', 'red'];
					case 1: 
						NoteSplash.colors = ['purple', 'green', 'red', 'yellow', 'blue', 'darkblue'];	
					case 2: 
						NoteSplash.colors = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'darkred', 'darkblue'];
					case 3: 
						NoteSplash.colors = ['purple', 'blue', 'white', 'green', 'red'];
						if (FlxG.save.data.gthc)
							NoteSplash.colors = ['green', 'red', 'yellow', 'darkblue', 'orange'];
					case 4: 
						NoteSplash.colors = ['purple', 'green', 'red', 'white', 'yellow', 'blue', 'darkblue'];
					case 5: 
						NoteSplash.colors = ['purple', 'blue', 'green', 'red', 'yellow', 'violet', 'darkred', 'darkblue'];
					case 6: 
						NoteSplash.colors = ['white'];
					case 7: 
						NoteSplash.colors = ['purple', 'red'];
					case 8: 
						NoteSplash.colors = ['purple', 'white', 'red'];
				}
			}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		// Song duration in a float, useful for the time left feature
		songLengthTime = FlxG.sound.music.length;

		trace(songLength);

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (PlayStateChangeables.useDownscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

		//	timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 248, 20, 400, "", 32);
		//	timeTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		///	timeTxt.scrollFactor.set();
		//	timeTxt.alpha = 0;
		//	timeTxt.borderSize = 2;
		//	timeTxt.visible = !ClientPrefs.hideTime;

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5),songPosBG.y,0,SONG.song + ' | Time Left: ' + timeTxt + ' or ' + Std.string(songLength - Conductor.songPosition), 16);
			if (PlayStateChangeables.useDownscroll)
				songName.y -= 3;
			songName.x -= 10;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();

			if (SONG.song.toLowerCase() != 'live-on')
				add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}

		if (SONG.song.toLowerCase() == 'live-on') {
		//	songName.text = '';
			kadeEngineWatermark.text = '';
	//		FlxTween.tween(songPosBG, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
	//		FlxTween.tween(songPosBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		//	FlxTween.tween(songName, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly Nice' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}

		if (useVideo)
			GlobalVideo.get().resume();
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if windows
			// pre lowercasing the song name (generateSong)
			var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
				switch (songLowercase) {
					case 'dad-battle': songLowercase = 'dadbattle';
					case 'philly-nice': songLowercase = 'philly';
				}

			var songPath = 'assets/data/' + songLowercase + '/';
			
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		var file:String = Paths.json(SONG.song.toLowerCase() + '/events');

		#if sys
		if (sys.FileSystem.exists(file)) {
		#else
		if (OpenFlAssets.exists(file)) {
		#end
			var eventsData:Array<SwagSection> = Song.loadFromJson('events', SONG.song.toLowerCase()).notes;
			for (section in eventsData)
			{
				for (songNotes in section.sectionNotes)
				{
					if(songNotes[1] < 0) {
						eventNotes.push(songNotes);
						eventPushed(songNotes);
					}
				}
			}
		}

		//if (FlxG.save.data.randomNotes != "Regular" && FlxG.save.data.randomNotes != "None" && FlxG.save.data.randomNotes != "Section")
			//FlxG.save.data.randomNotes = "None";
		for (section in noteData)
		{
			var mn:Int = keyAmmo[mania];
			var coolSection:Int = Std.int(section.lengthInSteps / 4);
			var dataForThisSection:Array<Int> = [];
			var randomDataForThisSection:Array<Int> = [];
			//var maxNoteData:Int = 3;
			switch (maniaToChange) //sets up the max data for each section based on mania
			{
				case 0: 
					dataForThisSection = [0,1,2,3];
				case 1: 
					dataForThisSection = [0,1,2,3,4,5];
				case 2: 
					dataForThisSection = [0,1,2,3,4,5,6,7,8];
				case 3: 
					dataForThisSection = [0,1,2,3,4];
				case 4: 
					dataForThisSection = [0,1,2,3,4,5,6];
				case 5: 
					dataForThisSection = [0,1,2,3,4,5,6,7];
				case 6: 
					dataForThisSection = [0];
				case 7: 
					dataForThisSection = [0,1];
				case 8: 
					dataForThisSection = [0,1,2];
			}

			if (PlayStateChangeables.randomNotes && PlayStateChangeables.randomSection)
			{
				for (i in 0...dataForThisSection.length) //point of this is to randomize per section, so each lane of notes will move together, its kinda hard to explain, but it give good charts so idc
				{
					var number:Int = dataForThisSection[FlxG.random.int(0, dataForThisSection.length - 1)];
					dataForThisSection.remove(number);
					randomDataForThisSection.push(number);
				}
			}

			for (songNotes in section.sectionNotes)
			{
				if(songNotes[1] > -1) { //Real notes
				var isRandomNoteType:Bool = false;
				var isReplaceable:Bool = false;
				var newNoteType:Int = 0;
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % mn);
				var daNoteTypeData:Int = FlxG.random.int(0, mn - 1);


				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] >= mn)
				{
					gottaHitNote = !section.mustHitSection;

				}
				if (PlayStateChangeables.randomNotes)
				{
					switch(PlayStateChangeables.randomNoteTypes) //changes based on chance based on setting
					{
						case 0: 
							isRandomNoteType = false;
						case 1: 
							isRandomNoteType = FlxG.random.bool(1);
						case 2: 
							isRandomNoteType = FlxG.random.bool(5);
						case 3: 
							isRandomNoteType = FlxG.random.bool(15);
						case 4: 
							isRandomNoteType = FlxG.random.bool(75);
					}
				}

				if (isRandomNoteType && PlayStateChangeables.randomNotes)
				{
					if (FlxG.random.bool(50)) // 50/50 chance for a note type thats supposed to hit or a note that isnt supposed to be hit, ones that are supposed to be hit replace already existing notes, so it makes sense in the chart
					{
						isReplaceable = false;
						newNoteType = nonReplacableTypeList[FlxG.random.int(0,2)];
					}
					else
					{
						isReplaceable = true;
						newNoteType = replacableTypeList[FlxG.random.int(0,2)];
					}
				}

				if (PlayStateChangeables.bothSide)
				{
					if (!gottaHitNote)
					{
						switch(daNoteData) //did this cuz duets crash game / cause issues
						{
							case 0: 
								daNoteData = 4;
							case 1: 
								daNoteData = 5;
							case 2: 
								daNoteData = 6;
							case 3:
								daNoteData = 7;
							case 4: 
								daNoteData = 0;
							case 5: 
								daNoteData = 1;
							case 6: 
								daNoteData = 2;
							case 7:
								daNoteData = 3;
						}
					}
					else
						{
							switch(daNoteData)
							{
								case 0: 
									daNoteData = 0;
								case 1: 
									daNoteData = 1;
								case 2: 
									daNoteData = 2;
								case 3:
									daNoteData = 3;
								case 4: 
									daNoteData = 4;
								case 5: 
									daNoteData = 5;
								case 6: 
									daNoteData = 6;
								case 7:
									daNoteData = 7;
							}
						}
					if (daNoteData > 7) //failsafe
						daNoteData -= 4;
				}


				if (PlayStateChangeables.randomNotes && !PlayStateChangeables.randomSection)
					{
						if (daNoteData > 3) //fixes duets
							gottaHitNote = !gottaHitNote;
						daNoteData = FlxG.random.int(0, mn - 1); //regular randomizaton
					}
				else if (PlayStateChangeables.randomNotes && PlayStateChangeables.randomSection)
				{
					if (daNoteData > 3) //fixes duets
						gottaHitNote = !gottaHitNote;
					daNoteData = randomDataForThisSection[daNoteData]; //per section randomization
				}
				if (PlayStateChangeables.bothSide)
				{
					gottaHitNote = true; //both side
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var daType = songNotes[3];
				if (isRandomNoteType && newNoteType != 0 && isReplaceable)
				{
					daType = newNoteType;
				}

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daType);

				var fuckYouNote:Note; //note type placed next to other note

				if (daNoteTypeData == daNoteData && daNoteTypeData == 0) //so it doesnt go over the other note, even though it still happens lol
					daNoteTypeData += 1;
				else if(daNoteTypeData == daNoteData)
					daNoteTypeData -= 1;

				if (isRandomNoteType && !isReplaceable)
				{
					fuckYouNote = new Note(daStrumTime, daNoteTypeData, swagNote, false, newNoteType); //note types that you arent supposed to hit
					fuckYouNote.scrollFactor.set(0, 0);
				}
				else
				{
					fuckYouNote = null;
					//fuckYouNote.scrollFactor.set(0, 0);
				}
					

				

				if (!gottaHitNote && PlayStateChangeables.Optimize)
					continue;

				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				if (susLength > 0)
					swagNote.isParent = true;

				var type = 0;

				if (isRandomNoteType && !isReplaceable)
					unspawnNotes.push(fuckYouNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					if (PlayStateChangeables.flip)
						sustainNote.mustPress = !gottaHitNote;
					else
						sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
					sustainNote.parent = swagNote;
					swagNote.children.push(sustainNote);
					sustainNote.spotInLine = type;
					type++;
				}

				if (PlayStateChangeables.flip) //flips the charts epic
				{
					swagNote.mustPress = !gottaHitNote;
					if (isRandomNoteType && !isReplaceable)
						fuckYouNote.mustPress = !gottaHitNote;
				}
				else
				{
					swagNote.mustPress = gottaHitNote;
					if (isRandomNoteType && !isReplaceable)
						fuckYouNote.mustPress = gottaHitNote;
				}
					


				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
					if (isRandomNoteType && !isReplaceable)
						fuckYouNote.x += FlxG.width / 2;
				}
				else {}
		 } else { //Event Notes bruh
					eventNotes.push(songNotes);
					eventPushed(songNotes);
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);
		if(eventNotes.length > 1) { //No need to sort if there's a single one or none at all
			eventNotes.sort(sortByTime);
		}

		generatedMusic = true;
	//	}
	}

	private function generateStaticArrows(player:Int, theAlpha:Float):Void
	{
		for (i in 0...keyAmmo[mania])
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			//defaults if no noteStyle was found in chart
			var noteTypeCheck:String = 'normal';
		
			if (PlayStateChangeables.Optimize && player == 0)
				continue;

			if (SONG.noteStyle == null) {
				switch(storyWeek) {case 6: noteTypeCheck = 'pixel';}
			} else {noteTypeCheck = SONG.noteStyle;}

			switch (noteTypeCheck)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('noteassets/pixel/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [11]);
					babyArrow.animation.add('red', [12]);
					babyArrow.animation.add('blue', [10]);
					babyArrow.animation.add('purplel', [9]);

					babyArrow.animation.add('white', [13]);
					babyArrow.animation.add('yellow', [14]);
					babyArrow.animation.add('violet', [15]);
					babyArrow.animation.add('black', [16]);
					babyArrow.animation.add('darkred', [16]);
					babyArrow.animation.add('orange', [16]);
					babyArrow.animation.add('dark', [17]);


					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom * Note.pixelnoteScale));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					var numstatic:Array<Int> = [0, 1, 2, 3, 4, 5, 6, 7, 8]; //this is most tedious shit ive ever done why the fuck is this so hard
					var startpress:Array<Int> = [9, 10, 11, 12, 13, 14, 15, 16, 17];
					var endpress:Array<Int> = [18, 19, 20, 21, 22, 23, 24, 25, 26];
					var startconf:Array<Int> = [27, 28, 29, 30, 31, 32, 33, 34, 35];
					var endconf:Array<Int> = [36, 37, 38, 39, 40, 41, 42, 43, 44];
						switch (mania)
						{
							case 1:
								numstatic = [0, 2, 3, 5, 1, 8];
								startpress = [9, 11, 12, 14, 10, 17];
								endpress = [18, 20, 21, 23, 19, 26];
								startconf = [27, 29, 30, 32, 28, 35];
								endconf = [36, 38, 39, 41, 37, 44];

							case 2: 
								babyArrow.x -= Note.tooMuch;
							case 3: 
								numstatic = [0, 1, 4, 2, 3];
								startpress = [9, 10, 13, 11, 12];
								endpress = [18, 19, 22, 20, 21];
								startconf = [27, 28, 31, 29, 30];
								endconf = [36, 37, 40, 38, 39];
							case 4: 
								numstatic = [0, 2, 3, 4, 5, 1, 8];
								startpress = [9, 11, 12, 13, 14, 10, 17];
								endpress = [18, 20, 21, 22, 23, 19, 26];
								startconf = [27, 29, 30, 31, 32, 28, 35];
								endconf = [36, 38, 39, 40, 41, 37, 44];
							case 5: 
								numstatic = [0, 1, 2, 3, 5, 6, 7, 8];
								startpress = [9, 10, 11, 12, 14, 15, 16, 17];
								endpress = [18, 19, 20, 21, 23, 24, 25, 26];
								startconf = [27, 28, 29, 30, 32, 33, 34, 35];
								endconf = [36, 37, 38, 39, 41, 42, 43, 44];
							case 6: 
								numstatic = [4];
								startpress = [13];
								endpress = [22];
								startconf = [31];
								endconf = [40];
							case 7: 
								numstatic = [0, 3];
								startpress = [9, 12];
								endpress = [18, 21];
								startconf = [27, 30];
								endconf = [36, 39];
							case 8: 
								numstatic = [0, 4, 3];
								startpress = [9, 13, 12];
								endpress = [18, 22, 21];
								startconf = [27, 31, 30];
								endconf = [36, 40, 39];


						}
					babyArrow.x += Note.swagWidth * i;
					babyArrow.animation.add('static', [numstatic[i]]);
					babyArrow.animation.add('pressed', [startpress[i], endpress[i]], 12, false);
					babyArrow.animation.add('confirm', [startconf[i], endconf[i]], 24, false);

					
				
					case 'normal':
						{
							babyArrow.frames = Paths.getSparrowAtlas('noteassets/NOTE_assets');
							babyArrow.animation.addByPrefix('green', 'arrowUP');
							babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
							babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
							babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
		
							babyArrow.antialiasing = FlxG.save.data.antialiasing;
							babyArrow.setGraphicSize(Std.int(babyArrow.width * Note.noteScale));
	
							var nSuf:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
							var pPre:Array<String> = ['purple', 'blue', 'green', 'red'];
								switch (mania)
								{
									case 1:
										nSuf = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
										pPre = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
	
									case 2:
										nSuf = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'SPACE', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
										pPre = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'darkred', 'dark'];
										babyArrow.x -= Note.tooMuch;
									case 3: 
										nSuf = ['LEFT', 'DOWN', 'SPACE', 'UP', 'RIGHT'];
										pPre = ['purple', 'blue', 'white', 'green', 'red'];
										if (FlxG.save.data.gthc)
											{
												nSuf = ['UP', 'RIGHT', 'LEFT', 'RIGHT', 'UP'];
												pPre = ['green', 'red', 'yellow', 'dark', 'orange'];
											}
									case 4: 
										nSuf = ['LEFT', 'UP', 'RIGHT', 'SPACE', 'LEFT', 'DOWN', 'RIGHT'];
										pPre = ['purple', 'green', 'red', 'white', 'yellow', 'blue', 'dark'];
									case 5: 
										nSuf = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
										pPre = ['purple', 'blue', 'green', 'red', 'yellow', 'violet', 'darkred', 'dark'];
									case 6: 
										nSuf = ['SPACE'];
										pPre = ['white'];
									case 7: 
										nSuf = ['LEFT', 'RIGHT'];
										pPre = ['purple', 'red'];
									case 8: 
										nSuf = ['LEFT', 'SPACE', 'RIGHT'];
										pPre = ['purple', 'white', 'red'];
	
								}
						
						babyArrow.x += Note.swagWidth * i;
						babyArrow.animation.addByPrefix('static', 'arrow' + nSuf[i]);
						babyArrow.animation.addByPrefix('pressed', pPre[i] + ' press', 24, false);
						babyArrow.animation.addByPrefix('confirm', pPre[i] + ' confirm', 24, false);
						}						
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();
			babyArrow.alpha = theAlpha;

			if (!isStoryMode)
			{
				//babyArrow.y -= 10;
				//babyArrow.alpha = 0;
				//FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
					if (PlayStateChangeables.bothSide)
						babyArrow.x -= 500;
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			if (PlayStateChangeables.flip)
			{
				
				switch (player)
				{
					case 0:
						babyArrow.x += ((FlxG.width / 2) * 1);
					case 1:
						babyArrow.x += ((FlxG.width / 2) * 0);
				}
			}
			else
				babyArrow.x += ((FlxG.width / 2) * player);
			
			if (PlayStateChangeables.Optimize)
				babyArrow.x -= 275;

			if (PlayStateChangeables.bothSide)
				babyArrow.x -= 350;
			
			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		if (isMonoDead) {
			Conductor.songPosition = 0;
			return;
		} 
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
		{
			return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
		}

	private var paused:Bool = false;

	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	public var stopUpdate = false;
	public var removedVideo = false;

		//ass crack
		var sh_r:Float = 600;
		var sShake:Float = 0;
		var ldx:Float = 0;
		var ldy:Float = 0;
		var lstep:Float = 0;
		var legs_in = false;
		var gf_launched:Bool = false;
	
		var godCutEnd:Bool = false;
		var godMoveBf:Bool = true;
		var godMoveGf:Bool = false;
		var godMoveSh:Bool = false;
	
		var rotInd:Int = 0;
	
		//oooOOooOoO
		public static var rotCam = false;
		var rotCamSpd:Float = 1;
		var rotCamRange:Float = 10;
		var rotCamInd = 0;
	
		//WB ending
		var wb_state = 0;
		var wb_speed:Float = 0;
		var wb_time = 0;
		var wb_eX:Float = 0;
		var wb_eY:Float = 0;
	
		//ZEPHYRUS vars mask vars
		var bfControlY:Float = 0;
		var maskCreated = false;
		var maskObj:MASKcoll;
		var alterRoute:Int = 0;
		var zephRot:Int = 0;
		var zephTime:Int = 0;
		var zephVsp:Float = 0;
		var zephGrav:Float = 0.15;
	
		//zeph ending
		var zend_state = 0;
		var zend_time = 0;

	override public function update(elapsed:Float)
	{
		if (FlxG.save.data.botplay && SONG.song.toLowerCase() == 'talladega' && !FlxG.save.data.unlockedExtra)
		{
			System.exit(0);
		}

		#if !debug
		perfectMode = false;
		#end

		if (generatedMusic)
			{
				for(i in notes)
				{
					var diff = i.strumTime - Conductor.songPosition;
					if (diff < 2650 && diff >= -2650)
					{
						i.active = true;
						i.visible = true;
					}
					else
					{
						i.active = false;
						i.visible = false;
					}
				}
			}

		if (PlayStateChangeables.botPlay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;


		if (useVideo && GlobalVideo.get() != null && !stopUpdate)
			{		
				if (GlobalVideo.get().ended && !removedVideo)
				{
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}
			}


		
		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				overhealthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				overhealthBar.visible = false;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...keyAmmo[mania])
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}

			camNotes.zoom = camHUD.zoom;
			camNotes.x = camHUD.x;
			camNotes.y = camHUD.y;
			camNotes.angle = camHUD.angle;
			camSustains.zoom = camHUD.zoom;
			camSustains.x = camHUD.x;
			camSustains.y = camHUD.y;
			camSustains.angle = camHUD.angle;
		}

		#end
		camNotes.zoom = camHUD.zoom;
		camNotes.x = camHUD.x;
		camNotes.y = camHUD.y;
		camNotes.angle = camHUD.angle;

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving && !PlayStateChangeables.Optimize)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;

			case 'sky':
				var rotRate = curStep * 0.25;
				var rotRateSh = curStep / 9.5;
				var rotRateGf = curStep / 9.5 / 4;
				var derp = 12;
				if (!startedCountdown)
				{
					camFollow.x = boyfriend.x - 300;
					camFollow.y = boyfriend.y - 40;
					derp = 20;
				}

				if (godCutEnd)
				{
					if (!maskCreated)
					{
						if (isStoryMode && !FlxG.save.data.p_maskGot[1])
						{
							maskObj = new MASKcoll(2, 330, 660, 0);
							maskCollGroup.add(maskObj);
						}
						maskCreated = true;
					}
					if (curBeat < 32)
					{
						sh_r = 60;
					}
					else if ((curBeat >= 140 * 4) || (curBeat >= 50 * 4 && curBeat <= 58 * 4))
					{
						sh_r += (60 - sh_r) / 32;
					}
					else
					{
						sh_r = 600;
					}

					if ((curBeat >= 32 && curBeat < 48) || (curBeat >= 124 * 4 && curBeat < 140 * 4))
					{
						if (boyfriend.animation.curAnim.name.startsWith('idle'))
						{
							boyfriend.playAnim('scared', true);
						}
					}

					if (curBeat < 58*4)
					{
					}
					else if (curBeat < 74 * 4)
					{
						rotRateSh *= 1.2;
					}
					else if (curBeat < 124 * 4)
					{
					}
					else if (curBeat < 140 * 4)
					{
						rotRateSh *= 1.2;
					}
					var bf_toy = -2000 + Math.sin(rotRate) * 20 + bfControlY;

					var sh_toy = -2450 + -Math.sin(rotRateSh * 2) * sh_r * 0.45;
					var sh_tox = -330 -Math.cos(rotRateSh) * sh_r;

					var gf_tox = 100 + Math.sin(rotRateGf) * 200;
					var gf_toy = -2000 -Math.sin(rotRateGf) * 80;

					if (godMoveBf)
					{
						boyfriend.y += (bf_toy - boyfriend.y) / derp;
						rock.x = boyfriend.x - 200;
						rock.y = boyfriend.y + 200;
						rock.alpha = 1;
						if (true)//(!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
						{
							if (FlxG.keys.pressed.UP && bfControlY > 0)
							{
								bfControlY --;
							}
							if (FlxG.keys.pressed.DOWN && bfControlY < 2290)
							{
								trace(bfControlY);
								bfControlY ++;
								if (bfControlY >= 400)
								{
									alterRoute = 1;
								}
							}
						}
					}

					if (godMoveSh)
					{
						dad.x += (sh_tox - dad.x) / 12;
						dad.y += (sh_toy - dad.y) / 12;

						if (dad.animation.name == 'idle')
						{
							var pene = 0.07;
							dad.angle = Math.sin(rotRateSh) * sh_r * pene / 4;

							legs.alpha = 1;
							legs.angle = Math.sin(rotRateSh) * sh_r * pene;// + Math.cos(curStep) * 5;

							legs.x = dad.x + 120 + Math.cos((legs.angle + 90) * (Math.PI/180)) * 150;
							legs.y = dad.y + 300 + Math.sin((legs.angle + 90) * (Math.PI/180)) * 150;
						}
						else
						{
							dad.angle = 0;
							legs.alpha = 0;
						}
						legT.visible = true;
						if (legs.alpha == 0)
							legT.visible = false;
					}

					if (godMoveGf)
					{
						gf.x += (gf_tox - gf.x) / derp;
						gf.y += (gf_toy - gf.y) / derp;

						gf_rock.x = gf.x + 80;
						gf_rock.y = gf.y + 530;
						gf_rock.alpha = 1;
						if (!gf_launched)
						{
							gf.scrollFactor.set(0.8, 0.8);
							gf.setGraphicSize(Std.int(gf.width * 0.8));
							gf_launched = true;
						}
					}
				}
				if (!godCutEnd || !godMoveBf)
				{
					rock.alpha = 0;
				}
				if (!godMoveGf)
				{
					gf_rock.alpha = 0;
				}
			case 'lava':
				if (dad.curCharacter == 'wbshaggy')
				{
					rotInd ++;
					var rot = rotInd / 6;

					dad.x = DAD_X + Math.cos(rot / 3) * 20 + wb_eX;
					dad.y = DAD_Y + Math.cos(rot / 5) * 40 + wb_eY;
				}
		}

		if (rotCam)
			{
				rotCamInd ++;
				camera.angle = Math.sin(rotCamInd / 100 * rotCamSpd) * rotCamRange;
			}
			else
			{
				rotCamInd = 0;
			}
	
			if (dimGo)
			{
				if (bgDim.alpha < 0.5) bgDim.alpha += 0.01;
			}
			else
			{
				if (bgDim.alpha > 0) bgDim.alpha -= 0.01;
			}
			if (fullDim && !Main.onlyExtra)
			{
				bgDim.alpha = 1;
	
				switch (noticeTime)
				{
					case 0:
						var no = new Alphabet(0, 200, 'You can unlock this in-game.', true, false);
						no.cameras = [camHUD];
						no.screenCenter();
						add(no);
					case 300:
						System.exit(0);
				}
				noticeTime ++;
			}

		super.update(elapsed);

		//Zephyrus buddy
		if (zeph != null)
			{
				if (zephState < 2) zephRot ++;
	
				var zToX = boyfriend.getMidpoint().x + 240 + Math.sin(zephRot / 213) * 20;
				var zToY = boyfriend.getMidpoint().y - 220 + Math.sin(zephRot / 50) * 15;
	
				switch (zephState)
				{
					case 1:
						camHUD.visible = false;
						camNotes.visible = false;
						var tow = new FlxPoint(dad.getMidpoint().x, dad.getMidpoint().y - 1200);
						zephAddX -= 1.25;
	
						var c = tow.y - (zeph.y + zephAddY);
						zephAddY += (c / Math.abs(c)) * 0.75;
	
						camFollow.x = zeph.x - 100;
						camFollow.y = zeph.y + 200;
						camLerp = 0.5;
	
						if (zeph.x < tow.x - 40)
						{
							zephState = 2;
							FlxG.sound.music.stop();
							remove(zeph);
							zeph = new FlxSprite().loadGraphic(Paths.image('MASK/possessed', 'shared'));
							zeph.updateHitbox();
							zeph.antialiasing = FlxG.save.data.antialiasing;
							camFollow.x = zeph.getMidpoint().x;
							camFollow.y = zeph.getMidpoint().y;
							camFollowPos.x = camFollow.x;
							camFollowPos.y = camFollow.y;
							zLockX = camFollow.x;
							zLockY = camFollow.y;
	
							zephScreen.screenCenter(X);
							zephScreen.screenCenter(Y);
							add(zephScreen);
							add(zeph);
	
							zeph.scrollFactor.set(0, 0);
							zeph.screenCenter(X);
							zeph.screenCenter(Y);
	
							healthBarBG.alpha = 0;
							healthBar.alpha = 0;
							iconP1.alpha = 0;
							iconP2.alpha = 0;
							scoreTxt.alpha = 0;
							boyfriend.alpha = 0;
						}
					case 2:
						camFollow.x = zLockX;
						camFollow.y = zLockY;
						camFollowPos.x = camFollow.x;
						camFollowPos.y = camFollow.y;
	
						zephTime ++;
						
						if (zephTime > 350)
						{
							zephVsp += zephGrav;
							zeph.angle -= 0.4;
							zeph.y += zephVsp;
	
							if (zephTime == 510)
							{
								FlxG.sound.play(Paths.sound('undSnap', 'preload'));
							}
							if (zephTime == 700)
							{
								trace(sEnding);
								storyPlaylist = ['Astral-calamity', 'Talladega'];
								endSong();
							}
						}
				}
				zToX += zephAddX;
				zToY += zephAddY;
	
				if (zeph.x == -2000)
				{
					zeph.x = zToX;
					zeph.y = zToY;
				}
				if (zephState < 2)
				{
					zeph.x += (zToX - zeph.x) / 12;
					zeph.y += (zToY - zeph.y) / 12;
				}
			}
	
			switch (wb_state)
			{
				case 1:
					wb_speed += 0.1;
					if (wb_speed > 20) wb_speed = 20;
					wb_eY -= wb_speed;
					wb_eX += wb_speed;
					
					wb_time ++;
	
					switch (wb_time)
					{
						case 400:
							var bDim = new FlxSprite(0, 0).makeGraphic(4000, 4000, FlxColor.BLACK);
							bDim.alpha = 0.5;
							bDim.scrollFactor.set(0);
							bDim.screenCenter();
							add(bDim);
	
							var cong = new Alphabet(0, 40, 'Congratulations!', true, false);
							cong.cameras = [camHUD];
							cong.screenCenter(X);
							add(cong);
							FlxG.sound.play(Paths.sound('victory'));
						case 600:
							var bef = new Alphabet(0, 200, 'You defeated WB', true, false);
							bef.cameras = [camHUD];
							bef.screenCenter(X);
	
							var bef2 = new Alphabet(0, 260, 'Shaggy!', true, false);
							bef2.cameras = [camHUD];
							bef2.screenCenter(X);
	
							add(bef);
							add(bef2);
						case 750:
							var bef = new Alphabet(0, 400, 'And got stuck in hell...', true, false);
							//bef.color = FlxColor.WHITE;
							bef.cameras = [camHUD];
							bef.screenCenter(X);
							add(bef);
	
						case 1000:
	
							var bef2 = new Alphabet(0, 600, 'Full ending', true, false);
							bef2.cameras = [camHUD];
							bef2.screenCenter(X);
	
							MASKstate.endingUnlock(1);
							add(bef2);
						case 1300:
							FlxG.sound.playMusic(Paths.music('freakyMenu'));
							MusicBeatState.switchState(new CreditsState());
					}
			}
			switch (zend_state)
			{
				case 1:
					zend_time ++;
					switch (zend_time)
					{
						case 1:
							camHUD.visible = false;
							camNotes.visible = false;
						case 200:
							camFollow.x = boyfriend.getMidpoint().x - 100;
							camFollow.y = boyfriend.getMidpoint().y - 300;
	
							var bDim = new FlxSprite(0, 0).makeGraphic(4000, 4000, FlxColor.BLACK);
							bDim.alpha = 0.5;
							bDim.scrollFactor.set(0);
							bDim.screenCenter();
							add(bDim);
	
							var cong = new Alphabet(0, 40, 'Congratulations!', true, false);
							cong.cameras = [camHUD];
							cong.screenCenter(X);
							add(cong);
							FlxG.sound.play(Paths.sound('victory'));
						
						case 400:
							var bef = new Alphabet(0, 200, 'You befriended a', true, false);
							bef.cameras = [camHUD];
							bef.screenCenter(X);
	
							var bef2 = new Alphabet(0, 260, 'universe conqueror!', true, false);
							bef2.cameras = [camHUD];
							bef2.screenCenter(X);
	
							add(bef);
							add(bef2);
						
						case 700:
							FlxG.sound.playMusic(Paths.music('MASK/phantomMenu'));
							Main.menuStringTrack = 'MASK/phantomMenu';
							FlxG.save.data.zephM = true;
	
							MASKstate.endingUnlock(2);
							var bef3 = new Alphabet(0, 600, 'secret ending', true, false);
							bef3.cameras = [camHUD];
							bef3.screenCenter(X);
	
							add(bef3);
						case 1000:
							var bef4 = new Alphabet(0, 400, 'Hold SHIFT while entering Freeplay', true, false);
							bef4.cameras = [camHUD];
							bef4.screenCenter(X);
	
							add(bef4);
						case 1200:
							MusicBeatState.switchState(new CreditsState());
					}
	
			}

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);

		var lengthInPx = scoreTxt.textField.length * scoreTxt.frameHeight; // bad way but does more or less a better job

		scoreTxt.x = (originalX - (lengthInPx / 2)) + 335;

		if (controls.PAUSE && startedCountdown && canPause && !cannotDie)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}


		if (FlxG.keys.justPressed.SEVEN && songStarted && !unowning)
		{
			if (useVideo)
				{
					GlobalVideo.get().stop();
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}
			cannotDie = true;
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			Main.editor = true;
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, releaseInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		if (!PlayStateChangeables.flip)
		{
			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
			iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);	
		}
		else
		{
			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 100, 0, 100, 0) * 0.01) - iconOffset);
			iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 100, 0, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		}

		if (health > 4)
			health = 4;

		if (!PlayStateChangeables.flip)
			{
				if (SONG.song != "Loca") {
				if (healthBar.percent < 20)
					iconP1.animation.curAnim.curFrame = 1;
				else
					iconP1.animation.curAnim.curFrame = 0;
		
				if (healthBar.percent > 80)
					iconP2.animation.curAnim.curFrame = 1;
				else
					iconP2.animation.curAnim.curFrame = 0;
				}
				else {
					if (healthBar.percent < 50)
						iconP1.animation.curAnim.curFrame = 1;
					else
						iconP1.animation.curAnim.curFrame = 0;
			
					if (healthBar.percent > 50)
						iconP2.animation.curAnim.curFrame = 1;
					else
						iconP2.animation.curAnim.curFrame = 0;
				}
			}
		else
		{
			if (SONG.song != "Loca") {
			if (healthBar.percent < 20)
				iconP2.animation.curAnim.curFrame = 1;
			else
				iconP2.animation.curAnim.curFrame = 0;
	
			if (healthBar.percent > 80)
				iconP1.animation.curAnim.curFrame = 1;
			else
				iconP1.animation.curAnim.curFrame = 0;
			}
			else {
				if (healthBar.percent < 50)
					iconP2.animation.curAnim.curFrame = 1;
				else
					iconP2.animation.curAnim.curFrame = 0;
		
				if (healthBar.percent > 50)
					iconP1.animation.curAnim.curFrame = 1;
				else
					iconP1.animation.curAnim.curFrame = 0;
			}
		}

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.SIX)
		{
			var curTime:Float = FlxG.sound.music.time;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLengthTime);

					var secondsTotal:Int = Math.floor((songLengthTime - curTime) / 1000);
					if(secondsTotal < 0) secondsTotal = 0;

					var minutesRemaining:Int = Math.floor(secondsTotal / 60);
					var secondsRemaining:String = '' + secondsTotal % 60;
					if(secondsRemaining.length < 2) secondsRemaining = '0' + secondsRemaining; //Dunno how to make it display a zero first in Haxe lol
					timeTxt = minutesRemaining + ':' + secondsRemaining;
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			var curTime:Float = FlxG.sound.music.time;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLengthTime);

					var secondsTotal:Int = Math.floor((songLengthTime - curTime) / 1000);
					if(secondsTotal < 0) secondsTotal = 0;

					var minutesRemaining:Int = Math.floor(secondsTotal / 60);
					var secondsRemaining:String = '' + secondsTotal % 60;
					if(secondsRemaining.length < 2) secondsRemaining = '0' + secondsRemaining; //Dunno how to make it display a zero first in Haxe lol
					timeTxt = minutesRemaining + ':' + secondsRemaining;
		}

		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			currentSection = SONG.notes[Std.int(curStep / 16)];

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				songTimer += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					songTimer = (songTimer + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				if(updateTime && SONG.song.toLowerCase() != 'live-on') {
					var curTime:Float = FlxG.sound.music.time;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLengthTime);

					var secondsTotal:Int = Math.floor((songLengthTime - curTime) / 1000);
					if(secondsTotal < 0) secondsTotal = 0;

					var minutesRemaining:Int = Math.floor(secondsTotal / 60);
					var secondsRemaining:String = '' + secondsTotal % 60;
					if(secondsRemaining.length < 2) secondsRemaining = '0' + secondsRemaining; //Dunno how to make it display a zero first in Haxe lol
					timeTxt = minutesRemaining + ':' + secondsRemaining;
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && currentSection != null)
		{
			closestNotes = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
					closestNotes.push(daNote);
			}); // Collect notes that can be hit

			closestNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

			if (closestNotes.length != 0)
				FlxG.watch.addQuick("Current Note",closestNotes[0].strumTime - Conductor.songPosition);
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly Nice':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",currentSection.mustHitSection);
			#end

		//	if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection &&s)
		//	{
		//		moveCameraSection(Std.int(curStep / 16));
		//	}

			if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null && !endingSong && !isCameraOnForcedPos)
			{
				moveCameraSection(Std.int(curStep / 16));
			}	

			if (PlayStateChangeables.flip)
			{
				/*race('attempting to change cameras: (flip)');
				if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != dad.getMidpoint().x - 100)
					{
						camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
				
							switch (curStage)
							{
								case 'limo':
									camFollow.x = boyfriend.getMidpoint().x - 300;
								case 'mall':
									camFollow.y = boyfriend.getMidpoint().y - 200;
								case 'school' | 'schoolEvil':
									camFollow.x = boyfriend.getMidpoint().x - 200;
									camFollow.y = boyfriend.getMidpoint().y - 200;
							}
						//	camFollow.x -= boyfriend.cameraPosition[0];
						//	camFollow.y += boyfriend.cameraPosition[1];
				
							if (SONG.song.toLowerCase() == 'tutorial')
							{
								FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
							}
					}
		
					if (camFollow.x != boyfriend.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
					{
						camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
					//	camFollow.x += dad.cameraPosition[0];
					//	camFollow.y += dad.cameraPosition[1];
						
						if (dad.curCharacter.startsWith('mom'))
							vocals.volume = 1;
		
						if (dad.curCharacter == 'mom')
							vocals.volume = 1;

					}*/
			}
			else
			{
				//trace('attempting to change cameras');
				/*if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
					{
					//	moveCamera(true);
					trace('attempting to change cameras: dad (no flip)');

						camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
					//	camFollow.x += dad.cameraPosition[0];
					//	camFollow.y += dad.cameraPosition[1];
						
						if (dad.curCharacter.startsWith('mom'))
							vocals.volume = 1;
		
						if (dad.curCharacter == 'mom')
							vocals.volume = 1;
					}
		
					if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
					{
							camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
							trace('attempting to change cameras: bf (no flip)');
				
							switch (curStage)
							{
								case 'limo':
									camFollow.x = boyfriend.getMidpoint().x - 300;
								case 'mall':
									camFollow.y = boyfriend.getMidpoint().y - 200;
								case 'school' | 'schoolEvil':
									camFollow.x = boyfriend.getMidpoint().x - 200;
									camFollow.y = boyfriend.getMidpoint().y - 200;
							}
						//	camFollow.x -= boyfriend.cameraPosition[0];
						//	camFollow.y += boyfriend.cameraPosition[1];
				
							if (SONG.song.toLowerCase() == 'tutorial')
							{
								FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
							}
					}*/
			}
		}

		if (camZooming)
		{
			if (FlxG.save.data.zoom < 0.8)
				FlxG.save.data.zoom = 0.8;
	
			if (FlxG.save.data.zoom > 1.2)
				FlxG.save.data.zoom = 1.2;
			if (!executeModchart)
				{
					FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
					camHUD.zoom = FlxMath.lerp(FlxG.save.data.zoom, camHUD.zoom, 0.95);
	
					camNotes.zoom = camHUD.zoom;
					camSustains.zoom = camHUD.zoom;
				}
				else
				{
					FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
					camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
	
					camNotes.zoom = camHUD.zoom;
					camSustains.zoom = camHUD.zoom;
				}
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (isMonoDead) {
			if (controls.ACCEPT)
				MusicBeatState.resetState();
			//trace(dad.animation.curAnim.curFrame);
		}

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0 && !cannotDie)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;
			deathCounter++;

			vocals.stop();
			FlxG.sound.music.stop();

			if (SONG.song.toLowerCase() == 'live-on') {
				boyfriend.stunned = true;
				deathCounter++;
				paused = true;
	
				vocals.stop();
				FlxG.sound.music.stop();
	
				isMonoDead = true;
				dad.debugMode = true;
			//	dad.playAnim('fadeOut', true);
				dad.animation.finishCallback = function (name:String) {
					remove(dad);
				}
	
				FlxTween.tween(healthBar, {alpha: 0}, 1, {ease: FlxEase.linear, onComplete: function (twn:FlxTween) {
					healthBar.visible = false;
					healthBarBG.visible = false;
					scoreTxt.visible = false;
					iconP1.visible = false;
					iconP2.visible = false;
				}});
				FlxTween.tween(healthBarBG, {alpha: 0}, 1, {ease: FlxEase.linear});
				FlxTween.tween(scoreTxt, {alpha: 0}, 1, {ease: FlxEase.linear});
				FlxTween.tween(iconP1, {alpha: 0}, 1, {ease: FlxEase.linear});
				FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.linear});
				for (i in playerStrums) {
					FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
				}
				
			} else {
			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			}

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
 		if (!inCutscene && FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R && !unowning)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
					#end
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		switch(mania)
		{
			case 0: 
				sDir = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
				bfsDir = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
			case 1: 
				sDir = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
				bfsDir = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
			case 2: 
				sDir = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'UP', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
				bfsDir = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'Hey', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
			case 3: 
				sDir = ['LEFT', 'DOWN', 'UP', 'UP', 'RIGHT'];
				bfsDir = ['LEFT', 'DOWN', 'Hey', 'UP', 'RIGHT'];
			case 4: 
				sDir = ['LEFT', 'UP', 'RIGHT', 'UP', 'LEFT', 'DOWN', 'RIGHT'];
				bfsDir = ['LEFT', 'UP', 'RIGHT', 'Hey', 'LEFT', 'DOWN', 'RIGHT'];
			case 5: 
				sDir = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
				bfsDir = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
			case 6: 
				sDir = ['UP'];
				bfsDir = ['Hey'];
			case 7: 
				sDir = ['LEFT', 'RIGHT'];
				bfsDir = ['LEFT', 'RIGHT'];
			case 8:
				sDir = ['LEFT', 'UP', 'RIGHT'];
				bfsDir = ['LEFT', 'Hey', 'RIGHT'];
		}

		if (generatedMusic)
			{
				switch(maniaToChange)
				{
					case 0: 
						hold = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
					case 1: 
						hold = [controls.L1, controls.U1, controls.R1, controls.L2, controls.D1, controls.R2];
					case 2: 
						hold = [controls.N0, controls.N1, controls.N2, controls.N3, controls.N4, controls.N5, controls.N6, controls.N7, controls.N8];
					case 3: 
						hold = [controls.LEFT, controls.DOWN, controls.N4, controls.UP, controls.RIGHT];
					case 4: 
						hold = [controls.L1, controls.U1, controls.R1, controls.N4, controls.L2, controls.D1, controls.R2];
					case 5: 
						hold = [controls.N0, controls.N1, controls.N2, controls.N3, controls.N5, controls.N6, controls.N7, controls.N8];
					case 6: 
						hold = [controls.N4];
					case 7: 
						hold = [controls.LEFT, controls.RIGHT];
					case 8: 
						hold = [controls.LEFT, controls.N4, controls.RIGHT];

					case 10: //changing mid song (mania + 10, seemed like the best way to make it change without creating more switch statements)
						hold = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT,false,false,false,false,false];
					case 11: 
						hold = [controls.L1, controls.D1, controls.U1, controls.R1, false, controls.L2, false, false, controls.R2];
					case 12: 
						hold = [controls.N0, controls.N1, controls.N2, controls.N3, controls.N4, controls.N5, controls.N6, controls.N7, controls.N8];
					case 13: 
						hold = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT, controls.N4,false,false,false,false];
					case 14: 
						hold = [controls.L1, controls.D1, controls.U1, controls.R1, controls.N4, controls.L2, false, false, controls.R2];
					case 15:
						hold = [controls.N0, controls.N1, controls.N2, controls.N3, false, controls.N5, controls.N6, controls.N7, controls.N8];
					case 16: 
						hold = [false, false, false, false, controls.N4, false, false, false, false];
					case 17: 
						hold = [controls.LEFT, false, false, controls.RIGHT, false, false, false, false, false];
					case 18: 
						hold = [controls.LEFT, false, false, controls.RIGHT, controls.N4, false, false, false, false];
				}
				var holdArray:Array<Bool> = hold;

				
				notes.forEachAlive(function(daNote:Note)
				{	

					if (!daNote.mustPress && SONG.song.toLowerCase() == 'live-on') {daNote.visible = false; daNote.active = false;}

					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
					if (!daNote.modifiedByLua)
						{
							if (PlayStateChangeables.useDownscroll)
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
										+ 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) - daNote.noteYOff;
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
										+ 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) - daNote.noteYOff;
								if (daNote.isSustainNote)
								{
									// Remember = minus makes notes go up, plus makes them go down
									if (daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
										daNote.y += daNote.prevNote.height;
									else
										daNote.y += daNote.height / 2;
		
									// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
									if (!PlayStateChangeables.botPlay)
									{
										if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit || holdArray[Math.floor(Math.abs(daNote.noteData))] && !daNote.tooLate)
											&& daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
												+ Note.swagWidth / 2
												- daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
		
											daNote.clipRect = swagRect;
										}
									}
									else
									{
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
											+ Note.swagWidth / 2
											- daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
		
										daNote.clipRect = swagRect;
									}
								}
							}
							else
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
										- 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) + daNote.noteYOff;
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
										- 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) + daNote.noteYOff;
								if (daNote.isSustainNote)
								{
									daNote.y -= daNote.height / 2;
		
									if (!PlayStateChangeables.botPlay)
									{
										if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit || holdArray[Math.floor(Math.abs(daNote.noteData))] && !daNote.tooLate)
											&& daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
												+ Note.swagWidth / 2
												- daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
		
											daNote.clipRect = swagRect;
										}
									}
									else
									{
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
											+ Note.swagWidth / 2
											- daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
		
										daNote.clipRect = swagRect;
									}
								}
							}
						}
		
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (currentSection != null)
						{
							if (currentSection.altAnim)
								altAnim = '-alt';
						}	
						if (daNote.alt)
							altAnim = '-alt';

						if (!exDad){
							dad.playAnim('sing' + sDir[daNote.noteData] + altAnim, true);

							if (SONG.song.toLowerCase() == 'loca')
								switch (PlayStateChangeables.flip) 
								{
									case false:
										health -= 0.023;
									case true:
										health -= 0.092;
								}
						}
						else {
								var targ:Character = dad;
								var both:Bool = false;
							//	if (daNote.dType == 0) targ = dad2; 
							//	else if (daNote.dType == 2)
							//	{
						//			if (daNote.noteData <= 3) targ = dad;
					//				if (daNote.noteData == 4) both = true;
						//		} //this code is old and broken so imma need to fix it

								if (currentSection.dType == 0) targ = dad2;
								if (currentSection.dType == 1) targ = dad;
								if (currentSection.dType == 2) both = true;

								if (currentSection.dType != 2)
									both = false;

								/*switch (Math.abs(daNote.noteData))
								{
									case 0:
										targ.playAnim('singLEFT' + altAnim, true);
									case 1:
										targ.playAnim('singDOWN' + altAnim, true);
									case 2:
										targ.playAnim('singUP' + altAnim, true);
									case 3:
										targ.playAnim('singRIGHT' + altAnim, true);
									case 4:
										targ.playAnim('singUP' + altAnim, true);

										if (both) dad2.playAnim('singUP' + altAnim, true);
									case 5:
										targ.playAnim('singLEFT' + altAnim, true);
									case 6:
										targ.playAnim('singDOWN' + altAnim, true);
									case 7:
										targ.playAnim('singUP' + altAnim, true);
									case 8:
										targ.playAnim('singRIGHT' + altAnim, true);
								}*/ //switch this out with this:
								if (!both)
									targ.playAnim('sing' + sDir[daNote.noteData] + altAnim, true);
								else{
					
									var p1Dir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'UP', null, null, null, null];
									var p2Dir:Array<String> = [null, null, null, null, 'UP', 'LEFT', 'DOWN', 'UP', 'RIGHT'];

									targ = dad2;
									targ.playAnim('sing' + p1Dir[daNote.noteData] + altAnim, true);
									dad.playAnim('sing' + p2Dir[daNote.noteData] + altAnim, true);
									if (targ.animation.curAnim.name == "singUp" && both)
										dad2.playAnim('singUP' + altAnim, true);
								}
						}


						/*if (daNote.isSustainNote)
						{
							health -= SONG.noteValues[0] / 3;
						}
						else
							health -= SONG.noteValues[0];
						*/
						
						if (FlxG.save.data.cpuStrums)
						{
							cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);
								}
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									spr.centerOffsets();
									switch(maniaToChange)
									{
										case 0: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 1: 
											spr.offset.x -= 16;
											spr.offset.y -= 16;
										case 2: 
											spr.offset.x -= 22;
											spr.offset.y -= 22;
										case 3: 
											spr.offset.x -= 15;
											spr.offset.y -= 15;
										case 4: 
											spr.offset.x -= 18;
											spr.offset.y -= 18;
										case 5: 
											spr.offset.x -= 20;
											spr.offset.y -= 20;
										case 6: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 7: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 8:
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 10: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 11: 
											spr.offset.x -= 16;
											spr.offset.y -= 16;
										case 12: 
											spr.offset.x -= 22;
											spr.offset.y -= 22;
										case 13: 
											spr.offset.x -= 15;
											spr.offset.y -= 15;
										case 14: 
											spr.offset.x -= 18;
											spr.offset.y -= 18;
										case 15: 
											spr.offset.x -= 20;
											spr.offset.y -= 20;
										case 16: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 17: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 18:
											spr.offset.x -= 13;
											spr.offset.y -= 13;
									}
								}
								else
									spr.centerOffsets();
							});
						}
	
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
						#end

						dad.holdTimer = 0;
						if (exDad) dad2.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}

					if (daNote.mustPress && !daNote.modifiedByLua)
						{
							daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
							daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
							if (!daNote.isSustainNote)
								daNote.modAngle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
							if (daNote.sustainActive)
							{
								if (executeModchart)
									daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
							}
							daNote.modAngle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						}
						else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
						{
							daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
							daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
							if (!daNote.isSustainNote)
								daNote.modAngle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
							if (daNote.sustainActive)
							{
								if (executeModchart)
									daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
							}
							daNote.modAngle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						}
		
						if (daNote.isSustainNote)
						{
							daNote.x += daNote.width / 2 + 20;
							if (SONG.noteStyle == 'pixel')
								daNote.x -= 11;
						}
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if (daNote.isSustainNote && daNote.wasGoodHit && Conductor.songPosition >= daNote.strumTime)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
					else if ((daNote.mustPress && daNote.tooLate && !PlayStateChangeables.useDownscroll || daNote.mustPress && daNote.tooLate
						&& PlayStateChangeables.useDownscroll)
						&& daNote.mustPress)
					{

							switch (daNote.noteType)
							{
						
								case 0: //normal
								{
									if (daNote.isSustainNote && daNote.wasGoodHit)
										{
											daNote.kill();
											notes.remove(daNote, true);
										}
										else
										{
											if (loadRep && daNote.isSustainNote)
											{
												// im tired and lazy this sucks I know i'm dumb
												if (findByTime(daNote.strumTime) != null)
													totalNotesHit += 1;
												else
												{
													vocals.volume = 0;
													if (theFunne && !daNote.isSustainNote)
													{
														noteMiss(daNote.noteData, daNote);
													}
													if (daNote.isParent)
													{
														health -= 0.15; // give a health punishment for failing a LN
														trace("hold fell over at the start");
														for (i in daNote.children)
														{
															i.alpha = 0.3;
															i.sustainActive = false;
														}
													}
													else
													{
														if (!daNote.wasGoodHit
															&& daNote.isSustainNote
															&& daNote.sustainActive
															&& daNote.spotInLine != daNote.parent.children.length)
														{
															health -= 0.2; // give a health punishment for failing a LN
															trace("hold fell over at " + daNote.spotInLine);
															for (i in daNote.parent.children)
															{
																i.alpha = 0.3;
																i.sustainActive = false;
															}
															if (daNote.parent.wasGoodHit)
																misses++;
																songMisses++;
															updateAccuracy();
														}
														else if (!daNote.wasGoodHit
															&& !daNote.isSustainNote)
														{
															health -= 0.15;
														}
													}
												}
											}
											else
											{
												vocals.volume = 0;
												if (theFunne && !daNote.isSustainNote)
												{
													if (PlayStateChangeables.botPlay)
													{
														daNote.rating = "bad";
														goodNoteHit(daNote);
													}
													else
														noteMiss(daNote.noteData, daNote);
												}
				
												if (daNote.isParent)
												{
													health -= 0.15; // give a health punishment for failing a LN
													trace("hold fell over at the start");
													for (i in daNote.children)
													{
														i.alpha = 0.3;
														i.sustainActive = false;
														trace(i.alpha);
													}
												}
												else
												{
													if (!daNote.wasGoodHit
														&& daNote.isSustainNote
														&& daNote.sustainActive
														&& daNote.spotInLine != daNote.parent.children.length)
													{
														health -= 0.25; // give a health punishment for failing a LN
														trace("hold fell over at " + daNote.spotInLine);
														for (i in daNote.parent.children)
														{
															i.alpha = 0.3;
															i.sustainActive = false;
															trace(i.alpha);
														}
														if (daNote.parent.wasGoodHit)
															misses++;
														songMisses++;
														updateAccuracy();
													}
													else if (!daNote.wasGoodHit
														&& !daNote.isSustainNote)
													{
														health -= 0.15;
													}
												}
											}
										}
				
										daNote.visible = false;
										daNote.kill();
										notes.remove(daNote, true);
								}
								case 1: //fire notes - makes missing them not count as one
								{
									daNote.kill();
									notes.remove(daNote, true);
									daNote.destroy();
								}
								case 2: //halo notes, same as fire
								{
									daNote.kill();
									notes.remove(daNote, true);
									daNote.destroy();
								}
								case 3:  //warning notes, removes half health and then removed so it doesn't repeatedly deal damage
								{
									health -= 1;
									vocals.volume = 0;
									badNoteHit();
									daNote.kill();
									notes.remove(daNote, true);
									daNote.destroy();
								}
								case 4: //angel notes
								{
									daNote.kill();
									notes.remove(daNote, true);
									daNote.destroy();
								}
								case 6:  //bob notes
								{
									daNote.kill();
									notes.remove(daNote, true);
									daNote.destroy();
								}
								case 7: //gltich notes
								{
									HealthDrain();
									daNote.kill();
									notes.remove(daNote, true);
									daNote.destroy();
								}



							}
						}
						if(PlayStateChangeables.useDownscroll && daNote.y > strumLine.y ||
							!PlayStateChangeables.useDownscroll && daNote.y < strumLine.y)
							{
									// Force good note hit regardless if it's too late to hit it or not as a fail safe
									if(PlayStateChangeables.botPlay && daNote.canBeHit && daNote.mustPress ||
									PlayStateChangeables.botPlay && daNote.tooLate && daNote.mustPress)
									{
										if(loadRep)
										{
											//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
											var n = findByTime(daNote.strumTime);
											trace(n);
											if(n != null)
											{
												goodNoteHit(daNote);
												boyfriend.holdTimer = daNote.sustainLength;
											}
										}else {
											if (!daNote.burning && !daNote.death && !daNote.bob)
												{
													goodNoteHit(daNote);
													boyfriend.holdTimer = daNote.sustainLength;
													playerStrums.forEach(function(spr:FlxSprite)
													{
														if (Math.abs(daNote.noteData) == spr.ID)
														{
															spr.animation.play('confirm', true);
														}
														if (spr.animation.curAnim.name == 'confirm' && SONG.noteStyle != 'pixel')
														{
															spr.centerOffsets();
															switch(maniaToChange)
															{
																case 0: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 1: 
																	spr.offset.x -= 16;
																	spr.offset.y -= 16;
																case 2: 
																	spr.offset.x -= 22;
																	spr.offset.y -= 22;
																case 3: 
																	spr.offset.x -= 15;
																	spr.offset.y -= 15;
																case 4: 
																	spr.offset.x -= 18;
																	spr.offset.y -= 18;
																case 5: 
																	spr.offset.x -= 20;
																	spr.offset.y -= 20;
																case 6: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 7: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 8:
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 10: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 11: 
																	spr.offset.x -= 16;
																	spr.offset.y -= 16;
																case 12: 
																	spr.offset.x -= 22;
																	spr.offset.y -= 22;
																case 13: 
																	spr.offset.x -= 15;
																	spr.offset.y -= 15;
																case 14: 
																	spr.offset.x -= 18;
																	spr.offset.y -= 18;
																case 15: 
																	spr.offset.x -= 20;
																	spr.offset.y -= 20;
																case 16: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 17: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 18:
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
															}
														}
														else
															spr.centerOffsets();
													});
												}
											}
											
									}
							}
								
					
				});
				
			}

		if (FlxG.save.data.cpuStrums)
		{
			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
			if (PlayStateChangeables.botPlay)
				{
					playerStrums.forEach(function(spr:FlxSprite)
						{
							if (spr.animation.finished)
							{
								spr.animation.play('static');
								spr.centerOffsets();
							}
						});
				}
		}

		while(eventNotes.length > 0) {
			var early:Float = eventNoteEarlyTrigger(eventNotes[0]);
			var leStrumTime:Float = eventNotes[0][0];
			if(Conductor.songPosition < leStrumTime - early) {
				break;
			}

			var value1:String = '';
			if(eventNotes[0][3] != null)
				value1 = eventNotes[0][3];

			var value2:String = '';
			if(eventNotes[0][4] != null)
				value2 = eventNotes[0][4];

			triggerEventNote(eventNotes[0][2], value1, value2);
			eventNotes.shift();
		}

		if (!inCutscene && songStarted)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE && !unowning)
			endSong();
		#end

		#if debug
		if(!endingSong && !startingSong) {
			if (FlxG.keys.justPressed.ONE)
				FlxG.sound.music.onComplete();
			if(FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future :O
				FlxG.sound.music.pause();
				vocals.pause();
				Conductor.songPosition += 10000;
				notes.forEachAlive(function(daNote:Note)
				{
					if(daNote.strumTime + 800 < Conductor.songPosition) {
						daNote.active = false;
						daNote.visible = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
				for (i in 0...unspawnNotes.length) {
					var daNote:Note = unspawnNotes[0];
					if(daNote.strumTime + 800 >= Conductor.songPosition) {
						break;
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					unspawnNotes.splice(unspawnNotes.indexOf(daNote), 1);
					daNote.destroy();
				}

				FlxG.sound.music.time = Conductor.songPosition;
				FlxG.sound.music.play();

				vocals.time = Conductor.songPosition;
				vocals.play();
			}
		}

		//setOnLuas('cameraX', camFollowPos.x);
		//setOnLuas('cameraY', camFollowPos.y);
		//setOnLuas('botPlay', PlayState.cpuControlled);
		//callOnLuas('onUpdatePost', [elapsed]);
		#end
	}

	function eventNoteEarlyTrigger(event:Array<Dynamic>):Float {
	//	var returnedValue:Float = callOnLuas('eventEarlyTrigger', [event[2]]);
	//	if(returnedValue != 0) {
	//		return returnedValue;
	//	}

		switch(event[2]) {
			case 'Kill Henchmen': //Better timing so that the kill sound matches the beat intended
				return 280; //Plays 280ms before the actual position
		}
		return 0;
	}

	function endSong():Void
		{
			canPause = false;
			endingSong = true;
			if (SONG.song.toLowerCase() == 'talladega') {FlxG.save.data.unlockedExtra = true; FlxG.save.flush();} //didn't know you could do this.
			camZooming = false;
			inCutscene = false;
			deathCounter = 0;
			updateTime = false;
			KillNotes();

			#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, releaseInput);
			if (useVideo)
			{
				GlobalVideo.get().stop();
				FlxG.stage.window.onFocusOut.remove(focusOut);
				FlxG.stage.window.onFocusIn.remove(focusIn);
				PlayState.instance.remove(PlayState.instance.videoSprite);
			}

		if (isStoryMode)
			campaignMisses = misses;

		if (!loadRep)
			rep.SaveReplay(saveNotes, saveJudge, replayAna);
		else
		{
			PlayStateChangeables.botPlay = false;
			PlayStateChangeables.scrollSpeed = 1;
			PlayStateChangeables.useDownscroll = false;
		}

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		FlxG.sound.music.pause();
		vocals.pause();
		if (SONG.validScore)
		{
			// adjusting the highscore song name to be compatible
			// would read original scores if we didn't change packages
			var songHighscore = StringTools.replace(PlayState.SONG.song, " ", "-");
			switch (songHighscore) {
				case 'Dad-Battle': songHighscore = 'Dadbattle';
				case 'Philly-Nice': songHighscore = 'Philly';
			}

			#if !switch
			Highscore.saveScore(songHighscore, Math.round(songScore), storyDifficulty);
			Highscore.saveCombo(songHighscore, Ratings.GenerateLetterRank(accuracy), storyDifficulty);
			#end
		}
	
			songEnded = true;
 
			/*
			if(PauseSubState.avoid) { //more hex v.s. whitty leaks
				if(SONG.song.toLowerCase() == "termination" && storyDifficulty == 2 && !FlxG.save.data.botplay){
					FlxG.save.data.terminationBeaten = true; //Congratulations, you won!
					FlxG.save.flush();
				}

				if(SONG.song.toLowerCase() == "expurgation" && storyDifficulty == 2 && !FlxG.save.data.botplay){
					FlxG.save.data.terminateWon = true;
					FlxG.save.data.isEligible = true;
					FlxG.save.data.didError == true;
					FlxG.save.data.diffStory = true;
					FlxG.save.flush();
				}

				if(SONG.song.toLowerCase() == "power-link" && storyDifficulty == 2 && !FlxG.save.data.botplay) {
					FlxG.save.data.powerWon = true;
					FlxG.save.flush();
				}

				if(SONG.song.toLowerCase() == "censory-overload" && storyDifficulty == 2 && !FlxG.save.data.botplay) {
					FlxG.save.data.didCensory = true;
					FlxG.save.flush();
				}
			}*/
	
			if (isStoryMode)
			{
				if (hudArrows != null)
				{
					new FlxTimer().start(0.003, function(fadear:FlxTimer)
					{
						var decAl:Float = 0.01;
						for (i in 0...hudArrows.length)
						{
							hudArrows[i].alpha -= decAl;
						}
						healthBarBG.alpha -= decAl;
						healthBar.alpha -= decAl;
						iconP1.alpha -= decAl;
						iconP2.alpha -= decAl;
						scoreTxt.alpha -= decAl;
						fadear.reset(0.003);
					});
				}
	
				if (sEnding == 'none')
				{
					Main.skipDes = false;
					campaignScore += songScore;
					campaignMisses += songMisses;
	
					storyPlaylist.remove(storyPlaylist[0]);
	
					if (storyPlaylist.length <= 0)
					{
						if (Main.menuBad)
						{
							FlxG.sound.playMusic(Paths.music('menuBad'));
						}
						else
						{
							FlxG.sound.playMusic(Paths.music('freakyMenu'));
						}
	
						transIn = FlxTransitionableState.defaultTransIn;
						transOut = FlxTransitionableState.defaultTransOut;
	
						MusicBeatState.switchState(new StoryMenuState());
	
						// if ()
						StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;
	
						if (SONG.validScore)
						{
							Highscore.saveWeekScore(WeekData.getCurrentWeekNumber(), campaignScore, storyDifficulty);
						}
	
						FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
						FlxG.save.flush();
						usedPractice = false;
						changedDifficulty = false;
						cpuControlled = false;
					}
					else
					{
						var difficulty:String = '' + CoolUtil.difficultyStuff[storyDifficulty][1];
	
						trace('LOADING NEXT SONG');
						trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);
	
						var winterHorrorlandNext = (SONG.song.toLowerCase() == "eggnog");
						if (winterHorrorlandNext)
						{
							var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
								-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
							blackShit.scrollFactor.set();
							add(blackShit);
							camHUD.visible = false;
	
							FlxG.sound.play(Paths.sound('Lights_Shut_off'));
						}
	
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
	
						prevCamFollow = camFollow;
						prevCamFollowPos = camFollowPos;
	
						PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
						FlxG.sound.music.stop();
	
						if(winterHorrorlandNext) {
							new FlxTimer().start(1.5, function(tmr:FlxTimer) {
								LoadingState.loadAndSwitchState(new PlayState());
							});
						} else {
							LoadingState.loadAndSwitchState(new PlayState());
						}
					}
				}
				else
				{
					switch (sEnding)
					{
						case 'here we go':
							textIndex = '3-post-eruption';
							afterAction = 'transform';
							schoolIntro(0);
						case 'week1 end':
							textIndex = '4-post-kaioken';
							afterAction = 'end song';
							schoolIntro(0);
						case 'post whats new':
							textIndex = '6-post-whatsnew';
							afterAction = 'transform';
							schoolIntro(0);
						case 'post blast':
							textIndex = '7-post-blast';
							afterAction = 'end song';
							schoolIntro(0);
						case 'week2 end':
							ssCutscene();
						case 'finale end':
							Main.menuBad = false;
							finalCutscene();
						case 'last goodbye': // not actually this is just a name
							lgCutscene();
						case 'wb ending':
							camFollow.x = gf.getMidpoint().x - 100;
							camFollow.y = gf.getMidpoint().y - 100;
	
							textIndex = 'upd/wb2';
							afterAction = 'wb bye';
							schoolIntro(0);
						case 'zeph ending':
							camFollow.x = dad.getMidpoint().x;
							camFollow.y = dad.getMidpoint().y;
							textIndex = 'upd/zeph3';
							afterAction = 'zeph bye';
							schoolIntro(0);
					}
					sEnding = 'none';
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				if (!Main.onlyExtra)
			 		MusicBeatState.switchState(new FreeplayState());
				else 
					MusicBeatState.switchState(new ExtraFreeplayState());
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				usedPractice = false;
				changedDifficulty = false;
				cpuControlled = false;
			}
		}

	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	public function reloadHealthBarColors() {
		healthBar.createFilledBar(FlxColor.fromRGB(dad.healthbar_colors[0], dad.healthbar_colors[1], dad.healthbar_colors[2]), 0xFF66FF33);
		healthBar.updateBar();
	}

	private function popUpScore(daNote:Note = null):Void
		{
			var noteDiff:Float = -(daNote.strumTime - Conductor.songPosition);
			var wife:Float = EtternaFunctions.wife3(-noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				case 'shit':
					score = -300;
					combo = 0;
					misses++;
					songMisses++;
					if (!FlxG.save.data.gthm)
						health -= 0.2;
					ss = false;
					shits++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit -= 1;
				case 'bad':
					daRating = 'bad';
					score = 0;
					if (!FlxG.save.data.gthm)
						health -= 0.06;
					ss = false;
					bads++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.50;
				case 'good':
					daRating = 'good';
					score = 200;
					ss = false;
					goods++;
					if (health < 2)
						health += 0.04;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.75;
				case 'sick':
					if (health < 2)
						health += 0.1;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 1;
					sicks++;
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			if (PlayStateChangeables.bothSide)
			{
				rating.x -= 350;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(PlayStateChangeables.botPlay && !loadRep) msTiming = 0;		
			
			if (loadRep)
				msTiming = HelperFunctions.truncateFloat(findByTime(daNote.strumTime)[3], 3);

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if(!PlayStateChangeables.botPlay || loadRep) add(currentTimingShown);
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if(!PlayStateChangeables.botPlay || loadRep) add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = FlxG.save.data.antialiasing;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = FlxG.save.data.antialiasing;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (combo > highestCombo)
				highestCombo = combo;

			// make sure we have 3 digits to display (looks weird otherwise lol)
			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = FlxG.save.data.antialiasing;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				add(numScore);

				visibleCombos.push(numScore);

				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						visibleCombos.remove(numScore);
						numScore.destroy();
					},
					onUpdate: function (tween:FlxTween)
					{
						if (!visibleCombos.contains(numScore))
						{
							tween.cancel();
							numScore.destroy();
						}
					},
					startDelay: Conductor.crochet * 0.002
				});

				if (visibleCombos.length > seperatedScore.length + 20)
				{
					for(i in 0...seperatedScore.length - 1)
					{
						visibleCombos.remove(visibleCombos[visibleCombos.length - 1]);
					}
				}
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

		function startUnown(timer:Int = 15, word:String = ''):Void {
				canPause = false;
				unowning = true;
				persistentUpdate = true;
				persistentDraw = true;
				var realTimer = timer;
				var unownState = new UnownSubState(realTimer, word);
				unownState.win = wonUnown;
				unownState.lose = die;
				unownState.cameras = [camHUD];
				FlxG.autoPause = false;
				openSubState(unownState);
		}

		public function die():Void{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;
			deathCounter++;

			vocals.stop();
			FlxG.sound.music.stop();

			if (SONG.song.toLowerCase() == 'live-on') {
				boyfriend.stunned = true;
				deathCounter++;
				paused = true;
	
				vocals.stop();
				FlxG.sound.music.stop();
	
				isMonoDead = true;
				dad.debugMode = true;
			//	dad.playAnim('fadeOut', true);
				dad.animation.finishCallback = function (name:String) {
					remove(dad);
				}
	
				FlxTween.tween(healthBar, {alpha: 0}, 1, {ease: FlxEase.linear, onComplete: function (twn:FlxTween) {
					healthBar.visible = false;
					healthBarBG.visible = false;
					scoreTxt.visible = false;
					iconP1.visible = false;
					iconP2.visible = false;
				}});
				FlxTween.tween(healthBarBG, {alpha: 0}, 1, {ease: FlxEase.linear});
				FlxTween.tween(scoreTxt, {alpha: 0}, 1, {ease: FlxEase.linear});
				FlxTween.tween(iconP1, {alpha: 0}, 1, {ease: FlxEase.linear});
				FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.linear});
				for (i in playerStrums) {
					FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
				}
				
			} else {
			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			}
		}
		
		public function wonUnown():Void {
			canPause = true;
			unowning = false;
		}

		public function triggerEventNote(eventName:String, value1:String, value2:String, ?onLua:Bool = false) {
			switch(eventName) {
				case 'Hey!':
					var value:Int = Std.parseInt(value1);
					var time:Float = Std.parseFloat(value2);
					if(Math.isNaN(time) || time <= 0) time = 0.6;
	
					if(value != 0) {
						if(dad.curCharacter == 'gf') { //Tutorial GF is actually Dad! The GF is an imposter!! ding ding ding ding ding ding ding, dindinding, end my suffering
							dad.playAnim('cheer', true);
							dad.specialAnim = true;
							dad.heyTimer = time;
						} else {
							gf.playAnim('cheer', true);
							gf.specialAnim = true;
							gf.heyTimer = time;
						}
	
						if(curStage == 'mall') {
							bottomBoppers.animation.play('hey', true);
							heyTimer = time;
						}
					}
					if(value != 1) {
						boyfriend.playAnim('hey', true);
						boyfriend.specialAnim = true;
						boyfriend.heyTimer = time;
					}
	
				case 'Set GF Speed':
					var value:Int = Std.parseInt(value1);
					if(Math.isNaN(value)) value = 1;
					gfSpeed = value;
	
				case 'Blammed Lights':
					//not used
	
				case 'Kill Henchmen':
					//killHenchmen();
	
				case 'Add Camera Zoom':
					if(ClientPrefs.camZooms && FlxG.camera.zoom < 1.35) {
						var camZoom:Float = Std.parseFloat(value1);
						var hudZoom:Float = Std.parseFloat(value2);
						if(Math.isNaN(camZoom)) camZoom = 0.015;
						if(Math.isNaN(hudZoom)) hudZoom = 0.03;
	
						FlxG.camera.zoom += camZoom;
						camHUD.zoom += hudZoom;
					}
	
				case 'Trigger BG Ghouls':
				//	if(curStage == 'schoolEvil' && !ClientPrefs.lowQuality) {
					//	bgGhouls.dance(true);
				//		bgGhouls.visible = true;
				//	}
	
				case 'Play Animation':
					trace('Anim to play: ' + value1);
					var val2:Int = Std.parseInt(value2);
					if(Math.isNaN(val2)) val2 = 0;
	
					var char:Character = dad;
					switch(val2) {
						case 1: char = boyfriend;
						case 2: char = gf;
					}
					char.playAnim(value1, true);
					char.specialAnim = true;
	
				case 'Camera Follow Pos':
					var val1:Float = Std.parseFloat(value1);
					var val2:Float = Std.parseFloat(value2);
					if(Math.isNaN(val1)) val1 = 0;
					if(Math.isNaN(val2)) val2 = 0;
	
					isCameraOnForcedPos = false;
					if(!Math.isNaN(Std.parseFloat(value1)) || !Math.isNaN(Std.parseFloat(value2))) {
						camFollow.x = val1;
						camFollow.y = val2;
						isCameraOnForcedPos = true;
					}
	
				case 'Alt Idle Animation':
					var val:Int = Std.parseInt(value1);
					if(Math.isNaN(val)) val = 0;
	
					var char:Character = dad;
					switch(val) {
						case 1: char = boyfriend;
						case 2: char = gf;
					}
					char.idleSuffix = value2;
					char.recalculateDanceIdle();
	
				case 'Screen Shake':
					var valuesArray:Array<String> = [value1, value2];
					var targetsArray:Array<FlxCamera> = [camGame, camHUD];
					for (i in 0...targetsArray.length) {
						var split:Array<String> = valuesArray[i].split(',');
						var duration:Float = Std.parseFloat(split[0].trim());
						var intensity:Float = Std.parseFloat(split[1].trim());
						if(Math.isNaN(duration)) duration = 0;
						if(Math.isNaN(intensity)) intensity = 0;
	
						if(duration > 0 && intensity != 0) {
							targetsArray[i].shake(intensity, duration);
						}
					}
	
				case 'Change Character':
					var charType:Int = Std.parseInt(value1);
					//var change:ModchartState = null;
					if(Math.isNaN(charType)) charType = 0;
	
					switch(charType) { //what?? I'm too lazy to add Psych's change char thing.
						case 0:
							switch (PlayStateChangeables.flip)
							{
								case false: 
									ChangeChar.changeBoyfriendCharacterBetter(boyfriend.x, boyfriend.y, value2);
								case true:
									ChangeChar.changeDadCharacterBetter(dad.x, dad.y, value2);
							}
	
						case 1:
							switch (PlayStateChangeables.flip)
							{
								case false:
									ChangeChar.changeDadCharacterBetter(dad.x, dad.y, value2);
								case true:
									ChangeChar.changeBoyfriendCharacterBetter(boyfriend.x, boyfriend.y, value2);
							}
	
						case 2:
							ChangeChar.changeGFCharacterBetter(gf.x, gf.y, value2);
	
					}
				case 'Shaggy trail alpha':
					if (dad.curCharacter == 'rshaggy')
					{
						camLerp = 2.5;
					}
					else
					{
						var a = value1;
						if (a == '1' || a == 'true')
							shaggyT.visible = false;
						else
							shaggyT.visible = true;
					}
				case 'Shaggy burst':
					burstRelease(dad.getMidpoint().x, dad.getMidpoint().y);
				case 'Camera rotate on':
					rotCam = true;
					rotCamSpd = Std.parseFloat(value1);
					rotCamRange = Std.parseFloat(value2);
				case 'Camera rotate off':
					rotCam = false;
					camera.angle = 0;
				case 'Toggle bg dim':
					dimGo = !dimGo;
				case 'Psyshock':
				//	psyshock();
				trace('nice try');
				case 'Fakeshock':
				//	fakeshock();
				trace('nice try');
				case 'Drop eye':
					if (!FlxG.save.data.p_maskGot[3])
					{
						maskObj = new MASKcoll(4, dad.getMidpoint().x, dad.getMidpoint().y - 300, 0);
						maskCollGroup.add(maskObj);
					}
				case 'Unown':
					startUnown(Std.parseInt(value1), value2);
				case 'Celebi':
					doCelebi(Std.parseFloat(value1));
			}
			if(!onLua) {
				//callOnLuas('onEvent', [eventName, value1, value2]);
			}
		}

		var dialogueCount:Int = 0;

		//You don't have to add a song, just saying. You can just do "dialogueIntro(dialogue);" and it should work
	public function dialogueIntro(dialogue:Array<String>, ?song:String = null):Void
		{
			// TO DO: Make this more flexible, maybe?
			inCutscene = true;
			CoolUtil.precacheSound('dialogue');
			CoolUtil.precacheSound('dialogueClose');
			var doof:DialogueBoxPsych = new DialogueBoxPsych(dialogue, song);
			doof.scrollFactor.set();
			doof.finishThing = startCountdown;
			doof.nextDialogueThing = startNextDialogue;
			doof.cameras = [camHUD];
			add(doof);
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;
		var l1Hold:Bool = false;
		var uHold:Bool = false;
		var r1Hold:Bool = false;
		var l2Hold:Bool = false;
		var dHold:Bool = false;
		var r2Hold:Bool = false;
	
		var n0Hold:Bool = false;
		var n1Hold:Bool = false;
		var n2Hold:Bool = false;
		var n3Hold:Bool = false;
		var n4Hold:Bool = false;
		var n5Hold:Bool = false;
		var n6Hold:Bool = false;
		var n7Hold:Bool = false;
		var n8Hold:Bool = false;
		// THIS FUNCTION JUST FUCKS WIT HELD NOTES AND BOTPLAY/REPLAY (also gamepad shit)

		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				switch(maniaToChange)
				{
					case 0: 
						//hold = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
						press = [
							controls.LEFT_P,
							controls.DOWN_P,
							controls.UP_P,
							controls.RIGHT_P
						];
						release = [
							controls.LEFT_R,
							controls.DOWN_R,
							controls.UP_R,
							controls.RIGHT_R
						];
					case 1: 
						//hold = [controls.L1, controls.U1, controls.R1, controls.L2, controls.D1, controls.R2];
						press = [
							controls.L1_P,
							controls.U1_P,
							controls.R1_P,
							controls.L2_P,
							controls.D1_P,
							controls.R2_P
						];
						release = [
							controls.L1_R,
							controls.U1_R,
							controls.R1_R,
							controls.L2_R,
							controls.D1_R,
							controls.R2_R
						];
					case 2: 
						//hold = [controls.N0, controls.N1, controls.N2, controls.N3, controls.N4, controls.N5, controls.N6, controls.N7, controls.N8];
						press = [
							controls.N0_P,
							controls.N1_P,
							controls.N2_P,
							controls.N3_P,
							controls.N4_P,
							controls.N5_P,
							controls.N6_P,
							controls.N7_P,
							controls.N8_P
						];
						release = [
							controls.N0_R,
							controls.N1_R,
							controls.N2_R,
							controls.N3_R,
							controls.N4_R,
							controls.N5_R,
							controls.N6_R,
							controls.N7_R,
							controls.N8_R
						];
					case 3: 
						//hold = [controls.LEFT, controls.DOWN, controls.N4, controls.UP, controls.RIGHT];
						press = [
							controls.LEFT_P,
							controls.DOWN_P,
							controls.N4_P,
							controls.UP_P,
							controls.RIGHT_P
						];
						release = [
							controls.LEFT_R,
							controls.DOWN_R,
							controls.N4_R,
							controls.UP_R,
							controls.RIGHT_R
						];
					case 4: 
						//hold = [controls.L1, controls.U1, controls.R1, controls.N4, controls.L2, controls.D1, controls.R2];
						press = [
							controls.L1_P,
							controls.U1_P,
							controls.R1_P,
							controls.N4_P,
							controls.L2_P,
							controls.D1_P,
							controls.R2_P
						];
						release = [
							controls.L1_R,
							controls.U1_R,
							controls.R1_R,
							controls.N4_R,
							controls.L2_R,
							controls.D1_R,
							controls.R2_R
						];
					case 5: 
						//hold = [controls.N0, controls.N1, controls.N2, controls.N3, controls.N5, controls.N6, controls.N7, controls.N8];
						press = [
							controls.N0_P,
							controls.N1_P,
							controls.N2_P,
							controls.N3_P,
							controls.N5_P,
							controls.N6_P,
							controls.N7_P,
							controls.N8_P
						];
						release = [
							controls.N0_R,
							controls.N1_R,
							controls.N2_R,
							controls.N3_R,
							controls.N5_R,
							controls.N6_R,
							controls.N7_R,
							controls.N8_R
						];
					case 6: 
						//hold = [controls.N4];
						press = [
							controls.N4_P
						];
						release = [
							controls.N4_R
						];
					case 7: 
					//	hold = [controls.LEFT, controls.RIGHT];
						press = [
							controls.LEFT_P,
							controls.RIGHT_P
						];
						release = [
							controls.LEFT_R,
							controls.RIGHT_R
						];
					case 8: 
						//hold = [controls.LEFT, controls.N4, controls.RIGHT];
						press = [
							controls.LEFT_P,
							controls.N4_P,
							controls.RIGHT_P
						];
						release = [
							controls.LEFT_R,
							controls.N4_R,
							controls.RIGHT_R
						];
					case 10: //changing mid song (mania + 10, seemed like the best way to make it change without creating more switch statements)
						press = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P,false,false,false,false,false];
						release = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R,false,false,false,false,false];
					case 11: 
						press = [controls.L1_P, controls.D1_P, controls.U1_P, controls.R1_P, false, controls.L2_P, false, false, controls.R2_P];
						release = [controls.L1_R, controls.D1_R, controls.U1_R, controls.R1_R, false, controls.L2_R, false, false, controls.R2_R];
					case 12: 
						press = [controls.N0_P, controls.N1_P, controls.N2_P, controls.N3_P, controls.N4_P, controls.N5_P, controls.N6_P, controls.N7_P, controls.N8_P];
						release = [controls.N0_R, controls.N1_R, controls.N2_R, controls.N3_R, controls.N4_R, controls.N5_R, controls.N6_R, controls.N7_R, controls.N8_R];
					case 13: 
						press = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P, controls.N4_P,false,false,false,false];
						release = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R, controls.N4_R,false,false,false,false];
					case 14: 
						press = [controls.L1_P, controls.D1_P, controls.U1_P, controls.R1_P, controls.N4_P, controls.L2_P, false, false, controls.R2_P];
						release = [controls.L1_R, controls.D1_R, controls.U1_R, controls.R1_R, controls.N4_R, controls.L2_R, false, false, controls.R2_R];
					case 15:
						press = [controls.N0_P, controls.N1_P, controls.N2_P, controls.N3_P, false, controls.N5_P, controls.N6_P, controls.N7_P, controls.N8_P];
						release = [controls.N0_R, controls.N1_R, controls.N2_R, controls.N3_R, false, controls.N5_R, controls.N6_R, controls.N7_R, controls.N8_R];
					case 16: 
						press = [false, false, false, false, controls.N4_P, false, false, false, false];
						release = [false, false, false, false, controls.N4, false, false, false, false];
					case 17: 
						press = [controls.LEFT_P, false, false, controls.RIGHT_P, false, false, false, false, false];
						release = [controls.LEFT_R, false, false, controls.RIGHT_R, false, false, false, false, false];
					case 18: 
						press = [controls.LEFT_P, false, false, controls.RIGHT_P, controls.N4_P, false, false, false, false];
						release = [controls.LEFT_R, false, false, controls.RIGHT_R, controls.N4_R, false, false, false, false];
				}
				var holdArray:Array<Bool> = hold;
				var pressArray:Array<Bool> = press;
				var releaseArray:Array<Bool> = release;
				
				#if windows
				if (luaModchart != null)
				{
					for (i in 0...pressArray.length) {
						if (pressArray[i] == true) {
						luaModchart.executeState('keyPressed', [sDir[i].toLowerCase()]);
						}
					};
					
					for (i in 0...releaseArray.length) {
						if (releaseArray[i] == true) {
						luaModchart.executeState('keyReleased', [sDir[i].toLowerCase()]);
						}
					};
					
				};
				#end
				
		 
				
				// Prevent player input if botplay is on
				if(PlayStateChangeables.botPlay)
				{
					holdArray = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
					pressArray = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
					releaseArray = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
				} 

				var anas:Array<Ana> = [null,null,null,null];
				switch(mania)
				{
					case 0: 
						anas = [null,null,null,null];
					case 1: 
						anas = [null,null,null,null,null,null];
					case 2: 
						anas = [null,null,null,null,null,null,null,null,null];
					case 3: 
						anas = [null,null,null,null,null];
					case 4: 
						anas = [null,null,null,null,null,null,null];
					case 5: 
						anas = [null,null,null,null,null,null,null,null];
					case 6: 
						anas = [null];
					case 7: 
						anas = [null,null];
					case 8: 
						anas = [null,null,null];
				}

				for (i in 0...pressArray.length)
					if (pressArray[i])
						anas[i] = new Ana(Conductor.songPosition, null, false, "miss", i);

				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				} //gt hero input shit, using old code because i can
				if (controls.GTSTRUM)
				{
					if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic && FlxG.save.data.gthm || holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic && FlxG.save.data.gthm)
						{
							var possibleNotes:Array<Note> = [];

							var ignoreList:Array<Int> = [];
				
							notes.forEachAlive(function(daNote:Note)
							{
								if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote)
								{
									possibleNotes.push(daNote);
									possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
				
									ignoreList.push(daNote.noteData);
								}
				
							});
				
							if (possibleNotes.length > 0)
							{
								var daNote = possibleNotes[0];
				
								// Jump notes
								if (possibleNotes.length >= 2)
								{
									if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
									{
										for (coolNote in possibleNotes)
										{
											if (pressArray[coolNote.noteData] || holdArray[coolNote.noteData])
												goodNoteHit(coolNote);
											else
											{
												var inIgnoreList:Bool = false;
												for (shit in 0...ignoreList.length)
												{
													if (holdArray[ignoreList[shit]] || pressArray[ignoreList[shit]])
														inIgnoreList = true;
												}
												if (!inIgnoreList && !FlxG.save.data.ghost)
													noteMiss(1, null);
											}
										}
									}
									else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
									{
										if (pressArray[daNote.noteData] || holdArray[daNote.noteData])
											goodNoteHit(daNote);
									}
									else
									{
										for (coolNote in possibleNotes)
										{
											if (pressArray[coolNote.noteData] || holdArray[coolNote.noteData])
												goodNoteHit(coolNote);
										}
									}
								}
								else // regular notes?
								{
									if (pressArray[daNote.noteData] || holdArray[daNote.noteData])
										goodNoteHit(daNote);
								}
							}
						}

					}
		 
				if (KeyBinds.gamepad && !FlxG.keys.justPressed.ANY)
				{
					// PRESSES, check for note hits
					if (pressArray.contains(true) && generatedMusic)
					{
						boyfriend.holdTimer = 0;
			
						var possibleNotes:Array<Note> = []; // notes that can be hit
						var directionList:Array<Int> = []; // directions that can be hit
						var dumbNotes:Array<Note> = []; // notes to kill later
						var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
						
						switch(mania)
						{
							case 0: 
								directionsAccounted = [false, false, false, false];
							case 1: 
								directionsAccounted = [false, false, false, false, false, false];
							case 2: 
								directionsAccounted = [false, false, false, false, false, false, false, false, false];
							case 3: 
								directionsAccounted = [false, false, false, false, false];
							case 4: 
								directionsAccounted = [false, false, false, false, false, false, false];
							case 5: 
								directionsAccounted = [false, false, false, false, false, false, false, false];
							case 6: 
								directionsAccounted = [false];
							case 7: 
								directionsAccounted = [false, false];
							case 8: 
								directionsAccounted = [false, false, false];
						}
						

						notes.forEachAlive(function(daNote:Note)
							{
								if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !directionsAccounted[daNote.noteData])
								{
									if (directionList.contains(daNote.noteData))
										{
											directionsAccounted[daNote.noteData] = true;
											for (coolNote in possibleNotes)
											{
												if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
												{ // if it's the same note twice at < 10ms distance, just delete it
													// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
													dumbNotes.push(daNote);
													break;
												}
												else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
												{ // if daNote is earlier than existing note (coolNote), replace
													possibleNotes.remove(coolNote);
													possibleNotes.push(daNote);
													break;
												}
											}
										}
										else
										{
											directionsAccounted[daNote.noteData] = true;
											possibleNotes.push(daNote);
											directionList.push(daNote.noteData);
										}
								}
						});

						for (note in dumbNotes)
						{
							FlxG.log.add("killing dumb ass note at " + note.strumTime);
							note.kill();
							notes.remove(note, true);
							note.destroy();
						}
			
						possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
						var hit = [false,false,false,false,false,false,false,false,false];
						switch(mania)
						{
							case 0: 
								hit = [false, false, false, false];
							case 1: 
								hit = [false, false, false, false, false, false];
							case 2: 
								hit = [false, false, false, false, false, false, false, false, false];
							case 3: 
								hit = [false, false, false, false, false];
							case 4: 
								hit = [false, false, false, false, false, false, false];
							case 5: 
								hit = [false, false, false, false, false, false, false, false];
							case 6: 
								hit = [false];
							case 7: 
								hit = [false, false];
							case 8: 
								hit = [false, false, false];
						}
						if (perfectMode)
							goodNoteHit(possibleNotes[0]);
						else if (possibleNotes.length > 0)
						{
							if (!FlxG.save.data.ghost)
								{
									for (i in 0...pressArray.length)
										{ // if a direction is hit that shouldn't be
											if (pressArray[i] && !directionList.contains(i))
												noteMiss(i, null);
										}
								}
							if (FlxG.save.data.gthm)
							{
	
							}
							else
							{
								for (coolNote in possibleNotes)
									{
										if (pressArray[coolNote.noteData] && !hit[coolNote.noteData])
										{
											if (mashViolations != 0)
												mashViolations--;
											hit[coolNote.noteData] = true;
											scoreTxt.color = FlxColor.WHITE;
											var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
											anas[coolNote.noteData].hit = true;
											anas[coolNote.noteData].hitJudge = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));
											anas[coolNote.noteData].nearestNote = [coolNote.strumTime,coolNote.noteData,coolNote.sustainLength];
											goodNoteHit(coolNote);
										}
									}
							}
							
						};
						if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || PlayStateChangeables.botPlay || PlayStateChangeables.bothSide && !currentSection.mustHitSection))
							{
								if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss') && (boyfriend.animation.curAnim.curFrame >= 10 || boyfriend.animation.curAnim.finished))
									boyfriend.dance();
							}
						else if (!FlxG.save.data.ghost)
							{
								for (shit in 0...keyAmmo[mania])
									if (pressArray[shit])
										noteMiss(shit, null);
							}
					}

					if (!loadRep)
						for (i in anas)
							if (i != null)
								replayAna.anaArray.push(i); // put em all there
				}
					
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || PlayStateChangeables.botPlay || PlayStateChangeables.bothSide && !currentSection.mustHitSection))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
						boyfriend.dance();
				}
		 
				if (!PlayStateChangeables.botPlay)
				{
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (keys[spr.ID] && spr.animation.curAnim.name != 'confirm' && spr.animation.curAnim.name != 'pressed')
							spr.animation.play('pressed', false);
						if (!keys[spr.ID])
							spr.animation.play('static', false);
			
						if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
						{
							spr.centerOffsets();
							switch(maniaToChange)
							{
								case 0: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 1: 
									spr.offset.x -= 16;
									spr.offset.y -= 16;
								case 2: 
									spr.offset.x -= 22;
									spr.offset.y -= 22;
								case 3: 
									spr.offset.x -= 15;
									spr.offset.y -= 15;
								case 4: 
									spr.offset.x -= 18;
									spr.offset.y -= 18;
								case 5: 
									spr.offset.x -= 20;
									spr.offset.y -= 20;
								case 6: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 7: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 8:
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 10: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 11: 
									spr.offset.x -= 16;
									spr.offset.y -= 16;
								case 12: 
									spr.offset.x -= 22;
									spr.offset.y -= 22;
								case 13: 
									spr.offset.x -= 15;
									spr.offset.y -= 15;
								case 14: 
									spr.offset.x -= 18;
									spr.offset.y -= 18;
								case 15: 
									spr.offset.x -= 20;
									spr.offset.y -= 20;
								case 16: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 17: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 18:
									spr.offset.x -= 13;
									spr.offset.y -= 13;
							}
						}
						else
							spr.centerOffsets();
					});
				}
			}

			public function findByTime(time:Float):Array<Dynamic>
				{
					for (i in rep.replay.songNotes)
					{
						//trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
						if (i[0] == time)
							return i;
					}
					return null;
				}

			public function findByTimeIndex(time:Float):Int
				{
					for (i in 0...rep.replay.songNotes.length)
					{
						//trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
						if (rep.replay.songNotes[i][0] == time)
							return i;
					}
					return -1;
				}

			public var fuckingVolume:Float = 1;
			public var useVideo = false;

			public static var webmHandler:WebmHandler;

			public var playingDathing = false;

			public var videoSprite:FlxSprite;

			public function focusOut() {
				if (paused)
					return;
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;
		
					if (FlxG.sound.music != null)
					{
						FlxG.sound.music.pause();
						vocals.pause();
					}
		
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}
			public function focusIn() 
			{ 
				// nada 
			}

			function doCelebi(newMax:Float):Void {
					maxHealth = newMax;
					remove(healthBar);
					healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8) - Std.int(healthBar.width * (maxHealth / 2)) , Std.int(healthBarBG.height - 8), this,
						'health', maxHealth, 2);
					healthBar.scrollFactor.set();
					healthBar.visible = !ClientPrefs.hideHud;
					remove(iconP1);
					remove(iconP2);
					add(healthBar);
					add(iconP1);
					add(iconP2);
					healthBar.cameras = [camHUD];
					reloadHealthBarColors();
			
					var celebi:FlxSprite = new FlxSprite(0 + FlxG.random.int(-150, -300), 0 + FlxG.random.int(-200, 200));
					celebi.frames = Paths.getSparrowAtlas('lostSilver/Celebi_Assets', 'shared');
					celebi.animation.addByPrefix('spawn', 'Celebi Spawn Full', 24, false);
					celebi.animation.addByIndices('reverseSpawn', 'Celebi Spawn Full', [14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],'', 24, false);
					celebi.animation.addByPrefix('idle', 'Celebi Idle', 24, false);
					celebi.animation.play('spawn');
					celebi.animation.finishCallback = function (name:String) {
						celebi.animation.play('idle');
						var note:FlxSprite = new FlxSprite(celebi.x + FlxG.random.int(70, 100), celebi.y + FlxG.random.int(-50, 50));
						note.frames = Paths.getSparrowAtlas('lostSilver/Note_asset', 'shared');
						note.animation.addByPrefix('spawn', 'Note Full', 24, false);
						note.animation.play('spawn');
						note.animation.finishCallback = function (name:String) {
							remove(note);
						};
						add(note);
						FlxTween.tween(note, {x: note.x + FlxG.random.int(100, 190), y:FlxG.random.int(-80, 140)}, (Conductor.stepCrochet * 8 / 1000), {ease: FlxEase.quadOut});
						celebi.animation.finishCallback = null;
							for (i in 0...3) {
								var note:FlxSprite = new FlxSprite(celebi.x + FlxG.random.int(70, 100), celebi.y + FlxG.random.int(-50, 50));
								note.frames = Paths.getSparrowAtlas('lostSilver/Note_asset', 'shared');
								note.animation.addByPrefix('spawn', 'Note Full', 24, false);
								note.animation.play('spawn');
								note.animation.finishCallback = function (name:String) {
									remove(note);
								};
								add(note);
								FlxTween.tween(note, {x: note.x + FlxG.random.int(100, 190), y:FlxG.random.int(-80, 140)}, (Conductor.stepCrochet * 8 / 1000), {ease: FlxEase.quadOut});
								celebi.animation.finishCallback = null;
							}
					};
					celebiLayer.add(celebi);
					
			
					
					new FlxTimer().start(Conductor.stepCrochet * 8 / 1000, function(tmr:FlxTimer)
					{
						var note:FlxSprite = new FlxSprite(celebi.x + FlxG.random.int(70, 100), celebi.y + FlxG.random.int(-50, 50));
						note.frames = Paths.getSparrowAtlas('lostSilver/Note_asset', 'shared');
						note.animation.addByPrefix('spawn', 'Note Full', 24, false);
						note.animation.play('spawn');
						note.animation.finishCallback = function (name:String) {
							remove(note);
						};
						add(note);
						FlxTween.tween(note, {x: note.x + FlxG.random.int(100, 190), y:FlxG.random.int(-80, 140)}, (Conductor.stepCrochet * 8 / 1000), {ease: FlxEase.quadOut});
							for (i in 0...3) {
								var note:FlxSprite = new FlxSprite(celebi.x + FlxG.random.int(70, 100), celebi.y + FlxG.random.int(-50, 50));
								note.frames = Paths.getSparrowAtlas('lostSilver/Note_asset', 'shared');
								note.animation.addByPrefix('spawn', 'Note Full', 24, false);
								note.animation.play('spawn');
								note.animation.finishCallback = function (name:String) {
									remove(note);
								};
								add(note);
								FlxTween.tween(note, {x: note.x + FlxG.random.int(100, 190), y:FlxG.random.int(-80, 140)}, (Conductor.stepCrochet * 8 / 1000), {ease: FlxEase.quadOut});
								celebi.animation.finishCallback = null;
							}
		
					});
			
					new FlxTimer().start(Conductor.stepCrochet * 16 / 1000, function(tmr:FlxTimer)
					{
						celebi.animation.play('reverseSpawn', true);
						celebi.animation.finishCallback = function (name:String) {
							celebiLayer.remove(celebi);
						};
					});
			}

			public function backgroundVideo(source:String) // for background videos
				{
					#if cpp
					useVideo = true;
			
					FlxG.stage.window.onFocusOut.add(focusOut);
					FlxG.stage.window.onFocusIn.add(focusIn);

					var ourSource:String = "assets/videos/daWeirdVid/dontDelete.webm";
					//WebmPlayer.SKIP_STEP_LIMIT = 90;
					var str1:String = "WEBM SHIT"; 
					webmHandler = new WebmHandler();
					webmHandler.source(ourSource);
					webmHandler.makePlayer();
					webmHandler.webm.name = str1;
			
					GlobalVideo.setWebm(webmHandler);

					GlobalVideo.get().source(source);
					GlobalVideo.get().clearPause();
					if (GlobalVideo.isWebm)
					{
						GlobalVideo.get().updatePlayer();
					}
					GlobalVideo.get().show();
			
					if (GlobalVideo.isWebm)
					{
						GlobalVideo.get().restart();
					} else {
						GlobalVideo.get().play();
					}
					
					var data = webmHandler.webm.bitmapData;
			
					videoSprite = new FlxSprite(-470,-30).loadGraphic(data);
			
					videoSprite.setGraphicSize(Std.int(videoSprite.width * 1.2));
			
					remove(gf);
					remove(boyfriend);
					remove(dad);
					add(videoSprite);
					add(gf);
					add(boyfriend);
					add(dad);
			
					trace('poggers');
			
					if (!songStarted)
						webmHandler.pause();
					else
						webmHandler.resume();
					#end
				}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;
			songMisses++;

			if (daNote != null)
			{
				if (!loadRep)
				{
					saveNotes.push([daNote.strumTime,0,direction,166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166]);
					saveJudge.push("miss");
				}
			}
			else
				if (!loadRep)
				{
					saveNotes.push([Conductor.songPosition,0,direction,166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166]);
					saveJudge.push("miss");
				}

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');
			boyfriend.playAnim('sing' + sDir[direction] + 'miss', true);

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end


			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}

		private function KillNotes() {
			while(notes.length > 0) {
				var daNote:Note = notes.members[0];
				daNote.active = false;
				daNote.visible = false;
	
				daNote.kill();
				notes.remove(daNote, true);
				daNote.destroy();
			}
			unspawnNotes = [];
			eventNotes = [];
		}
		
	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	var jumpscareSizeInterval:Float = 1.625;

	function jumpscare(chance:Float, duration:Float) {
		// jumpscare
		if (FlxG.save.data.flashing) {
			var outOfTen:Float = Std.random(10);
			if (outOfTen <= ((!Math.isNaN(chance)) ? chance : 4)) {
				jumpScare.visible = true;
				camHUD.shake(0.0125 * (jumpscareSizeInterval / 2), (((!Math.isNaN(duration)) ? duration : 1) * Conductor.stepCrochet) / 1000, 
					function(){
						jumpScare.visible = false;
						jumpscareSizeInterval += 0.125;
						jumpScare.setGraphicSize(Std.int(FlxG.width * jumpscareSizeInterval), Std.int(FlxG.height * jumpscareSizeInterval));
						jumpScare.updateHitbox();
						jumpScare.screenCenter();
					}, true
				);
			}
		}
	}

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		public function godIntro()
			{
				dad.playAnim('back', true);
				new FlxTimer().start(3, function(tmr:FlxTimer)
				{
					dad.playAnim('snap', true);
					new FlxTimer().start(0.85, function(tmr2:FlxTimer)
					{
						FlxG.sound.play(Paths.sound('snap'));
						FlxG.sound.play(Paths.sound('undSnap'));
						sShake = 10;
						//pon el sonido con los efectos circulares
						new FlxTimer().start(0.06, function(tmr3:FlxTimer)
						{
							dad.playAnim('snapped', true);
						});
						new FlxTimer().start(1.5, function(tmr4:FlxTimer)
						{
							//la camara tiembla y puede ser que aparezcan rocas?
							new FlxTimer().start(0.001, function(shkUp:FlxTimer)
							{
								sShake += 0.51;
								if (!godCutEnd) shkUp.reset(0.001);
							});
							new FlxTimer().start(1, function(tmr5:FlxTimer)
							{
								add(new MansionDebris(-300, -120, 'ceil', 1, 1, -4, -40));
								add(new MansionDebris(0, -120, 'ceil', 1, 1, -4, -5));
								add(new MansionDebris(200, -120, 'ceil', 1, 1, -4, 40));
		
								sShake += 5;
								FlxG.sound.play(Paths.sound('ascend'));
								boyfriend.playAnim('hit');
								godCutEnd = true;
								new FlxTimer().start(0.4, function(tmr6:FlxTimer)
								{
									godMoveGf = true;
									boyfriend.playAnim('hit');
								});
								new FlxTimer().start(1, function(tmr9:FlxTimer)
								{
									boyfriend.playAnim('scared', true);
								});
								new FlxTimer().start(2, function(tmr7:FlxTimer)
								{
									dad.playAnim('idle', true);
									FlxG.sound.play(Paths.sound('shagFly'));
									godMoveSh = true;
									new FlxTimer().start(1.5, function(tmr8:FlxTimer)
									{
										startCountdown();
									});
								});
							});
						});	
					});
				});
				new FlxTimer().start(0.001, function(shk:FlxTimer)
				{
					if (sShake > 0)
					{
						sShake -= 0.5;
						FlxG.camera.angle = FlxG.random.float(-sShake, sShake);
					}
					shk.reset(0.001);
				});
			}

	var curLightEvent:Int = 0;

	var scoob:Character;
	var cs_time:Int = 0;
	var cs_wait:Bool = false;
	var cs_zoom:Float = 1;
	var cs_slash_dim:FlxSprite;
	var cs_sfx:FlxSound;
	var cs_mus:FlxSound;
	var sh_body:FlxSprite;
	var sh_head:FlxSprite;
	var cs_cam:FlxObject;
	var cs_black:FlxSprite;
	var sh_ang:FlxSprite;
	var sh_ang_eyes:FlxSprite;
	var cs_bg:FlxSprite;
	var cs_reset:Bool = false;
	var nex:Float = 1;

	public function burstRelease(bX:Float, bY:Float)
		{
			FlxG.sound.play(Paths.sound('burst'));
			remove(burst);
			burst = new FlxSprite(bX - 1000, bY - 100);
			burst.frames = Paths.getSparrowAtlas('characters/shaggy');
			burst.animation.addByPrefix('burst', "burst", 30);
			burst.animation.play('burst');
			//burst.setGraphicSize(Std.int(burst.width * 1.5));
			burst.antialiasing = FlxG.save.data.antialiasing;
			add(burst);
			new FlxTimer().start(0.5, function(rem:FlxTimer)
			{
				remove(burst);
			});
		}

		function eventPushed(event:Array<Dynamic>) {
			switch(event[2]) {
				case 'Change Character':
				/*	var charType:Int = Std.parseInt(event[3]);
					if(Math.isNaN(charType)) charType = 0;
	
					var newCharacter:String = event[4];
					addCharacterToList(newCharacter, charType);*/

					trace('changing characters.');
			}
		}

		/*public function addCharacterToList(newCharacter:String, type:Int) {
			switch(type) {
				case 0:
					if(!boyfriendMap.exists(newCharacter)) {
						var newBoyfriend:Boyfriend = new Boyfriend(BF_X, BF_Y, newCharacter);
						boyfriendMap.set(newCharacter, newBoyfriend);
						boyfriendGroup.add(newBoyfriend);
						startCharacterPos(newBoyfriend);
						newBoyfriend.visible = false;
					}
	
				case 1:
					if(!dadMap.exists(newCharacter)) {
						var newDad:Character = new Character(DAD_X, DAD_Y, newCharacter);
						dadMap.set(newCharacter, newDad);
						dadGroup.add(newDad);
						startCharacterPos(newDad);
						newDad.visible = false;
					}
	
				case 2:
					if(!gfMap.exists(newCharacter)) {
						var newGf:Character = new Character(GF_X, GF_Y, newCharacter);
						newGf.scrollFactor.set(0.95, 0.95);
						gfMap.set(newCharacter, newGf);
						gfGroup.add(newGf);
						startCharacterPos(newGf);
						newGf.visible = false;
					}
			}
		}*/

		function startCharacterPos(char:Character, ?gfCheck:Bool = false) {
			if(gfCheck && char.curCharacter.startsWith('gf')) { //IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
				char.setPosition(GF_X, GF_Y);
			}
			char.x += char.positionArray[0];
			char.y += char.positionArray[1];
		}

	public function ssCutscene()
	{
		cs_cam = new FlxObject(0, 0, 1, 1);
		cs_cam.x = 605;
		cs_cam.y = 410;
		add(cs_cam);
		camFollowPos.destroy();
		FlxG.camera.follow(cs_cam, LOCKON, 0.01);

		Main.menuBad = true;
		new FlxTimer().start(0.002, function(tmr:FlxTimer)
		{
			switch (cs_time)
			{
				case 1:
					cs_zoom = 0.65;
				case 25:
					//scoob = new Character(1700, 290, 'scooby', false);
					scoob.playAnim('walk', true);
					scoob.x = 1700;
					scoob.y = 290;
					//scoob.playAnim('walk');
				case 240:
					scoob.playAnim('idle', true);
				case 340:
					burstRelease(dad.getMidpoint().x, dad.getMidpoint().y);

					remove(dad);
					dad = new Character(dad.x, dad.y, 'shaggy');
					add(dad);
					dad.playAnim('idle', true);
				case 390:
					remove(burst);
				case 420:
					if (!cs_wait)
					{
						csDial('found_scooby');
						schoolIntro(0);
						cs_wait = true;
						cs_reset = true;

						cs_mus = FlxG.sound.load(Paths.sound('cs_happy'));
						cs_mus.play();
						cs_mus.looped = true;
					}
				case 540:
					scoob.playAnim('scare', true);
					cs_mus.fadeOut(2, 0);
				case 900:
					FlxG.sound.play(Paths.sound('blur'));
					scoob.playAnim('blur', true);
					scoob.x -= 200;
					scoob.y += 100;
					scoob.angle = 23;
					dad.playAnim('catch', true);
				case 903:
					scoob.x = -4000;
					scoob.angle = 0;
				case 940:
					dad.playAnim('hold', true);
					cs_sfx = FlxG.sound.load(Paths.sound('scared'));
					cs_sfx.play();
					cs_sfx.looped = true;
				case 1200:
					if (!cs_wait)
					{
						csDial('scooby_hold_talk');
						schoolIntro(0);
						cs_wait = true;
						cs_reset = true;

						cs_mus.stop();
						cs_mus = FlxG.sound.load(Paths.sound('cs_drums'));
						cs_mus.play();
						cs_mus.looped = true;
					}
				case 1201:
					cs_sfx.stop();
					cs_mus.stop();
					FlxG.sound.play(Paths.sound('counter_back'));
					cs_slash_dim = new FlxSprite(-500, -400).makeGraphic(FlxG.width * 4, FlxG.height * 4, FlxColor.WHITE);
					cs_slash_dim.scrollFactor.set();
					add(cs_slash_dim);
					dad.playAnim('h_half', true);
					gf.playAnim('kill', true);
					scoob.playAnim('half', true);
					scoob.x += 4100;
					scoob.y -= 150;

					scoob.x -= 90;
					scoob.y -= 252;
				case 1700:
					scoob.playAnim('fall', true);
					cs_cam.x -= 150;
				case 1740:
					FlxG.sound.play(Paths.sound('body_fall'));
				case 2000:
					if (!cs_wait)
					{
						gf.playAnim('danceRight', true);
						csDial('gf_sass');
						schoolIntro(0);
						cs_wait = true;
						cs_reset = true;
					}
				case 2150:
					dad.playAnim('fall', true);
				case 2180:
					FlxG.sound.play(Paths.sound('shaggy_kneel'));
				case 2245:
					FlxG.sound.play(Paths.sound('body_fall'));
				case 2280:
					dad.playAnim('kneel', true);
					sh_head = new FlxSprite(440, 100);
					sh_head.y = 100 + FlxG.random.int(-0, 0);
					sh_head.frames = Paths.getSparrowAtlas('bshaggy');
					sh_head.animation.addByPrefix('idle', "bshaggy_head_still", 30);
					sh_head.animation.addByPrefix('turn', "bshaggy_head_transform", 30);
					sh_head.animation.addByPrefix('idle2', "bsh_head2_still", 30);
					sh_head.animation.play('turn');
					sh_head.animation.play('idle');
					sh_head.antialiasing = true;

					sh_ang = new FlxSprite(0, 0);
					sh_ang.frames = Paths.getSparrowAtlas('bshaggy');
					sh_ang.animation.addByPrefix('idle', "bsh_angry", 30);
					sh_ang.animation.play('idle');
					sh_ang.antialiasing = true;

					sh_ang_eyes = new FlxSprite(0, 0);
					sh_ang_eyes.frames = Paths.getSparrowAtlas('bshaggy');
					sh_ang_eyes.animation.addByPrefix('stare', "bsh_eyes", 30);
					sh_ang_eyes.animation.play('stare');
					sh_ang_eyes.antialiasing = true;

					cs_bg = new FlxSprite(-500, -80);
					cs_bg.frames = Paths.getSparrowAtlas('cs_bg');
					cs_bg.animation.addByPrefix('back', "cs_back_bg", 30);
					cs_bg.animation.addByPrefix('stare', "cs_bg", 30);
					cs_bg.animation.play('back');
					cs_bg.antialiasing = true;
					cs_bg.setGraphicSize(Std.int(cs_bg.width * 1.1));

					cs_sfx = FlxG.sound.load(Paths.sound('powerup'));
				case 2500:
					add(cs_bg);
					add(sh_head);

					sh_body = new FlxSprite(200, 250);
					sh_body.frames = Paths.getSparrowAtlas('bshaggy');
					sh_body.animation.addByPrefix('idle', "bshaggy_body_still", 30);
					sh_body.animation.play('idle');
					sh_body.antialiasing = true;
					add(sh_body);

					cs_mus = FlxG.sound.load(Paths.sound('cs_cagaste'));
					cs_mus.looped = false;
					cs_mus.play();
					cs_cam.x += 150;
					FlxG.camera.follow(cs_cam, LOCKON, 1);
				case 3100:
					burstRelease(1000, 300);
				case 3580:
					burstRelease(1000, 300);
					cs_sfx.play();
					cs_sfx.looped = false;
					FlxG.camera.angle = 10;
				case 4000:
					burstRelease(1000, 300);
					cs_sfx.play();
					FlxG.camera.angle = -20;
					sh_head.animation.play('turn');
					sh_head.offset.set(0, 60);

					cs_sfx = FlxG.sound.load(Paths.sound('charge'));
					cs_sfx.play();
					cs_sfx.looped = true;
				case 4003:
					cs_mus.play(true, 12286 - 337);
				case 4065:
					sh_head.animation.play('idle2');
				case 4550:
					remove(sh_head);
					remove(sh_body);
					cs_sfx.stop();


					sh_ang.x = -140;
					sh_ang.y = -5;

					sh_ang_eyes.x = 688;
					sh_ang_eyes.y = 225;

					add(sh_ang);
					add(sh_ang_eyes);

					cs_bg.animation.play('stare');

					cs_black = new FlxSprite(-500, -400).makeGraphic(FlxG.width * 4, FlxG.height * 4, FlxColor.BLACK);
					cs_black.scrollFactor.set();
					add(cs_black);

					cs_mus.play(true, 16388);
				case 6000:
					cs_black.alpha = 2;
					cs_mus.stop();
				case 6100:
					endSong();
			}
			if (cs_time >= 25 && cs_time <= 240)
			{
				scoob.x -= 6;
				scoob.playAnim('walk');
			}
			if (cs_time > 240 && cs_time < 540)
			{
				scoob.playAnim('idle');
			}
			if (cs_time > 940 && cs_time < 1201)
			{
				dad.playAnim('hold');
			}
			if (cs_time > 1201 && cs_time < 2500)
			{
				cs_slash_dim.alpha -= 0.003;
			}
			if (cs_time >= 2500 && cs_time < 4550)
			{
				cs_zoom += 0.0001;
			}
			if (cs_time >= 5120 && cs_time <= 6000)
			{
				cs_black.alpha -= 0.0015;
			}
			if (cs_time >= 3580 && cs_time < 4000)
			{
				sh_head.y = 100 + FlxG.random.int(-5, 5);
			}
			if (cs_time >= 4000 && cs_time <= 4548)
			{
				sh_head.x = 440 + FlxG.random.int(-10, 10);
				sh_body.x = 200 + FlxG.random.int(-5, 5);
			}

			if (cs_time == 3400 || cs_time == 3450 || cs_time == 3500 || cs_time == 3525 || cs_time == 3550 || cs_time == 3560 || cs_time == 3570)
			{
				burstRelease(1000, 300);
			}

			FlxG.camera.zoom += (cs_zoom - FlxG.camera.zoom) / 12;
			FlxG.camera.angle += (0 - FlxG.camera.angle) / 12;
			if (!cs_wait)
			{
				cs_time ++;
			}
			tmr.reset(0.002);
		});
	}

	var dfS:Float = 1;
	var toDfS:Float = 1;

	function sortByTime(Obj1:Array<Dynamic>, Obj2:Array<Dynamic>):Int
		{
			var earlyTime1:Float = eventNoteEarlyTrigger(Obj1);
			var earlyTime2:Float = eventNoteEarlyTrigger(Obj2);
			return FlxSort.byValues(FlxSort.ASCENDING, Obj1[0] - earlyTime1, Obj2[0] - earlyTime2);
		}

	public function finalCutscene()
	{
		cs_zoom = defaultCamZoom;
		cs_cam = new FlxObject(0, 0, 1, 1);
		camFollow.x = boyfriend.getMidpoint().x - 100;
		camFollow.y = boyfriend.getMidpoint().y - 100;
		cs_cam.x = camFollow.x;
		cs_cam.y = camFollow.y;
		add(cs_cam);
		camFollow.destroy();
		FlxG.camera.follow(cs_cam, LOCKON, 0.01);

		new FlxTimer().start(0.002, function(tmr:FlxTimer)
		{
			switch (cs_time)
			{
				case 200:
					cs_cam.x -= 500;
					cs_cam.y -= 200;
				case 400:
					dad.playAnim('smile');
				case 500:
					if (!cs_wait)
					{
						var exStr = '';
						if (alterRoute == 1)
						{
							exStr += '_alter';
						}
						csDial('sh_amazing' + exStr);
						schoolIntro(0);
						cs_wait = true;
						cs_reset = true;
					}
				case 700:
					godCutEnd = false;
					FlxG.sound.play(Paths.sound('burst'));
					if (maskObj != null) maskObj.x -= 5000;
					//maskCollGroup.remove(maskObj);
					dad.playAnim('stand', true);
					dad.x = 100;
					dad.y = 100;
					boyfriend.x = 770;
					boyfriend.y = 450;
					gf.x = 400;
					gf.y = 130;
					gf.scrollFactor.set(0.95, 0.95);
					gf.setGraphicSize(Std.int(gf.width));
					cs_cam.y = boyfriend.y;
					cs_cam.x += 100;
					cs_zoom = 0.8;
					FlxG.camera.zoom = cs_zoom;
					scoob.x = dad.x - 400;
					scoob.y = 290;
					scoob.flipX = true;
					remove(shaggyT);
					FlxG.camera.follow(cs_cam, LOCKON, 1);
				case 800:
					if (!cs_wait)
					{
						var exStr = '';
						if (alterRoute == 1)
						{
							exStr += '_alter';
						}
						csDial('sh_expo' + exStr);
						schoolIntro(0);
						cs_wait = true;
						cs_reset = true;

						cs_mus = FlxG.sound.load(Paths.sound('cs_finale'));
						cs_mus.looped = true;
						cs_mus.play();
					}
				case 840:
					FlxG.sound.play(Paths.sound('exit'));
					doorFrame.alpha = 1;
					doorFrame.x -= 90;
					doorFrame.y -= 130;
					toDfS = 700;
				case 1150:
					if (!cs_wait)
					{
						csDial('sh_bye');
						schoolIntro(0);
						cs_wait = true;
						cs_reset = true;
					}
				case 1400:
					FlxG.sound.play(Paths.sound('exit'));
					toDfS = 1;
				case 1645:
					cs_black = new FlxSprite(-500, -400).makeGraphic(FlxG.width * 4, FlxG.height * 4, FlxColor.BLACK);
					cs_black.scrollFactor.set();
					cs_black.alpha = 0;
					add(cs_black);
					cs_wait = true;
					modCredits();
					cs_time ++;
				case -1:
					if (!cs_wait)
					{
						csDial('troleo');
						schoolIntro(0);
						cs_wait = true;
						cs_reset = true;
					}
				case 1651:
					endSong();
			}
			if (cs_time > 700)
			{
				scoob.playAnim('idle');
			}
			if (cs_time > 1150)
			{
				scoob.alpha -= 0.004;
				dad.alpha -= 0.004;
			}
			FlxG.camera.zoom += (cs_zoom - FlxG.camera.zoom) / 12;
			if (!cs_wait)
			{
				cs_time ++;
			}

			dfS += (toDfS - dfS) / 18;
			doorFrame.setGraphicSize(Std.int(dfS));
			tmr.reset(0.002);
		});
	}
	
	var title:FlxSprite;
	var thanks:Alphabet;
	var endtxt:Alphabet;

	public function modCredits()
	{
		FlxG.sound.play(Paths.sound('cs_credits'));
		new FlxTimer().start(0.002, function(btmr:FlxTimer)
		{
			cs_black.alpha += 0.0025;
			btmr.reset(0.002);
		});

		new FlxTimer().start(3, function(tmrt:FlxTimer)
		{
			title = new FlxSprite(FlxG.width / 2 - 400, FlxG.height / 2 - 300).loadGraphic(Paths.image('sh_title'));
			title.setGraphicSize(Std.int(title.width * 1.2));
			title.antialiasing = true;
			title.scrollFactor.set();
			title.centerOffsets();
			//title.active = false;
			add(title);

			new FlxTimer().start(2.5, function(tmrth:FlxTimer)
			{
				thanks = new Alphabet(0, FlxG.height / 2 + 300, "THANKS FOR PLAYING THIS MOD", true, false);
				thanks.screenCenter(X);
				thanks.x -= 150;
				add(thanks);

				new FlxTimer().start(2.5, function(tmrth:FlxTimer)
				{
					MASKstate.endingUnlock(0);
					endtxt = new Alphabet(6, FlxG.height / 2 + 380, "MAIN ENDING", true, false);
					endtxt.screenCenter(X);
					endtxt.x -= 150;
					add(endtxt);

					new FlxTimer().start(12, function(gback:FlxTimer)
					{
						cs_wait = false;
					});
				});
			});
		});
	}

	function startNextDialogue() {
		dialogueCount++;
		//callOnLuas('onNextDialogue', [dialogueCount]);
	}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

				if(loadRep)
				{
					noteDiff = findByTime(note.strumTime)[3];
					note.rating = rep.replay.songJudgements[findByTimeIndex(note.strumTime)];
				}
				else
					note.rating = Ratings.CalculateRating(noteDiff);

				if (note.rating == "miss")
					return;	


				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
	
					var altAnim:String = "";

					if (currentSection != null)
						{
							if (currentSection.altAnim)
								altAnim = '-alt';
						}	
					if (note.alt)
						altAnim = '-alt';

					if (!PlayStateChangeables.bothSide)
					{
						if (boyfriend.curCharacter == 'bf')
							boyfriend.playAnim('sing' + bfsDir[note.noteData] + altAnim, true);
						else
							boyfriend.playAnim('sing' + sDir[note.noteData] + altAnim, true);
						boyfriend.holdTimer = 0;
						if (SONG.song.toLowerCase() == 'switched')
							FlxG.sound.play(Paths.sound('SNAP'));
					}
					else if (note.noteData <= 3)
					{
						boyfriend.playAnim('sing' + sDir[note.noteData] + altAnim, true);
						boyfriend.holdTimer = 0;
						if (SONG.song.toLowerCase() == 'switched')
							FlxG.sound.play(Paths.sound('SNAP'));
					}
					else
					{
						dad.playAnim('sing' + sDir[note.noteData] + altAnim, true);
						dad.holdTimer = 0;

						if (SONG.song.toLowerCase() == 'switched')
							FlxG.sound.play(Paths.sound('SNAP'));
					}

		
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end

					if (note.burning) //fire note
						{
							badNoteHit();
							health -= 0.45;
						}

					else if (note.death) //halo note
						{
							badNoteHit();
							health -= 2.2;
						}
					else if (note.angel) //angel note
						{
							switch(note.rating)
							{
								case "shit": 
									badNoteHit();
									health -= 2;
								case "bad": 
									badNoteHit();
									health -= 0.5;
								case "good": 
									health += 0.5;
								case "sick": 
									health += 1;

							}
						}
					else if (note.bob) //bob note
						{
							HealthDrain();
						}


					if(!loadRep && note.mustPress)
					{
						var array = [note.strumTime,note.sustainLength,note.noteData,noteDiff];
						if (note.isSustainNote)
							array[1] = -1;
						saveNotes.push(array);
						saveJudge.push(note.rating);
					}
					
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});
					
		
					if (!note.isSustainNote)
						{
							if (note.rating == "sick")
								doNoteSplash(note.x, note.y, note.noteData);

							note.kill();
							notes.remove(note, true);
							note.destroy();

						}
						else
						{
							note.wasGoodHit = true;
						}
					
					updateAccuracy();

					if (FlxG.save.data.gracetmr)
						{
							grace = true;
							new FlxTimer().start(0.15, function(tmr:FlxTimer)
							{
								grace = false;
							});
						}
					
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if(FlxG.save.data.distractions){
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if(FlxG.save.data.distractions){
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

/*	public function callOnLuas(event:String, args:Array<Dynamic>):Dynamic {
		/*var returnVal:Dynamic = FunkinLua.Function_Continue;
		for (i in 0...luaArray.length) {
			var ret:Dynamic = luaArray[i].call(event, args);
			if(ret != FunkinLua.Function_Continue) {
				returnVal = ret;
			}
		}
		return returnVal;
	}*/

	function faceRender():Void
		{
			jx = tb_fx;
			if (dside[curr_dial] == -1)
			{
				jx = tb_rx;
			}
			fsprite = new FlxSprite(tb_x + Std.int(tbox.width / 2) + jx, tb_y - tb_fy, Paths.image(fimage));
			fsprite.centerOffsets(true);
			fsprite.antialiasing = true;
			fsprite.updateHitbox();
			fsprite.scrollFactor.set();
			add(fsprite);
		}
		function superShaggy()
		{
			new FlxTimer().start(0.008, function(ct:FlxTimer)
			{
				switch (cutTime)
				{
					case 0:
						camFollow.x = dad.getMidpoint().x - 100;
						camFollow.y = dad.getMidpoint().y;
						camLerp = 2;
					case 15:
						dad.playAnim('power');
					case 48:
						dad.playAnim('idle_s');
						dad.powerup = true;
						burst = new FlxSprite(-1110, 0);
						FlxG.sound.play(Paths.sound('burst'));
						remove(burst);
						burst = new FlxSprite(dad.getMidpoint().x - 1000, dad.getMidpoint().y - 100);
						burst.frames = Paths.getSparrowAtlas('shaggy');
						burst.animation.addByPrefix('burst', "burst", 30);
						burst.animation.play('burst');
						//burst.setGraphicSize(Std.int(burst.width * 1.5));
						burst.antialiasing = true;
						add(burst);
	
						FlxG.sound.play(Paths.sound('powerup'), 1);
					case 62:
						burst.y = 0;
						remove(burst);
					case 95:
						FlxG.camera.angle = 0;
					case 130:
						startCountdown();
				}
	
				var ssh:Float = 45;
				var stime:Float = 30;
				var corneta:Float = (stime - (cutTime - ssh)) / stime;
	
				if (cutTime % 6 >= 3)
				{
					corneta *= -1;
				}
				if (cutTime >= ssh && cutTime <= ssh + stime)
				{
					FlxG.camera.angle = corneta * 5;
				}
				cutTime ++;
				ct.reset(0.008);
			});
		}

	function doNoteSplash(noteX:Float, noteY:Float, nData:Int)
		{
			var recycledNote = noteSplashes.recycle(NoteSplash);
			recycledNote.makeSplash(playerStrums.members[nData].x, playerStrums.members[nData].y, nData);
			noteSplashes.add(recycledNote);
			
		}

	function HealthDrain():Void //code from vs bob
		{
			badNoteHit();
			new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				health -= 0.005;
			}, 300);
		}

	function badNoteHit():Void
		{
			boyfriend.playAnim('hit', true);
			FlxG.sound.play(Paths.soundRandom('badnoise', 1, 3), FlxG.random.float(0.7, 1));
		}

	var justChangedMania:Bool = false;

	public function switchMania(newMania:Int) //i know this is pretty big, but how else am i gonna do this shit
	{
		if (mania == 2) //so it doesnt break the fucking game
		{
			maniaToChange = newMania;
			justChangedMania = true;
			new FlxTimer().start(10, function(tmr:FlxTimer)
				{
					justChangedMania = false; //cooldown timer
				});
			switch(newMania)
			{
				case 10: 
					Note.newNoteScale = 0.7; //fix the note scales pog
				case 11: 
					Note.newNoteScale = 0.6;
				case 12: 
					Note.newNoteScale = 0.5;
				case 13: 
					Note.newNoteScale = 0.65;
				case 14: 
					Note.newNoteScale = 0.58;
				case 15: 
					Note.newNoteScale = 0.55;
				case 16: 
					Note.newNoteScale = 0.7;
				case 17: 
					Note.newNoteScale = 0.7;
				case 18: 
					Note.newNoteScale = 0.7;
			}
	
			strumLineNotes.forEach(function(spr:FlxSprite)
				{
					FlxTween.tween(spr, {alpha: 0}, 0.5, {
						onComplete: function(tween:FlxTween)
						{
							spr.animation.play('static'); //changes to static because it can break the scaling of the static arrows if they are doing the confirm animation
							spr.setGraphicSize(Std.int((spr.width / Note.prevNoteScale) * Note.newNoteScale));
							spr.centerOffsets();
							Note.scaleSwitch = false;
						}
					});
				});
	
			new FlxTimer().start(0.6, function(tmr:FlxTimer)
				{
					cpuStrums.forEach(function(spr:FlxSprite)
						{
							moveKeyPositions(spr, newMania, 0);
						});
					playerStrums.forEach(function(spr:FlxSprite)
						{
							moveKeyPositions(spr, newMania, 1);
						});
				});
	
		}
	}

	function snapCamFollowToPos(x:Float, y:Float) {
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	public function moveCamera(isDad:Bool) {
		if(isDad) {
			camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
		//	camFollow.x += dad.cameraPosition[0];
		//	camFollow.y += dad.cameraPosition[1];
			
			if (dad.curCharacter.startsWith('mom'))
				vocals.volume = 1;

			if (SONG.song.toLowerCase() == 'tutorial')
			{
				tweenCamIn();
			}
		} else {
			camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

			switch (curStage)
			{
				case 'limo':
					camFollow.x = boyfriend.getMidpoint().x - 300;
				case 'mall':
					camFollow.y = boyfriend.getMidpoint().y - 200;
				case 'school' | 'schoolEvil':
					camFollow.x = boyfriend.getMidpoint().x - 200;
					camFollow.y = boyfriend.getMidpoint().y - 200;
			}
		//	camFollow.x -= boyfriend.cameraPosition[0];
		//	camFollow.y += boyfriend.cameraPosition[1];

			if (SONG.song.toLowerCase() == 'tutorial')
			{
				FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
			}
		}
	}

	function moveCameraSection(?id:Int = 0):Void {
		if (SONG.notes[id] != null && camFollow.x != dad.getMidpoint().x + 150 && !SONG.notes[id].mustHitSection)
		{
			if (!PlayStateChangeables.flip)
				moveCamera(true);
			else 
				moveCamera(false);
		//	callOnLuas('onMoveCamera', ['dad']);
		}

		if (SONG.notes[id] != null && SONG.notes[id].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
		{
			if (!PlayStateChangeables.flip)
				moveCamera(false);
			else 
				moveCamera(true);
		//	callOnLuas('onMoveCamera', ['boyfriend']);
		}
	}

	public function moveKeyPositions(spr:FlxSprite, newMania:Int, player:Int):Void //some complex calculations and shit here
	{
		spr.x = 0;
		spr.alpha = 1;
		switch(newMania) //messy piece of shit, i wish there was an easier way to do this, but it has to be done i guess
		{
			case 10: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (160 * 0.7) * 0;
					case 1: 
						spr.x += (160 * 0.7) * 1;
					case 2: 
						spr.x += (160 * 0.7) * 2;
					case 3: 
						spr.x += (160 * 0.7) * 3;
					case 4: 
						spr.alpha = 0;
					case 5: 
						spr.alpha = 0;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.alpha = 0;
				}
			case 11: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (120 * 0.7) * 0;
					case 1: 
						spr.x += (120 * 0.7) * 4;
					case 2: 
						spr.x += (120 * 0.7) * 1;
					case 3: 
						spr.x += (120 * 0.7) * 2;
					case 4: 
						spr.alpha = 0;
					case 5: 
						spr.x += (120 * 0.7) * 3;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.x += (120 * 0.7) * 5;
				}
			case 12: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (95 * 0.7) * 0;
					case 1: 
						spr.x += (95 * 0.7) * 1;
					case 2: 
						spr.x += (95 * 0.7) * 2;
					case 3: 
						spr.x += (95 * 0.7) * 3;
					case 4: 
						spr.x += (95 * 0.7) * 4;
					case 5: 
						spr.x += (95 * 0.7) * 5;
					case 6: 
						spr.x += (95 * 0.7) * 6;
					case 7: 
						spr.x += (95 * 0.7) * 7;
					case 8:
						spr.x += (95 * 0.7) * 8;
				}
				spr.x -= Note.tooMuch;
			case 13: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (130 * 0.7) * 0;
					case 1: 
						spr.x += (130 * 0.7) * 1;
					case 2: 
						spr.x += (130 * 0.7) * 3;
					case 3: 
						spr.x += (130 * 0.7) * 4;
					case 4: 
						spr.x += (130 * 0.7) * 2;
					case 5: 
						spr.alpha = 0;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.alpha = 0;
				}
			case 14: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (110 * 0.7) * 0;
					case 1: 
						spr.x += (110 * 0.7) * 5;
					case 2: 
						spr.x += (110 * 0.7) * 1;
					case 3: 
						spr.x += (110 * 0.7) * 2;
					case 4: 
						spr.x += (110 * 0.7) * 3;
					case 5: 
						spr.x += (110 * 0.7) * 4;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.x += (110 * 0.7) * 6;
				}
			case 15: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (100 * 0.7) * 0;
					case 1: 
						spr.x += (100 * 0.7) * 1;
					case 2: 
						spr.x += (100 * 0.7) * 2;
					case 3: 
						spr.x += (100 * 0.7) * 3;
					case 4: 
						spr.alpha = 0;
					case 5: 
						spr.x += (100 * 0.7) * 4;
					case 6: 
						spr.x += (100 * 0.7) * 5;
					case 7: 
						spr.x += (100 * 0.7) * 6;
					case 8:
						spr.x += (100 * 0.7) * 7;
				}
			case 16: 
				switch(spr.ID)
				{
					case 0: 
						spr.alpha = 0;
					case 1: 
						spr.alpha = 0;
					case 2: 
						spr.alpha = 0;
					case 3: 
						spr.alpha = 0;
					case 4: 
						spr.x += (160 * 0.7) * 0;
					case 5: 
						spr.alpha = 0;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.alpha = 0;
				}
			case 17: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (160 * 0.7) * 0;
					case 1: 
						spr.alpha = 0;
					case 2: 
						spr.alpha = 0;
					case 3: 
						spr.x += (160 * 0.7) * 1;
					case 4: 
						spr.alpha = 0;
					case 5: 
						spr.alpha = 0;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.alpha = 0;
				}
			case 18: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (160 * 0.7) * 0;
					case 1: 
						spr.alpha = 0;
					case 2: 
						spr.alpha = 0;
					case 3: 
						spr.x += (160 * 0.7) * 2;
					case 4: 
						spr.x += (160 * 0.7) * 1;
					case 5: 
						spr.alpha = 0;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.alpha = 0;
				}
		}
		spr.x += 50;
		if (PlayStateChangeables.flip)
			{
				
				switch (player)
				{
					case 0:
						spr.x += ((FlxG.width / 2) * 1); //so flip mode works pog
					case 1:
						spr.x += ((FlxG.width / 2) * 0);
				}
			}
		else
			spr.x += ((FlxG.width / 2) * player);
	}
	

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		if(FlxG.save.data.distractions){
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if(FlxG.save.data.distractions){
			if (trainSound.time >= 4700)
				{
					startedMoving = true;
					gf.playAnim('hairBlow');
				}
		
				if (startedMoving)
				{
					phillyTrain.x -= 400;
		
					if (phillyTrain.x < -2000 && !trainFinishing)
					{
						phillyTrain.x = -1150;
						trainCars -= 1;
		
						if (trainCars <= 0)
							trainFinishing = true;
					}
		
					if (phillyTrain.x < -4000 && trainFinishing)
						trainReset();
				}
		}

	}

	var reducedDrain:Float = 4;

	/*function fakeshock() {
		psyshockParticle.setPosition(dad.x, dad.y);
		psyshockParticle.playAnim("psyshock particle", true);
		psyshockParticle.alpha = 1;
		psyshockParticle.animation.finishCallback = function (lol:String) {
			psyshockParticle.alpha = 0;
		};
		tranceDeathScreen.alpha += 0.1;
		tranceCanKill = false;
		FlxG.sound.play(Paths.sound('Psyshock', 'shared'), 1);
		if (FlxG.save.data.flashing)
			camHUD.flash(FlxColor.fromString('0xFFFFAFC1'), 1, null, true);
	}*/

	function trainReset():Void
	{
		if(FlxG.save.data.distractions){
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	function doStopSign(sign:Int = 0, fuck:Bool = false)
		{
			trace('sign ' + sign);
			var daSign:FlxSprite = new FlxSprite(0,0);
			// CachedFrames.cachedInstance.get('sign')
	
			daSign.frames = Paths.getSparrowAtlas('fourth/mech/Sign_Post_Mechanic', 'shared');
	
			daSign.setGraphicSize(Std.int(daSign.width * 0.67));
	
			daSign.cameras = [camNotes];
	
			switch(sign)
			{
				case 0:
					daSign.animation.addByPrefix('sign','Signature Stop Sign 1',24, false);
					daSign.x = FlxG.width - 650;
					daSign.angle = -90;
					daSign.y = -300;
				case 1:
					/*daSign.animation.addByPrefix('sign','Signature Stop Sign 2',20, false);
					daSign.x = FlxG.width - 670;
					daSign.angle = -90;*/ // this one just doesn't work???
				case 2:
					daSign.animation.addByPrefix('sign','Signature Stop Sign 3',24, false);
					daSign.x = FlxG.width - 780;
					daSign.angle = -90;
					if (FlxG.save.data.downscroll)
						daSign.y = -395;
					else
						daSign.y = -980;
				case 3:
					daSign.animation.addByPrefix('sign','Signature Stop Sign 4',24, false);
					daSign.x = FlxG.width - 1070;
					daSign.angle = -90;
					daSign.y = -145;
			}
			add(daSign);
			daSign.flipX = fuck;
			daSign.animation.play('sign');
			daSign.animation.finishCallback = function(pog:String)
				{
					trace('ended sign');
					remove(daSign);
				}
		}

		function doGremlin(hpToTake:Int, duration:Int,persist:Bool = false)
			{
				interupt = false;
		
				grabbed = true;
				
				totalDamageTaken = 0;
		
				var gramlan:FlxSprite = new FlxSprite(0,0);
		
				gramlan.frames = Paths.getSparrowAtlas('fourth/mech/HP GREMLIN', 'shared');
		
				gramlan.setGraphicSize(Std.int(gramlan.width * 0.76));
		
				gramlan.cameras = [camHUD];
		
				gramlan.x = iconP1.x;
				gramlan.y = healthBarBG.y - 325;
		
				gramlan.animation.addByIndices('come','HP Gremlin ANIMATION',[0,1], "", 24, false);
				gramlan.animation.addByIndices('grab','HP Gremlin ANIMATION',[2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24], "", 24, false);
				gramlan.animation.addByIndices('hold','HP Gremlin ANIMATION',[25,26,27,28],"",24);
				gramlan.animation.addByIndices('release','HP Gremlin ANIMATION',[29,30,31,32,33],"",24,false);
		
				gramlan.antialiasing = true;
		
				add(gramlan);
		
				if(FlxG.save.data.downscroll){
					gramlan.flipY = true;
					gramlan.y -= 150;
				}
				
				// over use of flxtween :)
		
				var startHealth = health;
				var toHealth = (hpToTake / 100) * startHealth; // simple math, convert it to a percentage then get the percentage of the health
		
				var perct = toHealth / 2 * 100;
		
				trace('start: $startHealth\nto: $toHealth\nwhich is prect: $perct');
		
				var onc:Bool = false;
		
				FlxG.sound.play(Paths.sound('fourth/GremlinWoosh','shared'));
		
				gramlan.animation.play('come');
				new FlxTimer().start(0.14, function(tmr:FlxTimer) {
					gramlan.animation.play('grab');
					FlxTween.tween(gramlan,{x: iconP1.x - 140},1,{ease: FlxEase.elasticIn, onComplete: function(tween:FlxTween) {
						trace('I got em');
						gramlan.animation.play('hold');
						FlxTween.tween(gramlan,{
							x: (healthBar.x + 
							(healthBar.width * (FlxMath.remapToRange(perct, 0, 100, 100, 0) * 0.01) 
							- 26)) - 75}, duration,
						{
							onUpdate: function(tween:FlxTween) { 
								// lerp the health so it looks pog
								if (interupt && !onc && !persist)
								{
									onc = true;
									trace('oh shit');
									gramlan.animation.play('release');
									gramlan.animation.finishCallback = function(pog:String) { gramlan.alpha = 0;}
								}
								else if (!interupt || persist)
								{
									var pp = FlxMath.lerp(startHealth,toHealth, tween.percent);
									if (pp <= 0)
										pp = 0.1;
									health = pp;
								}
		
								if (shouldBeDead)
									health = 0;
							},
							onComplete: function(tween:FlxTween)
							{
								if (interupt && !persist)
								{
									remove(gramlan);
									grabbed = false;
								}
								else
								{
									trace('oh shit');
									gramlan.animation.play('release');
									if (persist && totalDamageTaken >= 0.7)
										health -= totalDamageTaken; // just a simple if you take a lot of damage wtih this, you'll loose probably.
									gramlan.animation.finishCallback = function(pog:String) { remove(gramlan);}
									grabbed = false;
								}
							}
						});
					}});
				});
			}

	var danced:Bool = false;

	var stepOfLast = 0;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end

		if (curStage == 'auditorHell' && curStep != stepOfLast)
			{
				switch(curStep)
				{
					case 384:
						doStopSign(0);
					case 511:
						doStopSign(2);
						doStopSign(0);
					case 610:
						doStopSign(3);
					case 720:
						doStopSign(2);
					case 991:
						doStopSign(3);
					case 1184:
						doStopSign(2);
					case 1218:
						doStopSign(0);
					case 1235:
						doStopSign(0, true);
					case 1200:
						doStopSign(3);
					case 1328:
						doStopSign(0, true);
						doStopSign(2);
					case 1439:
						doStopSign(3, true);
					case 1567:
						doStopSign(0);
					case 1584:
						doStopSign(0, true);
					case 1600:
						doStopSign(2);
					case 1706:
						doStopSign(3);
					case 1917:
						doStopSign(0);
					case 1923:
						doStopSign(0, true);
					case 1927:
						doStopSign(0);
					case 1932:
						doStopSign(0, true);
					case 2032:
						doStopSign(2);
						doStopSign(0);
					case 2036:
						doStopSign(0, true);
					case 2128:
				//		hexErrorSwitch();
					case 2144:
			//			hexErrorSwitch(false);
					case 2162:
						doStopSign(2);
						doStopSign(3);
					case 2193:
						doStopSign(0);
					case 2202:
						doStopSign(0,true);
					case 2239:
						doStopSign(2,true);
					case 2258:
						doStopSign(0, true);
					case 2304:
						doStopSign(0, true);
						doStopSign(0);	
					case 2326:
						doStopSign(0, true);
					case 2336:
						doStopSign(3);
					case 2447:
						doStopSign(2);
						doStopSign(0, true);
						doStopSign(0);	
					case 2480:
						doStopSign(0, true);
						doStopSign(0);	
					case 2512:
						doStopSign(2);
						doStopSign(0, true);
						doStopSign(0);
					case 2544:
						doStopSign(0, true);
						doStopSign(0);	
					case 2575:
						doStopSign(2);
						doStopSign(0, true);
						doStopSign(0);
					case 2608:
						doStopSign(0, true);
						doStopSign(0);	
					case 2604:
						doStopSign(0, true);
					case 2655:
						doGremlin(20,13,true);
				}
				stepOfLast = curStep;
			}
	
			/*if (SONG.song == 'Termination')
				{
					switch(curStep)
					{
						case 384:
							doStopSign(0);
						case 511:
							doStopSign(2);
							doStopSign(0);
						case 610:
							doStopSign(3);
						case 720:
							doStopSign(2);
						case 991:
							doStopSign(3);
						case 1184:
							doStopSign(2);
						case 1218:
							doStopSign(0);
						case 1235:
							doStopSign(0, true);
						case 1200:
							doStopSign(3);
						case 1328:
							doStopSign(0, true);
							doStopSign(2);
						case 1439:
							doStopSign(3, true);
						case 1567:
							doStopSign(0);
						case 1584:
							doStopSign(0, true);
						case 1600:
							doStopSign(2);
						case 1706:
							doStopSign(3);
						case 1917:
							doStopSign(0);
						case 1923:
							doStopSign(0, true);
						case 1927:
							doStopSign(0);
						case 1932:
							doStopSign(0, true);
						case 2032:
							doStopSign(2);
							doStopSign(0);
						case 2036:
							doStopSign(0, true);
						case 2162:
							doStopSign(2);
							doStopSign(3);
						case 2193:
							doStopSign(0);
						case 2202:
							doStopSign(0,true);
						case 2239:
							doStopSign(2,true);
						case 2258:
							doStopSign(0, true);
						case 2304:
							doStopSign(0, true);
							doStopSign(0);	
						case 2326:
							doStopSign(0, true);
						case 2336:
							doStopSign(3);
						case 2447:
							doStopSign(2);
							doStopSign(0, true);
							doStopSign(0);	
						case 2480:
							doStopSign(0, true);
							doStopSign(0);	
						case 2512:
							doStopSign(2);
							doStopSign(0, true);
							doStopSign(0);
						case 2544:
							doStopSign(0, true);
							doStopSign(0);	
						case 2575:
							doStopSign(2);
							doStopSign(0, true);
							doStopSign(0);
						case 2608:
							doStopSign(0, true);
							doStopSign(0);	
						case 2604:
							doStopSign(0, true);
						case 2655:
					//		doGremlin(20,13,true);
						case 2800:
							FlxG.save.data.terminationUnlocked = true; //sneak peek for new hex vs whitty update. :)
					}
					stepOfLast = curStep;
				}*/

		if (SONG.song.toLowerCase() == "paradoxial" && curStep != stepOfLast && storyDifficulty == 2)
			{
				switch (curStep)
				{
					case 1270:
						if (!FlxG.save.data.p_maskGot[4]) {
							maskObj.y -= 500;
							FlxTween.tween(maskObj, {alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
						}
				}
			}

		if (SONG.song.toLowerCase() == "tutorial" && curStep != stepOfLast && storyDifficulty == 2) //song events
			{
				switch(curStep) //guide for anyone looking at this, switching mid song needs to be mania + 10
				{
					case 56: //switched it to modcharts! (can still be hardcoded though)
						//2 key
						//switchMania(17);
					case 125: 
						//4 key
						//switchMania(10);
					case 189: 
						//6 key
						//switchMania(11);
					case 252: 
						//8 key
						//switchMania(15);
					case 323: 
						//9 key
						//switchMania(12);
					case 390: 
						//4 key
						//switchMania(10);
					case 410: 
						//9 key
						//switchMania(12);
				}
			}

		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end
		if (songName != null)
			songName.text = SONG.song + ' | Time Left: ' + timeTxt + ' or ' + Std.string(songLength - Conductor.songPosition);
		else 
			trace('something is wrong');
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;



	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (PlayStateChangeables.useDownscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		switch (SONG.song.toLowerCase())
		{
			case 'live-on':
				switch (curBeat) {
					case 28:
						FlxTween.tween(healthBar, {alpha: 0.4}, 3, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0.4}, 3, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 0.4}, 3, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 1}, 3, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 1}, 3, {ease: FlxEase.linear});
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 0.7}, 3, {ease: FlxEase.linear});
						}
					case 392:
						dad.debugMode = true;
					//	dad.playAnim('fadeOut', true);
						FlxTween.tween(healthBar, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(healthBarBG, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(scoreTxt, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(iconP1, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.linear});
						for (i in playerStrums) {
							FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.linear});
						}
					case 224:
						/*if (ClientPrefs.hellMode)
							startUnown(16, 'abcdefghijklmnopqrstuvwxyz');
						else
							startUnown(8);*/
					case 232:
						/*if (!ClientPrefs.hellMode)
							startUnown(8);*/
				}
		}
		if (currentSection != null)
		{
			if (!currentSection.mustHitSection)
			{
				switch (PlayStateChangeables.randomMania)
				{
					case 1: 
						var randomNum = FlxG.random.int(10, 15);
						if (FlxG.random.bool(0.5) && !justChangedMania)
						{
							switchMania(randomNum);
						}
					case 2: 
						var randomNum = FlxG.random.int(10, 15);
						if (FlxG.random.bool(5) && !justChangedMania)
						{
							switchMania(randomNum);
						}
					case 3: 
						var randomNum = FlxG.random.int(10, 15);
						if (FlxG.random.bool(15) && !justChangedMania)
						{
							switchMania(randomNum);
						}
				}
			}
			if (currentSection.changeBPM)
			{
				Conductor.changeBPM(currentSection.bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (dad.animation.curAnim.name.startsWith("sing") && dad.curCharacter != 'gf')
			{
				dad.dance();
		///		if (exDad)
		//		{
		//			dad2.dance();
		//		}
			}

			//Dad2 doesn't interupt his own notes
			if (exDad) {
			if (dad2.animation.curAnim.name.startsWith("sing"))
				dad2.dance();
		}
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (FlxG.save.data.camzoom)
		{
			// HARDCODING FOR MILF ZOOMS!
			if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
	
			switch (curSong.toLowerCase()) 
			{
				case 'talladega':
					if (camZooming && FlxG.camera.zoom < 1.35 && ClientPrefs.camZooms && curBeat % 3 == 0)
						{
							FlxG.camera.zoom += 0.015;
							camHUD.zoom += 0.03;
						}
				default:
					if (camZooming && FlxG.camera.zoom < 1.35 && ClientPrefs.camZooms && curBeat % 4 == 0)
						{
							FlxG.camera.zoom += 0.015;
							camHUD.zoom += 0.03;
						}
			}
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));
			
		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.dance();
		}
		

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

		switch (curStage)
		{
			case 'school':
				if(FlxG.save.data.distractions){
					bgGirls.dance();
				}

			case 'mall':
				if(FlxG.save.data.distractions){
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);
				}

			case 'limo':
				if(FlxG.save.data.distractions){
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
						{
							dancer.dance();
						});
		
						if (FlxG.random.bool(10) && fastCarCanDrive)
							fastCarDrive();
				}
			case "philly":
				if(FlxG.save.data.distractions){
					if (!trainMoving)
						trainCooldown += 1;
	
					if (curBeat % 4 == 0)
					{
						phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});
	
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
	
						phillyCityLights.members[curLight].visible = true;
						// phillyCityLights.members[curLight].alpha = 1;
				}

				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					if(FlxG.save.data.distractions){
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if(FlxG.save.data.distractions){
				lightningStrikeShit();
			}
		}
	}

	public function lgCutscene()
		{
			new FlxTimer().start(0.002, function(tmr:FlxTimer)
			{
				switch (cs_time)
				{
					case 0:
						if (!cs_wait)
						{
							textIndex = 'upd/4-1';
							schoolIntro(0);
							cs_wait = true;
							cs_reset = true;
						}	
					case 40:
						FlxG.sound.play(Paths.sound('exit'));
						doorFrame.alpha = 1;
						doorFrame.y -= 110;
						toDfS = 600;
					case 200:
						if (!cs_wait)
						{
							textIndex = 'upd/4-2';
							schoolIntro(0);
							cs_wait = true;
							cs_reset = true;
						}
					case 480:
						FlxG.sound.play(Paths.sound('exit'));
						toDfS = 1;
					case 720:
						var video:MP4Handler = new MP4Handler();
	
						video.playMP4(Paths.video('zoinks'));
						video.finishCallback = function()
						{
							endSong();
						}
				}
				if (cs_time > 220)
				{
					dad.alpha -= 0.004;
				}
				if (!cs_wait)
				{
					cs_time ++;
				}
				dfS += (toDfS - dfS) / 18;
				doorFrame.setGraphicSize(Std.int(dfS));
				tmr.reset(0.002);
			});
		}

	public function csDial(puta:String)
		{
			textIndex  = 'cs/' + puta;
		}

	var curLight:Int = 0;
}

class Pendulum extends FlxSprite //definitely not stolen from hypno
{
	public var daTween:FlxTween;
	public function new()
	{
		super();
		daTween = FlxTween.tween(this, {x: this.x}, 0.001, {});
	}
}