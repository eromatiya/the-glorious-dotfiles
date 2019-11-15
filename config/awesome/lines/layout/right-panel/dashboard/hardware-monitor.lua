local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local mat_list_item = require('widget.material.list-item')
local mat_list_sep = require('widget.material.list-item-separator')

local dpi = require('beautiful').xresources.apply_dpi

local separator = wibox.widget {
        orientation = 'horizontal',
        forced_height = 1,
        span_ratio = 0.95,
        opacity = 0.70,
        color = beautiful.background.hue_800,
        widget = wibox.widget.separator
}

local barColor = '#00000000'
local cpu = require('widget.cpu.cpu-meter')
local ram = require('widget.ram.ram-meter')
local temp = require('widget.temperature.temperature-meter')
local drive = require('widget.harddrive.harddrive-meter')
return wibox.widget {
  spacing = 0,
  layout = wibox.layout.fixed.vertical,
  wibox.widget{
    wibox.widget{
      cpu,
      bg = barColor,
      border_width = dpi(1),
      border_color = beautiful.bg_modal,
      shape = function(cr, width, height)
                gears.shape.partially_rounded_rect(
                  cr,
                  width,
                  height,
                  true,
                  true,
                  false,
                  false,
                  6)
              end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
  wibox.widget{
    wibox.widget{
      ram,
      bg = barColor,
      border_width = dpi(1),
      border_color = beautiful.bg_modal,
      shape = function(cr, width, height)
                gears.shape.partially_rounded_rect(
                  cr,
                  width,
                  height,
                  false,
                  false,
                  false,
                  false,
                  6)
              end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
  wibox.widget{
    wibox.widget{
      temp,
      bg = barColor,
      border_width = dpi(1),
      border_color = beautiful.bg_modal,
      shape = function(cr, width, height)
                gears.shape.partially_rounded_rect(
                  cr,
                  width,
                  height,
                  false,
                  false,
                  false,
                  false,
                  6)
              end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
  wibox.widget{
    wibox.widget{
      drive,
      bg = barColor,
      border_width = dpi(1),
      border_color = beautiful.bg_modal,
      shape = function(cr, width, height)
                gears.shape.partially_rounded_rect(
                  cr,
                  width,
                  height,
                  false,
                  false,
                  true,
                  true,
                  6)
              end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
}
