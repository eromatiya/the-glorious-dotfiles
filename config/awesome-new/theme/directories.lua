local Path = require("module.path")
local filesystem = require("gears.filesystem")
---@return {["root"]: string,["icons"]: string , ["titlebar_icons"]: string}
--- @type {["floppy"]: string}
local titlebar_themes = {
	["floppy"] = "stoplight",
	["gnawesome"] = "stoplight",
	["linear"] = "stoplight",
	["surreal"] = "stoplight",
}

local theme_root_dir = Path:new(filesystem.get_configuration_dir():gsub("/$", ""), "theme")
local curr_theme_dir = theme_root_dir:join(THEME)
local wallpaper_dir = curr_theme_dir:join("wallpapers")
local icons = theme_root_dir:join("icons")
local icons_tag_list = icons:join("tag-list")
print("icons", icons())
local titlebar = icons:join("titlebar", titlebar_themes[THEME])

---@alias themeDirectories "root" | "icons" | "titlebar_icons" | "wallpaper_dir"
--- @type {[ "root" ]: string,["curr_theme"]: string,["icons"]: string, ["titlebar_icons"]: string, ["wallpapers"]: string, ['icons_tag_list']: string}
local directories = {
	["root"] = theme_root_dir(),
	["curr_theme"] = theme_root_dir(),
	["icons"] = icons(),
	["titlebar_icons"] = titlebar(),
	["wallpapers"] = wallpaper_dir(),
	["icons_tag_list"] = icons_tag_list(),
}

return directories
