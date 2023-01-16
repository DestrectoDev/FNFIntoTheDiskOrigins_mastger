import flixel.*;
import flixel.util.*;

class Dumbass extends MusicBeatState{

    // var controls(get, never):Controls;

    var tail:FlxSprite;
    var tails:FlxSprite;
    override function create(){

        tail = new FlxSprite(50, 90);
        tail.makeGraphic(45, 93, FlxColor.LIME);
		// tail.frames = Paths.getSparrowAtlas("characters/tails/tailsSpr");
		// tail.animation.addByPrefix("jumped", "Símbolo 8 instancia", 24);
        // tail.animation.play("jumped");
        tail.angle =-15;
        // tail.origin.y += 25;
        add(tail);
      
		tails = new FlxSprite(50, 90);
        tails.makeGraphic(100, 120, FlxColor.RED);
		// tails.frames = Paths.getSparrowAtlas("characters/tails/tails_Assets");
		// tails.animation.addByPrefix("jumped", "Símbolo 25 instancia", 24);
		// tail.animation.play("jumped");
		tails.drag.x = SPEED * 4;
		tails.drag.y = SPEED * 4;
		tail.drag.x = SPEED * 4;
		tail.drag.y = SPEED * 4;
		tail.x = tails.x - 52;
        tails.acceleration.y = GRAVITY;
        tail.acceleration.y = GRAVITY;
		add(tails);

        _ = new FlxSprite(0, 550).makeGraphic(FlxG.width, 120, FlxColor.YELLOW);
        _.immovable = true;
        add(_);
    }
    var _:FlxSprite;
    var  SPEED:Int = 500;
    var GRAVITY:Int = 800;
    function move(){
        if (controls.UI_LEFT || controls.UI_RIGHT){
            tails.animation.play("jumped");
        }else
          tails.animation.play("jumped", false);
        {
			tails.setFacingFlip(FlxObject.LEFT, true, false);
			tails.setFacingFlip(FlxObject.RIGHT, false, false); 
        }
        if (controls.UI_RIGHT){
            tails.velocity.x = SPEED;
            tail.velocity.x = SPEED;
            tails.facing = FlxObject.RIGHT;
        }
		if (controls.UI_LEFT){
            tails.velocity.x = -SPEED;
            tail.velocity.x = -SPEED;
			tails.facing = FlxObject.LEFT;
        }
    }

    function jump(elapsed:Float){
        if (controls.UI_UP){
            if (tails.isTouching(FlxObject.FLOOR)){
				tails.velocity.y = -GRAVITY / 1;
                tail.animation.play("jumped");
                tail.angle = -17;
                // tail.visible = true;
				// calculateAngle(elapsed);
            }
        }
      
    }

	function calculateAngle(elapsed:Float){
		tail.setPosition(tails.x - tail.width / 2 - 52, tails.y - tail.height);
		if (tail.isTouching(FlxObject.FLOOR))  tail.velocity.y = -GRAVITY / 1;// tails.y - tail.height;
		tail.angle += Math.floor((elapsed * ((tail.x - tail.y) - tail.height) / tail.width + tail.height - 10)) / tail.angle + (SPEED / 4) / 2;/* / 2;*/

        if (tail.angle > 115){
            if (tail.angle >= -12)
            tail.angle -= elapsed * 5; 
        }
    }

    override function update(elapsed:Float){
        super.update(elapsed);

        FlxG.collide(tails, _);
        FlxG.collide(tail, _);
		if (controls.UI_UP)
		{
			calculateAngle(elapsed);
        }
		if (controls.UI_UP_R)
		{
			// tail.visible = false;
			tail.angle = -12;
			tail.x = tails.x - tail.width / 2 - 42;
			if (tail.isTouching(FlxObject.FLOOR))
			tail.velocity.y = -GRAVITY / 1; // tails.y - tail.height;
			// tail.animation.cur
		}
        move();
        jump(elapsed);
        
        if (FlxG.keys.justPressed.R){
            FlxG.resetState();
        }
        if (FlxG.keys.justPressed.ESCAPE){
	      MusicBeatState.switchState(new SelectState());
        }
    }
}