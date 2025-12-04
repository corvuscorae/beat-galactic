local H = require("utils.helpers")
local song_root = "assets/songs/"

local _tags = require("assets.songs.tagged")

local i = {}

-- formats file names to be usable keys in a lua object
local function formatName(filename, ext)
    -- replace all non-alphanumerics w/ underscores (except period to preserve file type (e.g. ".wav"))
    local _,__,noExt = filename:find("(.+)%" .. ext .. "$")
    local result = noExt:gsub("[^%w]", "_")

    result = result:gsub("looperman_l", "")
    local num_pattern = string.rep("%d", 7)
    result = result:gsub(num_pattern, "")

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

    local d = "return {\n"
    local tagged = _tags

    for _,type in ipairs(subfolders) do     -- types (i.e. "drums", "padding", etc)
        -- get bpm subfolders
        local bpms = love.filesystem.getDirectoryItems(path .. type .. "/")

        d = d .. type .. " = {\n"    
        if not tagged[type] then tagged[type] = {} end

        for _, b in ipairs(bpms) do      -- bpm values in type subfolder
            local keys = love.filesystem.getDirectoryItems(path .. type .. "/" .. b .. "/")

            H.printKeys(keys)

            d = d .. "_" .. b .. " = {\n"
            if not tagged[type]["_" .. b] then tagged[type]["_" .. b] = {} end

            for _, k in ipairs(keys) do      -- key values in bpm subfolder
                -- get song files
                local fullpath = path .. type .. "/" .. b .. "/" .. k .. "/" -- path to the songs in type/bpm/key subfolders
                local songs = love.filesystem.getDirectoryItems(fullpath)

                d = d .. k .. " = {\n" 
                if not tagged[type]["_" .. b][k] then tagged[type]["_" .. b][k] = {} end

                for _,song in ipairs(songs) do
                    local info = love.filesystem.getInfo(fullpath .. song)

                    if info and info.type == "file" then
                        local format = formatName(song, ext)
                        
                        local dest = (type == "main") and "mains" or "layers"
                        table.insert(paths[dest], fullpath .. format)

                        local _,__,param = nil, nil, nil

                        if #format > 0 then
                            -- remove spaces and rename file
                            -- https://www.gammon.com.au/scripts/doc.php?lua=os.rename
                            os.rename(fullpath .. song, fullpath .. format)

                            _,__,param = format:find("(.+)%" .. ext .. "$")

                            local info = tagged[type]["_"..b][k][param]
                            local source = {link = "", name = "", attr = ""}
                            if info and info.source then
                                source.link = info.source.link or ""
                                source.name = info.source.name or ""
                                source.attr = info.source.attr or ""
                            end 

                            d = d .. param .. " = { \nsource = {\n"
                            d = d .. "link = \"" .. source.link .. "\",\n"
                            d = d .. "name = \"" .. source.name .. "\",\n"
                            d = d .. "attr = \"" .. source.attr .. "\",\n"
                            d = d.. "},  \n}," 
                        else
                            _,__,param = format:find("(.+)%" .. ext .. "$")
                            d = d .. param .. " = {\n},"
                        end

                        if not tagged[type]["_"..b][k][param] then
                            tagged[type]["_"..b][k][param] = {
                                source = {
                                    link = "",
                                    name = "",
                                    attr = "",
                                },
                            }
                        end
                    end
                end

                d = d .."\n},"
            end
    
            d = d .. "\n},"
        end

        d = d .. "\n},"
    end

    d = d .. "\n}"
    love.filesystem.createDirectory(song_root)
    local s, m = love.filesystem.write("tagged.lua", d)
    if s then
        print("written to:", love.filesystem.getSaveDirectory():gsub("/", "\\"))
    else
        print(m)
    end

    local wPath = love.filesystem.getSource() .. "/" .. song_root
    file = io.open(wPath .. "/" .. "tagged.lua", "w")
    if file then
        file:write(d)
        file:close()
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