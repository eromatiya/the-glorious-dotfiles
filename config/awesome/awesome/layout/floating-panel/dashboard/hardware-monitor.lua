local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local dpi = require('beautiful').xresources.apply_dpi

return wibox.widget {
	layout = wibox.layout.fixed.vertical,
	{
		{
			{
				nil,
				{
					layout = wibox.layout.fixed.horizontal,
					spacing = dpi(16),
					require('widget.cpu.cpu-meter'),
					require('widget.ram.ram-meter'),
					require('widget.temperature.temperature-meter'),
					require('widget.harddrive.harddrive-meter')
				},
				nil,
				expand = 'none',
				layout = wibox.layout.align.horizontal	
			},
			left = dpi(24),
			right = dpi(24),
			widget = wibox.container.margin
		},
		bg = beautiful.groups_bg,
		shape = function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, beautiful.groups_radius) 
		end,
		forced_height = dpi(92),
		widget = wibox.container.background
	},

}
