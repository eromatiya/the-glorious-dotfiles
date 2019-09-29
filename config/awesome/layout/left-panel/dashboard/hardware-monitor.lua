local wibox = require('wibox')
local gears = require('gears')

local mat_list_item = require('widget.material.list-item')

local hardwareTitle = wibox.widget
{
  text = 'Hardware monitor',
  font = 'Iosevka Regular 10',
  align = 'left',
  widget = wibox.widget.textbox

}

local barColor = '#ffffff20'
local cpu = require('widget.cpu.cpu-meter')
local ram = require('widget.ram.ram-meter')
local temp = require('widget.temperature.temperature-meter')
local drive = require('widget.harddrive.harddrive-meter')
return wibox.widget {
  spacing = 1,
  wibox.widget {
    wibox.widget {
      hardwareTitle,
      bg = '#ffffff20',
      layout = wibox.layout.flex.vertical
    },
    widget = mat_list_item
  },
  wibox.widget{
    wibox.widget{
      cpu,
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
                  12)
              end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
  layout = wibox.layout.fixed.vertical,
  wibox.widget{
    wibox.widget{
      ram,
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
                  12)
              end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
  layout = wibox.layout.fixed.vertical,
  wibox.widget{
    wibox.widget{
      temp,
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
                  12)
              end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
  layout = wibox.layout.fixed.vertical,
  wibox.widget{
    wibox.widget{
      drive,
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
                  12)
              end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
}
