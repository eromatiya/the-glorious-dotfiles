local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local HOME = os.getenv('HOME')

local apps = require('configuration.apps')
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.material.clickable-container')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/notification-center/icons/'

-- Load panel rules, it will create panel for each screen
require('widget.notification-center.panel-rules')


local widget =
  wibox.widget {
  {
    id = 'icon',
    image = PATH_TO_ICONS .. 'notification' .. '.svg',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local widget_button = clickable_container(wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7))) -- 4 is top and bottom margin
widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        _G.screen.primary.right_panel:toggle()
      end
    )
  )
)

return widget_button
