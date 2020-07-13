local wibox = require('wibox')
local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')
local watch = awful.widget.watch
local spawn = awful.spawn
local dpi = beautiful.xresources.apply_dpi
local icons = require('theme.icons')

local meter_name = wibox.widget {
	text = 'Temperature',
	font = 'SF Pro Text Bold 10',
	align = 'left',
	widget = wibox.widget.textbox
}

local icon = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		image = icons.thermometer,
		resize = true,
		widget = wibox.widget.imagebox
	},
	nil
}

local meter_icon = wibox.widget {
	{
		icon,
		margins = dpi(5),
		widget = wibox.container.margin
	},
	bg = beautiful.groups_bg,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
	end,
	widget = wibox.container.background
}

local slider = wibox.widget {
	nil,
	{
		id 				 = 'temp_status',
		max_value     	 = 100,
		value         	 = 29,
		forced_height 	 = dpi(24),
		color 			 = '#f2f2f2EE',
		background_color = '#ffffff20',
		shape 			 = gears.shape.rounded_rect,
		widget        	 = wibox.widget.progressbar
	},
	nil,
	expand = 'none',
	forced_height = dpi(36),
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

local temp_meter = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	spacing = dpi(5),
	meter_name,
	{
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
		{
			layout = wibox.layout.align.vertical,
			expand = 'none',
			nil,
			{
				layout = wibox.layout.fixed.horizontal,
				forced_height = dpi(24),
				forced_width = dpi(24),
				meter_icon
			},
			nil
		},
		slider
	}
}

return temp_meter
