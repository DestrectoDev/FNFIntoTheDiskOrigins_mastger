local lib = "stages/green-hills";

function onCreate()
    -- bg cosas de pura cagada
    makeLuaSprite('fondo', 'stages/green-hills/fondo', 'disk', -500, -300);
    scaleObject('fondo', 0.5, 0.5, false);
    setLuaSpriteScrollFactor('fondo', 0.9, 0.9);

    makeLuaSprite('hill', 'stages/green-hills/hill', 'disk', -500, -300);
    scaleObject('hill', 0.5, 0.5, false);
    setLuaSpriteScrollFactor('hill', 0.9, 0.9);

    makeAnimatedLuaSprite('water', 'stages/green-hills/water', 'disk', -500, -300);
    setLuaSpriteScrollFactor('water', 0.9, 0.9);
    -- scaleObject('f', 0.5, 0.5, false);
    scaleObject('water', 0.2, 0.2);

    makeLuaSprite('pasto', 'stages/green-hills/pasto', 'disk', -500, -300);
    scaleObject('pasto', 0.5, 0.5, false);
    setLuaSpriteScrollFactor('pasto', 0.9, 0.9);

    makeLuaSprite('vegetacion', 'stages/green-hills/vegetacion', 'disk', -500, -300);
    scaleObject('vegetacion', 0.5, 0.5, false);
    setLuaSpriteScrollFactor('vegetacion', 0.9, 0.9);

    addLuaSprite('fondo', false);
    addLuaSprite('hill', false);
    addLuaSprite('pasto', false);
    addLuaSprite('vegetacion', false);

    addLuaSprite('water', false);
    addAnimationByPrefix('water', 'idle', 'Water BG', 24, false);
end