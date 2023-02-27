local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require("widget.clickable-container")
local icons = require("theme.icons")

local path_to_file = ...
local quick_settings = require(path_to_file .. ".quick-settings")
local hardware_monitor = require(path_to_file .. ".hardware-monitor")
return function()
	return wibox.widget({
		layout = wibox.layout.flex.horizontal,
		spacing = dpi(7),
		quick_settings,
		hardware_monitor,
	})
end
