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
				text = 'HDD',
				font = 'SFNS Pro Text Bold 10',
				align = 'center',
				valign = 'center',
				widget = wibox.widget.textbox
			},
			reflection = { vertical = true },
			widget = wibox.container.mirror
		},
		id 				 = 'hdd_usage',
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
	slider,
	reflection = { vertical = true },
	widget = wibox.container.mirror
}

return harddrive_meter
