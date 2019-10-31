-------------------------------------------------
-- Toggle System tray
-------------------------------------------------

local awful = require('awful')
local naughty = require('naughty')
local watch = require('awful.widget.watch')
local wibox = require('wibox')
local clickable_container = require('widget.material.clickable-container')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local apps = require('configuration.apps')

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/dashboard/icons/'

local widget =
  wibox.widget {
  {
    id = 'icon',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local widget_button = clickable_container(wibox.container.margin(widget, dpi(8), dpi(8), dpi(8), dpi(8))) -- default top bottom margin is 7
widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        _G.screen.primary.right_panel:toggle(false)
      end
    )
  )
)

widget.icon:set_image(PATH_TO_ICONS .. 'dash' .. '.svg')


return widget_button
