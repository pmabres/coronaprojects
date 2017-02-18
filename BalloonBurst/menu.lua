module(...,package.seeall)

function new()
	local Scene = display.newGroup()
	local GUI = display.newGroup()
	local bg_frame = display.newimage("nombreimagen")
	local bg_knockout = display.newimage("nombreimagen")
	local bg_rect = display.display.newRect(0,0,_W,_H)

	bg_rect.x =_WM; bg_rect.y = _HM;
	bg_rect:setFillColor(66,159,255)

	GUI:insert(bg_rect);
	GUI:insert(bg_knockout);
	GUI:insert(bg_frame);

	local title = display.newText("Balloon Burst", 0, 0, "Arial", 24)
	title.x = _WM; title.y = _HM - 120;
	local play_btn = display.newText("Play",0,0,"Arial",20)
	play_btn.x = _WM; play_btn.y = _HM;
	play_btn.scene = "game";

	GUI:insert(title);
	GUI:insert(play_btn);

	local function changeScene(e)
		if(e.phase == "ended" or e.phase == "cancelled") then
			director:changeScene(e.target.scene)
		end
	end

	play_btn:addEventListener("touch", changeScene)
	Scene:insert(GUI)
	return Scene
end
