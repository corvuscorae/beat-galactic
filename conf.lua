local Settings = require("src.utils.settings") 

function love.conf(t)
	t.console		= Settings.console --true
	t.window.width 	= Settings.width --650
	t.window.height = Settings.height --650
	t.title   		= Settings.title --"planet game"
end