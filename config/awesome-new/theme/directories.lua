local Path = require("module.path")
local filesystem = require("gears.filesystem")
---@return {["root"]: string,["icons"]: string , ["titlebar_icons"]: string}
--- @type {["floppy"]: string}
local titlebar_themes = {
	["floppy"] = "spotlight",
	["gnawesome"] = "spotlight",
	["linear"] = "spotlight",
	["surreal"] = "spotlight",
}

local theme_root_dir = Path:new(filesystem.get_configuration_dir():gsub("/$", ""), "theme")
local curr_theme_dir = theme_root_dir:join(THEME)
local wallpaper_dir = curr_theme_dir:join("wallpapers")
local icons = theme_root_dir:join("icons")
local titlebar = icons + Path:new("titlebar", titlebar_themes[THEME])

--- @type {"root": string,["curr_theme"]: string,["icons"]: string, ["titlebar_icons"]: string, ["wallpapers"]: string}
local directories = {
	["root"] = theme_root_dir(),
	["curr_theme"] = theme_root_dir(),
	["icons"] = icons(),
	["titlebar_icons"] = titlebar(),
	["wallpaper"] = wallpaper_dir(),
}
return directories
