-- Load these libraries (if you haven't already)
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi


local vol_osd = require('widget.brightness.brightness-slider-osd')

local briOver = function(s)

  -- Create the box
  local offsetx = dpi(56)
  local offsety = dpi(300)
  brightnessOverlay = wibox
  {
    visible = nil,
    ontop = true,
    screen = s,
    type = "dock",
    height = offsety,
    width = dpi(48),
    bg = "#00000000",
    x = s.geometry.width - offsetx,
    y = (s.geometry.height / dpi(2)) - (offsety / dpi(2)),
  }

  -- Put its items in a shaped container
  brightnessOverlay:setup {
    -- Container
    {
      -- Items go here
      --wibox.widget.textbox("Hello!"),
      wibox.container.rotate(vol_osd,'east'),
      -- ...
      layout = wibox.layout.fixed.vertical
    },
    -- The real background color
    bg = "#000000".. "66",
    -- The real, anti-aliased shape
    shape = gears.shape.rounded_rect,
    widget = wibox.container.background()
  }


  local hideOSD = gears.timer {
    timeout = 5,
    autostart = true,
    callback  = function()
    brightnessOverlay.visible = false
  end
}


  function toggleBriOSD(bool)
    brightnessOverlay.visible = bool
    if bool then
      hideOSD:again()
      if toggleVolOSD ~= nil then
        _G.toggleVolOSD(false)
      end
    else
      hideOSD:stop()
    end
  end


return brightnessOverlay

end


screen.connect_signal("request::desktop_decoration", function(s)
  -- Create overlay to all screens
  briOver(s)
end)