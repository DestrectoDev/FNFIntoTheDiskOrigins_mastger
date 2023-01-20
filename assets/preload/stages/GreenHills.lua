function onCreate()

	makeLuaSprite('sky', 'Hill/sky', -700, -800);
	setScrollFactor('sky', 1.0, 1.0);
	scaleObject('sky', 0.6, 0.6);

	makeLuaSprite('mountains', 'Hill/mountains', -700, -1000);
	setScrollFactor('mountains', 1.0, 01.0);
	scaleObject('mountains', 0.6, 0.6);

	makeAnimatedLuaSprite('water', 'Hill/water', -1050, -900);
	addAnimationByPrefix('water','water','Water BG',24,true)
	scaleObject('water', 2.0, 2.0);

	makeLuaSprite('pasto', 'Hill/pasto', -700, 350);
	setScrollFactor('pasto', 1.0, 1.0);
	scaleObject('pasto', 0.6, 0.6);

	makeLuaSprite('vegetacion', 'Hill/vegetacion',  -700, -800);
	setScrollFactor('vegetacion', 1.0, 1.0);
	scaleObject('vegetacion', 0.6, 0.6);

	addLuaSprite('sky', false);
	addLuaSprite('mountains', false);
	addLuaSprite('water', false);
	addLuaSprite('pasto',false);
	addLuaSprite('vegetacion',false);

end

	


