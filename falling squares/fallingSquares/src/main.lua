-- 
-- Abstract: Bouncing fruit, using enterFrame listener for animation
-- 
-- Version: 1.3 (uses new viewableContentHeight, viewableContentWidth properties)
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.

-- Demonstrates a simple way to perform animation, using an "enterFrame" listener to trigger updates.
-- GLOBALES
_H = display.contentHeight
_W = display.contentWidth
-----------------------------------------------------------------------------------------------
local background = display.newImage( "../graphics/bg.jpg" )
local radius = 40
local xpos = display.contentWidth * 0.5
local ypos = display.contentHeight * 0.5
local score = 0

--local spriteSheetHero = sprite.newSpriteSheet("graphics/caminar.png", 60, 50)
local sheetData = { width=64, height=64, numFrames=56, sheetContentWidth=448, sheetContentHeight=512 }
local sequenceData = {
    { 
        name = "walk",  --name of animation sequence
        start = 1,  --starting frame index
        count = 7,  --total number of frames to animate consecutively before stopping or looping
        time = 700,  --optional, in milliseconds; if not supplied, the sprite is frame-based          
        loopCount = 0,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
        loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
    },
    { 
        name = "die",  --name of animation sequence
        start = 45,  --starting frame index
        count = 12,  --total number of frames to animate consecutively before stopping or looping
        time = 800,  --optional, in milliseconds; if not supplied, the sprite is frame-based          
        loopCount = 1,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
        loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
    }
}
local enemySheet = graphics.newImageSheet( "../graphics/tile2.png", sheetData )
local animationRun = display.newSprite( enemySheet, sequenceData )

txtPuntaje = display.newText("Score="..score, 30, 10, "Arial", 24)


--Function to spawn an object
local function spawnEnemy(obj)
	local enemy = animationRun	
	--enemy = display.newImage( "../graphics/fruit.png", xpos, ypos )
	enemy.xspeed = 0
	enemy.yspeed = 2
	enemy.xdirection = 1
	enemy.ydirection = 1
	enemy.xpos = math.random(enemy.width/2, display.contentWidth - enemy.width/2)
	enemy.ypos = ypos
	enemy.died = false	
	return enemy
end

--Create a table to hold our spawns
--local enemies = {}

--Spawn two objects
--for i = 1, 1 do	
	local enemies = spawnEnemy(enemies)
	enemies:play();
--end


-- Get current edges of visible screen (accounting for the areas cropped by "zoomEven" scaling mode in config.lua)
local screenTop = display.screenOriginY
local screenBottom = display.viewableContentHeight + display.screenOriginY
local screenLeft = display.screenOriginX
local screenRight = display.viewableContentWidth + display.screenOriginX

local function animate(event)
	--for i=1,#enemies do
		if (not enemies.died) then
			enemies.xpos = enemies.xpos + ( enemies.xspeed * enemies.xdirection );
			enemies.ypos = enemies.ypos + ( enemies.yspeed * enemies.ydirection );	
			enemies:translate( enemies.xpos - enemies.x, enemies.ypos - enemies.y)
			if (enemies.y - enemies.height / 2 > display.contentHeight) then	
				enemies.y = -enemies.height	
				enemies.x = math.random(enemies.width/2, display.contentWidth - enemies.width/2)
			end
			enemies.ypos = enemies.y
			enemies.xpos = enemies.x
		end
	--end	
end

-- touch listener 
function enemies:touch( event )
	--enemy.ypos = -enemy.height
	if event.phase == "began" and not event.target.died then
		event.target:setSequence("die")
		event.target:play()
		event.target.died = true

	end 
end
local function animationListener( event ) 
  	if ( event.phase == "ended" ) then
		local thisSprite = event.target  --"event.target" references the sprite
		if (thisSprite.sequence == "die") then
			thisSprite.ypos = -thisSprite.height
			thisSprite.xpos = math.random(enemies.width/2, display.contentWidth - enemies.width/2)
			thisSprite:setSequence( "walk" )  --switch to "fastRun" sequence
			thisSprite:play()  --play the new sequence; it won't play automatically!			
			thisSprite.died = false
		end
  	end 
end
--for i=1,#enemies do
	enemies:addEventListener( "sprite", animationListener )  --add a sprite listener to your sprite
	enemies:addEventListener( "touch", enemies ); -- begin detecting touches
--end

Runtime:addEventListener( "enterFrame", animate );

