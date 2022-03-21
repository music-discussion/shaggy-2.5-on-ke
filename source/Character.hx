package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;
import Section.SwagSection;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end
import openfl.utils.Assets;
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

typedef CharacterFile = {
	var animations:Array<AnimArray>;
	var image:String;
	var scale:Float;
	var sing_duration:Float;
	var healthicon:String;

	var position:Array<Float>;
	var camera_position:Array<Float>;

	var flip_x:Bool;
	var no_antialiasing:Bool;
	var healthbar_colors:Array<Int>;
}

typedef AnimArray = {
	var anim:String;
	var name:String;
	var fps:Int;
	var loop:Bool;
	var indices:Array<Int>;
	var offsets:Array<Int>;
}

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	public var powerup:Bool = false;
	public var isPlayingAsBF:Bool;
	public var healthbar_colors:Array<Int>;

	public var specialAnim:Bool;
	public var heyTimer:Float;
	public var healthIcon:String = 'face';

	public var idleSuffix:String = '';
	public var danceIdle:Bool = false; //Character use "danceLeft" and "danceRight" instead of "idle"
	public var positionArray:Array<Float> = [0, 0];

	public var colorTween:FlxTween;
	public var animationNotes:Array<Dynamic> = [];
	public var singDuration:Float = 4; //Multiplier of how long a character holds the sing pose

	public var animationsArray:Array<AnimArray> = [];
	public var cameraPosition:Array<Float> = [0, 0];

	//Used on Character Editor
	public var imageFile:String = '';
	public var jsonScale:Float = 1;
	public var noAntialiasing:Bool = false;
	public var originalFlipX:Bool = false;
	public var healthColorArray:Array<Int> = [255, 0, 0];

	public static var DEFAULT_CHARACTER:String = 'bf'; //In case a character is missing, it will use BF on its place

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		isPlayingAsBF = !FlxG.save.data.flip;

		var tex:FlxAtlasFrames;
		antialiasing = FlxG.save.data.antialiasing;

		healthIcon = curCharacter;

		trace(curCharacter);

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-christmas':
				// MINI GIANT GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/minigiantgf');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-car':
				// VERY TALL GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/verytallgf');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'gf-tied':
				tex = Paths.getSparrowAtlas('characters/EX Tricky GF','shared');
				frames = tex;

				trace(frames.frames.length);

				animation.addByIndices('danceLeft','GF Ex Tricky',[0,1,2,3,4,5,6,7,8], "", 24, false);
				animation.addByIndices('danceRight','GF Ex Tricky',[9,10,11,12,13,14,15,16,17,18,19], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				trace(animation.curAnim);
			
			case 'verytallgf':
				// VERY TALL GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/verytallgf');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
			
			case 'minigiantgf':
				// MINI GIANT GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/minigiantgf');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
			case 'spooky':
				tex = Paths.getSparrowAtlas('characters/spooky_kids_assets');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);

				playAnim('danceRight');
			case 'mom':
				tex = Paths.getSparrowAtlas('characters/Mom_Assets');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('characters/momCar');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('characters/Monster_Assets');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -30, -40);
				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('characters/monsterChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);
				playAnim('idle');
			case 'pico':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				addOffset("singUPmiss", -19, 67);
				addOffset("singRIGHTmiss", -60, 41);
				addOffset("singLEFTmiss", 62, 64);
				addOffset("singDOWNmiss", 210, -28);

				playAnim('idle');

				flipX = true;

			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('singHey', 'BF HEY', 24, false);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset("singHey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('characters/bfChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('singHey', 'BF HEY', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset("singHey", 7, 4);

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				var tex = Paths.getSparrowAtlas('characters/bfCar');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				playAnim('idle');

				flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/bfPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'senpai':
				frames = Paths.getSparrowAtlas('characters/senpai');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters/senpai');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				frames = Paths.getPackerAtlas('characters/spirit');
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				addOffset('idle', -220, -280);
				addOffset('singUP', -220, -240);
				addOffset("singRIGHT", -220, -280);
				addOffset("singLEFT", -200, -280);
				addOffset("singDOWN", 170, 110);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets');
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				addOffset('idle');
				addOffset("singUP", -47, 24);
				addOffset("singRIGHT", -1, -23);
				addOffset("singLEFT", -30, 16);
				addOffset("singDOWN", -31, -29);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);

				playAnim('idle');
			
			// SHAGGY CHARACTERS!!!!!!!!!!!!!!!!!!!!

			case 'matt':
				tex = Paths.getSparrowAtlas('characters/matt', 'shared');
				if (Main.god) tex = Paths.getSparrowAtlas('characters/god_matt', 'shared');
				
				frames = tex;

				animation.addByPrefix('idle', "matt idle", 24, false);
				animation.addByPrefix('singUP', "matt up new", 24, false);
				animation.addByPrefix('singDOWN', "matt down new", 24, false);
				animation.addByPrefix('singLEFT', 'matt left new', 24, false);
				animation.addByPrefix('singRIGHT', 'matt right new', 24, false);

				animation.addByPrefix('singUPmiss', "matt up miss", 24, false);
				animation.addByPrefix('singDOWNmiss', "matt down miss", 24, false);
				animation.addByPrefix('singLEFTmiss', 'matt left miss', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'matt right miss', 24, false);

				addOffset('idle', 0, 70);

				addOffset("singUP", -5, 80);
				addOffset("singRIGHT", -47, 18);
				addOffset("singLEFT", 180, 19);
				addOffset("singDOWN", 64, -20);

				if (isPlayer)
				{
					addOffset("singUP", 15, 80);
					addOffset("singLEFT", 139, 21);
					addOffset("singRIGHT", -52, 27);
					addOffset("singDOWN", 87, -16);
				}
				addOffset("singUPmiss", 8, 80);
				addOffset("singLEFTmiss", 153, 26);
				addOffset("singRIGHTmiss", -23, 23);
				addOffset("singDOWNmiss", 75, -14);

				if (Main.god)
				{
					animation.addByPrefix('singUP', "matt up note", 24, false);
					animation.addByPrefix('singDOWN', "matt down note", 24, false);
					animation.addByPrefix('singLEFT', 'matt left note', 24, false);
					animation.addByPrefix('singRIGHT', 'matt right note', 24, false);
					
					addOffset('idle', 0, 0);
					addOffset("singUP", -105, 136);
					addOffset("singRIGHT", -133, -51);
					addOffset("singLEFT", 86, -23);
					addOffset("singDOWN", -111, 8);
				}

				playAnim('idle');
			case 'shaggy':
				tex = Paths.getSparrowAtlas('characters/shaggy', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'shaggy_idle0', 30);
				animation.addByPrefix('idle2', 'shaggy_idle2', 30);
				animation.addByPrefix('idle_s', 'shaggy_super_idle0', 30);
				animation.addByPrefix('singUP', 'shaggy_up', 30);
				animation.addByPrefix('singRIGHT', 'shaggy_right', 30);
				animation.addByPrefix('singDOWN', 'shaggy_down', 30); //god why does shaggy have so many animations
				animation.addByPrefix('singLEFT', 'shaggy_left', 30);

				animation.addByPrefix('powerup', 'shaggy_powerup', 24);
				animation.addByPrefix('catch', 'shaggy_catch', 30);
				animation.addByPrefix('hold', 'shaggy_hold', 30);

				animation.addByPrefix('h_half', 'shaggy_h_half', 30);
				animation.addByPrefix('fall', 'shaggy_fall', 30);
				animation.addByPrefix('kneel', 'shaggy_half_ground', 30);

				addOffset('idle');
				addOffset('idle2');
				addOffset('idle_s');
				addOffset("singUP", -16, 27);
				addOffset("singRIGHT", -1, -28);
				addOffset("singLEFT", 165, -114);
				addOffset("singDOWN", -10, -160);

				addOffset('powerup');
				addOffset("catch", 140, 90);
				addOffset("hold", 90, 100);

				addOffset("h_half", 90, 0);
				addOffset("fall", 130, 0);
				addOffset("kneel", 110, -123);

				healthbar_colors = [
					51,
					114,
					74
				];

				playAnim('idle');
			
			case 'scooby':
				tex = Paths.getSparrowAtlas('scooby');
				frames = tex;
				animation.addByPrefix('walk', 'scoob_walk', 30, false);
				animation.addByPrefix('idle', 'scoob_idle', 30, false);
				animation.addByPrefix('scare', 'scoob_scare', 24, false);
				animation.addByPrefix('blur', 'scoob_blur', 30, false);
				animation.addByPrefix('half', 'scoob_half', 30, false);
				animation.addByPrefix('fall', 'scoob_fall', 30, false);

				addOffset("walk", 100, 60);
				addOffset("idle");
				addOffset("scare", 40);
				addOffset("blur");
				addOffset("half");
				addOffset("fall", 420, 0);

				playAnim('walk', true);

				case 'god_shaggy':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/god_shaggy', 'shared');

				frames = tex;
				animation.addByPrefix('idle', 'shaggy_idle', 24);
				animation.addByPrefix('idle2', 'shaggy_idle2', 24);
				animation.addByPrefix('singUP', 'shaggy_up', 30);
				animation.addByPrefix('singRIGHT', 'shaggy_right', 30);
				animation.addByPrefix('singDOWN', 'shaggy_down', 30);
				animation.addByPrefix('singLEFT', 'shaggy_left', 30);

				addOffset('idle');
				addOffset('idle2');
				addOffset("singUP", -6, 0);
				addOffset("singRIGHT", -20, -40);
				addOffset("singLEFT", 100, -120);
				addOffset("singDOWN", 0, -170);

			//	if (Main.god)
			//	{
					animation.addByPrefix('idle', 'shaggy_idle', 60);
					animation.addByPrefix('idle2', 'shaggy_idle2', 60);
			//	}

				playAnim('idle');

			case 'sshaggy':
			// SSHAGGY ANIMATION LOADING CODE
			tex = Paths.getSparrowAtlas('characters/shaggy', 'shared');
			frames = tex;
			animation.addByPrefix('idle2', 'shaggy_idle2', 15);
			animation.addByPrefix('idle', 'shaggy_super_idle0', 15);
			animation.addByPrefix('singUP', 'shaggy_sup0', 15);
			animation.addByPrefix('singRIGHT', 'shaggy_sright', 15);
			animation.addByPrefix('singDOWN', 'shaggy_sdown', 15); //god why does sshaggy have so many animations
			animation.addByPrefix('singLEFT', 'shaggy_sleft', 15);

			addOffset('idle');
			addOffset('idle2');
			addOffset("singUP", -16, 27);
			addOffset("singRIGHT", -1, -28);
			addOffset("singLEFT", 165, -114);
			addOffset("singDOWN", -10, -160);

			healthbar_colors = [
				51,
				114,
				74
			];

			playAnim('idle');

				case 'pshaggy':
					tex = Paths.getSparrowAtlas('characters/pshaggy', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'pshaggy_idle', 7, false);
				animation.addByPrefix('singUP', 'pshaggy_up', 28, false);
				animation.addByPrefix('singDOWN', 'pshaggy_down', 28, false);
				animation.addByPrefix('singLEFT', 'pshaggy_left', 28, false);
				animation.addByPrefix('singRIGHT', 'pshaggy_right', 28, false);
				animation.addByPrefix('back', 'pshaggy_back', 28, false);
				animation.addByPrefix('snap', 'pshaggy_snap', 7, false);
				animation.addByPrefix('snapped', 'pshaggy_did_snap', 28, false);
				animation.addByPrefix('smile', 'pshaggy_smile', 7, false);
				animation.addByPrefix('stand', 'pshaggy_stand', 7, false);

				addOffset("idle");
				addOffset("smile");
				var sOff = 20;
				addOffset("back", 0, -20 + sOff);
				addOffset("stand", 0, -20 + sOff);
				addOffset("snap", 10, 72 + sOff);
				addOffset("snapped", 0, 60 + sOff);
				addOffset("singUP", -6, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 10, 0);
				addOffset("singDOWN", 60, -100);

				playAnim('idle', true);
			
			case 'rshaggy':
				// 	RSHAGGY ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/shaggy_red', 'shared');
				frames = tex;
				animation.addByPrefix('idle2', 'shaggy_idle2', 30);
				animation.addByPrefix('idle', 'shaggy_idle0', 30);
				animation.addByPrefix('singUP', 'shaggy_up', 30);
				animation.addByPrefix('singRIGHT', 'shaggy_right', 30);
				animation.addByPrefix('singDOWN', 'shaggy_down', 30); //god why does sshaggy have so many animations
				animation.addByPrefix('singLEFT', 'shaggy_left', 30);

				animation.addByPrefix('standUP', 'shaggy_stand0', 30);
				animation.addByPrefix('sit', 'shaggy_sit0', 30);

				addOffset('idle');
				addOffset("idle2", -1, 0);
				addOffset("singUP", -16, 27);
				addOffset("singRIGHT", -1, -43);
				addOffset("singLEFT", 165, -114);
				addOffset("singDOWN", -10, -160);

				addOffset("sit", 29, -218);
				addOffset("standUP", 33, 0);

				healthbar_colors = [
					209,
					26,
					26
				];
			case 'wbshaggy':
				// WBSHAGGY ANIMATION LOADING CODE
			tex = Paths.getSparrowAtlas('characters/shaggy_green', 'shared');
			frames = tex;
			animation.addByPrefix('idle', 'b_Idle', 24);
			animation.addByPrefix('singUP', 'b_Up', 24);
			animation.addByPrefix('singRIGHT', 'b_Right', 24);
			animation.addByPrefix('singDOWN', 'b_Down', 24); //god why does sshaggy have so many animations
			animation.addByPrefix('singLEFT', 'b_Left', 30);

			addOffset('idle');
			addOffset("singUP", -16, 115);
			addOffset("singRIGHT", 119, -106);
			addOffset("singLEFT", 131, -94);
			addOffset("singDOWN", 104, -140);

			healthbar_colors = [
				0,
				0,
				0,
			];

			playAnim('idle');

			case 'zshaggy':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/shaggy_phantom', 'shared');
				frames = tex;

			animation.addByPrefix('idle', 'phantom_idle0', 24);
			animation.addByPrefix('singUP', 'phantom_up', 24);
			animation.addByPrefix('singRIGHT', 'phantom_right', 24);
			animation.addByPrefix('singDOWN', 'phantom_down', 24); //god why does sshaggy have so many animations
			animation.addByPrefix('singLEFT', 'phantom_left', 24);

			addOffset('idle');
			addOffset("singUP", 87, 257);
			addOffset("singRIGHT", 34, -98);
			addOffset("singLEFT", 344, -49);
			addOffset("singDOWN", 106, -196);

			healthbar_colors = [
				20,
				72,
				0
			];

			playAnim('idle');

			case 'zsonic':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/sonic_phantom', 'shared');
				frames = tex;

			animation.addByPrefix('idle', 'phantom_idle0', 24);
			animation.addByPrefix('singUP', 'phantom_up', 24);
			animation.addByPrefix('singRIGHT', 'phantom_right', 24);
			animation.addByPrefix('singDOWN', 'phantom_down', 24); //god why does sshaggy have so many animations
			animation.addByPrefix('singLEFT', 'phantom_left', 24);

			addOffset('idle');
			addOffset("singUP", 87, 257);
			addOffset("singRIGHT", 34, -98);
			addOffset("singLEFT", 344, -49);
			addOffset("singDOWN", 106, -196);

			healthbar_colors = [
				20,
				72,
				0
			];

			playAnim('idle');

			case 'bshaggy':
				tex = Paths.getSparrowAtlas('characters/shaggy_bugged', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'shaggy_idle0', 30);
				animation.addByPrefix('idle2', 'shaggy_idle2', 30);
				animation.addByPrefix('idle_s', 'shaggy_super_idle0', 30);
				animation.addByPrefix('singUP', 'shaggy_up', 30);
				animation.addByPrefix('singRIGHT', 'shaggy_right', 30);
				animation.addByPrefix('singDOWN', 'shaggy_down', 30); //god why does shaggy have so many animations
				animation.addByPrefix('singLEFT', 'shaggy_left', 30);

				animation.addByPrefix('powerup', 'shaggy_powerup', 24);
				animation.addByPrefix('catch', 'shaggy_catch', 30);
				animation.addByPrefix('hold', 'shaggy_hold', 30);

				animation.addByPrefix('h_half', 'shaggy_h_half', 30);
				animation.addByPrefix('fall', 'shaggy_fall', 30);
				animation.addByPrefix('kneel', 'shaggy_half_ground', 30);

				addOffset('idle');
				addOffset('idle2');
				addOffset('idle_s');
				addOffset("singUP", -16, 27);
				addOffset("singRIGHT", -1, -28);
				addOffset("singLEFT", 165, -114);
				addOffset("singDOWN", -10, -160);

				addOffset('powerup');
				addOffset("catch", 140, 90);
				addOffset("hold", 90, 100);

				addOffset("h_half", 90, 0);
				addOffset("fall", 130, 0);
				addOffset("kneel", 110, -123);

				healthbar_colors = [
					51,
					114,
					74
				];

				playAnim('idle');

			case 'ronald':
			// SSHAGGY ANIMATION LOADING CODE
			tex = Paths.getSparrowAtlas('characters/workgoddamn', 'shared');
			frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -30, -40);
				playAnim('idle');

			healthbar_colors = [
				51,
				114,
				74
			];

			playAnim('idle');

			case 'bf-luigi':
				var tex = Paths.getSparrowAtlas('characters/luigi_assets', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('singHey', 'BF HEY', 24, false);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset("singHey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'dshaggy':
				tex = Paths.getSparrowAtlas('characters/Lost Silver Assets Gold', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Silver Idle', 24, false);
				animation.addByPrefix('singUP', 'Full Silver Up', 24, false);
				animation.addByPrefix('singDOWN', 'Silver Down Full', 24, false);
				animation.addByPrefix('singLEFT', 'Lost Silver Left finished', 24, false);
				animation.addByPrefix('singRIGHT', 'Silver Right Finished', 24, false);

				addOffset('idle');
				addOffset("singUP", -3, 181);
				addOffset("singRIGHT", -96, 91);
				addOffset("singLEFT",619, 126);
				addOffset("singDOWN", 11, -348);

				addOffset('fadeIn');
				addOffset('fadeOut');
				
				playAnim('idle');

			healthbar_colors = [
				51,
				114,
				74
			];

			playAnim('idle');

			case 'spamton':
				tex = Paths.getSparrowAtlas('characters/shaggy_spamton', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'phantom_idle0', 24, false);
				animation.addByPrefix('singUP', 'phantom_up', 24, false);
				animation.addByPrefix('singDOWN', 'phantom_down', 24, false);
				animation.addByPrefix('singLEFT', 'phantom_left', 24, false);
				animation.addByPrefix('singRIGHT', 'phantom_right', 24, false);

				addOffset('idle');
				addOffset("singUP", 87, 207);
				addOffset("singRIGHT", 34, -98);
				addOffset("singLEFT", 346, -71);
				addOffset("singDOWN", 106, -196);
				
				playAnim('idle');

				healthbar_colors = [
					51,
					51,
					51
				];
			case 'exTricky':
				frames = Paths.getSparrowAtlas('characters/EXTRICKY','shared');
			//	exSpikes = new FlxSprite(x - 350,y - 170);
			//	exSpikes.frames = Paths.getSparrowAtlas('fourth/FloorSpikes','clown');
			//	exSpikes.visible = false;

			//	exSpikes.animation.addByPrefix('spike','Floor Spikes', 24, false);

				animation.addByPrefix('idle', 'Idle', 24);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('Hank', 'Hank', 24, true);

				addOffset('idle');
				addOffset('Hank');
				addOffset("singUP", 0, 100);
				addOffset("singRIGHT", -209,-29);
				addOffset("singLEFT",127,20);
				addOffset("singDOWN",-100,-340);

				playAnim('idle');
			default:
				var characterPath:String = 'characters/' + curCharacter + '.json';
				var path:String = Paths.getShaggyPreloadPath(characterPath);
				if (!Assets.exists(path))
				{
					path = Paths.getShaggyPreloadPath('characters/' + DEFAULT_CHARACTER + '.json'); //If a character couldn't be found, change him to BF just to prevent a crash
				}


				var rawJson = Assets.getText(path);

				var json:CharacterFile = cast Json.parse(rawJson);
				if(Assets.exists(Paths.getPsychPath('images/' + json.image + '.txt', TEXT))) {
					frames = Paths.getPackerAtlas(json.image);
				} else {
					frames = Paths.getSparrowAtlas(json.image);
				}
				imageFile = json.image;

				if(json.scale != 1) {
					jsonScale = json.scale;
					setGraphicSize(Std.int(width * jsonScale));
					updateHitbox();
				}

				positionArray = json.position;
				cameraPosition = json.camera_position;

				healthIcon = json.healthicon;
				singDuration = json.sing_duration;
				flipX = !!json.flip_x;
				if(json.no_antialiasing)
					noAntialiasing = true;

				if(json.healthbar_colors != null && json.healthbar_colors.length > 2)
					healthColorArray = json.healthbar_colors;

				antialiasing = !noAntialiasing;
				if(!ClientPrefs.globalAntialiasing) antialiasing = false;

				animationsArray = json.animations;
				if(animationsArray != null && animationsArray.length > 0) {
					for (anim in animationsArray) {
						var animAnim:String = '' + anim.anim;
						var animName:String = '' + anim.name;
						var animFps:Int = anim.fps;
						var animLoop:Bool = !!anim.loop; //Bruh
						var animIndices:Array<Int> = anim.indices;
						if(animIndices != null && animIndices.length > 0) {
							animation.addByIndices(animAnim, animName, animIndices, "", animFps, animLoop);
						} else {
							animation.addByPrefix(animAnim, animName, animFps, animLoop);
						}

						if(anim.offsets != null && anim.offsets.length > 1) {
							addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
						}
					}
				} else {
					quickAnimAdd('idle', 'BF idle dance');
				}
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!isPlayingAsBF)
		{
			if (curCharacter.startsWith('bf') && !isPlayer)
				{
					if (animation.curAnim.name.startsWith('sing'))
					{
						holdTimer += elapsed;
					}
		
					var dadVar:Float = 4;
		
					if (curCharacter == 'dad')
						dadVar = 6.1;
					if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
					{
						trace('dance');
						dance();
						holdTimer = 0;
					}
				}
		
		}
		else
		{
			if (!isPlayer)
				{
				//	try{
					if (animation.curAnim.name.startsWith('sing'))
					{
						holdTimer += elapsed;
					}
		
					var dadVar:Float = 4;
		
					if (curCharacter == 'dad')
						dadVar = 6.1;
					if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
					{
						trace('dance');
						dance();
						holdTimer = 0;
					}
			//	} catch (exception) {
			//		trace('the error is: ' + exception);
			//	}
				}
		}
		
		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function recalculateDanceIdle() {
		danceIdle = (animation.getByName('danceLeft' + idleSuffix) != null && animation.getByName('danceRight' + idleSuffix) != null);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	public function quickAnimAdd(name:String, anim:String)
		{
			animation.addByPrefix(name, anim, 24, false);
		}
}
