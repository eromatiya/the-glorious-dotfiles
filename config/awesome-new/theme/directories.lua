--- @type {["floppy"]: string}
local titlebar_themes = {
	["floppy"] = "spotlight",
}
local gears = require("gears")
local filesystem = require("gears.filesystem")
local config_dir = { filesystem.get_xdg_config_home():sub(1, -2), "awesome" }
local theme_dir = { table.unpack(config_dir), "theme", THEME }
local icons = { table.unpack(theme_dir), "icons" }
local titlebar = { table.unpack(icons), "titlebar", titlebar_themes[THEME] }
print(theme_dir[2])

--- @type {["icons"]: string, ["root"]: string, ["titlebar_icons"]: string}
local directories = {
	["root"] = table.concat(theme_dir, "/"),
	["icons"] = table.concat(icons, "/"),
	["titlebar_icons"] = table.concat(titlebar, "/"),
}

return directories
