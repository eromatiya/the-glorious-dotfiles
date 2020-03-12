local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local watch = require('awful.widget.watch')
local icons = require('theme.icons')

local dpi = beautiful.xresources.apply_dpi

local slider = wibox.widget {
	nil,
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
	{
		{
			{
				image = icons.thermometer,
				resize = true,
				widget = wibox.widget.imagebox
			},
			top = dpi(12),
			bottom = dpi(12),
			widget = wibox.container.margin
		},
		slider,
		spacing = dpi(24),
		layout = wibox.layout.fixed.horizontal

	},
	left = dpi(24),
	right = dpi(24),
	forced_height = dpi(48),
	widget = wibox.container.margin
}

return temperature_meter
