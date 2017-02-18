-- Project: Game3
-- Description:
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2013 . All Rights Reserved.
---- cpmgen main.lua



local physics = require("physics")
physics.start()

function createBalls(event)
	circulo = display.newCircle( event.x, event.y, 10 )
	physics.addBody(circulo,"dynamic", {2,2, 2,10})
end
Runtime:addEventListener("touch",createBalls)


