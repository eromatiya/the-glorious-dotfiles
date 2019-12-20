-- Load these libraries (if you haven't already)
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local watch = require('awful.widget.watch')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi


local vol_osd = require('widget.volume.volume-slider-osd')


local volOver = function(s)

  -- Create the box
  local offsetx = dpi(56)
  local offsety = dpi(300)
  volumeOverlay = wibox
  {
    visible = nil,
    screen = s,
    ontop = true,
    type = "dock",
    height = offsety,
    width = dpi(48),
    bg = "#00000000",
    x = s.geometry.width - offsetx,
    y = (s.geometry.height / dpi(2)) - (offsety / dpi(2)),
  }
  -- Put its items in a shaped container
  volumeOverlay:setup {
    -- Container
    {
      -- Items go here
      --wibox.widget.textbox("Hello!"),
      wibox.container.rotate(vol_osd, 'east'),
      -- ...
      layout = wibox.layout.fixed.vertical
    },
    -- The real background color
    bg = "#000000".. "66",
    -- The real, anti-aliased shape
    shape = gears.shape.rounded_rect,
    widget = wibox.container.background()
  }


  local hideOSD = gears.timer 
  {
    timeout = 5,
    autostart = true,
    callback  = function()
    volumeOverlay.visible = false
    end
  }


  function toggleVolOSD(bool)
    volumeOverlay.visible = bool
    if bool then
      hideOSD:again()
      if toggleBriOSD ~= nil then
        _G.toggleBriOSD(false)
      end
    else
      hideOSD:stop()
    end
  end

  return volumeOverlay

end


screen.connect_signal("request::desktop_decoration", function(s)
  -- Create overlay to all screens
  volOver(s)
end)

