local wibox = require('wibox')
local mat_list_item = require('widget.material.list-item')
local mat_slider = require('widget.material.slider')
local mat_icon_button = require('widget.material.icon-button')
local clickable_container = require('widget.material.clickable-container')
local icons = require('theme.icons')
local watch = require('awful.widget.watch')
local spawn = require('awful.spawn')
local awful = require('awful')

local slider =
  wibox.widget {
  read_only = false,
  widget = mat_slider
}

slider:connect_signal(
  'property::value',
  function()
    spawn('xbacklight -set ' .. math.max(slider.value, 5), false)
  end
)

watch(
  [[bash -c "xbacklight -get"]],
  2,
  function(widget, stdout, stderr, exitreason, exitcode)
    local brightness = string.match(stdout, '(%d+)')

    slider:set_value(tonumber(brightness))
    collectgarbage('collect')
  end
)

function UpdateBrOSD()
  awful.spawn.easy_async_with_shell("xbacklight -get", function( stdout )
    local brightness = string.match(stdout, '(%d+)')
    slider:set_value(tonumber(brightness))
  end, false)
end


local icon =
  wibox.widget {
  image = icons.brightness,
  widget = wibox.widget.imagebox
}

local button = mat_icon_button(icon)

local brightness_setting =
  wibox.widget {
  button,
  slider,
  widget = mat_list_item
}

return brightness_setting
