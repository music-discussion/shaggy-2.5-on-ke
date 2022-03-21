package;

import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

#if sys
import sys.io.File;
import sys.FileSystem;
import flash.media.Sound;
import flixel.system.FlxSound;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story_mode', 'freeplay', 'credits', 'options'];
	#else
	var optionShit:Array<String> = ['story_mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.4 EK" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;
	public static var curSong:String = "Freaky Menu";

	private var isDebug:Bool = false;


	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (Main.onlyExtra)
			optionShit.remove('story_mode');

			if (FlxG.random.bool(0.1)) //awesome.
			{
				if (FlxG.random.bool(0.1)) {
					FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.inst("talladega"));
				}
				else {
					FlxG.sound.music.stop();
					musicShit();
				}
			}

		#if debug
		isDebug = true;
		#end

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
			{
				var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
				var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
				menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
				menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = i;
				menuItem.screenCenter(X);
				menuItems.add(menuItem);
				var scr:Float = (optionShit.length - 4) * 0.135;
				if(optionShit.length < 6) scr = 0;
				menuItem.scrollFactor.set(0, scr);
				menuItem.antialiasing = ClientPrefs.globalAntialiasing;
				//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
				menuItem.updateHitbox();
			}
	

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (FlxG.keys.justPressed.R)
			MASKstate.forceResetDataSetup();

		#if debug
		if (FlxG.keys.justPressed.TWO)
			FlxG.save.data.p_hintSaw = [true, true, true, true, false];
		if (FlxG.keys.justPressed.THREE)
			FlxG.save.data.p_maskGot = [true, true, true, true, false];
		if (FlxG.keys.justPressed.FOUR)
			FlxG.save.data.p_maskGot = [true, true, true, true, true];
		#end

		if (!selectedSomethin)
		{
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}
			}

			if (FlxG.keys.justPressed.FIVE)
				{
					FlxG.sound.music.stop();
					musicShit();
				}

			if (FlxG.keys.justPressed.SEVEN)
			{
				FlxG.sound.music.stop();
				FlxG.sound.playMusic(Paths.inst("talladega"));
				curSong = "talladega";
			}

			if (FlxG.keys.justPressed.NINE)
			{
				FlxG.sound.music.stop();
				FlxG.sound.playMusic(Paths.inst(curSong));
				FlxG.sound.playMusic(Paths.voices(curSong));
			}

			if (FlxG.keys.justPressed.UP)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (FlxG.keys.justPressed.DOWN)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					fancyOpenURL("https://ninja-muffin24.itch.io/funkin");
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					if (FlxG.save.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story_mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				if (Main.onlyExtra || FlxG.keys.pressed.ALT && FlxG.save.data.unlockedExtra || FlxG.keys.pressed.ALT && isDebug) //i dont want to beat my mod.
					FlxG.switchState(new ExtraFreeplayState());
				else 
					FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");
			case 'credits':
				MusicBeatState.switchState(new CreditsState());
			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	public static function musicShit():Void
		{
			
			var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
			var randomSong = FlxG.random.int(0, initSonglist.length - 1);
	
			var data:Array<String> = initSonglist[randomSong].split(':');
			var song = data[0].toLowerCase();
	
			FlxG.sound.playMusic(Paths.inst(song), 0.6, true);
	
			FlxG.sound.music.onComplete = MainMenuState.musicShit;
	
			//curSong = data[0]; //need help with vocals so fuck this
			curSong = song;
	
			/*songText = new FlxText(FlxG.width * 0.7, -1000, 0, "Now Playing: " + curSong, 20);
			songText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
			songText.scrollFactor.set();
			add(songText);
			FlxTween.tween(songText, {x: 100}, 1, {ease: FlxEase.quadInOut, 
				onComplete: function(twn:FlxTween)
				{
					new FlxTimer().start(4, function(tmr:FlxTimer)
					{
						FlxTween.tween(songText, {x: -1000}, 1, {ease: FlxEase.quadInOut, 
							onComplete: function(twn:FlxTween)
							{
								remove(songText);
								songText.destroy();
							}});
					});
				}});*/
			//apparently you literaly cant add sprites inside a static function bruh
		}

		function changeItem(huh:Int = 0)
			{
				curSelected += huh;
		
				if (curSelected >= menuItems.length)
					curSelected = 0;
				if (curSelected < 0)
					curSelected = menuItems.length - 1;
		
				menuItems.forEach(function(spr:FlxSprite)
				{
					spr.animation.play('idle');
					spr.offset.y = 0;
					spr.updateHitbox();
		
					if (spr.ID == curSelected)
					{
						spr.animation.play('selected');
						camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
						spr.offset.x = 0.15 * (spr.frameWidth / 2 + 180);
						spr.offset.y = 0.15 * spr.frameHeight;
						FlxG.log.add(spr.frameWidth);
					}
				});
			}
}
