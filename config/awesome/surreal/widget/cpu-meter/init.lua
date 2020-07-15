local wibox = require('wibox')
local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')
local watch = awful.widget.watch
local spawn = awful.spawn
local dpi = beautiful.xresources.apply_dpi
local icons = require('theme.icons')

local meter_name = wibox.widget {
	text = 'CPU',
	font = 'Inter Bold 10',
	align = 'left',
	widget = wibox.widget.textbox
}

local icon = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		image = icons.chart,
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
		id 				 = 'cpu_usage',
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
	forced_height = dpi(24),
	layout = wibox.layout.align.vertical
}

local total_prev = 0
local idle_prev = 0

watch(
	[[bash -c "
	cat /proc/stat | grep '^cpu '
	"]],
	10,
	function(_, stdout)
		local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
			stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')

		local total = user + nice + system + idle + iowait + irq + softirq + steal

		local diff_idle = idle - idle_prev
		local diff_total = total - total_prev
		local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

		slider.cpu_usage:set_value(diff_usage)

		total_prev = total
		idle_prev = idle
		collectgarbage('collect')
	end
)

local cpu_meter = wibox.widget {
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

return cpu_meter