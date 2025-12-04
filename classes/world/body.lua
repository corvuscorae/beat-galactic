local loveFFT = require("lib.lovefft.lovefft")
local tags = require("assets.songs.tagged")
local H = require("utils.helpers")
local Body = {}
Body.__index = Body

function Body:new(config, position, state)
    local instance = {}
    setmetatable(instance, Body)
    
    -- initial state
    instance.alive = state and state.alive or false 
    instance.activationTime = state and state.activationTime or nil
    instance.core = config.core  -- central body?
    instance.audio = nil

    -- physics
    instance.body = love.physics.newBody(
        config.world,
        position.x,
        position.y,
        config.type
    )

    instance.radius = position.radius

    instance.shape = love.physics.newCircleShape(position.radius)
    instance.fixture = love.physics.newFixture(instance.body, instance.shape)
    if config.mask then
        instance.fixture:setCategory(config.mask)
        instance.fixture:setMask(config.mask)
    end

    return instance
end

function Body:initFFT(size, ID)
    if not self.soundData then return end

    if not self.fft then
        self.fft = {}

        self.fft.size = size
        self.fft.array = {}

        self.fft.comp = loveFFT:new(size, ID)
        self.fft.comp:setSoundData(self.soundData)
        print("body " .. ID .. " FFT initialized!")

    else
        print(self.fft.comp, self.fft.array, self.fft.size)
    end

end

function Body:FFTsnapshot()
    return {
        fft
    }
end

function Body:updateFFT()
    if not self.soundData then return end
    if not self.audio then return end

    if self.audio:isPlaying() then
        local time = self.audio:tell()
        if time < self.audio:getDuration() then
            self.fft.comp:updatePlayTime(time)
            self.fft.array = self.fft.comp:pop()
        end
    end
end

function Body:render()
    if self.rendering and self.rendering.func and self.rendering.args then
        H.execute(self.rendering.func, self.rendering.args)
    else
        print("Error: Invalid rendering function.")
    end
end

return Body