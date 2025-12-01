local H = require("utils.helpers")
local path = "assets/songs/"

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

    -- put ext back
    result = result .. ext

    return result
end

-- this will rename all files so they don't have spaces, 
--  and will also print filenames (without ext) (so we can copy/paste them to the tags object)
function i.initFiles(path, subfolders, ext, log)
    local paths = {
        mains = {},
        layers = {}
    }

    for _,sub in ipairs(subfolders) do     -- types (i.e. "drums", "padding", etc)
        -- get bpm subfolders
        local bpm = love.filesystem.getDirectoryItems(path .. sub .. "/")

        if log then print(sub .. " = {") end    

        for _, b in ipairs(bpm) do      -- bpm values in type subfolder
            local keys = love.filesystem.getDirectoryItems(path .. sub .. "/" .. b .. "/")

            if log then print("_" .. b .. " = {") end

            for _, k in ipairs(keys) do      -- key values in bpm subfolder
                -- get song files
                local fullpath = path .. sub .. "/" .. b .. "/" .. k .. "/" -- path to the songs in type/bpm/key subfolders
                local songs = love.filesystem.getDirectoryItems(fullpath)

                if log then print(k .. " = {") end

                for _,song in ipairs(songs) do
                    local info = love.filesystem.getInfo(fullpath .. song)

                    if info and info.type == "file" then
                        local format = formatName(song, ext)
                        
                        local dest = (sub == "main") and "mains" or "layers"
                        table.insert(paths[dest], fullpath .. format)

                        if #format > 0 then
                            -- remove spaces and rename file
                            -- https://www.gammon.com.au/scripts/doc.php?lua=os.rename
                            os.rename(fullpath .. song, fullpath .. format)

                            local _,__,param = format:find("(.+)%" .. ext .. "$")
                            if log then print(param .. " = {},") end
                        else
                            local _,__,param = format:find("(.+)%" .. ext .. "$")
                            if log then print(param .. " = {},") end
                        end
                    end
                end

                if log then print("},") end

            end
    
            if log then print("},") end

        end

        if log then print("},") end

    end

    return paths
end

return i