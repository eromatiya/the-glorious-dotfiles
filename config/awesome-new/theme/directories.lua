local Path = require("module.path")
local filesystem = require("gears.filesystem")
---@return {["root"]: string,["icons"]: string , ["titlebar_icons"]: string}
--- @type {["floppy"]: string}
local titlebar_themes = {
	["floppy"] = "spotlight",
	["gnawesome"] = "spotlight",
}

local config_dir = Path:new(nil, { filesystem.get_configuration_dir() })
local theme_root_dir = config_dir + Path:new(nil, { "theme" })
local curr_theme_dir = theme_root_dir + Path:new(nil, { THEME })
local wallpaper_dir = curr_theme_dir + Path:new(nil, { "wallpapers" })
local icons = theme_root_dir + Path:new(nil, { "icons" })
local titlebar = icons + Path:new(nil, { "titlebar", titlebar_themes[THEME] })

--- @type {["root"]: string,["curr_theme"]: string,["icons"]: string, ["titlebar_icons"]: string, ["wallpapers"]: string}
local directories = {
	["root"] = theme_root_dir(),
	["curr_theme"] = theme_root_dir(),
	["icons"] = icons(),
	["titlebar_icons"] = titlebar(),
	["wallpaper"] = wallpaper_dir(),
}
return directories
