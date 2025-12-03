local System = require("classes.world.system")
local Body = require("classes.world.body")
local Settings = require("utils.settings") 
local width, height = Settings.width, Settings.height
local H = require("utils.helpers")

--------------------------------------------------
local ShuffleBag = require("classes.shufflebag")
local colors = {
    {1, 0.5, 0.4},  -- pink
    {1, 0.7, 0.4},  -- light orange
    {1, 0.9, 0.4},  -- light yellow
    {0.4, 1, 0.7},  -- greenish-blue
    {0.4, 1.7, 1},  -- light blue
    {0.5, 0.4, 1}   -- periwinkle
}
local colorBag = ShuffleBag.new(colors)
--------------------------------------------------

local SolarSystem = {}
SolarSystem.__index = SolarSystem
setmetatable(SolarSystem, {__index = System})

function SolarSystem:new(world, planets, minRadius, maxRadius, audio, maxAttempts)
    local instance = System:new(world, "planet", minRadius, maxRadius, maxAttempts)
    setmetatable(instance, SolarSystem)
    
    instance.type = "solar_system"
    instance.audio = audio
    instance.beat = -1
    instance.queued = {}

    if type(planets) == "number" then
        instance:generateSystem(planets)
    else -- assuming it's a snapshot
        instance:loadSnapshot(planets, world)
    end

    return instance
end

function SolarSystem:generateSystem(numPlanets)
    -- place sun in center
    local m = math.random(1.5, 3)
    self:addBody(0, 0, self.maxRadius*m, true)

    self:addBodies(numPlanets, 2)
end

function SolarSystem:addBody(angle, dist, radius, isCore, state)
    local forceColor = isCore and {1,1,1} or nil

    local config = {
        world = self.world,
        isCore = isCore,
        mask = self.mask,
        type = isCore and "static" or "dynamic"
    }

    local pos = {
        x = width / 2 + math.cos(angle) * dist,
        y = height / 2 + math.sin(angle) * dist,
        radius = radius,
    }

    local body = Body:new(config, pos, state)

    -- adding planet specific stuff to body
    -- body.loop = self.loopBag:next()
    body.color = forceColor or colorBag:next()
    body.rendering = {
        func = function ()
                local color = body.alive and body.color or H.getGrey(body.color)
                love.graphics.setColor(color)
                love.graphics.circle("fill", body.body:getX(), body.body:getY(), body.radius)
            end,
        args = { }
    }

    -- positioning
    body.angle = angle
    body.dist = dist
    body.rotationSpeed = radius / 150

    table.insert(self.system, body)
    body.fixture:setUserData({ id=self.bodyType, index=#self.system })

    if body.core then
        body.main = self.audio.main
        -- body.main.path = self.audio.main.path
        body.main.loop = love.audio.newSource(self.audio.main.path, "stream")
    else
        local _layer = self.audio.layers:next()
        if _layer then
            if not _layer.path then
                print("ERROR, ln 94, solar_system.lua: ", _layer)
            end
            body.layer = {}
            body.layer.path = _layer.path
            body.layer.loop = love.audio.newSource(body.layer.path, "stream")
            body.layer.loop:setPitch(_layer.pitch)
        end
    end

    return body
end

function SolarSystem:moveBody(body, dt)
    body.angle = body.angle + body.rotationSpeed * dt

    local x = width / 2 + math.cos(body.angle) * body.dist
    local y = height / 2 + math.sin(body.angle) * body.dist

    body.body:setPosition(x,y)
end

function SolarSystem:activateBody(body, overrideCore)
    -- requires system's core to be active to proceed (unless override flag is on)
    if not overrideCore and (not body.core and not self.system[1].alive) then return end 

    if (love.timer.getTime() - body.activationTime) < 0.02 then
        love.graphics.setColor(1, 0.5, 0.1, 0.8)
        love.graphics.circle("fill", body.body:getX(), body.body:getY(), 5*body.shape:getRadius())
    else
        if body.core then
            -- Play loop
            if not body.main.active then
                body.main.loop:setVolume(0.7)    -- dear god make it stop
                body.main.loop:setLooping(true)
                love.audio.play(body.main.loop)

                print(body.main.path)

                body.main.active = true
            end
        elseif body.layer then
            if not body.layer.active then
                body.layer.loop:setVolume(0.7)
                body.layer.loop:setLooping(true)

                if not (self.beat >= 0.9) then
                    table.insert(self.queued, body.layer)
                    print("loop queued")

                else
                    love.audio.play(body.layer.loop)
                    print(body.layer.path)
                end

                body.layer.active = true
            end
        else
            print("No loop")
        end

        if not body.alive then
            body.alive = true
        end
    end
end

function SolarSystem:snapshot()
    local s = {}
    for i, body in ipairs(self.system) do
        s[i] = {
            angle = body.angle,
            dist = body.dist,
            radius = body.radius,
            core = body.core,
            layer = body.layer,
            state = {alive=body.alive, activationTime=body.activationTime}
        }
    end

    return s
end

function SolarSystem:loadSnapshot(snapshot)
    for i, b in ipairs(snapshot) do
        local body = self:addBody(b.angle, b.dist, b.radius, b.core, b.state)

        for j,v in pairs(b) do
            if not body[j] then body[j] = v end
        end

    end
end

function SolarSystem:update()
    local bpm = self.system[1].main.metrics.bpm:gsub("_", "")
    local beatWidth = 1 / (tonumber(bpm) / 60)

    local songTime = self.system[1].main.loop:tell()
    self.beat = (songTime / beatWidth) % 1

    if (#self.queued > 0) and (self.beat >= 0.9) then
        local layer = self.queued[1]

        if not layer.loop:isPlaying() then
            love.audio.play(layer.loop)
            print(layer.path)
        end

        table.remove(self.queued, 1)
    end
end

return SolarSystem