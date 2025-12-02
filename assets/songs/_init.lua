local H = require("utils.helpers")
local song_root = "assets/songs/"

local i = {}

-- formats file names to be usable keys in a lua object
local function formatName(filename, ext)
    -- replace all non-alphanumerics w/ underscores (except period to preserve file type (e.g. ".wav"))
    local _,__,noExt = filename:find("(.+)%" .. ext .. "$")
    local result = noExt:gsub("[^%w]", "_")

    result = result:gsub("looperman_l", "")
    -- result = result:gsub("%d", "")

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

    local d = ""

    for _,sub in ipairs(subfolders) do     -- types (i.e. "drums", "padding", etc)
        -- get bpm subfolders
        local bpm = love.filesystem.getDirectoryItems(path .. sub .. "/")

        if log then d = d .. sub .. " = {\n" end    

        for _, b in ipairs(bpm) do      -- bpm values in type subfolder
            local keys = love.filesystem.getDirectoryItems(path .. sub .. "/" .. b .. "/")

            H.printKeys(keys)

            if log then d = d .. "_" .. b .. " = {\n" end

            for _, k in ipairs(keys) do      -- key values in bpm subfolder
                -- get song files
                local fullpath = path .. sub .. "/" .. b .. "/" .. k .. "/" -- path to the songs in type/bpm/key subfolders
                local songs = love.filesystem.getDirectoryItems(fullpath)

                if log then d = d .. k .. " = {\n" end

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
                            if log then 
                                d = d .. param .. " = { \nsource = {\n"
                                d = d .. "link = \"\",\n"
                                d = d .. "name = \"\",\n"
                                d = d .. "attr = \"\",\n"
                                d = d.. "},  \n}," 
                            end
                        else
                            local _,__,param = format:find("(.+)%" .. ext .. "$")
                            if log then d = d .. param .. " = {\n}," end
                        end
                    end
                end

                if log then d = d .."\n}," end

            end
    
            if log then d = d .. "\n}," end

        end

        if log then d = d .. "\n}," end

    end

    if log then 
        love.filesystem.createDirectory(song_root)
        local s, m = love.filesystem.write("mined_tags.txt", d)
        if s then
            print("written to:", love.filesystem.getSaveDirectory():gsub("/", "\\"))
        else
            print(m)
        end
    end

    return paths
end

return i