local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi


local slider= wibox.widget {
	bar_shape           = gears.shape.rounded_rect,
	bar_height          = dpi(8),
	bar_color           = '#ffffff66',
	handle_color        = '#ffffff',
	handle_shape        = gears.shape.circle,
	handle_border_color = '#00000012',
	handle_border_width = dpi(1),
	value               = 25,
	maximum				= 100,
	widget              = wibox.widget.slider,
}

return slider