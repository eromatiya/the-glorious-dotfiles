local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local watch = require('awful.widget.watch')
local icons = require('theme.icons')

local dpi = beautiful.xresources.apply_dpi

local slider = wibox.widget {
	nil,
	{
		id 				 = 'hdd_usage',
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

watch(
	[[bash -c "df -h /home|grep '^/' | awk '{print $5}'"]],
	10,
	function(_, stdout)
		local space_consumed = stdout:match('(%d+)')
		slider.hdd_usage:set_value(tonumber(space_consumed))
		collectgarbage('collect')
	end
)


local harddrive_meter = wibox.widget {
	{
		{
			{
				image = icons.harddisk,
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

return harddrive_meter
