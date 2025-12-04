local H = require("src.utils.helpers")
local Settings = require("src.utils.settings")
local width, height = Settings.width, Settings.height

local Ship = require("src.classes.ship")

local gal = {}
local Galaxy = require("src.classes.world.galaxy")

function gal:load(args)
    if args and args.index and args.snapshot then 
        galaxy.solarSystems[args.index].snapshot = args.snapshot 
    end

    if not world then world = love.physics.newWorld(0, 0, true) end
    if not ship then ship = Ship:new(world, width/4, height/4) end

    local mask = 1
    if not galaxy then
        local sysConf = {
            systems = 5,
            planets = 6,  
            planetMinRadius = 5,
            planetMaxRadius = 25
        }

        galaxy = Galaxy:new(world, sysConf, "TEMP_INDEX", 30, 100, mask)
    end

    -- print(galaxy.description.filled)

    if not sys_select then sys_select = 1 end
end

function gal:draw()
    -- LEGACY
    -- love.graphics.print("press enter to go to solar system #" .. sys_select, 200, 300)

    -- Draw stars/solar systems
    for _, planet in ipairs(galaxy.system) do        
        local color = planet.alive and planet.color or H.getGrey(planet.color)
        
        love.graphics.setColor(color)
        love.graphics.circle("fill", planet.body:getX(), planet.body:getY(), planet.shape:getRadius())

        if planet.activationTime then
            galaxy:activateBody(planet)
        end
    end

    love.graphics.push()

    local ins = "> click any solar system to enter\n> press R to regenerate"
    local font = love.graphics.getFont()
    local textW = font:getWidth(ins)
    local textH = font:getHeight(ins) * 4

    love.graphics.setColor({0,0,0, 0.2})
    love.graphics.rectangle("fill", width - textW - 10, height - textH - 20, textW + 10, textH + 20)
    love.graphics.setColor({1,1,1})
    love.graphics.print(ins, width - textW - 10, height - textH - 10)

    love.graphics.pop()
end

function gal:update(dt)
end

function gal:keypressed(key)
    if key == "r" then
        world = nil
        ship = nil
        galaxy = nil
        sys_select = nil
        gal.setScene("galaxy")
    end
end

function gal:mousepressed(x, y, button, istouch)
    if button == 1 then -- left mouse button
        -- check if one of the systems are clicked
        for i,system in pairs(galaxy.system) do
            local sysX, sysY = system.body:getPosition()
            local r = system.radius

            if x <= sysX + r and x >= sysX - r and y <= sysY + r and y >= sysY - r then
                gal.setScene(
                    "solsys",  
                    {   
                        ship = ship, 
                        planets = galaxy.solarSystems[i], 
                        index = i,
                        world = world
                    }
                )
            end

        end
    end
end

return gal