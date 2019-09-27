local wibox = require('wibox')
local mat_list_item = require('widget.material.list-item')

return wibox.widget {
  wibox.widget {
    wibox.widget {
      text = 'Hardware monitor',
      font = 'Roboto medium 12',
      widget = wibox.widget.textbox
    },
    widget = mat_list_item
  },
  require('widget.cpu.cpu-meter'),
  require('widget.ram.ram-meter'),
  require('widget.temperature.temperature-meter'),
  require('widget.harddrive.harddrive-meter'),
  layout = wibox.layout.fixed.vertical
}
