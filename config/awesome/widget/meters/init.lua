local icons = require("theme.icons")
local slider_class = require("widget.meters.entities.slider")
local icon_class = require("widget.meters.entities.icon")
local name_class = require("widget.meters.entities.name")
local meter = require("widget.meters.entities.meter")

-- 🔧 TODO: complete meter classes for refactoring
---@class meter_args
---@field name string
---@field icon string
---@field icon_margins string | nil
---@field clickable boolean
---@field slider_id string
---@field update_script string
---@field update_interval number
---@field update_callback function
---@type meter_args
local cpu = {
	name = "CPU",
	icon = icons.chart,
	icon_margins = _,
	clickable = false,
	slider_id = "cpu_usage",
	update_script = [[sh -c "grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}'"]],
	update_interval = 10,
	update_callback = function(widget, stdout)
		local percentage_num = tonumber(stdout)
		print(stdout)
		widget.cpu_usage:set_value(percentage_num)

		-- local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
		-- 	stdout:match("(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s")

		-- local total = user + nice + system + idle + iowait + irq + softirq + steal

		-- local diff_idle = idle - idle_prev
		-- local diff_total = total - total_prev
		-- local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

		-- ---@diagnostic disable-next-line: undefined-global
		-- self.cpu_usage:set_value(diff_usage)

		-- total_prev = total
		-- idle_prev = idle
		-- collectgarbage("collect")
	end,
}
local meter_map = { cpu = cpu }
---@see creting a meter widget utilizing domains
---@param args meter_args
local meter_factory = function(args)
	local meter_name = name_class:new(args.name, _, _)
	local slider = slider_class:new(args.slider_id, args.update_script, args.update_interval, args.update_callback)
	--- 🔧 change to more miningful icon
	local meter_icon = icon_class:new(args.icon, args.icon_margins, args.clickable)
	return meter(meter_name, meter_icon, slider)
end
---@param name "cpu" | "ram" | "swap" | "disk" | "network"
local create_widget = function(name)
	local meter_args = meter_map[name]
	return meter_factory(meter_args)
end
return create_widget
