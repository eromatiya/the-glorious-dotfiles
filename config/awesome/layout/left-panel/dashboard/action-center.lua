local wibox = require('wibox')
local gears = require('gears')
local mat_list_item = require('widget.material.list-item')
local beautiful = require('beautiful')

local actionTitle = wibox.widget {
  text = 'Action Center',
  font = 'Roboto medium 12',
  align = 'center',
  widget = wibox.widget.textbox
}

return wibox.widget {
  wibox.widget {
    wibox.widget {
      actionTitle,
      bg = '#ffffff20',
      shape = gears.shape.rounded_rect,
      widget = wibox.container.background(actionTitle)
    },
    widget = mat_list_item
  },
  require('widget.action-center'),
  layout = wibox.layout.fixed.vertical,
  spacing = 10,
}
