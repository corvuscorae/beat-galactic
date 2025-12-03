local SceneryInit = require("lib.scenery")
local scenery = SceneryInit(
    { path = "scenes.galaxy_scene"; key = "galaxy"; default = "true" },
    { path = "scenes.solarsystem_scene"; key = "solsys"; }
)
scenery:hook(love, { "load", "draw", "update", "keypressed", "keyreleased", "mousepressed"})