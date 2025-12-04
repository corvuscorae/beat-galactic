local tags = require("assets.songs._tags").tags
local ShuffleBag = require("src.classes.shufflebag")
local H = require("src.utils.helpers")

local function getParams(category)
    local params = {}

    for _,song in pairs(tags) do
        for i,cat in pairs(song) do
            if i == category then
                for _,val in ipairs(cat) do
                    -- add unique values to params table
                    if not H.tableHas(params, val) then table.insert(params, val) end 
                end
            end
        end
    end

    return params
end

local fill = {
    TIME = ShuffleBag.new({"60s", "70s", "80s", "90s", "00s", "10s", "contemporary"}),
    --GENREMOD = ShuffleBag.new({}),
    GENRE = ShuffleBag.new(getParams("GENRE")),
    --LOCALE = ShuffleBag.new(getParams("LOCALE")),
    SPECIAL = ShuffleBag.new(getParams("SPECIAL")),
    VIBES = ShuffleBag.new(getParams("VIBES")),
}

return fill