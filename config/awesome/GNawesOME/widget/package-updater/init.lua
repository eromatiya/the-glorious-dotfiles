-------------------------------------------------
-- Package Updater Widget for Awesome Window Manager
-- Shows the package updates information in Arch Linux
-------------------------------------------------

local awful = require('awful')
local naughty = require('naughty')
local watch = require('awful.widget.watch')
local wibox = require('wibox')
local clickable_container = require('widget.material.clickable-container')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/package-updater/icons/'
local updateAvailable = false
local numOfUpdatesAvailable

local widget =
  wibox.widget {
  {
    id = 'icon',
    widget = wibox.widget.imagebox,
    image = PATH_TO_ICONS .. 'package' .. '.svg',
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
        if updateAvailable then
          awful.spawn('pamac-manager --updates')
        else
          awful.spawn('pamac-manager')
        end
      end
    )
  )
)
widget_button.visible = false

-- Alternative to naughty.notify - tooltip. You can compare both and choose the preferred one
awful.tooltip(
  {
    objects = {widget_button},
    mode = 'outside',
    align = 'right',
    timer_function = function()
      if updateAvailable then
        return numOfUpdatesAvailable .. ' updates are available'
      else
        return 'We are up-to-date!'
      end
    end,
    preferred_positions = {'right', 'left', 'top', 'bottom'}
  }
)

-- To use colors from beautiful theme put
-- following lines in rc.lua before require("battery"):
--beautiful.tooltip_fg = beautiful.fg_normal
--beautiful.tooltip_bg = beautiful.bg_normal

local function show_battery_warning()
  naughty.notify {
    icon = PATH_TO_ICONS .. 'battery-alert.svg',
    icon_size = dpi(48),
    text = 'Huston, we have a problem',
    title = 'Battery is dying',
    timeout = 5,
    hover_timeout = 0.5,
    position = 'bottom_left',
    bg = '#d32f2f',
    fg = '#EEE9EF',
    width = 248
  }
end

local last_battery_check = os.time()
watch(
  'pamac checkupdates',
  60,
  function(_, stdout)
    numOfUpdatesAvailable = tonumber(stdout:match('.-\n'):match('%d*'))
    local widgetIconName
    if (numOfUpdatesAvailable ~= nil) then
      updateAvailable = true
      widgetIconName = 'package-up'
      widget_button.visible = true
    else
      updateAvailable = false
      widgetIconName = 'package'
      widget_button.visible = true
    end
    widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
    collectgarbage('collect')
  end,
  widget
)

return widget_button
