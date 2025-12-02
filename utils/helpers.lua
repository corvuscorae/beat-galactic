---@diagnostic disable: deprecated
local H = {}

function H.clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

function H.tableHas(table, val)
    for i,v in ipairs(table) do
        if v == val then
            return true
        end
    end

    return false
end

function H.execute(func, ...)
    if type(func) == "function" then
        local args = {...}

        for i,a in ipairs(args) do
            if type(a) == "function" then
                args[i] = a()
            end
        end

        if not table.unpack then
            table.unpack = unpack
        end

        return func(table.unpack(args))
    else
        print("Error: Not a function provided.")
    end
end

function H.getGrey(color)
    local grey = (color[1] + color[2] + color[3]) / 3
    return {grey, grey, grey}    
end

function H.getKeys(t)
    if not t then return nil end

    local keys = {}

    for key,_ in pairs(t) do
        table.insert(keys, key)
    end

    return keys
end

function H.printKeys(t)
    if not t then return nil end
    
    local keys = H.getKeys(t)
    if not t then return "" end

    local key_str = ""
    for key,_ in pairs(keys) do
        key_str = key_str .. key .. ", "
    end

    return key_str
end

return H