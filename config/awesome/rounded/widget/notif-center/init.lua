local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local HOME = os.getenv('HOME')

local dpi = require('beautiful').xresources.apply_dpi
local mat_list_item = require('widget.material.list-item')

return wibox.widget {
  expand = 'none',
  layout = wibox.layout.fixed.vertical,
  spacing = dpi(5),
  {
    expand = 'none',
    layout = wibox.layout.align.horizontal,
    nil,
    nil,
    {
      layout = wibox.layout.fixed.horizontal,
      spacing = dpi(5),
      require('widget.notif-center.dont-disturb'),
      require('widget.notif-center.clear-all')
    },
  },
  require('widget.notif-center.generate-notifbox')
}