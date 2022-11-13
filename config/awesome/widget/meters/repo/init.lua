local icons = require("theme.icons")
---@class meter_args
---@field name string
---@field icon string
---@field icon_margins string | nil
---@field clickable boolean
---@field slider_id string
---@field update_script string | nil
---@field update_interval number | nil
---@field update_callback function  | nil
---@type meter_args
local cpu = {
	name = "CPU",
	icon = icons.chart,
	icon_margins = _,
	clickable = false,
	slider_id = "cpu_usage",
	update_script = [[awk '/cpu / {usage=($2+$4)*100/($2+$4+$5)} END {print usage }' /proc/stat]],
	update_interval = 10,
	update_callback = function(widget, stdout)
		local percentage_num = tonumber(stdout)
		widget.cpu_usage:set_value(percentage_num)
	end,
}
local ram_meter = {
	name = "RAM",
	icon = icons.memory,
	icon_margins = _,
	clickable = false,
	slider_id = "ram_usage",
	update_script = [[awk '/cpu / {usage=($2+$4)*100/($2+$4+$5)} END {print usage }' /proc/stat]],
	update_interval = 10,
	update_callback = function(widget, stdout)
		local percentage_num = tonumber(stdout)
		widget.cpu_usage:set_value(percentage_num)
	end,
}

---@type {cpu: meter_args, ram: meter_args, swap: meter_args, disk: meter_args, network: meter_args}
local meter_map = { cpu = cpu }
return meter_map
