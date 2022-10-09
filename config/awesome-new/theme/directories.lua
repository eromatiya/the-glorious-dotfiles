local Path = require("module.path")
local config_dir = require("module.get-workspace-dir")
print("cc" .. config_dir())
--- @type {["floppy"]: string}
local titlebar_themes = {
	["floppy"] = "spotlight",
}

local theme_dir = config_dir + Path:new(nil, { "theme", THEME })
local icons = theme_dir + Path:new(nil, { "icons" })
local titlebar = icons + Path:new(nil, { "titlebar", titlebar_themes[THEME] })

-- @type {["root"]: string,["icons"]: string , ["titlebar_icons"]: string}
local directories = {
	["root"] = theme_dir(),
	["icons"] = icons(),
	["titlebar_icons"] = titlebar(),
}
print(directories.titlebar_icons)

return directories
