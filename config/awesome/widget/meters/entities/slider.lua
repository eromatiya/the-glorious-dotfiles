local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local watch = awful.widget.watch
local slider = {
  nil,
  {
    id = "",
    max_value = 100,
    value = 0,
    forced_height = _,
    color = "#f2f2f2EE",
    background_color = "#ffffff20",
    shape = gears.shape.rounded_rect,
    widget = wibox.widget.progressbar,
  },
  nil,
  expand = "none",
  forced_height = dpi(36),
  layout = wibox.layout.align.vertical,
}
local height_map = {
  floppy = dpi(2),
}
---@see make a new slider with a funcution to update it
---@param id string
---@param update_scirpt string| table | nil
---@param update_interval number | nil
---@param update_callback function | nil
function slider:new(id, update_scirpt, update_interval, update_callback)
  self[2].id = id
  self[2].forced_height = height_map[THEME] or dpi(24)
  local sl = wibox.widget(self)
  if update_scirpt then
    watch(update_scirpt, update_interval, update_callback, sl)
  end
  return sl
end

return slider
