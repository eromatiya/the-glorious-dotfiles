local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local mat_list_item = require('widget.material.list-item')
local mat_list_sep = require('widget.material.list-item-separator')


local barColor = beautiful.bg_modal
local volSlider = require('widget.volume.volume-slider')
local brightnessSlider = require('widget.brightness.brightness-slider')

local separator = wibox.widget {
  orientation = 'horizontal',
  forced_height = 1,
  span_ratio = 0.95,
  opacity = 0.70,
  color = beautiful.background.hue_800,
  widget = wibox.widget.separator
}

return wibox.widget {
  spacing = 0,
  nil,
  {
    layout = wibox.layout.fixed.vertical,
    wibox.widget{
      wibox.widget{
        volSlider,
        bg = barColor,
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
      widget = mat_list_item
    }
  },
  layout = wibox.layout.fixed.vertical,
  wibox.widget{
    wibox.widget{
      separator,
      bg = barColor,
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
    widget = mat_list_sep,
  },
  layout = wibox.layout.fixed.vertical,
  wibox.widget{
    wibox.widget{
      brightnessSlider,
      bg = barColor,
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
  }
}
