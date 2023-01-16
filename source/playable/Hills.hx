package playable;

import flixel.*;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.*;
import flixel.util.FlxCollision;
import playable.*;

class Hills extends MusicBeatState
{
	var scoreHUD:FlxSprite;

	public static var daPixelZoom:Float = 6;

	var camHUD:FlxCamera;


	var cameraCollision:FlxGroup;
	var score:Int = 0;
	var rings:Int = 0;
	var time:Float = 0;

	var lifes:Int = 0;

	var player:Player;
	var collisionShit:FlxSprite;

	var health:Int = 5;
	var infoGame:String = "0";

	// txt
	var infoTxt:FlxText;
	var lifeTxt:FlxText;

	// end
	var bg:FNFSprite;
	var floor:FlxBackdrop;
	var mont:FlxBackdrop;

	override function create()
	{
		super.create();

		cameraCollision = FlxCollision.createCameraWall(FlxG.camera, true, 1); //camera collision shit

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD);
		FlxG.camera.zoom = 0.7;

		var box = new FNFSprite();
		box.makeGraphic(FlxG.width * 3, FlxG.height * 3, 0xFFffa03a);
		box.screenCenter();
		add(box);

		var montass = new FNFSprite(0, -20);
		montass.loadGraphic(Paths.image("hills/stages/MONTANAS_1"));
		montass.screenCenter(XY);
		montass.scale.set(0.4, 0.5);
		add(montass);

		bg = new FNFSprite(0, -110);
		bg.frames = Paths.getSparrowAtlas("hills/stages/Bg");
		bg.animation.addByPrefix("loop", "Bg idle", 24);
		bg.playAnim("loop");
		bg.scrollFactor.set();
		bg.scale.set(1.4, 1.4);
		bg.alpha = 0.4;
		bg.screenCenter(X);
		add(bg);

		var frontFire = new FNFSprite(0, -40);
		frontFire.frames = Paths.getSparrowAtlas("hills/stages/Bg");
		frontFire.animation.addByPrefix("loop", "Bg idle", 24);
		frontFire.playAnim("loop");
		frontFire.scrollFactor.set();
		frontFire.scale.set(1.4, 1.4);
		frontFire.alpha = 0.48;
		frontFire.screenCenter(X);
		frontFire.cameras = [camHUD];

		floor = new FlxBackdrop(Paths.image("hills/stages/Floor"), 0, 0, true, true, 0, 0);
		floor.loadGraphic(Paths.image("hills/stages/Floor"), 2035, 1156);
		// backGround.ID = i;
		// floor.velocity.x = Player.SPEED;
		floor.x = -367;
		floor.y = -112.1;
		floor.antialiasing = true;

		mont = new FlxBackdrop(Paths.image("hills/stages/Mountains"), 0, 0, true, true, 0, 0);
		mont.loadGraphic(Paths.image("hills/stages/Mountains"), 2488, 1146);
		// backGround.ID = i;
		// mont.velocity.x = Player.SPEED;
		mont.antialiasing = true;
		mont.x = -525.7;
		mont.y = -560.7;
		add(mont);
		add(floor);

		player = new Player(56.05, 415.25);
		player.antialiasing = false;
		player.setGraphicSize(Std.int(player.width * 5.6));
		add(player);

		scoreHUD = new FlxSprite(32, 31.35, Paths.image("UI/default/base/scoreSpr"));
		scoreHUD.cameras = [camHUD];
		scoreHUD.antialiasing = false;
		scoreHUD.scale.set(0.85, 0.85);
		add(scoreHUD);

		infoTxt = new FlxText(scoreHUD.x - 90, scoreHUD.y + 10, FlxG.width, "pene", 32);
		infoTxt.setFormat(Paths.font("sonic-hud-font.ttf"), 52, FlxColor.WHITE, CENTER, OUTLINE, 0xff1a3668);
		infoTxt.borderSize = 3.43;
		add(infoTxt);

		// colitionGrp = new FlxTypedGroup<FlxSprite>();
		// for (i in 0...3){
		collisionShit = new FlxSprite(-362.75, 565.65).makeGraphic(2250, 935, FlxColor.GREEN);
		// collisionShit.alpha = 0;
		// collisionShit.makeGraphic(1950, 935, FlxColor.GREEN);
		// collisionShit.loadGraphic(Paths.image("hills/stages/stupidColl"));
		collisionShit.y = 559;
		collisionShit.alpha = 0;
		collisionShit.immovable = true;
		// collisionShit.x = -362 * i;
		add(collisionShit);
		// }
		// add(colitionGrp);
		
		var l = new FNFSprite(-22, 580);
		l.loadGraphic(Paths.image("hills/stages/tailsLifes"));
		l.replaceColor(FlxColor.RED, FlxColor.TRANSPARENT);
		l.antialiasing = false;
		l.cameras = [camHUD];
		l.setGraphicSize(Std.int(l.width / 1.5));
		add(l);
		add(frontFire);

		FlxG.camera.follow(player);
        FlxG.camera.zoom = 0.6;
		// add(new FlxText(0, 0, 0, "Hello World!", 32).screenCenter());
	}
    
	var colitionGrp:FlxTypedGroup<FlxSprite>;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// FlxG.overlap(player, ringSpr, ringSpr.collect);

		FlxG.collide(player, collisionShit);
		// FlxG.collide(player, cameraCollision);

		var infoDisplay:String = '0 "0 "1';

		if (time > 10000)
			infoDisplay = '0 "';
		else
			infoDisplay = '0 "0 "';
		// infoGame = ' : $score' + '\n : $time' + '\n : $rings';
		infoTxt.text = ': $score' + '\n\n: $infoDisplay$time' + '\n\n: $rings';
		infoTxt.x = scoreHUD.x + 270 - (infoTxt.width / 2);

		if (FlxG.keys.pressed.E)
			score+= 500 + Std.int(elapsed * 10);

		if (FlxG.keys.justPressed.Q)
			rings++;

		time += Math.round(Math.max(elapsed * 60, 2));

		if (controls.BACK)
			MusicBeatState.switchState(new SelectState());

		if (controls.BACK)
			MusicBeatState.switchState(new SelectState());

		if (FlxG.keys.justPressed.R)
			FlxG.resetState();
	}
}