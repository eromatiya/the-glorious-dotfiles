local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

---@param meter_name unknown
---@param meter_icon unknown
---@param meter_slider unknown
local return_button = function(meter_name, meter_icon, meter_slider)
  return wibox.widget({
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
      meter_slider,
    },
  })
end
return return_button
