local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local watch = require('awful.widget.watch')
local icons = require('theme.icons')

local dpi = beautiful.xresources.apply_dpi

local bar_name = wibox.widget {
	text = 'Temp',
	font = 'SFNS Pro Text Bold 10',
	align = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local slider = wibox.widget {
	{
		id 				 = 'temp_status',
		max_value     	 = 100,
		value         	 = 29,
		forced_height 	 = dpi(2),
		color 			 = beautiful.fg_normal,
		background_color = beautiful.groups_bg,
		shape 			 = gears.shape.rounded_rect,
		widget        	 = wibox.widget.progressbar
	},
    forced_height = dpi(270),
    forced_width  = dpi(55),
    direction     = 'east',
    layout        = wibox.container.rotate
}

local max_temp = 80

watch(
	'bash -c "cat /sys/class/thermal/thermal_zone0/temp"',
	5,
	function(_, stdout)
		local temp = stdout:match('(%d+)')
		slider.temp_status:set_value((temp / 1000) / max_temp * 100)
		collectgarbage('collect')
	end
)


local temperature_meter = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	expand = 'none',
	spacing = dpi(8),
	slider,
	nil,
	bar_name
}


return temperature_meter
