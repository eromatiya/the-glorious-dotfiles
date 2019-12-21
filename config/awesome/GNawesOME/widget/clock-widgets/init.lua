local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.material.clickable-container')

local dpi = require('beautiful').xresources.apply_dpi


-- Instantiate music box toggle function
toggle_clockbox = require('widget.clock-widgets.clock-box').toggle

local clock_widget = wibox.widget {
  {
    format = '%l:%M %p',
    font = 'SFNS Display Bold 10',
    refresh = 1,
    widget = wibox.widget.textclock
  },
  left = 7,
  right = 7,
  widget = wibox.container.margin
}

local clock_button = clickable_container(clock_widget)
clock_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        toggle_clockbox()
      end
    )
  )
)

return clock_button