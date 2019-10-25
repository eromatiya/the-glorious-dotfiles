local wibox = require('wibox')
local mat_list_item = require('widget.material.list-item')
local mat_slider = require('widget.material.slider')
local mat_icon = require('widget.material.icon')
local icons = require('theme.icons')
local watch = require('awful.widget.watch')
local dpi = require('beautiful').xresources.apply_dpi

local slider =
  wibox.widget {
  read_only = true,
  widget = mat_slider
}

local max_temp = 80
watch(
  'bash -c "cat /sys/class/thermal/thermal_zone0/temp"',
  1,
  function(_, stdout)
    local temp = stdout:match('(%d+)')
    slider:set_value((temp / 1000) / max_temp * 100)
    collectgarbage('collect')
  end
)

local temperature_meter =
  wibox.widget {
  wibox.widget {
    icon = icons.thermometer,
    size = dpi(24),
    widget = mat_icon
  },
  slider,
  widget = mat_list_item
}

return temperature_meter
