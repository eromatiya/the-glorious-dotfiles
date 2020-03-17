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
				text = 'RAM',
				font = 'SFNS Pro Text Bold 10',
				align = 'center',
				valign = 'center',
				widget = wibox.widget.textbox
			},
			reflection = { vertical = true },
			widget = wibox.container.mirror
		},
		id 				 = 'ram_usage',
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
	'bash -c "free | grep -z Mem.*Swap.*"',
	5,
	function(_, stdout)
		local total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap =
			stdout:match('(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)')
		slider.ram_usage:set_value(used / total * 100)
		collectgarbage('collect')
	end
)

local ram_meter = wibox.widget {
	slider,
	reflection = { vertical = true },
	widget = wibox.container.mirror
}

return ram_meter
