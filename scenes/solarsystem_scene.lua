local SolarSystem = require("classes.world.solar_system")

local Settings = require("utils.settings") 
local solar = {}
local debugMode = false

function solar:load(args)
    -- SIMPLE TRANSITION IN --
    local vol = love.audio.getVolume()
    while vol < 1 do
        love.audio.setVolume(vol)
        vol = love.audio.getVolume() + 0.1
    end
    ---------------------------

    systemDat = args.planets  
    
    math.randomseed(systemDat.config.seed)

    width = Settings.width
    height = Settings.height

    love.physics.setMeter(32)
    world = args.world
    world:setCallbacks(beginContact, endContact)

    -- Physics settings/flags
    gravityStrength = 2000 
    isThrusting = false

    -- Create the ship
    ship = args.ship
    index = args.index

    -- Make planets
    planets = SolarSystem:new(
        world, systemDat.config.index,
        systemDat.snapshot or systemDat.config.numPlanets,
        systemDat.config.planetMinRadius,
        systemDat.config.planetMaxRadius,
        systemDat.config.audio,
        1000
    )
    -- systemDat.visited = true
    activatedPlanets = 0

    -- Graphics setup
    --love.window.setMode(width, height)
end

function solar:update(dt)
    world:update(dt)

    -- Gravity well pull
    for _, planet in ipairs(planets.system) do        
        -- update planet positions
        if not planet.sun then
            planets:moveBody(planet, dt)
        end

        local sx, sy = ship.body:getPosition()
        local px, py = planet.body:getPosition()

        local dx = px - sx
        local dy = py - sy
        local distSq = dx * dx + dy * dy

        if distSq > 0.1 then -- prevent divide by zero
            local forceMag = (gravityStrength*planet.shape:getRadius()) / distSq
            local angle = math.atan(dy, dx)
            local fx = math.cos(angle) * forceMag
            local fy = math.sin(angle) * forceMag
            ship.body:applyForce(fx, fy)
        end
    end

    -- ROTATE LEFT/RIGHT
    if love.keyboard.isDown("left") then
        ship.body:setAngle(ship.body:getAngle() - ship.turnSpeed * dt)
        isTurning = true;
    elseif love.keyboard.isDown("right") then
        ship.body:setAngle(ship.body:getAngle() + ship.turnSpeed * dt)
        isTurning = true;
    else
        isTurning = false;
    end

    -- THRUST FORWARD
    if love.keyboard.isDown("up") then
        local angle = ship.body:getAngle() - math.pi/2
        local fx = math.cos(angle) * ship.thrustPower
        local fy = math.sin(angle) * ship.thrustPower
        ship.body:applyForce(fx, fy)
        isThrusting = true
    else
        isThrusting = false
    end

    -- THRUST BACKWARD
    if love.keyboard.isDown("down") then
        local angle = ship.body:getAngle() - math.pi/2
        local fx = math.cos(angle) * -ship.thrustPower
        local fy = math.sin(angle) * -ship.thrustPower
        ship.body:applyForce(fx, fy)
    end

    -- WRAPAROUND
    local x, y = ship.body:getPosition()
    local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()

    if x < 0 then
        ship.body:setPosition(screenW, y)
    elseif x > screenW then
        ship.body:setPosition(0, y)
    end

    if y < 0 then
        ship.body:setPosition(x, screenH)
    elseif y > screenH then
        ship.body:setPosition(x, 0)
    end
end

-- Helper to apply lensing
function lensWarp(x, y, sx, sy, lensRadius, lensStrength)
    local dx = x - sx
    local dy = y - sy
    local dist = math.sqrt(dx * dx + dy * dy)
    if dist < lensRadius then
        local factor = 1 + lensStrength * (1 - dist / lensRadius)^2 * 0.02
        return sx + dx * factor, sy + dy * factor
    else
        return x, y
    end
end

