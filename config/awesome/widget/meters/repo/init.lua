local icons = require("theme.icons")
local error_handler = require("utilities.error-handler")
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
  update_script = { "bash", "-c", [[ top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/"]] },
  update_interval = 10,
  update_callback = function(widget, stdout, err)
    error_handler(err)
    -- 🤔 this script needs to be subtracted
    local percentage_num = 100 - tonumber(assert(stdout))
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
  update_script = [[awk 'NR==1, NR==2 {if(NR==2)sum=$2/sum;else sum=$2;} END {print sum * 100}' /proc/meminfo]],
  update_interval = 10,
  update_callback = function(widget, stdout, err)
    error_handler(err)
    local value = tonumber(assert(stdout))
    widget.ram_usage:set_value(value)
  end,
}
---@type meter_args
local temperature = {

  name = "Temperature",
  icon = icons.thermometer,
  icon_margins = _,
  clickable = false,
  slider_id = "temperature_usage",
  update_script = {
    "bash",
    "-c",
    [[ sensors -j | jq '."coretemp-isa-0000"' | jq '."Package id 0"' | jq 'map(.)| .[0] / .[2] * 100' ]],
  },
  update_interval = 10,

  update_callback = function(widget, stdout, err)
    error_handler(err)
    local value = tonumber(assert(stdout))
    widget.temperature_usage:set_value(value)
  end,
}
local hard_drive = {
  name = "Hard Drive",
  icon = icons.harddisk,
  icon_margins = _,
  clickable = false,
  slider_id = "hard_drive_usage",
  update_script = [[bash -c "df -h /home|grep '^/' | awk '{print $5}'"]],
  update_interval = 10,
  update_callback = function(widget, stdout, err)
    error_handler(err)
    local space_consumed = stdout:match("(%d+)")
    local value = tonumber(assert(space_consumed))
    widget.hard_drive_usage:set_value(value)
  end,
}

---@type {cpu: meter_args, ram: meter_args, temperature: meter_args, disk: meter_args}
local meter_map = { cpu = cpu, ram = ram, temperature = temperature, disk = hard_drive }
return meter_map
