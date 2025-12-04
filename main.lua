local SceneryInit = require("src.lib.scenery")
local scenery = SceneryInit(
    { path = "src.scenes.galaxy_scene"; key = "galaxy"; default = "true" },
    { path = "src.scenes.solarsystem_scene"; key = "solsys"; }
)
scenery:hook(love, { "load", "draw", "update", "keypressed", "keyreleased", "mousepressed"})