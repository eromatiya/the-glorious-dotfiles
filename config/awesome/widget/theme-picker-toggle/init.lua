local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. "widget/theme-picker-toggle/icons/"
local clickable_container = require("widget.clickable-container")

local return_button = function()
	local widget = wibox.widget({
		{
			id = "icon",
			image = widget_icon_dir .. "flask.svg",
			widget = wibox.widget.imagebox,
			resize = true,
		},
		layout = wibox.layout.align.horizontal,
	})

	local widget_button = wibox.widget({
		{
			widget,
			margins = dpi(7),
			widget = wibox.container.margin,
		},
		widget = clickable_container,
	})

	widget_button:buttons(gears.table.join(awful.button({}, 1, nil, function()
		local theme_picker = awful.screen.focused().theme_picker
		if theme_picker.visible then
			theme_picker.visible = false
			awesome.emit_signal("theme-picker::closed")
		else
			theme_picker.visible = true
			awesome.emit_signal("theme-picker::opened")
		end
	end)))

	return widget_button
end

return return_button
