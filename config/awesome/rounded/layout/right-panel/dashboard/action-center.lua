local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local mat_list_item = require('widget.material.list-item')
local mat_list_sep = require('widget.material.list-item-separator')

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/bluetooth/icons/'
local checker
local mat_list_item = require('widget.material.list-item')


local separator = wibox.widget{
  orientation = 'horizontal',
  forced_height = 1,
  span_ratio = 0.95,
  opacity = 0.70,
  color = beautiful.background.hue_800,
  widget = wibox.widget.separator
}

local barColor = beautiful.bg_modal
local wifibutton = require('widget.action-center.wifi-button')
local bluebutton = require('widget.action-center.bluetooth-button')
local comptonbutton = require('widget.action-center.compositor-button')
return wibox.widget{
  spacing = 0,
  wibox.widget{
    wibox.widget{
      wifibutton,
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
    widget = mat_list_item,
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
  -- Bluetooth Connection
  layout = wibox.layout.fixed.vertical,
  wibox.widget{
    wibox.widget{
      bluebutton,
      bg = barColor,
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
  -- Compositor Toggle
  layout = wibox.layout.fixed.vertical,
  wibox.widget{
    wibox.widget{
      comptonbutton,
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
