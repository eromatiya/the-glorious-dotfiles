local wibox = require('wibox')
local mat_list_item = require('widget.material.list-item')
local mat_slider = require('widget.material.slider')
local mat_icon_button = require('widget.material.icon-button')
local clickable_container = require('widget.material.clickable-container')
local icons = require('theme.icons')
local watch = require('awful.widget.watch')
local spawn = require('awful.spawn')
local awful = require('awful')

local slider_osd =
  wibox.widget {
  read_only = false,
  widget = mat_slider
}

slider_osd:connect_signal(
  'property::value',
  function()
    spawn('xbacklight -set ' .. math.max(slider_osd.value, 5), false)
  end
)

slider_osd:connect_signal(
  'button::press',
  function()
    slider_osd:connect_signal(
      'property::value',
      function()
        _G.toggleBriOSD(true)
      end
    )
  end
)

function UpdateBrOSD()
  awful.spawn.easy_async_with_shell("xbacklight -get", function( stdout )
    local brightness = string.match(stdout, '(%d+)')
    slider_osd:set_value(tonumber(brightness))
  end, false)
end


local icon =
  wibox.widget {
  image = icons.brightness,
  widget = wibox.widget.imagebox
}

local button = mat_icon_button(icon)

local brightness_setting_osd =
  wibox.widget {
  button,
  slider_osd,
  widget = mat_list_item
}

return brightness_setting_osd
