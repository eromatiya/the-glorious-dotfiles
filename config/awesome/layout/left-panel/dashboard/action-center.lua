local wibox = require('wibox')
local gears = require('gears')
local mat_list_item = require('widget.material.list-item')
local beautiful = require('beautiful')

local actionTitle = wibox.widget {
  text = 'Action Center',
  font = 'Iosevka Regular 10',
  align = 'left',
  widget = wibox.widget.textbox
}

local actionWidget = require('widget.action-center')
return wibox.widget{
  spacing = 1,
  wibox.widget {
    wibox.widget {
      actionTitle,
      bg = '#ffffff20',
      layout = wibox.layout.flex.vertical
    },
    widget = mat_list_item,
  },
  layout = wibox.layout.fixed.vertical,
  {
    actionWidget,
    layout = wibox.layout.align.vertical
   }
}
