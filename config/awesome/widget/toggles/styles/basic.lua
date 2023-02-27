local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local toggle_component = require("widget.shared.components.toggle")
local name_component = require("widget.shared.components.name")
---@param args toggle_widget_args
local create = function(args)
	local toggle_widget = toggle_component:new(args.toggle_on_callback, args.toggle_off_callback, args.watch_script)
	local name_widget = name_component:new(args.name, _, _)
	return wibox.widget({
		{
			name_widget,
			nil,
			{
				toggle_widget,
				layout = wibox.layout.fixed.horizontal,
			},
			layout = wibox.layout.align.horizontal,
		},
		left = dpi(24),
		right = dpi(24),
		forced_height = dpi(48),
		widget = wibox.container.margin,
	})
end
return create
