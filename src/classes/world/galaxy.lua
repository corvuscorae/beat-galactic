local System = require("src.classes.world.system")
local Description = require("src.classes.description")
local Body = require("src.classes.world.body")
local Settings = require("src.utils.settings") 
local width, height = Settings.width, Settings.height
local H = require("src.utils.helpers")

local ShuffleBag = require("src.classes.shufflebag")
local loops = require("assets.songs._tags")
local _layers = ShuffleBag.new(loops.paths.layers)

local Galaxy = {}
Galaxy.__index = Galaxy
setmetatable(Galaxy, {__index = System})

-- debug
local printMatches = false

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
                    main = main,
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

function Galaxy:addBody(c)
    local config = {
        world = world,
        core = false,
        mask = self.mask,
        type = "static"
    }

    local pos = {
        x = width / 2 + math.cos(c.angle) * c.dist,
        y = height / 2 + math.sin(c.angle) * c.dist,
        radius = c.radius,
    }

    local body = Body:new(config, pos)
    body.fixture:setUserData({ id=self.bodyType, index=#self.system })

    body.color = {1,1,1}

    table.insert(self.system, body)
end

function Galaxy:getLayer(cat, conf)
    ::tryagain::
    local bpm = conf.bpm
    if not bpm then
        local bpms = H.getKeys(loops.tags[cat])
        bpm = bpms[math.random(#bpms)]
    end
    
    local key = (cat == "drums") and "x" or conf.key
    if not key then
        local keys = H.getKeys(loops.tags[cat][bpm])
        key = keys[math.random(#keys)]
    end

    local layers = nil
    local layer = nil
    local path = loops.applepath .. cat .. "/" .. bpm:gsub("_", "") .. "/" .. key .. "/"
    local pitch = 1

    if loops.tags[cat][bpm] and loops.tags[cat][bpm][key] and #loops.tags[cat][bpm][key] > 0 then
        layers = H.getKeys(loops.tags[cat][bpm][key])
        layer = layers[math.random(#layers)]
        path = path .. layer .. ".mp3"
    else
        print("WARNING! No loops in {" .. path .. "}" )

        if cat == "drums" then 
            local bpms = H.getKeys(loops.tags[cat])
            local new_bpm = bpms[math.random(#bpms)]
            
            local new_bpm_num = new_bpm:gsub("_","")
            new_bpm_num = tonumber(new_bpm_num)
            local bpm_num = bpm:gsub("_","")
            bpm_num = tonumber(bpm_num)

            local ratio = new_bpm_num / bpm_num

            print("no " .. bpm .. " drums, getting " .. new_bpm .. "...")
            layers = H.getKeys(loops.tags[cat][new_bpm][key])
            layer = layers[math.random(#layers)]
            path = loops.applepath .. cat .. "/" .. new_bpm:gsub("_", "") .. "/" .. key .. "/" .. layer .. ".mp3"
            pitch = ratio
        else
            local potential_matches = getBPMKeyMatches(bpm:gsub("_", ""), key)
            local matches = {}

            if printMatches then
                print("***" .. cat .. " matches for " .. bpm .. " in " .. key .. ":\n")
                print(string.format("%-8s %-12s %-8s %-12s", "shift", "bpm", "key", "pitch ratio"))
                print(string.rep("-", 45))
            end
            
            for _, match in ipairs(potential_matches) do
                local shift = string.format("%+d", match.semitoneShift)

                local match_bpm = "_" .. match.bpm

                local bpms = H.getKeys(loops.tags[cat])
                local keys = H.getKeys(loops.tags[cat][match_bpm])

                if not keys then goto continue end

                if  H.tableHas(bpms, match_bpm) then 
                    local match_key = ""
                    if H.tableHas(keys,match.key[1]) then
                        match_key = match_key .. match.key[1]
                    end
                    if H.tableHas(keys,match.key[2]) then
                        local comma = (#match_key > 0) and ", " or ""
                        match_key = match_key .. comma .. match.key[2]
                    end

                    if #match_key > 0 then 
                        local mStr = string.format("%-8s %-12d %-8s %.3f", shift, match.bpm, match_key, match.ratio)
                        -- print(mStr)

                        -- add a match for each key k
                        local m_keys = {}
                        for k in match_key:gmatch("[^,%s]+") do
                            match.key = k
                            table.insert(matches, match)
                        end
                    end

                end

                ::continue::

                if printMatches then 
                    if type(match.key) == "table" then
                        print(string.format("%-8s %-12d %-8s %.3f", shift, match.bpm, match.key[1] .. ", " .. match.key[2], match.ratio) .. " *missing")
                    end
                    if type(match.key) == "string" then
                        print(string.format("%-8s %-12d %-8s %.3f", shift, match.bpm, match.key, match.ratio) .. " *missing")
                    end
                end
            end
            if #matches == 0 then goto tryagain
            else 
                local pick = matches[math.random(#matches)]
                print("PICK = ", pick.bpm, pick.key)

                layers = H.getKeys(loops.tags[cat]["_" .. pick.bpm][pick.key])
                layer = layers[math.random(#layers)]

                path = loops.applepath .. cat .. "/" .. pick.bpm .. "/" .. pick.key .. "/" .. layer .. ".mp3"
                pitch = pick.dir == "up" and pick.ratio or pick.ratio * 2
            end
        end
    end

    local result = { path = path, pitch = pitch }
    if conf.getMetrics == true then result.metrics = { bpm = bpm, key = key } end

    return result
end

function Galaxy:getLayers(types, metrics)
    local layers = {}
    local maxTries = 5

    for _,type in pairs(types) do
        local loop = { path = nil }
        -- local tries = 0
        -- while tries < maxTries and not loop.path do 
            loop = self:getLayer(type, metrics) 
            -- tries = tries + 1
        -- end
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
