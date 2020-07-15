local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

local progressbar = wibox.widget {
	{
		id            = 'music_bar',
		max_value     = 100,
		forced_height = dpi(3),
		forced_width  = dpi(100),
		color         = '#ffffff',
		background_color  = '#ffffff20',
		shape         = gears.shape.rounded_bar,
		widget        = wibox.widget.progressbar
	},
	layout = wibox.layout.stack
}

return progressbar
