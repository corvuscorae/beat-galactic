local Settings = require("src.utils.settings") 
local width, height = Settings.width, Settings.height

-- CLASS ---
local System = {}
System.__index = System

function System:new(world, bodyType, minRadius, maxRadius, maxAttempts, mask)
    local instance = {
        index = index,
        system = {}
    }
    setmetatable(instance, System)

    self.world = world
    self.bodyType = bodyType
    self.minRadius = minRadius or 3
    self.maxRadius = maxRadius or 10
    self.maxAttempts = maxAttempts or 1000
    self.mask = mask

    return instance
end

function System:generateSystem(numBodies, startIndex, allCore) -- allCore is a temp fix to force all bodies to be static
    self:addBodies(numBodies, startIndex, allCore)
end

function System:addBodies(numBodies, startIndex, allCore)
    if not startIndex then startIndex = 1 end

    local shrink = 1
    for i = startIndex, numBodies do
        local placed = false
        local attempts = 0
    
        while not placed and attempts < self.maxAttempts do
            attempts = attempts + 1
    
            local angle = math.random() * 2 * math.pi
            local dist = math.random(100, 250)
            local x = width / 2 + math.cos(angle) * dist
            local y = height / 2 + math.sin(angle) * dist
            
            local tooClose = false
    
            for _, other in ipairs(self.system) do
                local ox, oy = other.body:getPosition()
                local dx = x - ox
                local dy = y - oy
                local dSq = dx * dx + dy * dy
                if dSq < (self.maxRadius * shrink * 2)^2 then
                    if shrink > 0 then shrink = shrink - 0.01 end
                    tooClose = true
                    break
                end
            end
    
            if not tooClose then
                local radius = love.math.random(self.minRadius, self.maxRadius * shrink)
                self:addBody({
                    angle = angle, 
                    dist = dist, 
                    radius = radius, 
                    core = allCore or false
                })
                placed = true
            end
        end
    
        if not placed then
            print("couldn't place " .. self.bodyType .. " " .. i .. " without overlap after " .. self.maxAttempts .. " attempts.")
        end
    end
end

function System:clearBodies()
    for _, body in ipairs(self.system) do
        if body.fft then
            body.fft.comp:release()
        end
        if body.audio then
            body.audio:stop()
        end
        if body.fixture and not body.fixture:isDestroyed() then
                body.fixture:destroy()
        end
        if body.body and not body.body:isDestroyed() then
            body.body:destroy()
        end
    end
    self.system = {}
end

function System:resetBodies()
    for _, body in ipairs(self.system) do
        body.alive = false
        body.activationTime = nil
    end
end

return System
