-- 
-- Abstract: Bouncing fruit, using enterFrame listener for animation
-- 
-- Version: 1.3 (uses new viewableContentHeight, viewableContentWidth properties)
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.

-- Demonstrates a simple way to perform animation, using an "enterFrame" listener to trigger updates.
-- GLOBALES
local storyboard = require "storyboard"
local scene = storyboard.newScene("main")
storyboard.gotoScene("main")
_H = display.contentHeight
_W = display.contentWidth
GAME_STATUS_PLAYING = 0
GAME_STATUS_LOOSE = 1
GAME_STATUS_WIN = 2
GAME_STATUS_PAUSE = 3
gameStatus = GAME_STATUS_PLAYING
INITIAL_LIFES = 3
-----------------------------------------------------------------------------------------------
local background = display.newImage( "graphics/bg.jpg" )
local txtMessage = display.newText("", 0, 0, "Arial", 24)
local radius = 40
local xpos = display.contentWidth * 0.5
local ypos = display.contentHeight * 0.5
local score = 0
local lifes = INITIAL_LIFES
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
local enemySheet = graphics.newImageSheet( "graphics/tile2.png", sheetData )
txtScore = display.newText("Score="..score, 30, 10, "Arial", 24)
txtLifes = display.newText ("Lifes="..lifes,_W - 120,10,"Arial",24)
--Create a table to hold our spawns
local enemies = {}
--Function to spawn an object
local function spawnEnemy(index)	
	local enemy = display.newSprite( enemySheet, sequenceData )
	enemy.xspeed = 0
	enemy.yspeed = math.random(1,3)
	enemy.xdirection = 1
	enemy.ydirection = 1
	enemy.xpos = math.random(enemy.width/2 + 10, display.contentWidth - enemy.width/2 - 10)
	enemy.ypos = math.random(-enemy.height,0)
	enemy.died = false
	enemy:play()
	return enemy
end

local function SpawnEnemies()	
	for i = 1, 15 do				
		enemies[i] = spawnEnemy(i)	
	end
end
SpawnEnemies()

local function resetEnemyPositions()
	for i = 1,#enemies do
		enemies[i].xpos =  math.random(enemies[i].width/2 + 10, display.contentWidth - enemies[i].width/2 - 10)
		enemies[i].ypos = math.random(-enemies[i].height,0)
		enemies[i].died = false
		enemies[i]:play()
	end
end
-- Get current edges of visible screen (accounting for the areas cropped by "zoomEven" scaling mode in config.lua)
local screenTop = display.screenOriginY
local screenBottom = display.viewableContentHeight + display.screenOriginY
local screenLeft = display.screenOriginX
local screenRight = display.viewableContentWidth + display.screenOriginX
txtScore:toFront()
txtLifes:toFront()
txtMessage:toFront()
local function onUpdate(event)	

	for i=1,#enemies do	
		if (not enemies[i].died) then
			enemies[i].xpos = enemies[i].xpos + ( enemies[i].xspeed * enemies[i].xdirection );
			enemies[i].ypos = enemies[i].ypos + ( enemies[i].yspeed * enemies[i].ydirection );	
			enemies[i]:translate( enemies[i].xpos - enemies[i].x, enemies[i].ypos - enemies[i].y)
			if (enemies[i].y - enemies[i].height / 2 > display.contentHeight) then	
				lifes = lifes - 1
				txtLifes.text = "Lifes="..lifes				
				enemies[i].y = -enemies[i].height	
				enemies[i].x = math.random(enemies[i].width/2, display.contentWidth - enemies[i].width/2)
			end
			enemies[i].ypos = enemies[i].y
			enemies[i].xpos = enemies[i].x
		end
	end	
	checkGameStatus()
end

function checkGameStatus()
	if (lifes<=0) then
		gameStatus = GAME_STATUS_LOOSE		
	end
	if (score>=30) then
		gameStatus = GAME_STATUS_WIN
	end
	if gameStatus == GAME_STATUS_WIN then
		showEndingText("Winner!",255,255,0)
		removeListeners()
	elseif gameStatus == GAME_STATUS_LOOSE then
		showEndingText("Game Over",255,0,0)
		removeListeners()
	end	
end

function showEndingText(text,r,g,b)	
	txtMessage.text = text
	txtMessage.x =  _W / 2
	txtMessage.y =  _H / 2	
	txtMessage:setTextColor(r, g, b)
	txtMessage.align = "center"	
	
end
-- touch listener 
function touchListener( event )	
	if event.phase == "began" and not event.target.died then
		event.target:setSequence("die")
		event.target:play()
		event.target.died = true
		score = score + 1
		txtScore.text = "Score="..score

	end 
end
local function animationListener( event ) 
  	if ( event.phase == "ended" ) then
		local thisSprite = event.target  --"event.target" references the sprite
		if (thisSprite.sequence == "die") then
			thisSprite.ypos = -thisSprite.height
			thisSprite.xpos = math.random(event.target.width/2, display.contentWidth - event.target.width/2)
			thisSprite:setSequence( "walk" )  --switch to "fastRun" sequence
			thisSprite:play()  --play the new sequence; it won't play automatically!			
			thisSprite.died = false
		end
  	end 
end
function removeListeners()
	Runtime:removeEventListener("enterFrame", onUpdate)
	for i=1,#enemies do
		enemies[i]:pause()
		enemies[i]:removeEventListener( "sprite", animationListener )  --add a sprite listener to your sprite
		enemies[i]:removeEventListener( "touch", touchListener ) -- begin detecting touches
	end
end
function addListeners()
	Runtime:addEventListener("enterFrame", onUpdate)
	for i=1,#enemies do
		enemies[i]:addEventListener( "sprite", animationListener )  --add a sprite listener to your sprite
		enemies[i]:addEventListener( "touch", touchListener ) -- begin detecting touches
	end
end
function txtMessage:touch(event)
	self.y = 0
	self.x = 0
	self.text = ""
	gameStatus = GAME_STATUS_PLAYING
	score = 0
	lifes = INITIAL_LIFES
	txtScore.text = "Score="..score
	txtLifes.text = "Lifes="..lifes
	resetEnemyPositions()
	addListeners()	
end
addListeners()
txtMessage:addEventListener("touch", txtMessage)


