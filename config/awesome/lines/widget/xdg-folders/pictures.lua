local awful = require('awful')
local naughty = require('naughty')
local watch = require('awful.widget.watch')
local wibox = require('wibox')
local clickable_container = require('widget.material.clickable-container')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/xdg-folders/icons/'

local picWidget =
  wibox.widget {
  {
    id = 'icon',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local pic_button = clickable_container(wibox.container.margin(picWidget, dpi(8), dpi(8), dpi(8), dpi(8)))
pic_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn.easy_async_with_shell("xdg-open $HOME/Pictures", function(stderr) end, 1)
      end
    )
  )
)

-- Alternative to naughty.notify - tooltip. You can compare both and choose the preferred one
awful.tooltip(
  {
    objects = {pic_button},
    mode = 'outside',
    align = 'right',
    timer_function = function()
      return 'Pictures'
    end,
    preferred_positions = {'right', 'left', 'top', 'bottom'}
  }
)

picWidget.icon:set_image(PATH_TO_ICONS .. 'folder-pictures' .. '.svg')

return pic_button
