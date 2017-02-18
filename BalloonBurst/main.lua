_W = display.contentWidth
_H = display.contentHeight
_WM = _W * 0.5
_HM = _H * 0.5
display.display.setStatusBar(display.HiddenStatusBar)

--cached math functions
m = {}
m.random = math.random

local director = require("director");

local mainGroup = display.display.newGroup()

local function main()
	mainGroup:group:insert(director.directorView)
	director:changeScene("menu");
	return true;
end
main();