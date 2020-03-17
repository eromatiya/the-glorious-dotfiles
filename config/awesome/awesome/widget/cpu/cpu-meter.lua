local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local watch = require('awful.widget.watch')

local icons = require('theme.icons')
local dpi = beautiful.xresources.apply_dpi

local total_prev = 0
local idle_prev = 0

local slider = wibox.widget {
	nil,
	{
		{
			{
				text = 'CPU',
				font = 'SFNS Pro Text Bold 10',
				align = 'center',
				valign = 'center',
				widget = wibox.widget.textbox
			},
			reflection = { vertical = true },
			widget = wibox.container.mirror
		},
		id 				 = 'cpu_usage',
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
	[[bash -c "cat /proc/stat | grep '^cpu '"]],
	5,
	function(_, stdout)
		local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
			stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')

		local total = user + nice + system + idle + iowait + irq + softirq + steal

		local diff_idle = idle - idle_prev
		local diff_total = total - total_prev
		local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

		slider.cpu_usage:set_value(tonumber(diff_usage))

		total_prev = total
		idle_prev = idle
		collectgarbage('collect')
	end
)

local cpu_meter = wibox.widget {
	slider,
	reflection = { vertical = true },
	widget = wibox.container.mirror
}

return cpu_meter
