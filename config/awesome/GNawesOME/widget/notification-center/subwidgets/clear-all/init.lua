local awful = require('awful')
local naughty = require('naughty')
local wibox = require('wibox')
local clickable_container = require('widget.material.clickable-container')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local mat_list_item = require('widget.material.list-item')
local beautiful = require('beautiful')

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/notification-center/icons/'


local clear_all_img = wibox.widget {
  {
    id = 'icon',
    image = HOME .. '/.config/awesome/theme/icons/tag-list/tag/close.png',
    resize = true,
    forced_height = dpi(15),
    widget = wibox.widget.imagebox,
  },
  layout = wibox.layout.fixed.horizontal
}


local clear_all_button = clickable_container(wibox.container.margin(clear_all_img, dpi(5), dpi(5), dpi(5), dpi(5)))
clear_all_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        _G.clear_all()
        _G.firstime = true
      end
    )
  )
)



local clear_button_wrapped = wibox.widget {
  clear_all_button,
  bg = beautiful.bg_modal, 
  shape = gears.shape.circle,
  widget = wibox.container.background
}



return clear_button_wrapped