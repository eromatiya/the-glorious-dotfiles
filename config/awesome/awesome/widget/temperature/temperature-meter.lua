local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local watch = require('awful.widget.watch')
local icons = require('theme.icons')

local dpi = beautiful.xresources.apply_dpi

local slider = wibox.widget {
	nil,
	{
		{
			{
				text = 'Temp',
				font = 'SFNS Pro Text Bold 10',
				align = 'center',
				valign = 'center',
				widget = wibox.widget.textbox
			},
			reflection = { vertical = true },
			widget = wibox.container.mirror
		},
		id 				 = 'temp_status',
		value         	 = 50,
		min_value 		 = 0,
		max_value     	 = 100,
		forced_height 	 = dpi(56),
		forced_width 	 = dpi(56),
		border_width	 = dpi(7),
		color 			 = beautiful.fg_normal,
		border_color 	 = beautiful.groups_bg,
		widget        	 = wibox.container.radialprogressbar
	},
	nil,
	expand = 'none',
	layout = wibox.layout.align.vertical
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
	slider,
	reflection = { vertical = true },
	widget = wibox.container.mirror
}


return temperature_meter
