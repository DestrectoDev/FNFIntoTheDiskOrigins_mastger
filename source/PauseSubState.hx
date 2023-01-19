package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import sys.thread.Mutex;
import sys.thread.Thread;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<FNFSprite>;

	var menuItems:Array<String> = ['resume', 'restart', 'exit'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	var mutex:Mutex;

	public static var songName:String = '';

	public function new(x:Float, y:Float)
	{
		super();

		mutex = new Mutex();
		Thread.create(function()
		{
			mutex.acquire();
			pauseMusic = new FlxSound().loadEmbedded(Paths.music('pause_menu_random_2'), true, true);
			pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
			FlxG.sound.list.add(pauseMusic);
			pauseMusic.volume = 0;
			mutex.release();
		});

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();

		var backGround = new FlxBackdrop(Paths.image("menus/back_menu", "disk"), 0, 0, true, true, 0, 0);
		// backGround.ID = i;
		backGround.velocity.x = -290;
		backGround.screenCenter(Y);
		backGround.antialiasing = true;
		backGround.alpha = 0;
		add(backGround);
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += ((PlayState.SONG.player2 == "nmi") ? "地獄の苦しみ" : PlayState.SONG.song);
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font(((PlayState.SONG.player2 == "nmi") ? 'AlibabaSansJP-Bold.ttf' : 'vcr.ttf')), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += ((PlayState.SONG.player2 == "nmi") ? "[難しい]" : CoolUtil.difficultyFromNumber(PlayState.storyDifficulty));
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font(((PlayState.SONG.player2 == "nmi") ? 'AlibabaSansJP-Bold.ttf' : 'vcr.ttf')), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var levelDeaths:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
		levelDeaths.text += ((PlayState.SONG.player2 == "nmi") ? "ブルーボールド: " : "Blue balled: ") + PlayState.deathCounter;
		levelDeaths.scrollFactor.set();
		levelDeaths.setFormat(Paths.font(((PlayState.SONG.player2 == "nmi") ? 'AlibabaSansJP-Bold.ttf' : 'vcr.ttf')), 32);
		levelDeaths.updateHitbox();
		add(levelDeaths);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		levelDeaths.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		levelDeaths.x = FlxG.width - (levelDeaths.width + 20);

		pene = new FNFSprite(860, 120);
		pene.frames = Paths.getSparrowAtlas("menus/pause_bf", "disk");
		pene.animation.addByPrefix("idle", "BF DE PAUSA", 24);
		pene.antialiasing = true;
		pene.playAnim("idle");
		pene.x -= 130;
		pene.screenCenter(X);
		add(pene);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(backGround, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(levelDeaths, {alpha: 1, y: levelDeaths.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		grpMenuShit = new FlxTypedGroup<FNFSprite>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var item:FNFSprite = new FNFSprite(0, 0);
			// songText.isMenuItem = true;
			if (PlayState.SONG.player2 == "nmi")
			item.loadGraphic(Paths.image("pause/nmi/"+menuItems[i], "disk"));
			else
			item.loadGraphic(Paths.image("pause/"+menuItems[i], "disk"));
			// songText.targetY = i;
			item.x = -495 + (i * 440);
			item.y = 384;
			item.setGraphicSize(Std.int(item.width / 4.5));	
			grpMenuShit.add(item);
		}

		box = new FNFSprite(grpMenuShit.members[0].x + (grpMenuShit.members[0].width / 2), 0);
		box.loadGraphic(Paths.image("pause/red", "disk"));
		box.y = grpMenuShit.members[0].y - (box.height / 2) + 190;
		box.antialiasing = false;
		box.setGraphicSize(Std.int(box.width / 4));
		add(box);

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}
	var box:FNFSprite;
    
	var pene:FNFSprite;
	
	var danced:Bool = false;
	override public function beatHit(){
		super.beatHit();

		pene.playAnim("idle");
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var upP = controls.UI_LEFT_P;
		var downP = controls.UI_RIGHT_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "resume":
					close();
				case "restart":
					restartSong();
				case "exit":
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;

					WeekData.loadTheFirstEnabledMod();
					if(PlayState.isStoryMode) {
						MusicBeatState.switchState(new StoryMenuState());
					} else {
						MusicBeatState.switchState(new FreeplayState());
					}
					PlayState.cancelMusicFadeTween();
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					PlayState.changedDifficulty = false;
					PlayState.chartingMode = false;
			}
		}

		if (pauseMusic != null && pauseMusic.playing)
		{
			if (pauseMusic.volume < 0.5)
				pauseMusic.volume += 0.01 * elapsed;
		}
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{
			MusicBeatState.resetState();
		}
	}

	override function destroy()
	{
		if (pauseMusic != null)
			pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;
		
		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			if (curSelected == 2)
				box.x = 322;
			else if (curSelected == 1)
				box.x = -125;
			else if (curSelected == 0)
				box.x = -575;
		}
		//
	}
}
