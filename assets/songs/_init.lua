local path = "assets/songs/drums/169/"
local files = love.filesystem.getDirectoryItems(path)

local i = {}

-- formats file names to be usable keys in a lua object
local function formatName(filename, ext)
    -- replace all non-alphanumerics w/ underscores (except period to preserve file type (e.g. ".wav"))
    local _,__,noExt = filename:find("(.+)%" .. ext .. "$")
    local result = noExt:gsub("[^%w]", "_")

    -- cleanup
    result = result:gsub("_+", "_") -- consecutive underscores
    result = result:gsub("^_+", "") -- leading underscores
    result = result:gsub("_+$", "") -- trailing underscores

    result = result:gsub("%d+_", "") 
    result = result:gsub("looperman_l_", "") 

    -- put ext back
    result = result .. ext

    return result
end

-- this will rename all files so they don't have spaces, 
--  and will also print filenames (without ext) (so we can copy/paste them to the tags object)
function i.initFiles(ext, log)
    for _, origName in ipairs(files) do
        local info = love.filesystem.getInfo(path .. origName)
        if info and info.type == "file" and origName ~= "_tags.lua" and origName ~= "_init.lua" then
            local format = formatName(origName, ext)
            if #format > 0 then
                -- remove spaces and rename file
                -- https://www.gammon.com.au/scripts/doc.php?lua=os.rename
                os.rename(path .. origName, path .. format)

                local _,__,param = format:find("(.+)%" .. ext .. "$")
                if log then print(param .. " = {},") end
            else
                local _,__,param = format:find("(.+)%" .. ext .. "$")
                if log then print(param .. " = {},") end
            end

        end
    end
end

return i