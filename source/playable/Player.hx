package playable;

import flixel.*;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import meta.*;
import meta.data.dependency.*;

class Player extends FNFSprite
{
	var holdTimer:Float;

	public static var SPEED:Int = 400;

	public var GRAVITY:Int = 900;

	public static var eventvalue:Bool = true;

	public var debugMode:Bool = false;

	// public var animOffsets:Map<String, Array<Dynamic>>;

	var holdSpeed:Int = 12;

	public function new(X, Y)
	{
		super(X, Y);
		// animOffsets = new Map<String, Array<Dynamic>>();

		drag.x = SPEED * 4;
		drag.y = SPEED * 4;

		loadGraphic(Paths.image("hills/characters/tails_assets"), true, 72, 72);

		animation.add("idle", CoolUtil.numberContainer(0, 4), 12, true);
		animation.add("spindash", CoolUtil.numberContainer(5, 7), 12, true);
		animation.add("charge", CoolUtil.numberContainer(8, 10), 12, true);
		animation.add("lookinup", CoolUtil.numberContainer(11, 15), 12, true);
		animation.add("crouched", CoolUtil.numberContainer(16, 20), 12, true);
		animation.add("running", CoolUtil.numberContainer(21, 24), 12, true);
		animation.add("dash", CoolUtil.numberContainer(25, 26), 12, true);
		animation.add("walk", CoolUtil.numberContainer(27, 34), 12, true);

		loadOffsetFile("tails");

		if (!debugMode)
		{
			acceleration.y = GRAVITY;
		}
		else
		{
			acceleration.y = 0;
		}

		updateHitbox();
	}

	var walkMode:Bool = true;

	public function loadOffsetFile(char:String = "tails")
	{
		var offset:Array<String> = CoolUtil.coolTextFile('assets/images/characters/${char}Offsets.txt');

		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}
	}

	public function moveTails(move:Bool = true, elapsed:Float)
	{
		var right = FlxG.keys.anyPressed([RIGHT, D]);
		var left = FlxG.keys.anyPressed([LEFT, A]);
		var rightR = FlxG.keys.anyJustReleased([RIGHT, D]);
		var leftR = FlxG.keys.anyJustReleased([LEFT, A]);
		var up = FlxG.keys.anyPressed([UP, W]);
		var down = FlxG.keys.anyPressed([DOWN]);
		// var shifty = FlxG.keys.pressed.SHIFT;
		// var down = FlxG.keys.anyPressed([DOWN, S]);
		// var down = FlxG.keys.anyPressed([DOWN, S]);
		// var down = FlxG.keys.anyPressed([DOWN, S]);

		if (move && !debugMode)
		{
			if (left || right)
			{
				if (holdSpeed >= 222)
				playAnim("running");
				else
				playAnim("walk", false, false, holdSpeed + 15);
			}
			else
				playAnim("idle");
			{
				setFacingFlip(FlxObject.LEFT, true, false);
				setFacingFlip(FlxObject.RIGHT, false, false);
			}
			if (down && right)
			{
				SPEED = 700;
				playAnim("spindash");
			}
			if (down && left)
			{
				SPEED = 700;
				playAnim("spindash");
			}
			if (right)
			{
				velocity.x = (SPEED + (holdSpeed * 2));
				holdSpeed += 8;
				facing = FlxObject.RIGHT;
			}
			else if (left)
			{
				velocity.x = -(SPEED - (Std.int(holdSpeed / 2)));
				holdSpeed += 8;
				facing = FlxObject.LEFT;
			}
			else if (leftR || rightR)
			{ 
			   holdSpeed = 12;	
			}
			else if (up)
			{
				playAnim("lookinup");
			}
			else if (down)
			{
				playAnim("crouched");
			}
			// if (left || right)
			// {
			// 	new FlxTimer().start(2.5, function(tmr)
			// 	{
			// 		var checkLastHold:Int = Math.floor((holdTimer - 0.5) * 10);
			// 		holdTimer += elapsed;
			// 		var checkNewHold:Int = Math.floor((holdTimer - 0.5) * 10);

			// 		if (holdTimer > 2.5 && checkNewHold - checkLastHold > 0)
			// 		{
			// 			walkMode = false;
			// 			if (right)
			// 			{
			// 				playAnim("running");
			// 				facing = FlxObject.RIGHT;
			// 				velocity.x = checkNewHold - checkLastHold * -SPEED + 20;
			// 			}
			// 			else if (left)
			// 			{
			// 				playAnim("running");
			// 				facing = FlxObject.LEFT;
			// 				velocity.x = checkNewHold - checkLastHold * SPEED - 20;
			// 			}
			// 			else if (FlxG.keys.anyJustReleased([RIGHT, LEFT, A, D]))
			// 			{
			// 				walkMode = true;
			// 				holdTimer = 0;
			// 			}
			// 		}
			// 	});
			// }
		}
	}

	public function jumpTails(canJump:Bool = true)
	{
		if (canJump)
		{
			var jump = FlxG.keys.anyPressed([SPACE, SHIFT, S]);
			if (jump && isTouching(FlxObject.FLOOR))
			{
				animation.play('spindash');

				angle += FlxG.elapsed;

				velocity.y = -GRAVITY / 1.5;
			}
			if (FlxG.keys.anyJustReleased([SPACE, SHIFT, S]))
			{
				angle = 0;
			}
		}
	}

	// public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0)
	// {
	// 	animation.play(AnimName, Force, Reversed, Frame);

	// 	var daOffset = animOffsets.get(AnimName);
	// 	if (animOffsets.exists(AnimName))
	// 	{
	// 		offset.set(daOffset[0], daOffset[1]);
	// 	}
	// 	else
	// 		offset.set(0, 0);
	// }

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		moveTails(eventvalue, elapsed);
		jumpTails(true);	

	}

	// public function addOffset(name:String, x:Float = 0, y:Float = 0)
	// {
	// 	animOffsets[name] = [x, y];
	// }
}