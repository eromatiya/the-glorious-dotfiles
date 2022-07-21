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
					require('widget.brightness-slider')[1],
					require('widget.volume-slider')[1],
					require('widget.airplane-mode')[1],
					require('widget.bluetooth-toggle')[1],
					require('widget.blue-light')[1]
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
					require('widget.blur-slider')[1],
					require('widget.blur-toggle')[1]
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
