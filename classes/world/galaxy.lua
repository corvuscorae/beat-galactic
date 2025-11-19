local System = require("classes.world.system")
local Description = require("classes.description")
local Body = require("classes.world.body")
local Settings = require("utils.settings") 
local width, height = Settings.width, Settings.height
local H = require("utils.helpers")

local ShuffleBag = require("classes.shufflebag")
local songs = require("assets.songs._tags")
local songKeys = ShuffleBag.new(H.getKeys(songs.tags))

local Galaxy = {}
Galaxy.__index = Galaxy
setmetatable(Galaxy, {__index = System})

function Galaxy:new(world, config, index, minRadius, maxRadius, mask)
    local instance = System:new(world, "galaxy", minRadius, maxRadius, 1000, mask)
    setmetatable(instance, Galaxy)

    instance.index = index

    -- description
    instance.description = Description:new()

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
        local song, key = self:getSong()
        local system = {
            config = {
                index = i,
                numPlanets = config.planets, 
                planetMinRadius = config.planetMinRadius, 
                planetMaxRadius = config.planetMaxRadius, 
                audio = { 
                    song = song,
                    layer = self:getDrums(songs.tags[key])
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

function Galaxy:getSong()
    local match = nil
    local key = nil

    while not match do
        -- get a random song
        key = songKeys:next()
        local song = songs.tags[key]
        local bpm = song.METRICS.BPM

        print(key)

        -- if song has a matching tag, add it to table
        for cat,tag in pairs(self.description.tags) do
            if(H.tableHas(song[cat], tag)) then
                local sourceLoc = songs.path .. "vocals/" .. bpm .. "/" .. key .. songs.ext
                match = love.audio.newSource(sourceLoc, "stream")
            end
        end
    end

    print("Base: " .. key)

    return match, key
end

function Galaxy:getDrums(control)
    local bpm = control.METRICS.BPM
    local dir = songs.path .. "drums/" .. bpm 
    local files = love.filesystem.getDirectoryItems(dir)

    local index = math.ceil(math.random(#files))
    local drums = files[index]
    -- print(dir, #files, index, drums)

    print("Drums: " .. drums)

    return { song = love.audio.newSource(dir .. "/" .. drums, "stream"), pitch = 1 }
end

return Galaxy
