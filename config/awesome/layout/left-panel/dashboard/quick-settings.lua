local wibox = require('wibox')
local gears = require('gears')
local mat_list_item = require('widget.material.list-item')

local quickTile = wibox.widget {
  text = 'Quick settings',
  font = 'Roboto medium 12',
  align = 'center',
  widget = wibox.widget.textbox
}

return wibox.widget {
  wibox.widget {
    wibox.widget {
      quickTile,
      bg = '#ffffff20',
      shape = gears.shape.rounded_rect,
      widget = wibox.container.background(quickTile)
    },
    widget = mat_list_item
  },
  require('widget.volume.volume-slider'),
  require('widget.brightness.brightness-slider'),
  layout = wibox.layout.fixed.vertical
}
