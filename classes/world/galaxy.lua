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
    local bpm = conf.bpm
    if not bpm then
        local bpms = H.getKeys(loops.tags[type])
        bpm = bpms[math.random(#bpms)]
    end
    
    local key = (type == "drums") and "x" or conf.key
    if not key then
        local keys = H.getKeys(loops.tags[type][bpm])
        key = keys[math.random(#keys)]
    end

    local layers = nil
    local layer = nil
    local path = loops.applepath .. type .. "/" .. bpm:gsub("_", "") .. "/" .. key .. "/"
    local pitch = 1
    if loops.tags[type][bpm][key] then
        layers = H.getKeys(loops.tags[type][bpm][key])
        layer = layers[math.random(#layers)]
        path = path .. layer .. ".mp3"
    else
        print("WARNING! No loops in {" .. path .. "}" )

        local potential_matches = getBPMKeyMatches(bpm:gsub("_", ""), key)
        local matches = {}

        print("***" .. type .. " matches for " .. bpm .. " in " .. key .. ":\n")
        print(string.format("%-8s %-12s %-8s %-12s", "shift", "bpm", "key", "pitch ratio"))
        print(string.rep("-", 45))
        
        for _, match in ipairs(potential_matches) do
            local shift = string.format("%+d", match.semitoneShift)

            local match_bpm = "_" .. match.bpm

            local bpms = H.getKeys(loops.tags[type])
            local keys = H.getKeys(loops.tags[type][match_bpm])

            if not keys then goto continue end

            if  H.tableHas(bpms, match_bpm) then 
                local match_key = ""
                if H.tableHas(keys,match.key[1]) then
                    match_key = match_key .. match.key[1]
                end
                if H.tableHas(keys,match.key[2]) then
                    match_key = match_key .. #match_key > 0 and ", " or "" .. match.key[2]
                end

                if #match_key > 0 then 
                    local mStr = string.format("%-8s %-12d %-8s %.3f", shift, match.bpm, match_key, match.ratio)
                    print(mStr)

                    -- add a match for each key k
                    local m_keys = {}
                    for k in match_key:gmatch("[^,%s]+") do
                        match.key = k
                        table.insert(matches, match)
                    end
                end

            end

            ::continue::

            -- print(string.format("%-8s %-12d %-8s %.3f", shift, match.bpm, match.key[1] .. ", " .. match.key[2], match.ratio) .. " *missing")
        end
   
        if #matches == 0 then path = nil
        else 
            local pick = matches[math.random(#matches)]
            print("PICK = ", pick.bpm, pick.key)

            layers = H.getKeys(loops.tags[type]["_" .. pick.bpm][pick.key])
            layer = layers[math.random(#layers)]

            path = loops.applepath .. type .. "/" .. pick.bpm .. "/" .. pick.key .. "/" .. layer .. ".mp3"
            pitch = pick.dir == "up" and pick.ratio or pick.ratio * 2
        end
    end

    local result = { path = path, pitch = pitch }
    if conf.getMetrics == true then result.metrics = { bpm = bpm, key = key } end

    return result
end

function Galaxy:getLayers(types, metrics)
    local layers = {}
    local maxTries = 500

    for _,type in pairs(types) do
        local loop = { path = nil }
        local tries = 0
        while tries < maxTries and not loop.path do 
            loop = self:getLayer(type, metrics) 
            tries = tries + 1
        end
        if loop.path then table.insert(layers, loop) end
    end

    return layers
end

function getBPMKeyMatches(bpm, key)
    local noteToSemitone = {
        C =  0,     Am =  0,
        Db = 1,     Bbm = 1,
        D =  2,     Bm =  2,
        Eb = 3,     Cm =  3,
        E =  4,     Dbm = 4,
        F =  5,     Dm =  5,
        Gb = 6,     Ebm = 6,
        G =  7,     Em =  7,
        Ab = 8,     Fm =  8,
        A =  9,     Gbm = 9,
        Bb = 10,    Gm =  10,
        B =  11,    Abm = 11
    }

    local semitoneToNote = { [0] =
        { "C"   , "Am"  },
        { "Db"  , "Bbm" },
        { "D"   , "Bm"  },
        { "Eb"  , "Cm"  },
        { "E"   , "Dbm" },
        { "F"   , "Dm"  },
        { "Gb"  , "Ebm" },
        { "G"   , "Em"  },
        { "Ab"  , "Fm"  },
        { "A"   , "Gbm" },
        { "Bb"  , "Gm"  },
        { "B"   , "Abm" },
    }

    local origSemitone = noteToSemitone[key]
    local matches = {}

    for semitoneShift = -12, 12 do
        if semitoneShift ~= 0 then  
            local pitchRatio = 2 ^ (semitoneShift / 12)
            
            local targetBPM = bpm * pitchRatio
            local targetSemitone = (origSemitone + semitoneShift) % 12
            local targetKeys = semitoneToNote[targetSemitone]
            
            table.insert(matches, {
                semitoneShift = semitoneShift,
                bpm = math.floor(targetBPM + 0.5),  -- rounded
                -- bpmExact = targetBPM,
                key = targetKeys,
                ratio = pitchRatio,
                dir = semitoneShift > 0 and "up" or "down"
            })
        end
    end
    
    return matches
end


return Galaxy
