local init = require("assets.songs._init")

local ext = ".mp3"
local applepath = "assets/songs/"
local subfolders = { "drums", "main", "padding", "texture" }
local log_names = false

local paths = init.initFiles(applepath, subfolders, ext, log_names)

local tags = require("assets.songs.tagged")

return {
    tags = tags,
    paths = paths,
    ext = ext,
    applepath = applepath
}
