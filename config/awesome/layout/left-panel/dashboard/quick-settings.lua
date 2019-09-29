local wibox = require('wibox')
local gears = require('gears')
local mat_list_item = require('widget.material.list-item')

local quickTitle = wibox.widget {
  text = 'Quick settings',
  font = 'Iosevka Regular 10',
  align = 'left',
  widget = wibox.widget.textbox
}

local barColor = '#ffffff20'
local volSlider = require('widget.volume.volume-slider')
local brightnessSlider = require('widget.brightness.brightness-slider')
return wibox.widget {
  spacing = 1,
  wibox.widget {
    wibox.widget {
      quickTitle,
      bg = '#ffffff20',
      layout = wibox.layout.flex.vertical
    },
    widget = mat_list_item
  },
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
                    12)
                end,
        widget = wibox.container.background
      },
      widget = mat_list_item
    }
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
                  12)
              end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  }


  -- require('widget.volume.volume-slider'),
  -- require('widget.brightness.brightness-slider'),
}
