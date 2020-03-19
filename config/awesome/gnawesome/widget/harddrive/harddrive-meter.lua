local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local watch = require('awful.widget.watch')
local icons = require('theme.icons')

local dpi = beautiful.xresources.apply_dpi

local bar_name = wibox.widget {
	text = 'HDD',
	font = 'SFNS Pro Text Bold 10',
	align = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local slider = wibox.widget {
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
    forced_height = dpi(270),
    forced_width  = dpi(55),
    direction     = 'east',
    layout        = wibox.container.rotate
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
	layout = wibox.layout.fixed.vertical,
	expand = 'none',
	spacing = dpi(8),
	slider,
	nil,
	bar_name
}

return harddrive_meter
