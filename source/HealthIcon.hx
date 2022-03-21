package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	 public var sprTracker:FlxSprite;
	 private var isOldIcon:Bool = false;
	 private var isPlayer:Bool = false;
	 private var char:String = '';

	 // The following icons have antialiasing forced to be disabled
	var noAntialiasing:Array<String> = ['bf-pixel', 'senpai', 'spirit'];

	public var offsetX = 0;
	public var offsetY = 0;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	public function changeIcon(char:String) {
	if(this.char != char) {

		switch (char)
		{
			case 'ronald': 
				loadGraphic(Paths.image('ronaldGrid'), true, 150, 150);

				antialiasing = true;
				animation.add('ronald', [19, 20], 0, false, isPlayer);
				animation.play(char);
			case 'matt' | 'both' | 'both-god':
				loadGraphic(Paths.image('shaggyXMattGrid'), true, 150, 150);

				antialiasing = true;
				animation.add('mom-car', [6, 7], 0, false, isPlayer);
				animation.add('matt', [8, 9], 0, false, isPlayer);
				animation.add('both', [19, 20], 0, false, isPlayer);
				animation.add('both-god', [23, 23], 0, false, isPlayer);
				animation.play(char);
			default:
				var name:String = 'icons/icon-' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			loadGraphic(file, true, 150, 150);
			animation.add(char, [0, 1], 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			antialiasing = FlxG.save.data.antialiasing;
			for (i in 0...noAntialiasing.length) {
				if(char == noAntialiasing[i]) {
					antialiasing = false;
					break;
					}
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
