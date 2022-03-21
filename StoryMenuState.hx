package;

import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	var weekData:Array<Dynamic> = [
		['Tutorial'],
		['Bopeebo', 'Fresh', 'Dad Battle'],
		['Spookeez', 'South', "Monster"],
		['Pico', 'Philly Nice', "Blammed"],
		['Satin Panties', "High", "Milf"],
		['Cocoa', 'Eggnog', 'Winter Horrorland'],
		['Senpai', 'Roses', 'Thorns']
	];
	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [
		true,	//Tutorial
		true,	//Week 1
		true,	//Week 2
		true,	//Week 3
		true,	//Week 4
		true,	//Week 5
		true,	//Week 6
		true
	];

	//It works like this:
	// ['Left character', 'Center character', 'Right character']
	var weekCharacters:Array<Dynamic> = [
		['shaggy', 'bf', 'gf'],
		['shaggy', 'bf', 'gf'],
		['pshaggy', 'bf', 'gf'],
		['shaggymatt', 'bf', 'gf'],
		['rshaggy', 'bf', 'gf'],
		['wbshaggy', 'bf', 'gf'],
		['', 'bf', 'gf']
	];

	//The week's name, displayed on top-right
	var weekNames:Array<String> = [
		"First encounter",
		"The rematch",
		"Ultimate destruction",
		"Cruel revelation",
		"Bonus match",
		"Special Kombat with the third of his kind",
		"BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"
	];

	//Background asset name, the background files are stored on assets/preload/menubackgrounds/
	var weekBackground:Array<String> = [
		'halloween',		
		'halloween',
		'sky',
		'boxin',
		'outside',
		'lava',
		'blank'
	];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var zephGfx:MenuItem;

	var zephMenu:FlxSprite;

	var moNotice:FlxText;
	var bgSprite:FlxSprite;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 70");

		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}

		trace("Line 96");

	//	grpWeekCharacters.add(new MenuCharacter(0, 100, 0.5, false));
