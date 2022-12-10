local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears_table = require("gears.table")
local media_button_images = require(... .. ".button-images")
local media_button = require("widget.mpd.content.media-buttons.media_button")
local margins = {
  -- surreal = dpi(8),
  -- linear = dpi(8),
}

local media_buttons = gears_table.join({
  play_button = media_button:new(media_button_images.play_button_image, margins[THEME]),
  next_button = media_button:new(media_button_images.next_button_image, margins[THEME]),
  prev_button = media_button:new(media_button_images.prev_button_image, margins[THEME]),
  repeat_button = media_button:new(media_button_images.rep_button_image, nil),
  random_button = media_button:new(media_button_images.rand_button_image, dpi(10)),
}, media_button_images)

media_buttons.navigate_buttons = wibox.widget({
  expand = "none",
  layout = wibox.layout.align.horizontal,
  media_buttons.repeat_button,
  {
    layout = wibox.layout.fixed.horizontal,
    media_buttons.prev_button,
    media_buttons.play_button,
    media_buttons.next_button,
    forced_height = dpi(35),
  },
  media_buttons.random_button,
  forced_height = dpi(35),
})

-- 🔧 TODO: add correct map for themes
local theme_map = {
  floppy = media_buttons,
  gnawesome = media_buttons,
  default = gears_table.join({
    play_button = media_buttons.play_button,
    next_button = media_buttons.next_button,
    prev_button = media_buttons.prev_button,
    -- navigate_buttons = media_buttons.navigate_buttons,
  }, media_button_images),
}
theme_map.default.navigate_buttons = wibox.widget({
  layout = wibox.layout.fixed.horizontal,
  media_buttons.prev_button,
  media_buttons.play_button,
  media_buttons.next_button,
  -- forced_height = dpi(35),
})

local mt = {
  __index = function()
    return theme_map.default
  end,
}
setmetatable(theme_map, mt)

-- pl.dump(theme_map[THEME].navigate_buttons)
return theme_map[THEME]
