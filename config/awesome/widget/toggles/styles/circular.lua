local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local toggle_component = require("widget.shared.components.circular_toggle")
local name_component = require("widget.shared.components.name")
---@param args toggle_widget_args
local create = function(args)
	local toggle_widget_components = toggle_component:new(
		args.toggle_on_icon,
		args.toggle_off_icon,
		args.toggle_on_callback,
		args.toggle_off_callback,
		args.watch_script
	)
	---@diagnostic disable-next-line: deprecated
	local toggle_widget, status_widget = table.unpack(toggle_widget_components)
	local name_widget = name_component:new(args.name, _, _)
	local name_and_status_widget = wibox.widget({
		layout = wibox.layout.fixed.vertical,
		spacing = dpi(5),
		name_widget,
		status_widget,
	})
	return wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(10),
		toggle_widget,
		{
			layout = wibox.layout.align.vertical,
			expand = "none",
			nil,
			name_and_status_widget,
			nil,
		},
	})
end
return create