//		grpWeekCharacters.add(new MenuCharacter(450, 25, 0.9, true));
	//	grpWeekCharacters.add(new MenuCharacter(850, 100, 0.5, true));

	for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, weekCharacters[0][char]);
			weekCharacterThing.y += 70;
			weekCharacterThing.antialiasing = ClientPrefs.globalAntialiasing;
			grpWeekCharacters.add(weekCharacterThing);
		}

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		for (i in 0...CoolUtil.difficultyStuff.length) {
			var sprDifficulty:FlxSprite = new FlxSprite(leftArrow.x + 35, leftArrow.y).loadGraphic(Paths.image('menudifficulties/' + CoolUtil.difficultyStuff[i][0].toLowerCase()));
			sprDifficulty.x += (308 - sprDifficulty.width) / 2;
			sprDifficulty.ID = i;
			sprDifficulty.antialiasing = ClientPrefs.globalAntialiasing;
			sprDifficultyGroup.add(sprDifficulty);
		}

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		trace("Line 150");

		add(yellowBG);
		add(grpWeekCharacters);

		if (FlxG.save.data.p_partsGiven >= 4 && !FlxG.save.data.ending[2])
			{
				zephMenu = new FlxSprite(200, 40).loadGraphic(Paths.image('menucharacters/zephyrus'));
				zephMenu.scale.x = 0.75;
				zephMenu.scale.y = 0.75;
				zephMenu.antialiasing = true;
				add(zephMenu);
			}

		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);

		updateText();

		trace("Line 165");

		super.create();
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		if (zephMenu != null)
			{
				ztime ++;
				zephMenu.x = 800;
				zephMenu.y = 40 + Math.sin(ztime / 60) * 10;
			}
	
			moNotice.text = "";
			if (curWeek == 1)
			{
				moNotice.text = "First song has copyright :(\nPress P for drums cover\n";
				if (Main.drums) moNotice.text += "(drums cover active)\n";
	
				if (FlxG.keys.justPressed.P)
				{
					Main.drums = !Main.drums;
					if (Main.drums) FlxG.sound.play(Paths.sound('cancelMenu'));
					else FlxG.sound.play(Paths.sound('scrollMenu'));
				}
			}

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

				if (gamepad != null)
				{
					if (gamepad.justPressed.DPAD_UP)
					{
						changeWeek(-1);
					}
					if (gamepad.justPressed.DPAD_DOWN)
					{
						changeWeek(1);
					}

					if (gamepad.pressed.DPAD_RIGHT)
						rightArrow.animation.play('press')
					else
						rightArrow.animation.play('idle');
					if (gamepad.pressed.DPAD_LEFT)
						leftArrow.animation.play('press');
					else
						leftArrow.animation.play('idle');

					if (gamepad.justPressed.DPAD_RIGHT)
					{
						changeDifficulty(1);
					}
					if (gamepad.justPressed.DPAD_LEFT)
					{
						changeDifficulty(-1);
					}
				}

				if (FlxG.keys.justPressed.UP)
				{
					changeWeek(-1);
				}

				if (FlxG.keys.justPressed.DOWN)
				{
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
		{
			if (curWeek >= weekUnlocked.length || weekUnlocked[curWeek])
			{
				switch (curWeek)
				{
					case 3:
						//CoolUtil.browserLoad('https://gamejolt.com/games/fnf-shaggy-matt/648032');
						trace('shaggyxmatt song');
					case 6:
						MusicBeatState.switchState(new MASKstate());
					default:
						trace(curDifficulty, WeekData.maniaSongs[curWeek]);
						if (curDifficulty != 0 || WeekData.maniaSongs[curWeek][0] != '')
						{
							if (stopspamming == false)
							{
								FlxG.sound.play(Paths.sound('confirmMenu'));
	
								grpWeekText.members[curWeek].startFlashing();
								grpWeekCharacters.members[1].animation.play('confirm');
								stopspamming = true;
							}
	
							// We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.
							var songArray:Array<String> = [];
							var leWeek:Array<Dynamic> = WeekData.songsNames[curWeek];
	
							if (curDifficulty == 0)
							{
								leWeek = WeekData.maniaSongs[curWeek];
							}
	
							for (i in 0...leWeek.length) {
								songArray.push(leWeek[i]);
							}
	
							// I'm a motherfucking genious
							PlayState.storyPlaylist = songArray;
							PlayState.isStoryMode = true;
							selectedWeek = true;
	
							var diffic = CoolUtil.difficultyStuff[curDifficulty][1];
							if(diffic == null) diffic = '';
	
							PlayState.storyDifficulty = curDifficulty;
	
							PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
							PlayState.storyWeek = curWeek;
							PlayState.campaignScore = 0;
							PlayState.campaignMisses = 0;
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								LoadingState.loadAndSwitchState(new PlayState(), true);
								FreeplayState.destroyFreeplayVocals();
							});
						}
				}
			}
		}

		function changeDifficulty(change:Int = 0):Void
			{
				var lDif = curDifficulty;
				curDifficulty += change;
		
				if (curDifficulty < 0)
					curDifficulty = CoolUtil.difficultyStuff.length-1;
				if (curDifficulty >= CoolUtil.difficultyStuff.length)
					curDifficulty = 0;
		
				if (lDif == 0 || curDifficulty == 0)
				{
					updateText();
				}
				//updateText();
		
				sprDifficultyGroup.forEach(function(spr:FlxSprite) {
					spr.visible = false;
					if(curDifficulty == spr.ID) {
						spr.visible = true;
						spr.alpha = 0;
						spr.y = leftArrow.y - 15;
						FlxTween.tween(spr, {y: leftArrow.y + 10 + 33 - spr.height / 2, alpha: 1}, 0.07);
					}
				});
		
				#if !switch
				intendedScore = Highscore.getWeekScore(WeekData.getWeekNumber(curWeek), curDifficulty);
				#end
			}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
		{
			curWeek += change;
	
			var zSub = 1;
			if (MASKstate.getProgress() > 0 && FlxG.save.data.p_progress[4] == 0) zSub = 0;
			if (FlxG.save.data.ending[2]) zSub = 1;
	
			if (curWeek > WeekData.songsNames.length - 1 - zSub)
				curWeek = 0;
			if (curWeek < 0)
				curWeek = WeekData.songsNames.length - 1 - zSub;
	
			var leName:String = '';
			if(curWeek < weekNames.length) {
				leName = weekNames[curWeek];
			}
	
			txtWeekTitle.text = leName.toUpperCase();
			txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);
	
			var bullShit:Int = 0;
	
			for (item in grpWeekText.members)
			{
				item.targetY = bullShit - curWeek;
				if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
					item.alpha = 1;
				else
					item.alpha = 0.6;
	
				bullShit++;
			}
	
			var assetName:String = weekBackground[0];
			if(curWeek < weekBackground.length) assetName = weekBackground[curWeek];
	
			bgSprite.loadGraphic(Paths.image('menubackgrounds/menu_' + assetName));
			updateText();
		}

		function updateText()
			{
				var weekArray:Array<String> = weekCharacters[0];
				if(curWeek < weekCharacters.length) weekArray = weekCharacters[curWeek];
		
				for (i in 0...grpWeekCharacters.length) {
					grpWeekCharacters.members[i].changeCharacter(weekArray[i]);
				}
		
				var stringThing:Array<String> = WeekData.songsNames[curWeek];
		
				if (curDifficulty == 0)
				{
					stringThing = WeekData.maniaSongs[curWeek];
				}
		
				txtTracklist.text = '';
				for (i in 0...stringThing.length)
				{
					txtTracklist.text += stringThing[i] + '\n';
				}
		
				txtTracklist.text = StringTools.replace(txtTracklist.text, '-', ' ');
				txtTracklist.text = txtTracklist.text.toUpperCase();
		
				txtTracklist.screenCenter(X);
				txtTracklist.x -= FlxG.width * 0.35;
		
				#if !switch
				intendedScore = Highscore.getWeekScore(WeekData.getWeekNumber(curWeek), curDifficulty);
				#end
			}
}
