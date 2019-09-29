local awful = require('awful')
local naughty = require('naughty')
local watch = require('awful.widget.watch')
local wibox = require('wibox')
local clickable_container = require('widget.action-center.clickable-container')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local gap = 1

-- acpi sample outputs
-- Battery 0: Discharging, 75%, 01:51:38 remaining
-- Battery 0: Charging, 53%, 00:57:43 until charged

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/bluetooth/icons/'
local checker
local mat_list_item = require('widget.material.list-item')

-- TEMPLATE DOWN BELOW DO NOT ALTER OR ELSE WILL DELETE ROOT --
-- Todos:
-- X wifi
-- X bluetooth
-- mpd
-- compositor
-- speaker
-- redshift
-- Screen Resolution (XRANDR)???
--
local barColor = '#ffffff20'
local wifibutton = require('widget.action-center.wifi-button')
local bluebutton = require('widget.action-center.bluetooth-button')
local comptonbutton = require('widget.action-center.compositor-button')

return wibox.widget {
  spacing = gap,
  -- Wireless Connection
  wibox.widget{
    wibox.widget{
      wifibutton,
      bg = barColor,
      shape = function(cr, width, height)
                gears.shape.partially_rounded_rect(
                  cr,
                  width,
                  height,
                  true,
                  true,
                  false,
                  false,
                  12)
              end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
  -- Bluetooth Connection
  layout = wibox.layout.fixed.vertical,
  wibox.widget{
    wibox.widget{
      bluebutton,
      bg = barColor,
      shape = function(cr, width, height)
                gears.shape.partially_rounded_rect(
                  cr,
                  width,
                  height,
                  false,
                  false,
                  false,
                  false,
                  12)
              end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
  -- Compositor Toggle
  layout = wibox.layout.fixed.vertical,
  wibox.widget{
    wibox.widget{
      comptonbutton,
      bg = barColor,
      shape = function(cr, width, height)
                gears.shape.partially_rounded_rect(
                  cr,
                  width,
                  height,
                  false,
                  false,
                  true,
                  true,
                  12)
              end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  }
}
