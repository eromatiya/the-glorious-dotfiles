local awful = require('awful')
local naughty = require('naughty')
local watch = require('awful.widget.watch')
local wibox = require('wibox')
local clickable_container = require('widget.material.clickable-container')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/xdg-folders/icons/'


  local separator = wibox.widget {
    orientation = 'vertical',
    forced_width = 16,
    opacity = 0.50,
    span_ratio = 0.7,
    widget = wibox.widget.separator
  }

return wibox.widget {
  layout = wibox.layout.align.horizontal,
  {
    separator,
    require("widget.xdg-folders.home"),
    require("widget.xdg-folders.documents"),
    require("widget.xdg-folders.downloads"),
    require("widget.xdg-folders.pictures"),
    require("widget.xdg-folders.videos"),
    separator,
    require("widget.xdg-folders.trash"),
    layout = wibox.layout.fixed.horizontal,

  },

}
