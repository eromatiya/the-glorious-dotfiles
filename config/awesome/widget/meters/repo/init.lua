local icons = require("theme.icons")
---@class meter_args
---@field name string
---@field icon string
---@field icon_margins string | nil
---@field clickable boolean
---@field slider_id string
---@field update_script string |table | nil
---@field update_interval number | nil
---@field update_callback function  | nil
--  [[awk '/cpu / {usage=($2+$4)*100/($2+$4+$5)} END {print usage }' /proc/stat]]
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
		print(percentage_num)
		widget.cpu_usage:set_value(percentage_num)
	end,
}

---@type meter_args
local ram = {
	name = "RAM",
	icon = icons.memory,
	icon_margins = _,
	clickable = false,
	slider_id = "ram_usage",
	--script gets first 2 lines of file (MemTotal and MemFree) and calculates their ratio
	-- 🔧 TODO: add "Mem" regex on awk
	update_script = [[awk 'NR==1, NR==2 {if(NR==2)sum=$2/sum;else sum=$2;} END {print sum}' /proc/meminfo]],
	update_interval = 10,
	update_callback = function(widget, stdout)
		local value = tonumber(stdout)
		widget.ram_usage:set_value(value * 100)
	end,
}
-- update_script = {
-- 		"bash",
-- 		"-c",
-- 		[[ sensors -j | jq '."coretemp-isa-0000"' | jq '."Package id 0"' | jq 'map(.)| .[0] / .[2] * 100' ]],
-- 	},

---@type {cpu: meter_args, ram: meter_args, swap: meter_args, disk: meter_args, network: meter_args}
local meter_map = { cpu = cpu, ram = ram }
return meter_map
