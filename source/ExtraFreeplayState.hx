package;

import flixel.input.gamepad.FlxGamepad;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.system.FlxSound;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import openfl.utils.Assets as OpenFlAssets;
import haxe.Json;
import haxe.format.JsonParser;

import sys.io.File;
import sys.FileSystem;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class ExtraFreeplayState extends MusicBeatState
{
	var songs:Array<ESongMetadata> = [];

	private static var vocals:FlxSound = null;

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var intendedColor:Int;

	var bg:FlxSprite;

 //	var songNameLow = songs[curSelected].songName.toLowerCase();

	var scoreText:FlxText;
	var comboText:FlxText;
	var colorTween:FlxTween;
	var diffText:FlxText;
	var randomText:FlxText;
	var randomModeText:FlxText;
	var maniaText:FlxText;
	var flipModeText:FlxText;
	var bothSideText:FlxText;
	var randomManiaText:FlxText;
	var noteTypesText:FlxText;
	public static var coolColors:Array<Int> = [];

	var keyAmmo:Array<Int> = [4, 6, 9, 5, 7, 8, 1, 2, 3];
	var randMania:Array<String> = ["Off", "Low Chance", "Medium Chance", "High Chance"];
	var randNoteTypes:Array<String> = ["Off", "Low Chance", "Medium Chance", "High Chance", 'Unfair'];

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var combo:String = '';

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];
	var instPlaying:Int = -1;

	override function create()
	{
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		addSong('Sweet-Sauce', 7, 'ronald');
		addSong('Infinite-Songs', 7, 'zsonic');
		addSong('live-on', 7, 'dshaggy');
		addSong('Whats-Bugged', 7, 'bshaggy');
		addSong('BIG-SHOT', 7, 'spamton');
		addSong('Loca', 7, 'gf');
	//	#if debug
		addSong('Godalovania', 7, 'pshaggy');
	//	#end
		addSong('Ultra-Instinct', 7, 'sshaggy');
	//	addSong('Paradoxial', 7, 'rshaggy');
		addSong('b-side-final-destination', 7, 'shaggymatt-bside');
		addSong('final-destination-god', 7, 'shaggymattgod');
		addSong('Switched', 7, 'bf');
		addSong('Paradoxial', 7, 'rshaggy');
		trace(FlxG.save.data.p_maskGot[4]);

		if (FlxG.save.data.p_maskGot[4])
			addSong('Expurgation', 7, 'dshaggy');
		else {
			addSong('Unknown', 7, 'dshaggy');
		}

		coolColors.push(0xFF941653);
		coolColors.push(0xFFFF78BF);
		coolColors.push(0xFFFC96D7);
		coolColors.push(0xFF223344);
		coolColors.push(0xFFFC96D7);
		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Freeplay Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.screenCenter();
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false, true);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		randomText = new FlxText(FlxG.width * 0.7, 489, 0, FlxG.save.data.randomNotes ? "Randomization On (R)" : "Randomization Off (R)", 20);
		randomText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT);

		randomModeText = new FlxText(randomText.x, randomText.y + 32, FlxG.save.data.randomSection ? "Mode: Per Section (best for extra keys) (T)" : "Mode: Regular (T)", 16);
		randomModeText.setFormat(Paths.font("vcr.ttf"), 14, FlxColor.WHITE, RIGHT);

		randomManiaText = new FlxText(randomText.x, randomText.y + 64, "Randomly change Amount of keys: " + randMania[FlxG.save.data.randomMania] + " (Y)", 16);
		randomManiaText.setFormat(Paths.font("vcr.ttf"), 14, FlxColor.WHITE, RIGHT);

		maniaText = new FlxText(randomText.x, randomText.y + 96, "Set ammount of keys: " + keyAmmo[FlxG.save.data.mania] + " (4 = default) (U)", 24);
		maniaText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);

		noteTypesText = new FlxText(randomText.x, randomText.y + 128, "Randomly Place Note Types: " + randNoteTypes[FlxG.save.data.randomNoteTypes] + "(I)", 24);
		noteTypesText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);

		flipModeText = new FlxText(randomText.x, randomText.y + 160, FlxG.save.data.flip ? "Play as Oppenent: On (O)" : "Play as Oppenent: Off (O)", 20);
		flipModeText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT);

		bothSideText = new FlxText(randomText.x, randomText.y + 192, FlxG.save.data.bothSide ? "Both side: On (only 4k songs, turns into 8k) (P)" : "Both side: Off (P)", 16);
		bothSideText.setFormat(Paths.font("vcr.ttf"), 14, FlxColor.WHITE, RIGHT);

		var settingsBG:FlxSprite = new FlxSprite(randomText.x - 6, 484).makeGraphic(Std.int(FlxG.width * 0.35), 300, 0xFF000000);
		settingsBG.alpha = 0.6;
		add(settingsBG);
		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		comboText = new FlxText(diffText.x + 500, diffText.y, 0, "", 24);
		comboText.font = diffText.font;
		add(comboText);

		add(scoreText);
		add(randomText);
		add(randomModeText);
		add(maniaText);
		add(flipModeText);
		add(bothSideText);
		add(randomManiaText);
		add(noteTypesText);

		bg.color = songs[curSelected].color;
		intendedColor = bg.color;
		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		#if PRELOAD_ALL
		var leText:String = "Press SPACE to listen to this Song.";
		#else
		var leText:String = "Songs aren't currently loaded for listening pleasure. Stop using HTML.";
		#end

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new ESongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['dad'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;
		comboText.text = combo + '\n';

		var upP = FlxG.keys.justPressed.UP;
		var downP = FlxG.keys.justPressed.DOWN;
		var accepted = controls.ACCEPT;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.DPAD_UP)
			{
				changeSelection(-1);
			}
			if (gamepad.justPressed.DPAD_DOWN)
			{
				changeSelection(1);
			}
			if (gamepad.justPressed.DPAD_LEFT)
			{
				changeDiff(-1);
			}
			if (gamepad.justPressed.DPAD_RIGHT)
			{
				changeDiff(1);
			}
		}

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (songs[curSelected].songName.toLowerCase() == "live-on")
		{
			FlxG.save.data.randomNotes = false;
			FlxG.save.data.randomSection = false;
			FlxG.save.data.randomMania = 0;
			FlxG.save.data.mania = 0;
			FlxG.save.data.randomNoteTypes = 0;
			FlxG.save.data.flip = false;
			FlxG.save.data.bothSide = false;
		}

		if (FlxG.keys.justPressed.R && songs[curSelected].songName.toLowerCase() != "live-on")
		{
			FlxG.save.data.randomNotes = !FlxG.save.data.randomNotes;
			randomText.text = FlxG.save.data.randomNotes ? "Randomization On (R)" : "Randomization Off (R)";
		}
		if (FlxG.keys.justPressed.T && songs[curSelected].songName.toLowerCase() != "live-on")
		{
			FlxG.save.data.randomSection = !FlxG.save.data.randomSection;
			randomModeText.text = FlxG.save.data.randomSection ? "Mode: Per Section (best for extra keys) (T)" : "Mode: Regular (T)";
		}

		if (FlxG.keys.justPressed.Y && songs[curSelected].songName.toLowerCase() != "live-on")
			{
				FlxG.save.data.randomMania += 1;
				if (FlxG.save.data.randomMania > 3)
					FlxG.save.data.randomMania = 0;
				randomManiaText.text = "Randomly change Amount of keys: " + randMania[FlxG.save.data.randomMania] + " (Y)";
			}

		if (FlxG.keys.justPressed.U && songs[curSelected].songName.toLowerCase() != "live-on")
		{
			FlxG.save.data.mania += 1;
			if (FlxG.save.data.mania > 8)
				FlxG.save.data.mania = 0;
			maniaText.text = "Set ammount of keys: " + keyAmmo[FlxG.save.data.mania] + " (4 = default) (U)";
		}
		if (FlxG.keys.justPressed.I && songs[curSelected].songName.toLowerCase() != "live-on")
			{
				FlxG.save.data.randomNoteTypes += 1;
				if (FlxG.save.data.randomNoteTypes > 4)
					FlxG.save.data.randomNoteTypes = 0;
				noteTypesText.text = "Randomly Place Note Types: " + randNoteTypes[FlxG.save.data.randomNoteTypes] + "(I)";
			}
		if (FlxG.keys.justPressed.O && songs[curSelected].songName.toLowerCase() != "live-on")
		{
			FlxG.save.data.flip = !FlxG.save.data.flip;
			flipModeText.text = FlxG.save.data.flip ? "Play as Oppenent: On (O)" : "Play as Oppenent: Off (O)";
		}
		if (FlxG.keys.justPressed.P && songs[curSelected].songName.toLowerCase() != "live-on")
		{
			FlxG.save.data.bothSide = !FlxG.save.data.bothSide;
			bothSideText.text = FlxG.save.data.bothSide ? "Both side: On (only 4k songs, turns into 8k) (P)" : "Both side: Off (P)";
		}

		if (FlxG.keys.justPressed.LEFT)
			changeDiff(-1);
		if (FlxG.keys.justPressed.RIGHT)
			changeDiff(1);

		if (controls.BACK)
		{
			destroyFreeplayVocals();
			FlxG.switchState(new MainMenuState());
		}

		if (songs[curSelected].songName.toLowerCase() == "live-on" && curDifficulty != 1)
			curDifficulty = 1;

		if (songs[curSelected].songName.toLowerCase() == "live-on") //bullshit af but idc
			diffText.text = '< OVER >';
		else {
			if (diffText.text == '< OVER >')
				diffText.text = '< EASY >';
		}

		if (songs[curSelected].songName.toLowerCase() == "switched" && curDifficulty != 2)
			curDifficulty = 2;

		if (songs[curSelected].songName.toLowerCase() == "switched") //bullshit af but idc
			diffText.text = '< OSU-MANIA >';
		else {
			if (diffText.text == '< OSU-MANIA >')
				diffText.text = '< CANON >';
		}

		if (songs[curSelected].songName.toLowerCase() != "unknown" && diffText.text == 'PARADOXIAL SECRET REQUIRED')
			diffText.text = '< CANON >';

	//	if (songNameLow == "final-destinaton" && curDifficulty == 4)
	//		diffText.text = '< GOD MANIA >';

		var space = FlxG.keys.justPressed.SPACE;

		#if PRELOAD_ALL
		if(space && instPlaying != curSelected)
			{
				destroyFreeplayVocals();
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				if (PlayState.SONG.needsVoices)
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				else
					vocals = new FlxSound();
	
				FlxG.sound.list.add(vocals);
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
				vocals.play();
				vocals.persist = true;
				vocals.looped = true;
				vocals.volume = 0.7;
				instPlaying = curSelected;
			}
			else#end if (accepted)
		{
			if (!FlxG.keys.pressed.SHIFT)
			{
				// adjusting the song name to be compatible
				var songFormat = StringTools.replace(songs[curSelected].songName, " ", "-");
				switch (songFormat) {
					case 'Dad-Battle': songFormat = 'Dadbattle';
					case 'Philly-Nice': songFormat = 'Philly';
				}
				
				trace(songs[curSelected].songName);

				trace('assets/data/' + songFormat.toLowerCase() + '/' + songFormat.toLowerCase() + // prevent crashes for difficulties with no jsons
				CoolUtil.difficultyStuff[curDifficulty][1] + '.json');

				var jsonExists = FileSystem.exists('assets/data/' + songFormat.toLowerCase() + '/' + songFormat.toLowerCase() + // prevent crashes for difficulties with no jsons
				CoolUtil.difficultyStuff[curDifficulty][1] + '.json');

				if (songFormat.toLowerCase() != "unknown" && FileSystem.exists('assets/data/' + songFormat.toLowerCase() + '/' + songFormat.toLowerCase() + // prevent crashes for difficulties with no jsons
				CoolUtil.difficultyStuff[curDifficulty][1] + '.json')) {

				var poop:String = Highscore.formatSong(songFormat, curDifficulty);

				trace(poop);
				
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
				PlayState.storyWeek = songs[curSelected].week;
				trace('CUR WEEK' + PlayState.storyWeek);
				destroyFreeplayVocals();
				LoadingState.loadAndSwitchState(new PlayState());
				} else curDifficulty = fixDiff(curDifficulty, jsonExists); //fixing diffs with no json so they can't be selected.
			}
			else
			{
				// adjusting the song name to be compatible
				var songFormat = StringTools.replace(songs[curSelected].songName, " ", "-");
				switch (songFormat) {
					case 'Dad-Battle': songFormat = 'Dadbattle';
					case 'Philly-Nice': songFormat = 'Philly';
				}
				
				trace(songs[curSelected].songName);

				trace('assets/data/' + songFormat.toLowerCase() + '/' + songFormat.toLowerCase() + // prevent crashes for difficulties with no jsons
				CoolUtil.difficultyStuff[curDifficulty][1] + '.json');
				var jsonExists = FileSystem.exists('assets/data/' + songFormat.toLowerCase() + '/' + songFormat.toLowerCase() + // prevent crashes for difficulties with no jsons
				CoolUtil.difficultyStuff[curDifficulty][1] + '.json');

				if (songFormat.toLowerCase() != "unknown" && FileSystem.exists('assets/data/' + songFormat.toLowerCase() + '/' + songFormat.toLowerCase() + // prevent crashes for difficulties with no jsons
					CoolUtil.difficultyStuff[curDifficulty][1] + '.json')) {

				var poop:String = Highscore.formatSong(songFormat, curDifficulty);

				trace(poop);
				destroyFreeplayVocals();
				
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
				PlayState.storyWeek = songs[curSelected].week;
				LoadingState.loadAndSwitchState(new ChartingState());
				Main.editor = true;
				} else curDifficulty = fixDiff(curDifficulty, jsonExists); //fixing diffs with no json so they can't be selected.
			}

		}
	}

	function changeDiff(change:Int = 0)
	{
		var songNameLow = songs[curSelected].songName.toLowerCase();

		var songFormat = StringTools.replace(songs[curSelected].songName, " ", "-");
				switch (songFormat) {
					case 'Dad-Battle': songFormat = 'Dadbattle';
					case 'Philly-Nice': songFormat = 'Philly';
				}

		trace('assets/data/' + songFormat.toLowerCase() + '/' + songFormat.toLowerCase() + // prevent crashes for difficulties with no jsons
		CoolUtil.difficultyStuff[curDifficulty][1] + '.json');

		var jsonExists = FileSystem.exists('assets/data/' + songFormat.toLowerCase() + '/' + songFormat.toLowerCase() + // prevent crashes for difficulties with no jsons
		CoolUtil.difficultyStuff[curDifficulty][1] + '.json');

		trace(jsonExists);
		
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		trace(fixDiff(curDifficulty, jsonExists));
		curDifficulty = fixDiff(curDifficulty, jsonExists); //fixing diffs with no json so they can't be selected.

		if (songs[curSelected].songName.toLowerCase() == "live-on")
			curDifficulty = 2;

		// adjusting the highscore song name to be compatible (changeDiff)
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}
		
		#if !switch
		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		#end

		var diffTxt:Array<String>;

		PlayState.storyDifficulty = curDifficulty;

		diffTxt = ['MANIA', 'EASY', 'CANON'];

		if (songNameLow == 'expurgation') diffTxt = ['NO NOTETYPES', 'DEATH NOTES ONLY', 'UNFAIR'];
		if (songNameLow == 'unknown') diffTxt = ['PARADOXIAL SECRET REQUIRED'];

		diffText.text = '< ' + diffTxt[curDifficulty] + ' >';
		if (songNameLow == 'unknown') diffText.text = diffTxt[0];
	}

	function fixDiff(diff:Int, jsonExists:Bool){ //someone fix my horendous code please :(
		var subDiff = 0;
		var songFormat = StringTools.replace(songs[curSelected].songName, " ", "-");
				switch (songFormat) {
					case 'Dad-Battle': songFormat = 'Dadbattle';
					case 'Philly-Nice': songFormat = 'Philly';
				}
		switch (diff) {
			case 0: //mania
				if (!jsonExists) {
					//so we need to just skip straight to easy.
					subDiff += 1;
					//however we also check if other jsons exist

					var normJsonExists = FileSystem.exists('assets/data/' + songFormat.toLowerCase() + '/' + songFormat.toLowerCase() + // prevent crashes for difficulties with no jsons
					CoolUtil.difficultyStuff[1][1] + '.json');
					
					if (!normJsonExists)
					{
						subDiff += 1;

						var hardJsonExists = FileSystem.exists('assets/data/' + songFormat.toLowerCase() + '/' + songFormat.toLowerCase() + // prevent crashes for difficulties with no jsons
						CoolUtil.difficultyStuff[2][1] + '.json');

						if (!hardJsonExists) trace('ur fucked');
					}
				}

			case 1: //easy	
			if (!jsonExists) {
				//so we need to just skip straight to easy.
				subDiff += 1;
				//however we also check if other jsons exist

				var hardJsonExists = FileSystem.exists('assets/data/' + songFormat.toLowerCase() + '/' + songFormat.toLowerCase() + // prevent crashes for difficulties with no jsons
				CoolUtil.difficultyStuff[2][1] + '.json');
				
				if (!hardJsonExists)
				{
					subDiff = 0;

					var maniaJsonExists = FileSystem.exists('assets/data/' + songFormat.toLowerCase() + '/' + songFormat.toLowerCase() + // prevent crashes for difficulties with no jsons
					CoolUtil.difficultyStuff[0][1] + '.json');

					if (!maniaJsonExists) trace('ur fucked');
				}
			}
			case 2: //canon
			if (!jsonExists) {
				//so we need to just skip straight to easy.
				subDiff == 0;
				//however we also check if other jsons exist

				var maniaJsonExists = FileSystem.exists('assets/data/' + songFormat.toLowerCase() + '/' + songFormat.toLowerCase() + // prevent crashes for difficulties with no jsons
				CoolUtil.difficultyStuff[0][1] + '.json');
				
				if (!maniaJsonExists)
				{
					subDiff += 1;

					var normJsonExists = FileSystem.exists('assets/data/' + songFormat.toLowerCase() + '/' + songFormat.toLowerCase() + // prevent crashes for difficulties with no jsons
					CoolUtil.difficultyStuff[1][1] + '.json');

					if (!normJsonExists) trace('ur fucked');
				}
			}
		}
		var givenDiff = diff + subDiff;
		if (diff + subDiff > 2) {trace('uh oh, null diff'); /*not today*/ givenDiff = 2;}
		if (diff + subDiff < 0) {trace('null diff?'); /*not today*/ givenDiff = 0;}

		return givenDiff;
	}

	public static function destroyFreeplayVocals() 
	{
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		destroyFreeplayVocals();

	var newColor:Int = songs[curSelected].color;
	if(newColor != intendedColor) {
		if(colorTween != null) {
			colorTween.cancel();
		}
		intendedColor = newColor;
		colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
			onComplete: function(twn:FlxTween) {
				colorTween = null;
			}
		});
	}

		// selector.y = (70 * curSelected) + 30;
		
		// adjusting the highscore song name to be compatible (changeSelection)
		// would read original scores if we didn't change packages
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}

		#if !switch
		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var songNameLow = songs[curSelected].songName.toLowerCase();

		if (songNameLow == 'expurgation' || songNameLow == 'unknown') changeDiff();

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class ESongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		if(week < FreeplayState.coolColors.length) {
			this.color = FreeplayState.coolColors[week];
		}
	}
}