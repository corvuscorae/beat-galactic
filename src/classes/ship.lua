local Solar = require("src.classes.world.solar_system")
local Ship = {}
Ship.__index = Ship

function Ship:new(world, x, y)
    local instance = {}
    setmetatable(instance, Ship)

    instance.body = love.physics.newBody(world, x, y, "dynamic")
    instance.shape = love.physics.newPolygonShape(12, 10, 0, -15, -12, 10)    
    instance.fixture = love.physics.newFixture(instance.body, instance.shape)
    instance.fixture:setUserData({ id="ship" })

    instance.thrustPower = 25
    instance.turnSpeed = 3 -- radians per second

    instance.body:setAngularDamping(3)
    instance.body:setLinearDamping(0.5)

    return instance
end

function Ship:destroy()
    if self.fixture and not self.fixture:isDestroyed() then
        self.fixture:destroy()
    end

    if self.body and not self.body:isDestroyed() then
        self.body:destroy()
    end

    self.fixture = nil
    self.shape = nil
    self.body = nil
end

return Ship
