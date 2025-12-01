local System = require("classes.world.system")
local Description = require("classes.description")
local Body = require("classes.world.body")
local Settings = require("utils.settings") 
local width, height = Settings.width, Settings.height
local H = require("utils.helpers")

local ShuffleBag = require("classes.shufflebag")
local loops = require("assets.songs._tags")
local _layers = ShuffleBag.new(loops.paths.layers)

local Galaxy = {}
Galaxy.__index = Galaxy
setmetatable(Galaxy, {__index = System})

function Galaxy:new(world, config, index, minRadius, maxRadius, mask)
    local instance = System:new(world, "galaxy", minRadius, maxRadius, 1000, mask)
    setmetatable(instance, Galaxy)

    instance.index = index

    -- description
    instance.description = ""--Description:new()

    -- generate a collection of solar systems
    instance.solarSystems = instance:populate(config, world)
    instance.solarSystems.snapshot = nil

    -- make a drawable system to represent galaxy
    if type(config.systems) == "number" then
        instance:generateSystem(config.systems, 1, true)
    else -- assuming it's a snapshot
        instance:loadSnapshot(config.systems, world)
    end

    return instance
end

function Galaxy:populate(config, world)
    local g = {}
    local num = config.systems

    for i = 1, num do
        local main = self:getLayer("main", {getMetrics = true})
        local layers = self:getLayers(
            {"drums", "texture", "padding", "padding", "texture"}, 
            main.metrics
        )

        local system = {
            config = {
                index = i,
                numPlanets = config.planets, 
                planetMinRadius = config.planetMinRadius, 
                planetMaxRadius = config.planetMaxRadius, 
                audio = { 
                    main = main.path,
                    layers = ShuffleBag.new(layers)
                },
                seed = math.random(0, 10000)
            },
            snapshot = nil,
            -- visited = false
        }

        table.insert(g, system)
    end

    return g
end

function Galaxy:addBody(angle, dist, radius)
    local config = {
        world = world,
        isCore = false,
        mask = self.mask,
        type = "static"
    }

    local pos = {
        x = width / 2 + math.cos(angle) * dist,
        y = height / 2 + math.sin(angle) * dist,
        radius = radius,
    }

    local body = Body:new(config, pos)
    body.fixture:setUserData({ id=self.bodyType, index=#self.system })

    body.color = {1,1,1}

    table.insert(self.system, body)
end

function Galaxy:getLayer(type, conf)
    print(type)

    local bpm = conf.bpm
    if not bpm then
        local bpms = H.getKeys(loops.tags[type])
        bpm = bpms[math.random(#bpms)]
    end
    print(bpm)
    
    local key = (type == "drums") and "x" or conf.key
    if not key then
        local keys = H.getKeys(loops.tags[type][bpm])
        key = keys[math.random(#keys)]
    end
    print(key)

    local layers = nil
    local layer = nil
    local path = loops.applepath .. type .. "/" .. bpm:gsub("_", "") .. "/" .. key .. "/"
    if loops.tags[type][bpm][key] then
        layers = H.getKeys(loops.tags[type][bpm][key])
        layer = layers[math.random(#layers)]
        path = path .. layer .. ".mp3"
    else
        print("WARNING! No loops in {" .. path .. "}" )
        path = nil
    end

    local result = { path = path }
    if conf.getMetrics == true then result.metrics = { bpm = bpm, key = key } end

    return result
end

function Galaxy:getLayers(types, metrics)
    local layers = {}

    for _,type in pairs(types) do
        print(metrics.bpm, metrics.key)
        local loop = self:getLayer(type, metrics)
        table.insert(layers, loop.path)
    end

    return layers
end

return Galaxy
