local gears = require("gears")
local theme_icons = require("theme.icons")
local config_dir = gears.filesystem.get_configuration_dir()
local widget_dir = config_dir .. "widget/"
local toggle_icon_dir = widget_dir .. "toggles/icons/"

---@alias toggle_widet_icons {on : string, off : string}
---@type table<toggle_widgets, any>
local icons = {
	airplane_mode = {
		on = toggle_icon_dir .. "airplane-mode.svg",
		off = toggle_icon_dir .. "airplane-mode-off.svg",
	},

	bluetooth = {
		on = toggle_icon_dir .. "bluetooth.svg",
		off = toggle_icon_dir .. "bluetooth-off.svg",
	},
	blue_light = {
		on = toggle_icon_dir .. "blue-light.svg",
		off = toggle_icon_dir .. "blue-light-off.svg",
	},
	blur_effects = {
		on = theme_icons.effects,
		off = toggle_icon_dir .. "effects-off.svg",
	},
}
return icons
