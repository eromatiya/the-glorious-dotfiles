local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.clickable-container')
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/keyboard-layout/icons/'
local keyboard_tbl = {}
keyboard_tbl.default_button = wibox.widget {
	image = widget_icon_dir .. 'def' .. '.svg',
	resize = true,
	widget = wibox.widget.imagebox
}

return keyboard_tbl
