local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local dpi = require('beautiful').xresources.apply_dpi

local hardware_header = wibox.widget
{

	text = 'Hardware Monitor',
	font = 'SF Pro Text Regular 12',
	align = 'left',
	valign = 'center',
	widget = wibox.widget.textbox

}

return wibox.widget {
	layout = wibox.layout.fixed.vertical,
	{
		{
			hardware_header,
			left = dpi(24),
			right = dpi(24),
			widget = wibox.container.margin
		},
		bg = beautiful.groups_title_bg,
		shape = function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, beautiful.groups_radius) 
		end,
		forced_height = dpi(35),
		widget = wibox.container.background
		
	},
	{
		require('widget.cpu.cpu-meter'),
		bg = beautiful.groups_bg,
		shape = function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, false, false, false, false, beautiful.groups_radius) 
		end,
		forced_height = dpi(48),
		widget = wibox.container.background
	},
	{
		require('widget.ram.ram-meter'),
		bg = beautiful.groups_bg,
		shape = function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, false, false, false, false, beautiful.groups_radius) 
		end,
		forced_height = dpi(48),
		widget = wibox.container.background
	},
	{
		require('widget.temperature.temperature-meter'),
		bg = beautiful.groups_bg,
		shape = function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, false, false, false, false, beautiful.groups_radius) 
		end,
		forced_height = dpi(48),
		widget = wibox.container.background

	},
	{
		require('widget.harddrive.harddrive-meter'),
		bg = beautiful.groups_bg,
		shape = function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, beautiful.groups_radius) 
		end,
		forced_height = dpi(48),
		widget = wibox.container.background
	},
}
