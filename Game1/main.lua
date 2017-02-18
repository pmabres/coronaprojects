-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
--constantes
_H = display.contentHeight
_W = display.contentWidth
o = 0
Rand = math.random
time_remaining = 10
time_up = false
total_orbs = 20
ready = false

--prepare sound to be played
--local soundtrack = audio.loadStream("media/soundtrack.caf")
--local pop_sound = audio.loadSound("media/pop.caf")
--local winsound = audio.localsound("media/win.caf")
--local fail_sound = audio.loadSound("Media/fail.caf")

local txtDisplay = display.newText("Wait",0,0,native.systemFont,16*2)
txtDisplay.xScale = .5
txtDisplay.yScale = .5
txtDisplay:setReferencePoint(display.BottomLeftReferencePoint)
txtDisplay.x = 20
txtDisplay.y = _H-20

local txtCountDown = display.newText(time_remaining,0,0,native.systemFont,16*2)
txtCountDown.xScale = .5
txtCountDown.yScale = .5
txtCountDown:setReferencePoint(display.BottomRightReferencePoint)
txtCountDown.x = _W-20
txtCountDown.y = _H-20
local function trackOrbs(obj)    
    obj:removeSelf()
    o = o - 1
    if o == 0 then
        txtDisplay.text = "Win!"
        timer.cancel(gametmr)        
    end
end

local function countDown(i)
    if time_remaining == 10 then
        ready = true
        txtDisplay.text = "Go!"
    end
    time_remaining = time_remaining - 1
    txtCountDown.text = time_remaining
end
-- funcion para espawnear orbs
local function spawnOrb ()
    local orb = display.newImageRect("img/balloon.png",45,45)
    orb:setReferencePoint(display.CenterReferencePoint)
    orb.x = Rand(50,_W-50); orb.y = Rand(50,_H-50)
    function orb:touch(e)
        if ready == true then            
            if (e.phase == "ended") then
                --play the popping ound
                --audio.play(pop_sound)
                --remove orbs
                trackOrbs(self)
            end
        end 
        return true
    end
    o = o + 1
    orb:addEventListener("touch",orb)
    if o == total_orbs then
       gametmr = timer.performWithDelay(1000,countDown,10) 
    else
        ready = false
    end
end

tmr = timer.performWithDelay(20, spawnOrb, total_orbs)
