local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local watch = awful.widget.watch
local spawn = awful.spawn
local dpi = beautiful.xresources.apply_dpi
local create_meter = require("widget.meters")
local icons = require("theme.icons")
local slider_class = require("widget.meters.entities.slider")
local icon_class = require("widget.meters.entities.icon")
local name_class = require("widget.meters.entities.name")
local meter_factory = require("widget.meters.entities.meter")

local slider = slider_class:new("cpu_usage")

local meter_name = name_class:new("CPU", _, _)
--- 🔧 change to more miningful icon
local meter_icon = icon_class:new(icons.chart, _, _)

local total_prev = 0
local idle_prev = 0

watch(
	[[bash -c "
	cat /proc/stat | grep '^cpu '
	"]],
	10,
	function(_, stdout)
		local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
			stdout:match("(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s")

		local total = user + nice + system + idle + iowait + irq + softirq + steal

		local diff_idle = idle - idle_prev
		local diff_total = total - total_prev
		local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

		slider.cpu_usage:set_value(diff_usage)

		total_prev = total
		idle_prev = idle
		collectgarbage("collect")
	end
)

local cpu_meter = meter_factory(meter_name, meter_icon, slider)
return cpu_meter
