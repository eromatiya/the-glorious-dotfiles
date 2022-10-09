local Path = require("module.path")
--- @type {["floppy"]: string}
local titlebar_themes = {
	["floppy"] = "spotlight",
}

local gears = require("gears")
local filesystem = require("gears.filesystem")

local config_dir = Path:new(nil, { filesystem.get_xdg_config_home(), "awesome" })
local theme_dir = Path:new(nil, { "theme", THEME })
local icons = Path:new(nil, { "icons" })
local titlebar = Path:new(nil, { "titlebar", titlebar_themes[THEME] })

-- @type {["root"]: string,["icons"]: string , ["titlebar_icons"]: string}
local directories = {
	["root"] = (config_dir + theme_dir)(),
	["icons"] = (config_dir + theme_dir + icons)(),
	["titlebar_icons"] = (config_dir + theme_dir + icons + titlebar)(),
}

return directories
