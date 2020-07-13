local wibox = require('wibox')
local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')
local watch = awful.widget.watch
local spawn = awful.spawn
local dpi = beautiful.xresources.apply_dpi
local icons = require('theme.icons')

local meter_name = wibox.widget {
	text = 'Hard Drive',
	font = 'SF Pro Text Bold 10',
	align = 'left',
	widget = wibox.widget.textbox
}

local icon = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		image = icons.harddisk,
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
		id 				 = 'hdd_usage',
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

watch(
	[[bash -c "df -h /home|grep '^/' | awk '{print $5}'"]],
	10,
	function(_, stdout)
		local space_consumed = stdout:match('(%d+)')
		slider.hdd_usage:set_value(tonumber(space_consumed))
		collectgarbage('collect')
	end
)

local brightness_setting = wibox.widget {
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

return brightness_setting
