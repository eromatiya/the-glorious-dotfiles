local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local watch = awful.widget.watch
local spawn = awful.spawn
local dpi = beautiful.xresources.apply_dpi
local icons = require("theme.icons")
local slider_class = require("widget.meters.entities.slider")
local slider = slider_class:new("ram_usage")
local icon_class = require("widget.meters.entities.icon")

local meter_name = wibox.widget({
	text = "RAM",
	font = "Inter Bold 10",
	align = "left",
	widget = wibox.widget.textbox,
})
local meter_icon = icon_class:new(icons.memory, _, _)

-- awk 'NR==1, NR==2 {if(NR==2)sum=$2/sum;else sum=$2;} END {print sum}' /proc/meminfo
watch("awk 'NR==1, NR==2 {if(NR==2)sum=$2/sum;else sum=$2;} END {print sum}' /proc/meminfo", 10, function(_, stdout)
	local value = tonumber(stdout)
	slider.ram_usage:set_value(value * 100)
end)

local ram_meter = wibox.widget({
	layout = wibox.layout.fixed.vertical,
	spacing = dpi(5),
	meter_name,
	{
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
		{
			layout = wibox.layout.align.vertical,
			expand = "none",
			nil,
			{
				layout = wibox.layout.fixed.horizontal,
				forced_height = dpi(24),
				forced_width = dpi(24),
				meter_icon,
			},
			nil,
		},
		slider,
	},
})

return ram_meter
