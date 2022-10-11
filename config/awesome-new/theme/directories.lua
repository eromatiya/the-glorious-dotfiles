local Path = require("module.path")
local filesystem = require("gears.filesystem")
---@return {["root"]: string,["icons"]: string , ["titlebar_icons"]: string}
local getDirectories = function()
	--- @type {["floppy"]: string}
	local titlebar_themes = {
		["floppy"] = "spotlight",
	}

	local config_dir = Path:new(nil, { filesystem.get_configuration_dir() })
	local theme_dir = config_dir + Path:new(nil, { "theme", THEME })
	local icons = theme_dir + Path:new(nil, { "icons" })
	local titlebar = icons + Path:new(nil, { "titlebar", titlebar_themes[THEME] })

	-- @type {["root"]: string,["icons"]: string , ["titlebar_icons"]: string}
	local directories = {
		["root"] = theme_dir(),
		["icons"] = icons(),
		["titlebar_icons"] = titlebar(),
	}
	return directories
end

return getDirectories
