local bases = require("src.grammars.bases")
local fillers = require("src.grammars.fillers")

-- CLASS ---
local Description = {}
Description.__index = Description

function Description:new()
    math.randomseed(os.time())
    local instance = {
        base = bases[math.random(1, #bases)]
    }
    setmetatable(instance, Description)

    instance.filled, instance.tags = instance:generate()

    return instance
end

function Description:generate()
    local result = self.base
    local tags = {}

    while result:find(("%#(.%a+)%#")) do
        local _,index,found = result:find("%#(.%a+)%#")

        local catBag = fillers[found]   -- get filler values
        local fill = catBag:next()

        tags[found] = fill
        result = result:gsub(("%#".. found .."%#"), fill, 1)
    end

    return result, tags
end

return Description