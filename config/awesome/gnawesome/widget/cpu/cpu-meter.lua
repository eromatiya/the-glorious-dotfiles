local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local watch = require('awful.widget.watch')

local icons = require('theme.icons')
local dpi = beautiful.xresources.apply_dpi

local total_prev = 0
local idle_prev = 0

local bar_name = wibox.widget {
	text = 'CPU',
	font = 'SFNS Pro Text Bold 10',
	align = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local slider = wibox.widget {
	{
		id 				 = 'cpu_usage',
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
	layout = wibox.layout.fixed.vertical,
	expand = 'none',
	spacing = dpi(8),
	slider,
	nil,
	bar_name
}

return cpu_meter
