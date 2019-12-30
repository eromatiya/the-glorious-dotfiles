local awful = require('awful')
local naughty = require('naughty')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local dpi = require('beautiful').xresources.apply_dpi
local mat_list_item = require('widget.material.list-item')
local clickable_container = require('widget.material.clickable-container')

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/notif-center/icons/'


-- Delete button imagebox
local delete_imagebox = wibox.widget {
  {
    image = PATH_TO_ICONS .. 'delete' .. '.svg',
    resize = true,
    forced_height = dpi(20),
    forced_width = dpi(20),
    widget = wibox.widget.imagebox,
  },
  layout = wibox.layout.fixed.horizontal
}


local delete_button = clickable_container(wibox.container.margin(delete_imagebox, dpi(7), dpi(7), dpi(7), dpi(7)))
delete_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        _G.reset_notifbox_layout()
      end
    )
  )
)

local delete_button_wrapped = wibox.widget {
  {
    delete_button,
    bg = beautiful.bg_modal, 
    shape = gears.shape.circle,
    widget = wibox.container.background
  },
  layout = wibox.layout.fixed.horizontal
}

return delete_button_wrapped