function solar:draw()
    love.graphics.push()
    love.graphics.setColor(1,1,1)
    love.graphics.pop()
    -- Draw background grid with lensing effect
    local gridSpacing = 40
    local lensRadius = 60

    local lensStrength = 70
    local segmentStep = 10
    local sx, sy = ship.body:getPosition()
    love.graphics.setColor(0.25, 0.25, 0.25, 0.7)
    love.graphics.setPointSize(3)
    -- Horizontal grid lines

    for y = 0, height, gridSpacing do

        local points = {}
        for x = 0, width, segmentStep do
            local wx, wy = lensWarp(x, y, sx, sy, lensRadius, lensStrength)
            table.insert(points, wx)
            table.insert(points, wy)
        end
        love.graphics.line(points)
    end
    -- Vertical grid lines
    for x = 0, width, gridSpacing do

        local points = {}
        for y = 0, height, segmentStep do
            local wx, wy = lensWarp(x, y, sx, sy, lensRadius, lensStrength)
            table.insert(points, wx)
            table.insert(points, wy)
        end
        love.graphics.line(points)
    end

    -- Black hole effect: event horizon and accretion disk
    -- Draw radial gradient for event horizon
    for r = lensRadius * 0.7, lensRadius, 2 do
        local alpha = 0.15 * (1 - (r - lensRadius * 0.7) / (lensRadius * 0.3))
        love.graphics.setColor(0, 0, 0, alpha)
        love.graphics.circle("fill", sx, sy, r)
    end

    -- Draw swirling accretion disk
    local diskRadius = lensRadius * 1.2
    local segments = 32
    for i = 1, segments do
        local angle = (i / segments) * 2 * math.pi
        local nextAngle = ((i + 1) / segments) * 2 * math.pi
        local innerR = lensRadius * 1.05 + math.sin(love.timer.getTime() * 2 + angle * 3) * 3
        local outerR = diskRadius + math.cos(love.timer.getTime() * 2 + angle * 2) * 4
        local t = love.timer.getTime()
        local r = (0.1*activatedPlanets) + 0.3 * math.sin(t)
        local g = (0.1*activatedPlanets) + 0.3 * math.sin(t + 2)
        local b = (0.1*activatedPlanets) + 0.3 * math.sin(t + 4)
        local a = 0.3 + 0.3 * math.sin(angle * 4 + t)
        love.graphics.setColor(r, g, b, a)
        love.graphics.arc("fill", sx, sy, (innerR + outerR) / 2, angle, nextAngle)
    end

    -- Draw subtle black hole core
    love.graphics.setColor(0, 0, 0, 0.4)
    love.graphics.circle("fill", sx, sy, lensRadius * 0.7)
    love.graphics.circle("line", sx, sy, lensRadius)

    -- Draw planets
    for _, planet in ipairs(planets.system) do        
        -- local color = planet.alive and planet.color or planets:getGrey(planet.color)
        
        -- love.graphics.setColor(color)
        -- love.graphics.circle("fill", planet.body:getX(), planet.body:getY(), planet.shape:getRadius())
        planet:render()

        if planet.activationTime then
            planets:activateBody(planet)
        end
    end

    -- Ship is invisible: do not draw ship polygon or thrust flame
    -- only drawing ship when turning 
    if isTurning then
        love.graphics.setColor(1, 1, 1, 0.2)
        love.graphics.push()
        love.graphics.translate(ship.body:getX(), ship.body:getY())
        love.graphics.rotate(ship.body:getAngle())
        love.graphics.polygon("line", ship.shape:getPoints())
        love.graphics.pop()
    end
    --[[
    if isThrusting then
        love.graphics.setColor(1, 0.5, 0)
        love.graphics.polygon("fill", 0, 15, 5, 25, -5, 25)
    end
    ]]

    if debugMode then
        love.graphics.print("DEBUG MODE: click to activate", 10, 10)

        if planets.system[1].main and planets.system[1].main.loop then
            local b = planets.beat
            if b >= 0.9 then love.graphics.setColor(1, 0.5, 0) else love.graphics.setColor(1, 1, 1) end
            love.graphics.print(b , 10, 100)
        end

    end

    planets:update()

end

function beginContact(a, b, coll)
    local aData = a:getUserData()
    local bData = b:getUserData()

    -- Planet-Player collision
    if (aData.id == "planet" and bData.id == "ship") or
       (aData.id == "ship" and bData.id == "planet") then
        for _, planet in ipairs(planets.system) do
            if not planet.alive then
                local pData = planet.fixture:getUserData()
                if pData and (pData.index == aData.index or pData.index == bData.index) then
                    if planets.system[1].alive or pData.index == 1 then
                        planet.activationTime = love.timer.getTime() -- trigger planet destruction
                    end
                end
            end
        end

    end
end

function solar:keypressed(key)
    if key == "r" then
        love.audio.stop()
        planets:resetBodies()

        -- reset ship
        ship.body:setLinearVelocity(0,0)
        ship.body:setAngularVelocity(0,0)
        ship.body:setPosition(width/4, height/4)
    end
    if key == "return" then
        -- SIMPLE TRANSITION OUT --
        local vol = love.audio.getVolume()
        while vol > 0 do
            love.audio.setVolume(vol)
            vol = love.audio.getVolume() - 0.1
        end
        ---------------------------

        love.audio.stop()

        local snapshot = planets:snapshot()
        planets:clearBodies()

        ship.body:setLinearVelocity(0,0)
        ship.body:setAngularVelocity(0,0)
        ship.body:setPosition(width/4, height/4)
        
        solar.setScene("galaxy", {index = index, snapshot = snapshot})
    end

    if key=="d" then
        debugMode = not debugMode
    end
end

-- DEBUG MODE
function solar:mousepressed(x, y, button, istouch)
    if debugMode then
        if button == 1 then -- left mouse button
            -- check if one of the systems are clicked
            for i,planet in pairs(planets.system) do
                local sysX, sysY = planet.body:getPosition()
                local r = planet.radius

                if x <= sysX + r and x >= sysX - r and y <= sysY + r and y >= sysY - r then
                    if planets.system[1].alive or i == 1 then
                        planet.activationTime = love.timer.getTime() -- trigger planet destruction
                    end
                end

            end
        end
    end
end

return solar