local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local dpi = require('beautiful').xresources.apply_dpi

local bar_color = beautiful.groups_bg


return wibox.widget {
	layout = wibox.layout.fixed.vertical,
	spacing = dpi(7),
	{
		layout = wibox.layout.fixed.vertical,
		{
			require('widget.brightness.brightness-slider'),
			bg = bar_color,
			shape = function(cr, width, height)
				gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, beautiful.groups_radius) end,
			forced_height = dpi(48),
			widget = wibox.container.background

		},
		{
			require('widget.volume.volume-slider'),
			bg = bar_color,
			shape = function(cr, width, height)
				gears.shape.partially_rounded_rect(cr, width, height, false, false, false, false, beautiful.groups_radius) end,
			forced_height = dpi(48),
			widget = wibox.container.background

		},

		{
			require('widget.network.network-toggle'),
			bg = bar_color,
			shape = function(cr, width, height)
				gears.shape.partially_rounded_rect(cr, width, height, false, false, false, false, beautiful.groups_radius) end,
			forced_height = dpi(48),
			widget = wibox.container.background
		},

		{
			require('widget.bluetooth.bluetooth-toggle'),
			bg = bar_color,
			shape = function(cr, width, height)
				 gears.shape.partially_rounded_rect(cr, width, height, false, false, false, false, beautiful.groups_radius) end,
			forced_height = dpi(48),
			widget = wibox.container.background
		},
		{
			require('widget.blue-light'),
			bg = bar_color,
			shape = function(cr, width, height)
				 gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, beautiful.groups_radius) end,
			forced_height = dpi(48),
			widget = wibox.container.background
		}
	},
	{
		layout = wibox.layout.fixed.vertical,
		{
			require('widget.window-effects.blur-toggle'),
			bg = bar_color,
			shape = function(cr, width, height)
				 gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, beautiful.groups_radius) end,
			forced_height = dpi(48),
			widget = wibox.container.background
		},
		{
			require('widget.window-effects.blur-strength-slider'),
			bg = bar_color,
			shape = function(cr, width, height)
				gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, beautiful.groups_radius) end,
			forced_height = dpi(48),
			widget = wibox.container.background
		}
	}
}
