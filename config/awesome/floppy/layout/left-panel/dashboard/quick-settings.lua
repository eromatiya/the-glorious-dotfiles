local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local bar_color = beautiful.groups_bg
local dpi = beautiful.xresources.apply_dpi

local quick_header = wibox.widget {
	text = 'Quick Settings',
	font = 'Inter Regular 12',
	align = 'left',
	valign = 'center',
	widget = wibox.widget.textbox

}

return wibox.widget {
	layout = wibox.layout.fixed.vertical,
	spacing = dpi(7),
	{
		layout = wibox.layout.fixed.vertical,
		{
			{
				quick_header,
				left = dpi(24),
				right = dpi(24),
				widget = wibox.container.margin
			},
			forced_height = dpi(35),
			bg = beautiful.groups_title_bg,
			shape = function(cr, width, height)
				gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, beautiful.groups_radius) 
			end,
			widget = wibox.container.background
		},
		{
			layout = wibox.layout.fixed.vertical,
			spacing = dpi(7),
			{
				{
					layout = wibox.layout.fixed.vertical,
					require('widget.brightness-slider'),
					require('widget.volume-slider'),
					require('widget.airplane-mode'),
					require('widget.bluetooth-toggle'),
					require('widget.blue-light')
				},
				bg = beautiful.groups_bg,
				shape = function(cr, width, height)
					gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, beautiful.groups_radius) 
				end,
				widget = wibox.container.background
			},
			{
				{
					layout = wibox.layout.fixed.vertical,
					require('widget.blur-slider'),
					require('widget.blur-toggle')
				},
				bg = beautiful.groups_bg,
				shape = function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius) 
				end,
				widget = wibox.container.background
			}
		}
	}
}
