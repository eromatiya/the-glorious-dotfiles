local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local HOME = os.getenv('HOME')

local apps = require('configuration.apps')
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.material.clickable-container')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/notification-center/icons/'


local notif_header = wibox.widget {
  text = 'Notifications',
  align = 'left',
  valign = 'center',
  font = 'SFNS Display Bold 14',
  widget = wibox.widget.textbox
}

return wibox.widget {
  {
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(10),
    {
      layout = wibox.layout.align.horizontal,
      {
        notif_header,
        layout = wibox.layout.fixed.horizontal
      },
      nil,
      {
        require('widget.notification-center.subwidgets.clear-all'),
        layout = wibox.layout.fixed.horizontal
      },
    },
    {
      spacing = dpi(4),
      layout = wibox.layout.fixed.vertical,
      require('widget.notification-center.subwidgets.notif-generate'),
    },
  },
  forced_width = dpi(365),
  margins = dpi(5),
  widget = wibox.container.margin
}
