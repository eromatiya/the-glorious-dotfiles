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
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/systemtray/icons/'

local widget =
  wibox.widget {
  {
    id = 'icon',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local widget_button = clickable_container(wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7)))
widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awesome.emit_signal("toggle_tray")
      end
    )
  )
)

-- Execute if button is next/play/prev button is pressed
awesome.connect_signal("toggle_tray", function()
  if awful.screen.focused().systray.visible ~= true then
    awful.screen.focused().systray.visible = true
    widget.icon:set_image(gears.surface.load_uncached(PATH_TO_ICONS .. 'left-arrow' .. '.svg'))
  else
    awful.screen.focused().systray.visible = false
    widget.icon:set_image(gears.surface.load_uncached(PATH_TO_ICONS .. 'right-arrow' .. '.svg'))
  end
  -- awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible
end)

if awful.screen.focused().systray.visible ~= true then
  widget.icon:set_image(PATH_TO_ICONS .. 'right-arrow' .. '.svg')
end


return widget_button
